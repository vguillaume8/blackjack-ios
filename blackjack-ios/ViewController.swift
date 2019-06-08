//
//  ViewController.swift
//  blackjack-ios
//
//  Created by Vince G on 5/26/19.
//  Copyright © 2019 Guillaume Corporations. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftScoreLabel: UILabel!
    
    @IBOutlet weak var rightScoreLabel: UILabel!
    
   
    
    var leftScore = 0
    var rightScore = 0
    var aceValue = 0
    let computerLimit = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func dealTapped(_ sender: Any) {
      
        
        if Int(rightScoreLabel.text!)! < computerLimit {
            
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
            while rightScore < computerLimit && rightScore < leftScore {
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
         
        }else if cardNumber > 10 {
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
                    } else {
            alert.title = "Congrats You Won! \(leftScore) - \(rightScore)"
            alert.message = "Nice Job!"
           
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
}

