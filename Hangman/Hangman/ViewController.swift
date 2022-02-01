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
    var hiddenWord = ""
    var allWords = [String]()
    var usedLetters = [String]()
    let allowedErrors = 8
    var errorCount = 0 {
        didSet {
            title = "\(errorCount) errors to Hangman"
            progressView.progress = Float(errorCount) / Float(allowedErrors)
        }
    }
    var guessedLettersCount = 0
    var guessedLetters = [String]()
    var hiddenWordArray = ["_","_","_","_","_","_","_","_"] {
        didSet {
            hiddenWord = hiddenWordArray.joined(separator: " ")
            wordLabel.text = hiddenWord
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(errorCount) errors to Hangman"
        
        progressView.progressViewStyle = .default
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        
        submitButton.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        
        performSelector(inBackground: #selector(loadAllWords), with: nil)
        
        hiddenWord = hiddenWordArray.joined(separator: " ")
        
    }
    
    @objc func startGame() {
        wordToFind = allWords.randomElement() ?? "silkworm"

        restartGame()
    }
    
    @objc func restartGame() {
        usedLetters.removeAll(keepingCapacity: true)
        guessedLetters.removeAll(keepingCapacity: true)
        errorCount = allowedErrors
        guessedLettersCount = 0
        hiddenWordArray = ["_","_","_","_","_","_","_","_"]
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
        
        performSelector(onMainThread: #selector(restartGame), with: nil, waitUntilDone: false)
    }
    
    @objc func submitAnswer() {
        if usedLetters.isEmpty {
            for letter in wordToFind {
                let strLetter = String(letter)
                usedLetters.append(strLetter)
            }
        }
        
        guard let input = letterTextField.text?.lowercased()  else { return }
        
        if letterTextField.text!.count > 1 {
            let ac = UIAlertController(title: "Warning!", message: "Only one letter allowed!", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
            
            letterTextField.text = ""
            
            return
        }
                
        if guessedLetters.contains(input) {
            let ac = UIAlertController(title: "Error", message: "This letter is already used", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
            letterTextField.text = ""
        } else if !usedLetters.contains(input)  {
            errorCount -= 1
            guessedLetters.append(input)
            
            if errorCount <= 0 {
                letterTextField.text = ""
                
                let repeatGameAction =  UIAlertAction(title: "Repeat the game?", style: .default) { [weak self] action in
                    self?.restartGame()
                }
                
                let newGameAction = UIAlertAction(title: "Start new game?", style: .default) { [weak self] action in
                    self?.startGame()
                }
                
                let ac = UIAlertController(title: "Congratulations!", message: "You are Hangman!", preferredStyle: .alert)
                
                ac.addAction(repeatGameAction)
                ac.addAction(newGameAction)
                ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
                present(ac, animated: true)
                letterTextField.text = ""
            }  else {
                guessedLetters.append(input)
                
                let ac = UIAlertController(title: "Error", message: "No such letter in the word", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                
                present(ac, animated: true)
                letterTextField.text = ""
            }
        } else {
            letterTextField.text = ""
            
            for _ in 0..<usedLetters.count {
                if guessedLettersCount == usedLetters.count {
    
                    let ac = UIAlertController(title: "Congratulations!", message: "You won!", preferredStyle: .alert)
                    
                    let newGameAction = UIAlertAction(title: "Start new game?", style: .default) { [weak self] action in
                        self?.startGame()
                    }
                    
                    ac.addAction(newGameAction)
                    ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    present(ac, animated: true)
                    letterTextField.text = ""
                    return
                }
                guard let indexToRemove = usedLetters.firstIndex(of: input) else { return }
                hiddenWordArray.remove(at: indexToRemove)
                hiddenWordArray.insert(input.uppercased(), at: indexToRemove)
                usedLetters.remove(at: indexToRemove)
                usedLetters.insert("*", at: indexToRemove)
                guessedLettersCount += 1
                guessedLetters.append(input)
                letterTextField.text = ""
            }
        }
    }
}

