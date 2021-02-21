//
//  ViewController.swift
//  Flashcards
//
//  Created by Anna Liu on 2/13/21.
//  Copyright © 2021 Anna Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var backLabel: UILabel!
   @IBOutlet weak var frontLabel: UILabel!

   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   @IBAction func didTapOnFlashcard(_ sender: Any) {
      frontLabel.isHidden = true
   }

}

