//
//  SelectMonitorViewController.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2019/01/04.
//  Copyright © 2019 田中惇貴. All rights reserved.
//

import UIKit

class SelectMonitorViewController: UITableViewController {
    
    var pickerView: UIPickerView!
    
    var pickerCell: WisdomTableViewCell!
    
    var timerTableDelegate: TimerTableDelegate?
    
    // 時・分・秒のデータ
    let timeDatas = [[Int](0...23), [Int](0...59), [Int](0...59)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func cancelButtonDidTouch(sender: AnyObject) {
        // Cancelが押されたら
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonDidTouch(sender: AnyObject) {
        // Doneが押されたら
        // 新しいタイマーを作る
        let newTimer = pickerCell.makeTimer()
        
        if newTimer.initialWholeSecond == 0 {
            // 秒数０、失敗、アラートビュー
            let failAlert = UIAlertController(title: "Failed To Make Timer", message: "It is not possible to create a timer due to the specification of the number of seconds or for other reasons.", preferredStyle: UIAlertController.Style.alert)
            let sureButton = UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.cancel,
                handler: { action in
                    print("Timer has not been made.")
            })
            failAlert.addAction(sureButton)
            
            present(failAlert, animated: true, completion: nil)
        } else {
            // 秒数１以上、成功、メニュービューに追加
            
            if let navVC = self.navigationController!.presentingViewController as? UINavigationController {
                let menuView = navVC.viewControllers[0] as! MenuViewController
                
                menuView.timerArray.append(newTimer)
                
                self.timerTableDelegate = menuView
                
                self.dismiss(animated: true, completion: {
                    self.timerTableDelegate?.updateTableView()
                })
            }
        }
    }
    
//    These are the tableView (timePicker) Settings
//    これらはテーブルビュー(timePicker)の設定です
    
    let sections = ["Time", "Basic Status", "Alarm and Notification"]
    let basicCells = ["Title", "Repetation"]
    let notifyCells = ["Notification", "Sounds"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // テーブルビューのセクションの数
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // テーブルビューのセクションごとのセルの数
        var rows = 0
        if section == 0 {
            rows = 1
        } else if section == 1 {
            rows = notifyCells.count
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // セクションのヘッダーの名前
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // テーブルビューのセルの設定
        
        if indexPath.section == 0 {
            
            pickerCell = tableView.dequeueReusableCell(withIdentifier: "WisdomTableViewCell", for: indexPath) as? WisdomTableViewCell
            pickerCell.timePicker = pickerView
            
            return pickerCell
            
        } else if indexPath.section == 1 {
            
            var normalCell: UITableViewCell!
            normalCell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
            
            normalCell.textLabel?.text = basicCells[indexPath.row]
            
            if indexPath.row == 0 {
                normalCell.accessoryType = .disclosureIndicator
            }
            
            return normalCell
        } else {
            var normalCell2: UITableViewCell!
            normalCell2 = tableView.dequeueReusableCell(withIdentifier: "normalCell2", for: indexPath)
            
            normalCell2.textLabel?.text = notifyCells[indexPath.row]
            
            if indexPath.row == 1 {
                normalCell2.accessoryType = .disclosureIndicator
            }
            
            return normalCell2
        }
    }

}
