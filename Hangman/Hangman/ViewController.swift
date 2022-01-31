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
    var hiddenWord = "" //
    var allWords = [String]()
    var usedLetters = [String]()
    var errorCount = 12 {
        didSet {
            title = "\(errorCount) errors to Hangman"
        }
    }
    
    
    
    var hiddenWordArray = ["_","_","_","_","_","_","_","_"] {
        didSet {
            hiddenWord = hiddenWordArray.joined(separator: " ")
            print(hiddenWordArray)
            wordLabel.text = hiddenWord
            print(hiddenWord)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(errorCount) errors to Hangman"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        
        submitButton.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        
        performSelector(inBackground: #selector(loadAllWords), with: nil)
        
        hiddenWord = hiddenWordArray.joined(separator: " ")
        
    }
    
    @objc func startGame() {
        wordToFind = allWords.randomElement() ?? "silkworm"
        print(wordToFind)
        restartGame()
    }
    
    @objc func restartGame() {
        usedLetters.removeAll(keepingCapacity: true)
        wordLabel.text = hiddenWord
    }
    
    @objc func loadAllWords() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
        
        wordToFind = allWords.randomElement()!
        print(wordToFind)
        
        performSelector(onMainThread: #selector(restartGame), with: nil, waitUntilDone: false)
    }
    
    @objc func submitAnswer() {
        for letter in wordToFind {
            let strLetter = String(letter)
            usedLetters.append(strLetter)
            
            print(usedLetters)

        }
        guard let input = letterTextField.text?.lowercased() else { return }
        
        print(input)
        
        for _ in 0..<8 {
            if usedLetters.contains(input)  {
                usedLetters.removeSubrange(8...)
              let indexToRemove = usedLetters.firstIndex(of: input)!
                hiddenWordArray.remove(at: indexToRemove)
                hiddenWordArray.insert(input.uppercased(), at: indexToRemove)
                usedLetters.remove(at: indexToRemove)
                usedLetters.insert("*", at: indexToRemove)
            }
        }
        letterTextField.text = ""
    }
            
    
        
        
        
    

}

