//
//  ViewController.swift
//  Flashcards
//
//  Created by Anna Liu on 2/13/21.
//  Copyright © 2021 Anna Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var answer: UILabel!
   @IBOutlet weak var question: UILabel!
   @IBOutlet weak var card: UIView!
   @IBOutlet weak var optionOne: UIButton!
   @IBOutlet weak var optionTwo: UIButton!
   @IBOutlet weak var optionThree: UIButton!

   override func viewDidLoad() {
      super.viewDidLoad()

      // makes question and answer cards round
      card.layer.cornerRadius = 20.0;
      question.layer.cornerRadius = 20.0;
      answer.layer.cornerRadius = 20.0;

      question.clipsToBounds = true;
      answer.clipsToBounds = true;

      // adds shadows/dimensions
      card.layer.shadowRadius = 15.0
      card.layer.shadowOpacity = 0.2

      // makes answer options round
      optionOne.layer.cornerRadius = 20.0;
      optionTwo.layer.cornerRadius = 20.0;
      optionThree.layer.cornerRadius = 20.0;

      // creates borders and custom color
      optionOne.layer.borderWidth = 3.0;
      optionOne.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
      optionTwo.layer.borderWidth = 3.0;
      optionTwo.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
      optionThree.layer.borderWidth = 3.0;
      optionThree.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
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
         question.isHidden = false;
      }
      else {
         question.isHidden = true;
      }
   }

   func updateFlashcard(question: String, answer: String, extraAnswerOne: String?, extraAnswerTwo: String?) {
      self.question.text = question;
      self.answer.text = answer;

      optionOne.setTitle(extraAnswerOne, for: .normal)
      optionTwo.setTitle(answer, for: .normal)
      optionThree.setTitle(extraAnswerTwo, for: .normal)
   }

   @IBAction func didTapOnOptionOne(_ sender: Any) {
      optionOne.isHidden = true;
   }

   @IBAction func didTapOnOptionTwo(_ sender: Any) {

   }
   @IBAction func didTapOnOptionThree(_ sender: Any) {
      optionThree.isHidden = true;
   }

}





