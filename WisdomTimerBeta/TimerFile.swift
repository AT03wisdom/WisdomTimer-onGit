//
//  TimerFile.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2018/12/05.
//  Copyright © 2018 田中惇貴. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import AudioToolbox

class TimerFile {
    
    // テキストを表示させるためのプロトコル
    var delegate: TimerViewProtocols?
    
    // 分も時も一つにまとめた秒数 （変化する）
    var currentWholeSecond: Double!
    
    // 分も時も一つにまとめた秒数 （最初からある）
    var initialWholeSecond: Double!
    
    // Pauseボタンが押された時に、保存します
    var pauseWholeSecond: Double!
    
    // バックグラウンドに入る時に表示される秒数
    var savedSecond: Double!
    
    // 10, 60まで来ると繰り上がるタイプの秒分時(Limited Time), デシ秒
    var limitedDeciSecond: Int!
    var limitedSecond: Int!
    var limitedMinute: Int!
    var limitedHour: Int!
    
    // title（タイマーそのものの名前）, passageForTimerLabel（タイマーの時間表示）
    var title: String!
    var passageForTimerLabel: String!
    
    // デシ秒を使えるか
    var isDeciSecond: Bool!
    
    // タイマーがカウントダウンしてるか
    var isBeforeStart: Bool!
    
    // 通知やバイブレーションなどについて
    var isNotification: Bool!
    var isVibrate: Bool!
    var howrepetation: Int!
    
    // オリジナル・フリー音源の配列とオーディオプレーヤー
    var musicArray: [String] = ["receipt01"]
    var alarmAudioPlayer: AVAudioPlayer!
    var notificationPlayer: UNNotificationSound!
    
    // TimerFileの核部分、カウントダウンを制御する
    var timer: Timer = Timer()
    
    init(second: Int, minute: Int, hour: Int) {
        // LimitedTimeからのイニシャライザ
        self.limitedDeciSecond = 0
        self.limitedSecond = second
        self.limitedMinute = minute
        self.limitedHour = hour
        
        let wholeS = second + (minute * 60) + (hour * 3600)
        self.currentWholeSecond = Double(wholeS)
        self.initialWholeSecond = Double(wholeS)
        
        isDeciSecond = false
        isBeforeStart = true
        
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        
        title = "New Timer A"
        
        let bothFileName = "receipt01"
        alarmAudioPlayer = setSoundPlayer(fileName: bothFileName)
        notificationPlayer = setNotificationPlayer(fileName: bothFileName)
    }
    
    init(wholeSecond: Double) {
        // WholeTimeからのイニシャライザ
        reflectLimitedTime(time: wholeSecond)
        
        self.currentWholeSecond = Double(wholeSecond)
        self.initialWholeSecond = Double(wholeSecond)
        
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        
        title = "New Timer B"
        
        isDeciSecond = true
        isBeforeStart = true
        
        let bothFileName = "receipt01"
        alarmAudioPlayer = setSoundPlayer(fileName: bothFileName)
        notificationPlayer = setNotificationPlayer(fileName: bothFileName)
    }
    
    func increase(sec: Double) {
        self.currentWholeSecond += sec
        
        reflectLimitedTime(time: self.currentWholeSecond)
    }
    func decrease(sec: Double) {
        self.currentWholeSecond -= sec
        
        reflectLimitedTime(time: self.currentWholeSecond)
    }
    
    @objc func decreaseObjc() {
        self.currentWholeSecond -= 0.1
        
        reflectLimitedTime(time: self.currentWholeSecond)
        
        if isDeciSecond {
            reflectTimeText(decisecond: self.limitedDeciSecond,
                            second: self.limitedSecond,
                            minute: self.limitedMinute,
                            hour: self.limitedHour)
        } else {
            let secPointDeciSecond: Double = Double(self.limitedSecond) + Double(self.limitedDeciSecond)/10
            reflectTimeText(second: secPointDeciSecond, minute: self.limitedMinute, hour: self.limitedHour)
        }
        
        if self.currentWholeSecond <= 0.0 {
            // タイマー終了時
            timer.invalidate()
            
            self.isBeforeStart = true
            
            if UIApplication.shared.applicationState == .background {
                self.cancelNotificationTrigger()
            }
            
            DispatchQueue.main.asyncAfter( deadline: .now() + 0.2 ) {
                //処理
                self.doneAction()
                self.delegate?.reflectButtonStyle(tag: "Done")
                
                if self.isVibrate {
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                }
                
                if self.isNotification {
                    self.notificationAction(timeLimit: 0)
                }
                
                //                self.alarmAudioPlayer.play()
                AudioServicesPlaySystemSound(1007)
            }
        }
    }
    
