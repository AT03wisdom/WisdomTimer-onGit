//
//  TimerViewController.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2018/12/07.
//  Copyright © 2018 田中惇貴. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, TimerViewProtocols {
    
    var timerFile: TimerFile!
    
//    let device: UIDevice = UIDevice.current
//    let screen: UIScreen = UIScreen.main
    
    @IBOutlet var titleLabel: UINavigationItem!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var restartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.title = timerFile.title
        timeLabel.text = timerFile.passageForTimerLabel
        
        timerFile.delegate = self
        
//        doneButton.placeButton(device: device, screen: screen, buttonType: 2)
//        restartButton.placeButton(device: device, screen: screen, buttonType: 1)
//
//        print(doneButton.frame.origin.x)
//        print((doneButton.frame.width, doneButton.frame.height))
        
        if timerFile.timer.isValid {
            // タイマーが動いている時
            restartButton.setTitle("Pause", for: .normal)
            restartButton.setTitleColorToLightGreen()
        } else {
            // タイマーが止まっている時
            restartButton.setTitle("Start", for: .normal)
            restartButton.setTitleColorToMagenta()
        }
        
        restartButton.layer.cornerRadius = 10
        
        doneButton.layer.cornerRadius = 10
        doneButton.setTitleColor(UIColor(red: 0.1, green: 0.2, blue: 0.9, alpha: 1.0), for: .normal)
        
    }
    
    @IBAction func onDoneButton() {
        timerFile.doneAction()
        
        reflectButtonStyle(tag: "Done")
    }
    
    @IBAction func onRestartButton() {
        
        if restartButton.titleLabel?.text == "Pause" {
            timerFile.pauseAction()
            reflectButtonStyle(tag: "Pause")
        } else {
            
            if timerFile.isBeforeStart {
                timerFile.startAction()
                reflectButtonStyle(tag: "Start")
            } else {
                timerFile.restartAction()
                reflectButtonStyle(tag: "Restart")
            }
        }
        
    }
    
    // Delegate ここから
    func showText(text: String) {
        timeLabel.text = text
    }
    
    func reflectButtonStyle(tag: String) {
        
        switch tag {
        case "Start":
            // Start ボタンが押された時
            fallthrough
        case "Restart":
            // Restart ボタンが押された時
            restartButton.setTitle("Pause", for: .normal)
            restartButton.setTitleColorToLightGreen()
            
        case "Pause":
            // Pause ボタンが押された時
            restartButton.setTitle("Restart", for: .normal)
            restartButton.setTitleColorToMagenta()
            
        case "Done":
            // Done ボタンが押された時
            restartButton.setTitle("Start", for: .normal)
            restartButton.setTitleColorToMagenta()
            
        default:
            print("\(tag)が引数に入力されました。関数は実行されません。")
        }
    }
    
    // Delegate ここまで

}
