//
//  ViewController.swift
//  Flashcards
//
//  Created by Anna Liu on 2/13/21.
//  Copyright © 2021 Anna Liu. All rights reserved.
//

import UIKit

struct Flashcard {
   var question: String
   var answer: String
   var extraAnswer1: String
   var extraAnswer2: String
}

class ViewController: UIViewController {

   @IBOutlet weak var answer: UILabel!
   @IBOutlet weak var question: UILabel!
   @IBOutlet weak var card: UIView!
   @IBOutlet weak var optionOne: UIButton!
   @IBOutlet weak var optionTwo: UIButton!
   @IBOutlet weak var optionThree: UIButton!
   @IBOutlet weak var nextButton: UIButton!
   @IBOutlet weak var prevButton: UIButton!

   // array to hold flashcards
   var flashcards = [Flashcard]()

   var currentIndex = 0

   // button to remember what the correct answer is
   var correctAnswerButton: UIButton!

   override func viewDidLoad() {
      super.viewDidLoad()

      // makes question and answer cards round
      card.layer.cornerRadius = 20.0
      question.layer.cornerRadius = 20.0
      answer.layer.cornerRadius = 20.0

      question.clipsToBounds = true
      answer.clipsToBounds = true

      // adds shadows/dimensions
      card.layer.shadowRadius = 15.0
      card.layer.shadowOpacity = 0.2

      // makes answer options round
      optionOne.layer.cornerRadius = 20.0
      optionTwo.layer.cornerRadius = 20.0
      optionThree.layer.cornerRadius = 20.0

      // creates borders and custom color
      optionOne.layer.borderWidth = 3.0
      optionOne.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
      optionTwo.layer.borderWidth = 3.0
      optionTwo.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
      optionThree.layer.borderWidth = 3.0
      optionThree.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

      readSavedFlashcards()
      if flashcards.count == 0 {
         updateFlashcard(question: "What is the capital of California?",
                         answer: "Sacramento", extraAnswerOne: "Paris",
                         extraAnswerTwo: "Phoenix",
                         isExisting: false)
      }
      else {
         updateLabels()
         updateNextPrevButtons()
      }
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      // first start with the flashcard invisible and slightly smaller in size
      card.alpha = 0.0
      card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)