    func reflectLimitedTime(time: Double) {
        // wholeSecond を Limited Time群に反映する
        
        // Intにして値を繰り下げる
        let wholeSecondInt: Int = Int(time)
        
        self.limitedDeciSecond = Int( (time - Double(wholeSecondInt)) * 10 )
        self.limitedSecond = wholeSecondInt % 60
        self.limitedMinute = (wholeSecondInt % 3600) / 60
        self.limitedHour = wholeSecondInt / 3600
        
        if !self.isDeciSecond && self.limitedSecond == 59 && self.limitedDeciSecond != 0 {
            self.limitedDeciSecond = 0
            self.limitedSecond += 1
        }
        
        if self.limitedSecond == 60 {
            self.limitedSecond = 0
            self.limitedMinute += 1
        }
        
        if self.limitedMinute == 60 {
            self.limitedMinute = 0
            self.limitedHour += 1
        }
    }
    
    func reflectTimeText(second: Double, minute: Int, hour: Int) {
        
        //  テキストに表示（デシ秒非対応）
        
        let mixedSecond: Int = Int(ceil(second))
        
        var hourString: String = String(hour)
        var minuteString: String = String(minute)
        var secondString: String = String(mixedSecond)
        
        if hour < 10 {
            hourString = "0" + hourString
        }
        if minute < 10 {
            minuteString = "0" + minuteString
        }
        if mixedSecond < 10 {
            secondString = "0" + secondString
        }
        
        // テキストに表示（TimerViewへはデリゲートを使う）
        let passage: String = "\(hourString):\(minuteString):\(secondString)"
        self.passageForTimerLabel = passage
        
        delegate?.showText(text: passage)
    }
    
    func reflectTimeText(second: Int, minute: Int, hour: Int) {
        
        //  テキストに表示（デシ秒非対応）
        var hourString: String = "0"
        var minuteString: String = "0"
        var secondString: String = "0"
        
        if !self.isDeciSecond && self.limitedSecond == 59 && self.limitedDeciSecond != 0 {
            
            // 59秒xデシ秒時の特別処理
            hourString = String(hour)
            secondString = String(0)
            minuteString = String(minute + 1)
            
            if minuteString == "59" {
                // 59分時の特別処理
                minuteString = String(0)
                hourString = String(hour + 1)
            }
        } else {
            
            hourString = String(hour)
            minuteString = String(minute)
            secondString = String(second)
        }
        
        if hour < 10 {
            hourString = "0" + hourString
        }
        if minute < 10 {
            minuteString = "0" + minuteString
        }
        if second < 10 {
            secondString = "0" + secondString
        }
        
        // テキストに表示（TimerViewへはデリゲートを使う）
        let passage: String!
        if self.isDeciSecond {
            passage = "\(hourString):\(minuteString):\(secondString):0"
        } else {
            passage = "\(hourString):\(minuteString):\(secondString)"
        }
        self.passageForTimerLabel = passage
        
        delegate?.showText(text: passage)
    }
    
    func reflectTimeText(decisecond: Int, second: Int, minute: Int, hour: Int) {
        //  テキストに表示（デシ秒対応）
        var hourString: String = String(hour)
        var minuteString: String = String(minute)
        var secondString: String = String(second)
        var decisecondString: String = String(decisecond)
        
        if hour < 10 {
            hourString = "0" + hourString
        }
        if minute < 10 {
            minuteString = "0" + minuteString
        }
        if second < 10 {
            secondString = "0" + secondString
        }
        if decisecond < 10 {
            decisecondString = "0" + decisecondString
        }
        
        // テキストに表示（TimerViewへはデリゲートを使う）
        let passage: String = "\(hourString):\(minuteString):\(secondString):\(decisecondString)"
        self.passageForTimerLabel = passage
        
        delegate?.showText(text: passage)
    }
    
