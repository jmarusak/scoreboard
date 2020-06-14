//
//  ViewController.swift
//  ScoreboardA
//
//  Created by Jozef Marusak on 2018-02-05.
//  Copyright © 2018 Jozef Marusak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var leftScore = 0
    var rightScore = 0
    var swapAfterPoints = 0
    var servingChangeCount = 0
    var servingPosessionLeft = true;
    
    @IBOutlet weak var labelLeftScore: UILabel!
    @IBOutlet weak var labelRightScore: UILabel!
    @IBOutlet weak var labelServingPlayer: UILabel!
    @IBOutlet weak var labelServingPlayerSeq: UILabel!
    @IBOutlet weak var labelSwapSideIndicator: UILabel!
    
    @IBOutlet weak var tapRightOnce: UITapGestureRecognizer!
    @IBOutlet weak var tapRightTwice: UITapGestureRecognizer!
    @IBOutlet weak var tapLeftOnce: UITapGestureRecognizer!
    @IBOutlet weak var tapLeftTwice: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapRightOnce.require(toFail: tapRightTwice)
        tapLeftOnce.require(toFail: tapLeftTwice)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            leftScore = 0
            labelLeftScore.text = String(leftScore)
            
            rightScore = 0
            labelRightScore.text = String(rightScore)
            
            swapAfterPoints = 0
            
            servingChangeCount = 0
            servingPosessionLeft=true
            labelServingPlayer.text = "<"
            labelSwapSideIndicator.text = ""
            
        }
    }

    @IBAction func leftScodeTapOnce(_ sender: UITapGestureRecognizer) {
        leftScore += 1
        labelLeftScore.text = String(leftScore)
        
        if !servingPosessionLeft {
            toggleServingPosession()
            nextServingPlayerSeq()
        }

        swapCourtSideReminder()
    }
    
    @IBAction func rightScoreTap(_ sender: UITapGestureRecognizer) {
        rightScore += 1
        labelRightScore.text = String(rightScore)

        if servingPosessionLeft {
            toggleServingPosession()
            nextServingPlayerSeq()
        }
        
        swapCourtSideReminder()
    }
    
    @IBAction func leftScoreTapTwice(_ sender: UITapGestureRecognizer) {
        if leftScore > 0 {
            leftScore -= 1
            labelLeftScore.text = String(leftScore)
        }
    }
    
    @IBAction func rightScoreTapTwice(_ sender: UITapGestureRecognizer) {
        if rightScore > 0 {
            rightScore -= 1
            labelRightScore.text = String(rightScore)
        }
    }
    
    @IBAction func swap(_ sender: UISwipeGestureRecognizer) {
        
        let tempScore = leftScore
        leftScore = rightScore
        rightScore = tempScore
        
        labelLeftScore.text = String(leftScore)
        labelRightScore.text = String(rightScore)
        
        let tempColor = labelLeftScore.textColor
        labelLeftScore.textColor = labelRightScore.textColor
        labelRightScore.textColor = tempColor
        
        toggleServingPosession()
        
        labelSwapSideIndicator.text = ""
                        
        // first court side swap (if any), set point sum for swapping notification
        if swapAfterPoints == 0 {
            swapAfterPoints = leftScore + rightScore
        }
    }
    
    @IBAction func servingPlayerTap(_ sender: UITapGestureRecognizer) {
        toggleServingPosession()
    }
    
    func nextServingPlayerSeq() {
        let playerNumbers = ["1", "1", "2", "2"]
        
        servingChangeCount += 1
        labelServingPlayerSeq.text = playerNumbers[servingChangeCount%4]
    }
    
    func swapCourtSideReminder() {
        if swapAfterPoints != 0 && ((leftScore + rightScore) % swapAfterPoints) == 0 {
            labelSwapSideIndicator.text = "="
        }
        else {
            labelSwapSideIndicator.text = ""
        }

    }
    
    func toggleServingPosession() {
        servingPosessionLeft.toggle()
        
        if servingPosessionLeft {
            labelServingPlayer.text = "<"
        }
        else {
            labelServingPlayer.text = ">"
        }
    }
}
