//
//  ViewController.swift
//  blackjack-ios
//
//  Created by Vince G on 5/26/19.
//  Copyright © 2019 Guillaume Corporations. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {  
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    
    @IBOutlet weak var playerGameScore: UILabel!
    var playerGameScoreValue = 0
    
    @IBOutlet weak var cpuGameScore: UILabel!
    var cpuGameScoreValue = 0
    
    var leftScore = 0
    var rightScore = 0
    var aceValue = 0
    let computerLimit = 18
    
    var userIsWining: Bool {
        if rightScoreLabel.text! < leftScoreLabel.text! {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let getplayerGameScoreValue = defaults.value(forKey: "playerGameScore") ?? 0
        let getcpuGameScoreValue = defaults.value(forKey: "cpuGameScore") ?? 0
        
        playerGameScoreValue = getplayerGameScoreValue as! Int
        cpuGameScoreValue = getcpuGameScoreValue as! Int
        
        playerGameScore.text = String(playerGameScoreValue)
        cpuGameScore.text = String(cpuGameScoreValue)
    }

    @IBAction func dealTapped(_ sender: Any) {
        if Int(rightScoreLabel.text!)! < computerLimit || userIsWining {
            drawCard(player: true)
            drawCard(player: false)
        } else {          
            drawCard(player: true)
        }

        checkScore()
    }
      
    @IBAction func userStop(_ sender: Any) {
        // checks if the computer can still play
        if rightScore < computerLimit {
            while rightScore < computerLimit && rightScore <= leftScore {
                drawCard(player: false)
            }
        }
        
        if rightScore > 21 {
            gameOver(player: false)
        }
    
        else if leftScore > rightScore {
            gameOver(player: false)
        } else {
            
            if leftScore == rightScore {
                drawGame()
            } else {
                gameOver(player: true)
            }
        }
    }
    
    
    @IBAction func startOver(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to reset the scores?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
  
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
        self.reset()
        }))
       
        self.present(alert, animated: true)
    }
    
    
    func convertCard(cardNumber: Int, player: Bool) -> Int {

        if cardNumber == 14  {
            
            if player == true {
                // ask user if ace should be a 11 or 1
                setAceValue()
                
                return aceValue
                
            } else {
                if rightScore > 10 {
                    return 1
                } else {
                    return 11
                }
            }
         
        } else if cardNumber > 10 {
            return 10
            
        } else if cardNumber > 10 {
            return 10
        }
            
        else {
            return cardNumber
        }
    }
    
    func drawCard(player: Bool) {    
        if player {
            let leftNumber = Int.random(in: 2...14)
            leftImageView.image = UIImage(named: "card\(leftNumber)")
            leftScore = leftScore + convertCard(cardNumber: leftNumber, player: true)
            leftScoreLabel.text = String(leftScore)
        } else {
            let rightNumber = Int.random(in: 2...14)
            rightImageView.image = UIImage(named: "card\(rightNumber)")
            rightScore = rightScore + convertCard(cardNumber: rightNumber, player: false)
            rightScoreLabel.text = String(rightScore)
        }
    }
    
    func setAceValue() {
        let alert = UIAlertController(title: "You Dealt an Ace!", message: "Choose a Value", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "11", style: .default, handler: { action in
            self.leftScore = self.leftScore + 11
            self.leftScoreLabel.text = String(self.leftScore)
            self.checkScore()
        }))
        
        alert.addAction(UIAlertAction(title: "1", style: .default, handler: { action in
            self.leftScore = self.leftScore + 1
            self.leftScoreLabel.text = String(self.leftScore)
            self.checkScore()
        }))
        
        self.present(alert, animated: true)
    }
    
    func gameOver(player: Bool) {
        let alert = UIAlertController()
        
        if player == true {
            alert.title = "Sorry, You Lost! \(leftScore) - \(rightScore)"
            alert.message = "Better Luck Next Time!"
            self.cpuGameScoreValue = self.cpuGameScoreValue + 1
            self.cpuGameScore.text = String(self.cpuGameScoreValue)
            defaults.set(self.cpuGameScoreValue, forKey: "cpuGameScore")
        } else {
            alert.title = "Congrats You Won! \(leftScore) - \(rightScore)"
            alert.message = "Nice Job!"
            self.playerGameScoreValue = self.playerGameScoreValue + 1
            self.playerGameScore.text = String(self.playerGameScoreValue)
            defaults.set(self.playerGameScoreValue, forKey: "playerGameScore")
        }
        
        alert.addAction(UIAlertAction(title: "Play Again?", style: .default, handler: { action in
           self.restart()
        }))
        
         self.present(alert, animated: true)
    }
    
    func drawGame() {
        let alert = UIAlertController(title: "Draw! \(leftScore) - \(rightScore)", message: "You were close!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play Again?", style: .default, handler: { action in
            self.restart()
        }))
        
        self.present(alert, animated: true)
    }
    
    func checkScore() {
        if leftScore == 21 {
            gameOver(player: false)
        }
        
        if(rightScore == 21) {
            gameOver(player: true)
        }
        
        if leftScore > 21 {
            gameOver(player: true)
        }
        
        if rightScore > 21 {
            gameOver(player: false)
        }
    }
    
    func restart() {
        leftScore = 0
        rightScore = 0
        leftScoreLabel.text = "0"
        rightScoreLabel.text = "0"
    }
    
    func reset() {
        restart()
        playerGameScoreValue = 0
        playerGameScore.text = "0"
        cpuGameScoreValue = 0
        cpuGameScore.text = "0"
        defaults.set(0, forKey: "cpuGameScore")
        defaults.set(0, forKey: "playerGameScore")
    }
}
