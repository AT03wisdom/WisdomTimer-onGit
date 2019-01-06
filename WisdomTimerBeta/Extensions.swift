//
//  Extensions.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2018/12/28.
//  Copyright © 2018 田中惇貴. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setTitleColorToMagenta() {
        self.setTitleColor(UIColor(red: 1.0, green: 0.2, blue: 1.0, alpha: 1.0), for: .normal)
    }
    
    func setTitleColorToLightGreen() {
        self.setTitleColor(UIColor(red: 0.0, green: 0.9, blue: 0.4, alpha: 1.0), for: .normal)
    }
    
    func placeButton(device: UIDevice, screen: UIScreen, buttonType: Int) {
        // デバイスによってボタン配置箇所を変える
        if device.model == "iPad" {
            // iPadでのUI
            if buttonType == 2 {
                self.layer.position = CGPoint(x: screen.nativeBounds.width * 0.3, y: screen.nativeBounds.height * 0.9)
            } else {
                self.layer.position = CGPoint(x: screen.nativeBounds.width * 0.7, y: screen.nativeBounds.height * 0.9)
            }
            
        } else if device.model == "iPhone" {
            // iPhoneでのUI
            placeButtonOnEachPhone(button: self, screen: screen, buttonType: buttonType)
            
        } else if device.model == "iPod Touch" {
            // iPod TouchでのUI （iPhone 5系・SEと同じ）
        } else {
            assert(false, "デバイスが対応していません。")
        }

    }
}

func placeButtonOnEachPhone(button: UIButton, screen: UIScreen, buttonType: Int) {
    
    let valueToAddX: CGFloat!
    
    switch screen.nativeBounds.height {
    case 960:
        // iPhone 4, 4S のUI
        button.layer.position = CGPoint(x: 60, y: 30)
    case 1136:
        // iPhone 5, 5S, 5C, SE のUI
        button.layer.position = CGPoint(x: 60, y: 30)
    case 1334:
        // iPhone 6, 6S, 7, 8 のUI
        button.layer.position = CGPoint(x: 60, y: 30)
    case 2208:
        // iPhone 6+, 6S+, 7+, 8+ のUI
        button.layer.position = CGPoint(x: 60, y: 30)
    case 2436:
        // iPhone X, (XS) のUI
        button.layer.position = CGPoint(x: 60, y: 30)
    case 1792:
        // iPhone XR のUI
        button.layer.position = CGPoint(x: 60, y: 30)
    case 2688:
        // iPhone XS Max のUI
        button.layer.position = CGPoint(x: 60, y: 30)
    default:
        // その他
        print((button, screen, buttonType))
        print("見つからなかったので適当に代入")
        if buttonType == 2 {
            valueToAddX = screen.nativeBounds.height * 0.6
        } else {
            valueToAddX = screen.nativeBounds.height * 0.1
        }
        button.layer.frame = CGRect(x: valueToAddX, y: screen.nativeBounds.height * 0.75, width: screen.nativeBounds.height / 10, height: screen.nativeBounds.height / 36)
        button.titleLabel?.font = UIFont.systemFont(ofSize: screen.nativeBounds.height / 40)
        button.layer.position = CGPoint(x: 60, y: 30)
    }
}
