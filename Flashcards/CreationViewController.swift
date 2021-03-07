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

   var flashcardsController: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

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

      
      flashcardsController.updateFlashcard(question: questionText!, answer: answerText!)
   }

}








