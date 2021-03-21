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
      if question.isHidden {
         question.isHidden = false
      }
      else {
         question.isHidden = true
      }
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
      let currentFlashcard = flashcards[currentIndex]
      question.text = currentFlashcard.question
      answer.text = currentFlashcard.answer

      optionOne.titleLabel?.text = currentFlashcard.extraAnswer1
      optionTwo.titleLabel?.text = currentFlashcard.answer
      optionThree.titleLabel?.text = currentFlashcard.extraAnswer2
   }

   @IBAction func didTapOnOptionOne(_ sender: Any) {
      optionOne.isHidden = true
   }

   @IBAction func didTapOnOptionTwo(_ sender: Any) {

   }

   @IBAction func didTapOnOptionThree(_ sender: Any) {
      optionThree.isHidden = true
   }

   @IBAction func didTapOnPrev(_ sender: Any) {
      currentIndex = currentIndex - 1
      updateLabels()
      updateFlashcard(question: question.text!, answer: answer.text!,
                      extraAnswerOne: (optionOne.titleLabel?.text)!,
                      extraAnswerTwo: (optionThree.titleLabel?.text)!,
                      isExisting: true)
      updateNextPrevButtons()
   }

   @IBAction func didTapOnNext(_ sender: Any) {
      currentIndex = currentIndex + 1
      updateLabels()
      updateFlashcard(question: question.text!, answer: answer.text!,
                      extraAnswerOne: (optionOne.titleLabel?.text)!,
                      extraAnswerTwo: (optionThree.titleLabel?.text)!,
                      isExisting: true)
      updateNextPrevButtons()
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

}





