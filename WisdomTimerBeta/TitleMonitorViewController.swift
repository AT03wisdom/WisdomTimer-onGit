//
//  TitleMonitorViewController.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2019/01/13.
//  Copyright © 2019 田中惇貴. All rights reserved.
//
import UIKit
class TitleMonitorViewController: UITableViewController {
    
    var textView: UITextField!
    var titleText: String!
    
    var cell: TextWriterCell!

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
        cell = tableView.dequeueReusableCell(withIdentifier: "titleName", for: indexPath) as? TextWriterCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TextWriterCell {
            cell.becomeFirstResponder()
        }
    }
}
