//
//  TimerViewController.swift
//  WisdomTimer onGit
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
    
    @IBOutlet var upperButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.title = timerFile.title
        timeLabel.text = timerFile.passageForTimerLabel
        
        timerFile.delegate = self
        
        //        clearButton.placeButton(device: device, screen: screen, buttonType: 2)
        //        upperButton.placeButton(device: device, screen: screen, buttonType: 1)
        //
        //        print(clearButton.frame.origin.x)
        //        print((clearButton.frame.width, clearButton.frame.height))
        
        if timerFile.timer.isValid {
            // タイマーが動いている時
            upperButton.setTitle(NSLocalizedString("Pause", comment: ""), for: .normal)
            upperButton.setTitleColorToLightGreen()
        } else {
            // タイマーが止まっている時
            upperButton.setTitle(NSLocalizedString("Start", comment: ""), for: .normal)
            upperButton.setTitleColorToMagenta()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeRotateAction),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        upperButton.layer.cornerRadius = 10
        upperButton.titleLabel?.font = UIFont.systemFont(ofSize: 0.045 * self.view.bounds.height)
        upperButton.titleLabel?.adjustsFontSizeToFitWidth = true
        upperButton.titleLabel?.minimumScaleFactor = 0.3
        
        drawUpperButton()
        
        clearButton.layer.cornerRadius = 10
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 0.045 * self.view.bounds.height)
        clearButton.setTitleColor(UIColor(red: 0.1, green: 0.2, blue: 0.9, alpha: 1.0), for: .normal)
        
        //        悲しいことに、フォントとかボタンサイズに関してはAutorayoutが優先される関係で全く働いていない！
        //        if UIScreen.main.bounds.width >= 800 && UIScreen.main.bounds.height >= 800 {
        //            upperButton.frame.size = CGSize(width: 250, height: upperButton.frame.height)
        //            clearButton.frame.size = CGSize(width: 250, height: upperButton.frame.height)
        //        }
    }
    
    @objc func changeRotateAction() {
        upperButton.titleLabel?.font = UIFont.systemFont(ofSize: 0.045 * self.view.bounds.height)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 0.045 * self.view.bounds.height)
    }
    
    @IBAction func onClearButton() {
        timerFile.clearAction()
        
        reflectButtonStyle(tag: "Clear")
        timerFile.isSoonAsFromBackground = false
    }
    
    @IBAction func onUpperButton() {
        
        if upperButton.titleLabel?.text == NSLocalizedString("Pause", comment: "") {
            timerFile.pauseAction()
            reflectButtonStyle(tag: "Pause")
        } else {
            
            if timerFile.isBeforeStart {
                timerFile.startAction()
                reflectButtonStyle(tag: "Start")
            } else {
                timerFile.resumeAction()
                reflectButtonStyle(tag: "Resume")
            }
        }
        
    }
    
    func drawUpperButton() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let paddingRect = upperButton.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
            upperButton.draw(paddingRect)
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
        case "Resume":
            // Resume ボタンが押された時
            upperButton.setTitle(NSLocalizedString("Pause", comment: ""), for: .normal)
            upperButton.setTitleColorToLightGreen()
            
        case "Pause":
            // Pause ボタンが押された時
            
            // iPad・日本語の時は位置調整のために空白を設け「　再開　」にする
            var resumeString = NSLocalizedString("Resume", comment: "")
            
            let language_region: String = NSLocale.preferredLanguages.first!
            let lang: String = language_region.components(separatedBy: "-").first!
            
            if UIDevice.current.userInterfaceIdiom == .pad && lang == "ja" {
                resumeString = "　" + resumeString + "　"
            }
            
            upperButton.setTitle(resumeString, for: .normal)
            upperButton.setTitleColorToMagenta()
            
        case "Clear":
            // Clear ボタンが押された時
            upperButton.setTitle(NSLocalizedString("Start", comment: ""), for: .normal)
            upperButton.setTitleColorToMagenta()
            
        default:
            print("\(tag)が引数に入力されました。関数は実行されません。")
        }
        
        drawUpperButton()
    }
    
    // Delegate ここまで
    
}
