//
//  TextWriterCell.swift
//  WisdomTimer onGit
//
//  Created by 田中惇貴 on 2019/01/13.
//  Copyright © 2019 田中惇貴. All rights reserved.
//

import UIKit

class TextWriterCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    
    var presentingVC: SelectMonitorViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "TimerName"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getText() -> String! {
        return textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presentingVC.titleCell.detailTextLabel!.text = getText()
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        presentingVC.titleCell.detailTextLabel!.text = getText()
        return true
    }

}
