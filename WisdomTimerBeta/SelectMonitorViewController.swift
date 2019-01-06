//
//  SelectMonitorViewController.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2019/01/04.
//  Copyright © 2019 田中惇貴. All rights reserved.
//

import UIKit

class SelectMonitorViewController: UITableViewController {
    
    var wholeSeconds: Float!
    
    var pickerView: UIPickerView! = UIPickerView()

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
    }
    
//    These are the tableView (timePicker) Settings
//    これらはテーブルビュー(timePicker)の設定です
    
    let sections = ["Set Your Time", ""]
    let normalCells = ["Notification", "Sounds"]
    
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
            rows = normalCells.count
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // セクションのヘッダーの名前
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // テーブルビューのセルの設定
        var cell: WisdomTableViewCell!
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "WisdomTableViewCell", for: indexPath) as? WisdomTableViewCell
            cell.timePicker = pickerView
            
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath) as? WisdomTableViewCell
            
            cell.textLabel?.text = normalCells[indexPath.row]
            if indexPath.row == 1 {
                cell.accessoryType = .disclosureIndicator
            }
        } else {
            cell = WisdomTableViewCell()
        }
        
        return cell
    }

}
