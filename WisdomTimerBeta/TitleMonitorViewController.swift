//
//  TitleMonitorViewController.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2019/01/13.
//  Copyright © 2019 田中惇貴. All rights reserved.
//
import UIKit
class TitleMonitorViewController: UITableViewController {
    
    var textCell: TextWriterCell!
    var textView: UITextField!
    
    var presentingVC: SelectMonitorViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        textCell = tableView.dequeueReusableCell(withIdentifier: "titleName", for: indexPath) as? TextWriterCell
        
        if textView != nil {
            if let newTitle = textView.text {
                textCell.textField?.text = newTitle
            }
        }
        
        textCell.presentingVC = self.presentingVC
        
        return textCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TextWriterCell {
            cell.becomeFirstResponder()
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
