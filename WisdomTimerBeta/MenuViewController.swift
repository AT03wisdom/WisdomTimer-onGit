//
//  ViewController.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2018/12/05.
//  Copyright © 2018 田中惇貴. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, TimerTableDelegate {
    
    @IBOutlet var timerTable: UITableView!
    
    var timerArray:[TimerFile] = []
    
    let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timerTable.dataSource = self
        timerTable.delegate = self
        
        // アプリ立ち上がり時に呼ばれ、予約通知の解除とタイマーから引き算する
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(prepareForForeground),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        // バックグラウンド中に通知を送るために、それぞれのタイマーの終了時刻になったら通知がなるようにセットする
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(prepareForBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timerTable.reloadData()
        super.viewWillAppear(true)
    }
    
    func updateTableView() {
        self.timerTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // コンテンツの数を揃える
        return timerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // コンテンツをテーブルビューに入力
        let content = tableView.dequeueReusableCell(withIdentifier: "wTimer", for: indexPath)
        
        content.textLabel?.text = timerArray[indexPath.row].title
        
        return content
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // 簡単にセルが除去できるようにする(タイマー停止も忘れず)
        timerArray[indexPath.row].timer.invalidate()
        timerArray.remove(at: indexPath.row)
        timerTable.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        // 専用ぺーじを開く
        let numberOfTouchedCell: Int = indexPath.row
        performSegue(withIdentifier: "ToTimerView", sender: numberOfTouchedCell)
    }
    
    @IBAction func tapAddButton() {
//        let wtimer: TimerFile = TimerFile(second: 0, minute: 1, hour: 0)
//        timerArray.append(wtimer)
        
        // 新しいSelectMenuControllerに移ろう
        let selectMenuViewController: UINavigationController! = self.storyboard?.instantiateViewController(withIdentifier: "SelectMonitor") as? UINavigationController
        
        selectMenuViewController.modalPresentationStyle = .custom
        selectMenuViewController.transitioningDelegate = self
        present(selectMenuViewController, animated: true, completion: nil)
        
        timerTable.reloadData()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // UIViewControllerTransitioningDelegate
        return SelectMonitorPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // UIViewControllerTransitioningDelegate
        return CustomAnimatedTransitioning(isPresent: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // UIViewControllerTransitioningDelegate
        return CustomAnimatedTransitioning(isPresent: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TimerViewControllerに値を渡す
        if segue.identifier == "ToTimerView" {
            
            let timerViewController: TimerViewController = segue.destination as! TimerViewController
            let row: Int = sender as! Int
            timerViewController.timerFile = self.timerArray[row]
        }
    }
    
    // バックグラウンド中にタイマーが終了した時に通知を送るという予約の解除
    // タイマーのセーブ
    @objc func prepareForForeground() {
        // 閉じていた時間を計算し、全てのアクティブなタイマーから引き算する
        if let interval = appdelegate.timeDatabase.object(forKey: "intervalTime") {
            
            for timerFile in timerArray {
                print(timerFile.currentWholeSecond, timerFile.savedSecond)
                if !timerFile.isBeforeStart {
                    
                    timerFile.cancelNotificationTrigger()
                    timerFile.specialRestartAction(interval: interval as! TimeInterval)
                }
            }
        }
    }
    
    // バックグラウンド中にタイマーが終了した時に通知を送るという予約
    // タイマーの適応時間分前に進める
    @objc func prepareForBackground() {
        
        for timerFile in timerArray {
            if !timerFile.isBeforeStart {
                
                timerFile.saveTime()
                timerFile.setNotificationTrigger()
            }
        }
    }
    
    // バックグラウンド中にタイマーが終了した時に通知を送るという予約の解除
    func cancelNotificationsTrigger() {
        // 未使用
    }

}

