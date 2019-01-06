//
//  TimerFile.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2018/12/05.
//  Copyright © 2018 田中惇貴. All rights reserved.
//

import UIKit
import AVFoundation

class TimerFile {
    
    // テキストを表示させるためのプロトコル
    var delegate: TimerViewProtocols?
    
    // 分も時も一つにまとめた秒数 （変化する）
    var currentWholeSecond: Float!
    
    // 分も時も一つにまとめた秒数 （最初からある）
    var initialWholeSecond: Float!
    
    // Pauseボタンが押された時に、保存します
    var pauseWholeSecond: Float!
    
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
    var isTimerStopping: Bool!
    
    // オリジナル・フリー音源の配列とオーディオプレーヤー
    var musicArray: [String] = ["receipt01"]
    var alarmAudioPlayer: AVAudioPlayer!
    
    // TimerFileの核部分、カウントダウンを制御する
    var timer: Timer = Timer()
    
    init(second: Int, minute: Int, hour: Int) {
        // LimitedTimeからのイニシャライザ
        self.limitedDeciSecond = 0
        self.limitedSecond = second
        self.limitedMinute = minute
        self.limitedHour = hour
        
        let wholeS = second + (minute * 60) + (hour * 3600)
        self.currentWholeSecond = Float(wholeS)
        self.initialWholeSecond = Float(wholeS)
        
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        
        title = "Timer-A"
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseObjc), userInfo: nil, repeats: true)
        
        alarmAudioPlayer = setSoundPlayer(fileName: "receipt01")
    }
    
    init(wholeSecond: Float) {
        // WholeTimeからのイニシャライザ
        reflectLimitedTime(time: wholeSecond)
        
        self.currentWholeSecond = Float(wholeSecond)
        self.initialWholeSecond = Float(wholeSecond)
        
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        
        title = "Timer-B"
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseObjc), userInfo: nil, repeats: true)
    }
    
    func increase(sec: Float) {
        self.currentWholeSecond += sec
        
        reflectLimitedTime(time: self.currentWholeSecond)
    }
    func decrease(sec: Float) {
        self.currentWholeSecond -= sec
        
        reflectLimitedTime(time: self.currentWholeSecond)
    }
    
    @objc func decreaseObjc() {
        self.currentWholeSecond -= 0.1
        
        reflectLimitedTime(time: self.currentWholeSecond)
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        
        if self.currentWholeSecond <= 0.0 {
            // タイマー終了時
            timer.invalidate()
        }
    }
    
    func reflectLimitedTime(time: Float) {
        // wholeSecond を Limited Time群に反映する
        
        // Intにして値を繰り下げる
        let wholeSecondInt: Int = Int(time)
        
        self.limitedDeciSecond = Int( Float(wholeSecondInt) - time * 10 )
        self.limitedSecond = wholeSecondInt % 60
        self.limitedMinute = (wholeSecondInt % 3660) / 60
        self.limitedHour = wholeSecondInt / 3600
    }
    
    func reflectTimeText(second: Int, minute: Int, hour: Int) {
        
        //  テキストに表示（デシ秒非対応）
        var hourString: String = String(hour)
        var minuteString: String = String(minute)
        var secondString: String = String(second)
        
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
        let passage: String = "\(hourString):\(minuteString):\(secondString)"
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
        let passage: String = "\(hourString):\(minuteString):\(second):\(decisecond)"
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
    
    func doneAction() {
        // Doneボタンが押された時
        
        // タイマーの状況を全部リセットする
        timer.invalidate()
        
        // 時間・表示をinit時に戻す
        self.currentWholeSecond = self.initialWholeSecond
        reflectLimitedTime(time: self.initialWholeSecond)
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        
        self.pauseWholeSecond = self.initialWholeSecond
    }
    
    func pauseAction() {
        // restartボタンが押された時 (Pause)
        
        // pauseWholeSecondに保存！
        self.pauseWholeSecond = self.currentWholeSecond
        // タイマーの状況を全部リセットする
        timer.invalidate()
    }
    
    func restartAction() {
        // restartボタンが押された時
        
        // 時間・表示をpause時に戻す
        self.currentWholeSecond = self.pauseWholeSecond
        reflectLimitedTime(time: self.initialWholeSecond)
        reflectTimeText(second: self.limitedSecond, minute: self.limitedMinute, hour: self.limitedHour)
        
        // timerはリスタート必至
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decreaseObjc), userInfo: nil, repeats: true)
    }
    
}
