//
//  WisdomTableViewCell.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2019/01/05.
//  Copyright © 2019 田中惇貴. All rights reserved.
//

import UIKit

class WisdomTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // 時・分・秒のデータ
    let timeDatas = [[Int](0...23), [Int](0...59), [Int](0...59)]
    
    var limitedSecond: Int = 0
    var limitedMinute: Int = 0
    var limitedHour: Int = 0
    
    // UIPickerViewなどのOutletは、UITableViewCellに直接挿入できないので新しいクラスで定義
    @IBOutlet var timePicker: UIPickerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // デリゲートを使えるようにするおきまりのあれ
        
        timePicker.dataSource = self
        timePicker.delegate = self
        
        // 時データ
        let hourLabel = UILabel()
        hourLabel.text = "hour"
        hourLabel.sizeToFit()
        hourLabel.frame = CGRect(x: timePicker.bounds.width/4 - hourLabel.bounds.width/2, y: timePicker.bounds.height/2 - hourLabel.bounds.height, width: hourLabel.bounds.width, height: hourLabel.bounds.height)
        timePicker.addSubview(hourLabel)
        
        // 分データ
        let minuteLabel = UILabel()
        minuteLabel.text = "minute"
        minuteLabel.sizeToFit()
        minuteLabel.frame = CGRect(x: timePicker.bounds.width/4*2 - minuteLabel.bounds.width/2, y: timePicker.bounds.height/2 - minuteLabel.bounds.height, width: minuteLabel.bounds.width, height: minuteLabel.bounds.height)
        timePicker.addSubview(minuteLabel)
        
        // 秒データ
        let secondLabel = UILabel()
        secondLabel.text = "second"
        secondLabel.sizeToFit()
        secondLabel.frame = CGRect(x: timePicker.bounds.width/4*3 - secondLabel.bounds.width/2, y: timePicker.bounds.height/2 - secondLabel.bounds.height, width: secondLabel.bounds.width, height: secondLabel.bounds.height)
        timePicker.addSubview(secondLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func makeTimer() -> TimerFile {
        let timer: TimerFile = TimerFile(second: limitedSecond,
                                         minute: limitedMinute,
                                         hour: limitedHour)
        return timer
    }
    
    //    These are the timePicker Delegate
    //    これらはtimePickerのDelegateです
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // ピッカービューの列数（三つ）
        return timeDatas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // ピッカービューの行数（24 or 60）
        return timeDatas[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.width * 1/4
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // pickerViewに値を挿入
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.left
        pickerLabel.text = String(timeDatas[component][row])
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            limitedHour = timeDatas[0][row]
        case 1:
            limitedMinute = timeDatas[1][row]
        case 2:
            limitedSecond = timeDatas[2][row]
        default:
            assert(false, "Because of confirming unknown conponent value \(component)")
        }
    }

}
