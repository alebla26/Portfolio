//
//  ViewController.swift
//  Tricky Little Words
//
//  Created by Alex Blanchard on 10/6/17.
//  Copyright © 2017 Alex Blanchard. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
  @IBOutlet weak var cluesLabel: UILabel!
  @IBOutlet weak var answersLabel: UILabel!
  @IBOutlet weak var currentAnswer: UITextField!
  @IBOutlet weak var scoreLabel: UILabel!
  
  var letterButtons = [UIButton]()
  var activatedButtons = [UIButton]()
  var solutions = [String]()
  
  var score = 0 {
    didSet {
      scoreLabel.text! = "Score: \(score)"
    }
  }
  var level = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for subview in view.subviews where subview.tag == 1001 {
      let btn = subview as! UIButton
      letterButtons.append(btn)
      btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
    }
    
    loadLevel()
    
  }
  
  //MARK: UI Functions
  
  func loadLevel() {
    var clueString = ""
    var solutionString = ""
    var letterBits = [String]()
    
    if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
      if let levelContents = try? String(contentsOfFile: levelFilePath) {
        var lines = levelContents.components(separatedBy: "\n")
        lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
        
        for (index, line) in lines.enumerated() {
          let parts = line.components(separatedBy: ": ")
          let answer = parts[0]
          let clue = parts[1]
          
          clueString += "\(index + 1). \(clue)\n"
          
          let solutionWord = answer.replacingOccurrences(of: "|", with: "")
          solutionString += "\(solutionWord.count) letters\n"
          solutions.append(solutionWord)
          
          let bits = answer.components(separatedBy: "|")
          letterBits += bits
        }
      } else { print("contents of file failed") }
    } else { print("path for resource failed") }
    
    cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
    answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
    
    letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
    
    if letterBits.count == letterButtons.count {
      for i in 0 ..< letterBits.count {
        letterButtons[i].isHidden = false
        letterButtons[i].setTitle(letterBits[i], for: .normal)
      }
    } else { print("counts are off") }
  }
  
  func levelUp(_ a: UIAlertAction) {
    level += 1
    solutions.removeAll(keepingCapacity: true)
    
    loadLevel()
  }
  
  //MARK: IBActions and user input methods
  
  @objc func letterTapped(_ btn: UIButton) {
   currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
    activatedButtons.append(btn)
    btn.isHidden = true
  }
  
  @IBAction func submitTapped(_ sender: UIButton) {
    // Search for the index location of the currentAnswer text in the solutions string array.
    if let solutionPosition = solutions.index(of: currentAnswer.text!) {
      activatedButtons.removeAll()
      
      // Build the splitAnswers array of strings by separating the answersLabel string by "\n".
      var splitAnswers = answersLabel.text!.components(separatedBy: "\n")
      // Use the index location of currentAnswer to set the currentAnswer text to the new location.
      splitAnswers[solutionPosition] = currentAnswer.text!
      // Set ansersLabel text to the contents of the new splitAnswers array with "\n" as the separator.
      answersLabel.text = splitAnswers.joined(separator: "\n")
      
      currentAnswer.text = ""
      score += 1
      
      if score % 7 == 0 {
        let ac = UIAlertController(title: "Well Done!!", message: "Ready for the next level?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: levelUp))
        present(ac, animated: true)
      }
    } else {
        showErrorAlert(title: "Wrong", message: "Please try again.")
        clearTapped()
    }
  }

//    if solutions.contains(currentAnswer.text!) {
//      score += 1
//      scoreLabel.text = "Score: \(score)"
//      currentAnswer.text = ""
//      activatedButtons = []
  
  @IBAction func clearTapped(_ sender: UIButton? = nil) {
    currentAnswer.text = ""
    for btn in activatedButtons {
      btn.isHidden = false
    }
  }
  
  
  
  

  //MARK: Error Handling
  
  func showErrorAlert(title: String, message: String) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
}