      optionOne.alpha = 0.0
      optionOne.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
      optionTwo.alpha = 0.0
      optionTwo.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
      optionThree.alpha = 0.0
      optionThree.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)

      // animation
      UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.7,
                     initialSpringVelocity: 0.7, options: [], animations: {
                        self.card.alpha = 1.0
                        self.card.transform = CGAffineTransform.identity
                        self.optionOne.alpha = 1.0
                        self.optionOne.transform = CGAffineTransform.identity
                        self.optionTwo.alpha = 1.0
                        self.optionTwo.transform = CGAffineTransform.identity
                        self.optionThree.alpha = 1.0
                        self.optionThree.transform = CGAffineTransform.identity
      })
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let navigationController = segue.destination as! UINavigationController
      let creationController = navigationController.topViewController as! CreationViewController
      creationController.flashcardsController = self

      if segue.identifier == "EditSegue" {
         creationController.initialQuestion = question.text
         creationController.initialAnswer = answer.text
      }
   }

   @IBAction func didTapOnFlashcard(_ sender: Any) {
      flipFlashcard()
   }

   func flipFlashcard() {
      UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
         if self.question.isHidden {
            self.question.isHidden = false
         }
         else {
            self.question.isHidden = true
         }
      })
   }

   func updateFlashcard(question: String, answer: String, extraAnswerOne: String,
                        extraAnswerTwo: String, isExisting: Bool) {

      let flashcard = Flashcard(question: question, answer: answer,
                                extraAnswer1: extraAnswerOne,
                                extraAnswer2: extraAnswerTwo)
      self.question.text = flashcard.question
      self.answer.text = flashcard.answer

      optionOne.setTitle(extraAnswerOne, for: .normal)
      optionTwo.setTitle(answer, for: .normal)
      optionThree.setTitle(extraAnswerTwo, for: .normal)

      if isExisting {
         flashcards[currentIndex] = flashcard
      }
      else {
         // adding flashcard to flashcards array
         flashcards.append(flashcard)

         print("Added new flashcard")
         print("We now have \(flashcards.count) flashcards")

         currentIndex = flashcards.count - 1
         print("Our current index is \(currentIndex)")
      }

      updateNextPrevButtons()
      updateLabels()
      saveAllFlashcardsToDisk()
   }

   func updateNextPrevButtons() {
      // disable next button if at the end
      if currentIndex == flashcards.count - 1 {
         nextButton.isEnabled = false
      }
      else {
         nextButton.isEnabled = true
      }

      // disable prev button if at beginning
      if currentIndex == 0 {
         prevButton.isEnabled = false
      }
      else {
         prevButton.isEnabled = true
      }
   }

   func updateLabels() {
      // get current flashcard
      let currentFlashcard = flashcards[currentIndex]

      // update labels
      question.text = currentFlashcard.question
      answer.text = currentFlashcard.answer

      optionOne.titleLabel?.text = currentFlashcard.extraAnswer1
      optionTwo.titleLabel?.text = currentFlashcard.answer
      optionThree.titleLabel?.text = currentFlashcard.extraAnswer2


//      // update buttons
//      let buttons = [optionOne, optionTwo, optionThree].shuffled()
//      let answers = [currentFlashcard.answer, currentFlashcard.extraAnswer1,
//                     currentFlashcard.extraAnswer2].shuffled()
//
//     //  iterate over both arrays at the same time
//      for (button, answer) in zip(buttons, answers) {
//
//         // set title of this random button with random answer
//         button?.setTitle(answer, for: .normal)
//
//         // if correct answer, save button
//         if answer == currentFlashcard.answer {
//            correctAnswerButton = button
//         }
//
//      }

   }

   @IBAction func didTapOnOptionOne(_ sender: Any) {
      // if correct answer flip flashcard, else disable button and show front label
      if optionOne == correctAnswerButton {
         flipFlashcard()
      }
      else {
         question.isHidden = false
         optionOne.isHidden = false
      }
   }

   @IBAction func didTapOnOptionTwo(_ sender: Any) {
      // if correct answer flip flashcard, else disable button and show front label
      if optionTwo == correctAnswerButton {
         flipFlashcard()
      }
      else {
         question.isHidden = false
         optionTwo.isHidden = false
      }
   }

   @IBAction func didTapOnOptionThree(_ sender: Any) {
      // if correct answer flip flashcard, else disable button and show front label
      if optionThree == correctAnswerButton {
         flipFlashcard()
      }
      else {
         question.isHidden = false
         optionThree.isHidden = false
      }
   }

   @IBAction func didTapOnPrev(_ sender: Any) {
      currentIndex = currentIndex - 1
      updateNextPrevButtons()
      animateCardOutPrev()
   }

   @IBAction func didTapOnNext(_ sender: Any) {
      currentIndex = currentIndex + 1
      updateNextPrevButtons()
      animateCardOutNext()
   }

   @IBAction func didTapOnDelete(_ sender: Any) {
      let alert = UIAlertController(title: "Delete flashcard", message:
         "Are you sure you want to delete it?", preferredStyle: .actionSheet)

      let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
         self.deleteCurrentFlashcard()
      }
      alert.addAction(deleteAction)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      alert.addAction(cancelAction)

      present(alert, animated: true)
   }

   func deleteCurrentFlashcard() {
      // delete current flashcard
      flashcards.remove(at: currentIndex)

      // check if last card is deleted
      if currentIndex > flashcards.count - 1 {
         currentIndex = flashcards.count - 1
      }
      updateNextPrevButtons()
      updateLabels()
      saveAllFlashcardsToDisk()
   }


   func saveAllFlashcardsToDisk() {
      // flashcard to dictionary array
      let dictionaryArray = flashcards.map { (card) -> [String: String] in
         return ["question": card.question, "answer": card.answer,
                 "extra answer one": card.extraAnswer1,
                 "extra answer two": card.extraAnswer2]
      }

      // save array on disk
      UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
      print("Flashcards saved to UserDefaults")
   }

   func readSavedFlashcards() {
      // read dictionary array from disk, if any
      if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
         // know for sure we have dictionary array
         let savedCards = dictionaryArray.map { dictionary -> Flashcard in
            return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!,
                             extraAnswer1: dictionary["extra answer one"]!,
                             extraAnswer2: dictionary["extra answer two"]!)
         }
         flashcards.append(contentsOf: savedCards)
      }
   }

   func animateCardOutNext() {
      UIView.animate(withDuration: 0.3, animations: {
         self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
      }, completion: { finished in
         self.updateLabels()
         self.updateFlashcard(question: self.question.text!, answer: self.answer.text!,
                         extraAnswerOne: (self.optionOne.titleLabel?.text)!,
                         extraAnswerTwo: (self.optionThree.titleLabel?.text)!,
                         isExisting: true)
         self.animateCardInNext()
      })
   }

   func animateCardInNext() {
      card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)

      UIView.animate(withDuration: 0.3) {
         self.card.transform = CGAffineTransform.identity
      }
   }

   func animateCardOutPrev() {
      UIView.animate(withDuration: 0.3, animations: {
         self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
      }, completion: { finished in
         self.updateLabels()
         self.updateFlashcard(question: self.question.text!, answer: self.answer.text!,
                              extraAnswerOne: (self.optionOne.titleLabel?.text)!,
                              extraAnswerTwo: (self.optionThree.titleLabel?.text)!,
                              isExisting: true)
         self.animateCardInPrev()
      })
   }

   func animateCardInPrev() {
      card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)

      UIView.animate(withDuration: 0.3) {
         self.card.transform = CGAffineTransform.identity
      }
   }
}





