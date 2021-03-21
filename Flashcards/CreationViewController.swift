//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Anna Liu on 3/6/21.
//  Copyright © 2021 Anna Liu. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {

   @IBOutlet weak var questionTextField: UITextField!
   @IBOutlet weak var answerTextField: UITextField!
   @IBOutlet weak var extraAnswerOne: UITextField!
   @IBOutlet weak var extraAnswerTwo: UITextField!

   var initialQuestion: String?
   var initialAnswer: String?
   var initialExtraAnswerOne: String?
   var initialExtraAnswerTwo: String?

   var flashcardsController: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

      questionTextField.text = initialQuestion
      answerTextField.text = initialAnswer
      extraAnswerOne.text = initialExtraAnswerOne
      extraAnswerTwo.text = initialExtraAnswerTwo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   @IBAction func didTapOnCancel(_ sender: Any) {
      dismiss(animated: true)
   }

   @IBAction func didTapOnDone(_ sender: Any) {
      let questionText = questionTextField.text
      let answerText = answerTextField.text
      let extraAnswerOneText = extraAnswerOne.text
      let extraAnswerTwoText = extraAnswerTwo.text

      if questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty {
         let alert = UIAlertController(title: "Missing text", message: "You need to enter both a question and an answer",
                                       preferredStyle: .alert)
         present(alert, animated: true)
         let okAction = UIAlertAction(title: "Ok", style: .default)
         alert.addAction(okAction)
      }
      else {
         // see if it's existing
         var isExisting = false
         if initialQuestion != nil {
            isExisting = true
         }
         flashcardsController.updateFlashcard(question: questionText!, answer: answerText!,
                                              extraAnswerOne: extraAnswerOneText!,
                                              extraAnswerTwo: extraAnswerTwoText!,
                                              isExisting: isExisting)
      }
   }
   
}








