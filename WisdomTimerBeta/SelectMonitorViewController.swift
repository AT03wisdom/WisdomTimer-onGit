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
    
    var titleMonitorVC: TitleMonitorViewController? = nil
    
    var pickerCell: WisdomTableViewCell!
    var titleCell: UITableViewCell!
    var stepperCell: UITableViewCell!
    
    var timerTableDelegate: TimerTableDelegate?
    
    var tentativeTitle: String!
    
    var repetationStepper: UIStepper = UIStepper()
    
    var notificationSwitch: UISwitch = UISwitch()
    var vibrationSwitch: UISwitch = UISwitch()
    
    // 時・分・秒のデータ
    let timeDatas = [[Int](0...23), [Int](0...59), [Int](0...59)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleMonitorVC = storyboard?.instantiateViewController(withIdentifier: "setTitle") as? TitleMonitorViewController
        
        repetationStepper.maximumValue = 100
        repetationStepper.minimumValue = 0
        repetationStepper.stepValue = 1
        repetationStepper.value = 1
        repetationStepper.addTarget(self, action: #selector(stepperAction(stepper:)), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TitleMonitorVCから帰ってきたときのアクション（タイトルを設定）
        
        print("\(String(describing: titleMonitorVC))がtimerMoniterのはずですよ？")
        
        if let cell = titleMonitorVC?.textCell {
            tentativeTitle = cell.getText()
            print("\(String(describing: tentativeTitle))がtentativeのはずですよ？")
            titleCell.detailTextLabel?.text = tentativeTitle
        }
        
        self.tableView.reloadData()
        super.viewWillAppear(true)
        print("reload&appearしとるぞ！生きとるぞ！")
    }
    
    @IBAction func cancelButtonDidTouch(sender: AnyObject) {
        // Cancelが押されたら
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonDidTouch(sender: AnyObject) {
        // Doneが押されたら
        // 新しいタイマーを作る
        let newTimer = pickerCell.makeTimer()
        
        newTimer.title = tentativeTitle
        newTimer.isNotification = notificationSwitch.isOn
        newTimer.isVibrate = vibrationSwitch.isOn
        newTimer.howrepetation = Int(repetationStepper.value)
        
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
    let notifyCells = ["Notification", "Vibration", "Sounds"]
    
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
            rows = basicCells.count
        } else if section == 2 {
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
                // title settings 名前設定
                titleCell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
                titleCell.textLabel?.text = basicCells[indexPath.row]
                titleCell.accessoryType = .disclosureIndicator
                titleCell.detailTextLabel?.text = ""
                
                if tentativeTitle != nil {
                    titleCell.detailTextLabel?.text = tentativeTitle
                }
                return titleCell
            }
            
            if indexPath.row == 1 {
                // repetation settings 繰り返し設定
                stepperCell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
                stepperCell.textLabel?.text = basicCells[indexPath.row]
                stepperCell.accessoryView = repetationStepper
                stepperCell.detailTextLabel?.text = String(Int(repetationStepper.value))
                return stepperCell
            }
            
            return normalCell
        } else {
            var normalCell2: UITableViewCell!
            normalCell2 = tableView.dequeueReusableCell(withIdentifier: "normalCell2", for: indexPath)
            
            normalCell2.textLabel?.text = notifyCells[indexPath.row]
            normalCell2.detailTextLabel?.text = ""
            
            if indexPath.row == 0 {
                // notification settings 通知設定
                normalCell2.accessoryView = notificationSwitch
            }
            
            if indexPath.row == 1 {
                // vibration settings 本体振動設定
                normalCell2.accessoryView = vibrationSwitch
            }
            
            if indexPath.row == 2 {
                // sounds settings 通知音設定
                normalCell2.accessoryType = .disclosureIndicator
            }
            
            return normalCell2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルが選択された時
        
        if indexPath.section == 1 && indexPath.row == 0 {
            // Title選択時
            tableView.deselectRow(at: indexPath, animated: true)
            
            performSegue(withIdentifier: "toTitleSettings", sender: nil)
        } else if indexPath.section == 2 && indexPath.row == 2 {
            // Sounds選択時
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            // いわゆるnormalCell
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTitleSettings" {
            titleMonitorVC = (segue.destination as? TitleMonitorViewController)!
            titleMonitorVC?.presentingVC = self
            
            if tentativeTitle != nil {
                titleMonitorVC?.textView.text = tentativeTitle
            }
        } else if segue.identifier == "i" {
            
        }
        
    }
    
    @objc func stepperAction(stepper: UIStepper) {
        // repetationStepperが変更された時、repetationLabelの値を変更させる
        let repeatTime: Int = Int(stepper.value)
        stepperCell.detailTextLabel?.text = "\(repeatTime)  "
    }

}
