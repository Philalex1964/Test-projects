//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Alexander Filippov on 18.1.22..
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0 {
        didSet {
            title = countries[correctAnswer].uppercased() + "?" + " Score: \(score)"
        }
    }
    var correctAnswer = 0
    var highScore = 0 {
        didSet {
            newHighScore()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.darkGray.cgColor
        button2.layer.borderColor = UIColor.darkGray.cgColor
        button3.layer.borderColor = UIColor.darkGray.cgColor
        
        askQuestion()
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "highScore")
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + "?" + " Score: \(score)"
    }

    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 2, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        sender.transform = CGAffineTransform.identity
        
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            if score > highScore {
                highScore = score
                save()
                return
            }
        } else {
            title = "Wrong"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: score == 10 ? "Your score is \(score). Game over!" : "Your score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
        print("Highscore saved!")
    }
    
    func newHighScore() {
        
        let ac = UIAlertController(title: "High score", message: score == 0 ? "Current high score = \(highScore)." : "New high score = \(highScore)!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
}

