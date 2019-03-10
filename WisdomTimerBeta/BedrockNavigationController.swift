//
//  BedrockNavigationController.swift
//  WisdomTimer onGit
//
//  Created by 田中惇貴 on 2019/03/06.
//  Copyright © 2019 田中惇貴. All rights reserved.
//

import UIKit

class BedrockNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //　ナビゲーションバーの背景色
        navigationBar.barTintColor = UIColor(red: 0.01, green: 3/16, blue: 0.6, alpha: 0.8)
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = UIColor.white
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