    func setSoundPlayer(fileName: String) -> AVAudioPlayer? {
        // audioPlayerの値設定、初期化時に読み込む、任意時に再生可
        if let path = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            let soundURL = URL(fileURLWithPath: path)
            
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                return audioPlayer
            }catch {
                print(error)
                return nil
            }
        } else {
            print("Error! (アラーム音楽が見つからないためこちらに逃がしているぞ)")
            return nil
        }
        
    }
    
    func setNotificationPlayer(fileName: String) -> UNNotificationSound? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            
            let audioPlayer = UNNotificationSound(named: UNNotificationSoundName(rawValue: path))
            return audioPlayer
            
        } else {
            print("Error! (通知音楽が見つからないためこちらに逃がしているぞ)")
            return nil
        }
    }
    
    // ボタンプッシュ時の関数
    // 4種
    
    func startAction() {
        // restartボタンが押された時 (Start)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseObjc), userInfo: nil, repeats: true)
        
        isBeforeStart = false
    }
    
    func doneAction() {
        // Doneボタンが押された時
        
        // タイマーの状況を全部リセットする
        timer.invalidate()
        
        // 時間・表示をinit時に戻す
        self.currentWholeSecond = self.initialWholeSecond
        reflectLimitedTime(time: self.initialWholeSecond)
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        
        self.pauseWholeSecond = self.initialWholeSecond
        
        isBeforeStart = true
    }
    
    func pauseAction() {
        // restartボタンが押された時 (Pause)
        
        // pauseWholeSecondに保存！
        self.pauseWholeSecond = self.currentWholeSecond
        // タイマーの状況を全部リセットする
        timer.invalidate()
        
        isBeforeStart = false
    }
    
    func restartAction() {
        // restartボタンが押された時 (Restart)
        
        // 時間・表示をpause時に戻す
        self.currentWholeSecond = self.pauseWholeSecond
        reflectLimitedTime(time: self.currentWholeSecond)
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        
        // timerはリスタート必至
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseObjc), userInfo: nil, repeats: true)
        
        isBeforeStart = false
    }
    
    // バックグラウンド終了・復帰時の関数
    // 4種
    
    func saveTime() {
        // バックグラウンド入る時に呼ばれる
        // 時間の保存
        self.savedSecond = self.currentWholeSecond
        print("saveSecond :")
        print(self.savedSecond)
        
        timer.invalidate()
        
    }
    
    func specialRestartAction(interval: TimeInterval) {
        
        print(interval, self.savedSecond)
        // アプリバックグラウンド復帰時その時間で再開
        
        // 時間・表示をバックグラウンド入る前に戻す
        self.currentWholeSecond = self.savedSecond - interval
        reflectLimitedTime(time: self.currentWholeSecond)
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        //        print("specialRestartTime :")
        //        print(self.limitedSecond, self.limitedMinute, self.limitedHour)
        
        // timerはリスタート必至
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseObjc), userInfo: nil, repeats: true)
        
        isBeforeStart = false
    }
    
    func setNotificationTrigger() {
        // 通知を予約する
        self.notificationAction(timeLimit: self.currentWholeSecond)
    }
    
    func cancelNotificationTrigger() {
        // 通知を解除する
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.title])
    }
    
    func notificationAction(timeLimit: Double) {
        // 通知する
        
        // すぐに一度だけ通知（発火）
        let trigger: UNTimeIntervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeLimit + 0.5, repeats: false)
        // 通知の中身
        let content = UNMutableNotificationContent()
        content.title = self.title
        content.body = "タイマーが終了しました。"
        content.sound = self.notificationPlayer
        
        // 通知を送信
        let request = UNNotificationRequest(identifier: self.title, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print("Failed to add request")
                print(error.localizedDescription)
            }
        }
    }
    
}
