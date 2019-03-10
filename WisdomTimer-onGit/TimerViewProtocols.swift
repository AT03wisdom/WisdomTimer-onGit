//
//  TimerViewProtocols.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2018/12/26.
//  Copyright © 2018 田中惇貴. All rights reserved.
//

import Foundation
import UIKit

protocol TimerViewProtocols {
    // TimerViewControllerが設定し、TimerFileで実行される
    func showText(text: String) -> Void
    
    func reflectButtonStyle(tag: String) -> Void
}

protocol TimerTableDelegate {
    // MenuViewControllerが設定し、SelectMonitorViewControllerで実行される
    func updateTableView() -> Void
}
