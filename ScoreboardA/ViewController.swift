//
//  ViewController.swift
//  ScoreboardA
//
//  Created by Jozef Marusak on 2018-02-05.
//  Copyright © 2018 Jozef Marusak. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {
    var leftScore = 0
    var rightScore = 0
    var swapAfterPoints = 0
    var servingChangeCount = 0
    
    enum ServingPosession {
        case left
        case right
    }
    var servingPosession = ServingPosession.left;
    
    @IBOutlet weak var labelLeftScore: UILabel!
    @IBOutlet weak var labelRightScore: UILabel!
    @IBOutlet weak var labelServingPlayer: UILabel!
    
    @IBOutlet weak var textFieldPlayer1: UITextField!
    @IBOutlet weak var textFieldPlayer2: UITextField!
    @IBOutlet weak var textFieldPlayer3: UITextField!
    @IBOutlet weak var textFieldPlayer4: UITextField!
    
    @IBOutlet weak var tapRightOnce: UITapGestureRecognizer!
    @IBOutlet weak var tapRightTwice: UITapGestureRecognizer!
    @IBOutlet weak var tapLeftOnce: UITapGestureRecognizer!
    @IBOutlet weak var tapLeftTwice: UITapGestureRecognizer!
    
    var servingSeq = [UITextField]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldPlayer1.delegate = self
        textFieldPlayer2.delegate = self
        textFieldPlayer3.delegate = self
        textFieldPlayer4.delegate = self
        
        tapRightOnce.require(toFail: tapRightTwice)
        tapLeftOnce.require(toFail: tapLeftTwice)
        
        reset()
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
            reset()
        }
    }

    @IBAction func leftScodeTapOnce(_ sender: UITapGestureRecognizer) {
        leftScore += 1
        labelLeftScore.text = String(leftScore)
        
        if servingPosession == .right {
            toggleServingPosession()
        }

        swapCourtSideReminder()
    }
    
    @IBAction func rightScoreTap(_ sender: UITapGestureRecognizer) {
        rightScore += 1
        labelRightScore.text = String(rightScore)

        if servingPosession == .left {
            toggleServingPosession()
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
        swapCourtSide()
    }
    
    @IBAction func servingPlayerTap(_ sender: UITapGestureRecognizer) {
        toggleServingPosession()
    }
    

    
    func swapCourtSide() {
        let tempScore = leftScore
        leftScore = rightScore
        rightScore = tempScore

        labelLeftScore.text = String(leftScore)
        labelRightScore.text = String(rightScore)

        let tempColor = labelLeftScore.textColor
        labelLeftScore.textColor = labelRightScore.textColor
        labelRightScore.textColor = tempColor
        
        var tempPlayerInitials = textFieldPlayer1.text
        textFieldPlayer1.text = textFieldPlayer3.text
        textFieldPlayer3.text = tempPlayerInitials
        tempPlayerInitials = textFieldPlayer2.text
        textFieldPlayer2.text = textFieldPlayer4.text
        textFieldPlayer4.text = tempPlayerInitials
              

        switch servingPosession {
        case .left:
            labelServingPlayer.text = ">"
            servingPosession = .right
        case .right:
            labelServingPlayer.text = "<"
            servingPosession = .left
        }
        serviceSeqSwap()
        servingPlayerShow()
                     
        // first court side swap (if any), set point sum for swapping notification
        if swapAfterPoints == 0 {
         swapAfterPoints = leftScore + rightScore
        }

        // beep
        AudioServicesPlaySystemSound(SystemSoundID(1352))
    }
    
    func swapCourtSideReminder() {
        if swapAfterPoints != 0 && ((leftScore + rightScore) % swapAfterPoints) == 0 {
            swapCourtSide()
        }
    }
    
    func toggleServingPosession() {
        switch servingPosession {
        case .left:
            labelServingPlayer.text = ">"
            servingPosession = .right
        case .right:
            labelServingPlayer.text = "<"
            servingPosession = .left
        }

        if rightScore + leftScore == 0 {
           serviceSeqSwap()
        }
        else {
            servingChangeCount += 1
        }
        servingPlayerShow()
    }
    
   func servingPlayerShow() {
       for player in servingSeq {
           player.backgroundColor = .white
       }
       servingSeq[servingChangeCount%4].backgroundColor = .lightGray
   }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func reset() {
        leftScore = 0
        labelLeftScore.text = String(leftScore)
        
        rightScore = 0
        labelRightScore.text = String(rightScore)
        
        swapAfterPoints = 0
        
        servingPosession = .left
        labelServingPlayer.text = "<"

        servingChangeCount = 0
        servingSeq = [textFieldPlayer1, textFieldPlayer3, textFieldPlayer2, textFieldPlayer4]
        servingPlayerShow()
    }
    
    func serviceSeqSwap() {
        var textFieldPlayerTmp = servingSeq[0]
        servingSeq[0] = servingSeq[1]
        servingSeq[1] = textFieldPlayerTmp
        
        textFieldPlayerTmp = servingSeq[2]
        servingSeq[2] = servingSeq[3]
        servingSeq[3] = textFieldPlayerTmp
    }
    
}
