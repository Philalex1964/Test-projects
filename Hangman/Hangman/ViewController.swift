//
//  ViewController.swift
//  Hangman
//
//  Created by Alexander Filippov on 31.1.22..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var letterTextField: UITextField!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var submitButton: UIButton!
    
    var wordToFind = ""
    var allWords = [String]()
    var usedLetters = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "HANGMAN"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        
        submitButton.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        
        performSelector(inBackground: #selector(loadAllWords), with: nil)
        
    }
    
    @objc func startGame() {
        wordToFind = allWords.randomElement() ?? "silkworm"
        print(wordToFind)
        usedLetters.removeAll(keepingCapacity: true)
        wordLabel.text = "_ _ _ _ _ _ _ _"
    }
    
    @objc func restartGame() {
        usedLetters.removeAll(keepingCapacity: true)
        wordLabel.text = "_ _ _ _ _ _ _ _"
    }
    
    @objc func loadAllWords() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
        print(allWords)
        
        wordToFind = allWords.randomElement()!
        print(wordToFind)
        
        performSelector(onMainThread: #selector(startGame), with: nil, waitUntilDone: false)
    }
    
    @objc func submitAnswer()
    {
        print("SubmitTapped")
    }

}

