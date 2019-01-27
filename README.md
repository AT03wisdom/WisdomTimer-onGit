# WisdomTimerBeta (日本語)
こんにちは。WisdomTimerのBeta版ページへようこそ。

## 概要
このアプリはタイマーを複数作成することができるアプリです。

## 動作環境・サポート言語など
iOS 11以上

swift 4.2  Xcode 10.1

Apple未申請

アプリの最新のバージョン：　（未発表）

## 使い方


## 制作の経緯

### 動機
私は時間の管理が下手で、バックグラウンドで動くタイマーアプリが欲しかったのですが、いいものがなかったので自分で作りました。

### 作者
@ImaZin03 (2003年生まれ、2月で16歳)

Swift歴
4ヶ月くらい

これは自分で作った、App Storeに出す初めてのアプリということもあり、何から初めていいかわかりませんでした。
しかし、「Life is Tech!」さんのプログラミングスクールに通って、今ではSwiftにはかなり詳しくなっていますし、まだまだ拙いですがある程度のことはわかります。

## 力を入れたコード

### 1.画面遷移・半モーダルビュー

画面遷移は大変難しいです。特にタイマー編集画面の半モーダルビューの実装はかなり難しく、半モーダルビューと遷移元との値の受け渡しにとても苦労しました。

MenuViewController.swiftより抜粋

``` swift
@IBAction func tapAddButton() {
    // 右上の＋ボタンを押した時にSelectMonitorViewControllerに遷移
    let selectMenuViewController: UINavigationController! = self.storyboard?.instantiateViewController(withIdentifier: "SelectMonitor") as? UINavigationController
    selectMenuViewController.modalPresentationStyle = .custom
    present(selectMenuViewController, animated: true, completion: nil)
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // セルを押した時にTimerViewControllerに遷移
    // セルの選択解除
    tableView.deselectRow(at: indexPath, animated: true)
    // 専用ページを開く
    let numberOfTouchedCell: Int = indexPath.row
    performSegue(withIdentifier: "ToTimerView", sender: numberOfTouchedCell)
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TimerViewControllerに値を渡す
    if segue.identifier == "ToTimerView" {

        let timerViewController: TimerViewController = segue.destination as! TimerViewController
        let row: Int = sender as! Int
        timerViewController.timerFile = self.timerArray[row]
    }
}
```

アプリとは思った以上に画面遷移が多く、その際に大変な処理を実施しようとしていることがよくわかりました。

### 2.擬似バックグラウンド

iOSアプリでは、音楽の再生などの一部の機能を除き、バックグラウンド使用を認められていません。

そのため私は、以下に示すやり方であたかもバックグラウンド処理が行われているかのように実装しました。

>1. アプリ終了時に現在時刻を計測する。この時刻をAとし、UserDefaultsに保存する。
2. バックグラウンド中にタイマーが終了した時に通知を送るために、それぞれのタイマーの終了時刻になったら通知がなるようにセットする。
3. アプリ開始時に現在時刻を計測する。この時刻をBとする。
4. 2.でやった通知のセットを解除する。
5. BとAとの時刻の差を求め、その分時刻を前に進める。

ここでは詳しいコードは記載しませんが、総勢1200行以上にも及ぶ集大成です。公開された暁には、ぜひダウンロードの方をよろしくお願いします。

## 音源提供
ポケットサウンド – http://pocket-se.info/

## インスパイアを受けたアプリ
Time Timer

https://itunes.apple.com/us/app/time-timer/id332520417

https://www.timetimer.com/

## Special Thanks
Life is Tech!



# WisdomTimerBeta (English)
Hello. Welcome to the page of WisdomTimer Beta Edition.

## Overview
This application is an application that can create multiple timers.

## Operating environment · Support language etc.
iOS 11 or higher

swift 4.2 Xcode 10.1

No Apple applicant

The latest version of the application: (unreleased)

## Usage

# Background of production

### Motivation
I wanted a timer application that is not good at managing time and runs in the background, but since I did not have a good one, I made it myself.

### author
@ImaZin03 (born in 2003, 16 in February)

Swift history
About 4 months

This is my first app to put on the App Store, which I made, and I did not know what to do for the first time.
However, I went to the programming school "Life is Tech!" And now I am quite familiar with Swift and I am still a bit scary but I understand to some extent.

## Interested code

### 1. Screen transition and Half-modal view

The screen transition is very difficult. 
Especially implementation of semi-modal view of timer edit screen is quite difficult, and it was very difficult to pass values between semi-modal view and transition source.

Extracted from MenuViewController.swift

``` swift
@IBAction func tapAddButton() {
    // Transition to SelectMonitorViewController when pressing the + button on the upper right
    let selectMenuViewController: UINavigationController! = self.storyboard?.instantiateViewController(withIdentifier: "SelectMonitor") as? UINavigationController
    selectMenuViewController.modalPresentationStyle = .custom
    present(selectMenuViewController, animated: true, completion: nil)
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Transition to TimerViewController when cell is pushed
    // Deselect cell
    tableView.deselectRow(at: indexPath, animated: true)
    // Open dedicated page
    let numberOfTouchedCell: Int = indexPath.row
    performSegue(withIdentifier: "ToTimerView", sender: numberOfTouchedCell)
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Passing a value to TimerViewController
    if segue.identifier == "ToTimerView" {

        let timerViewController: TimerViewController = segue.destination as! TimerViewController
        let row: Int = sender as! Int
        timerViewController.timerFile = self.timerArray[row]
    }
}
```

I understood that there are more screen transitions than I thought, and I am trying to carry out extensive processing at that time.

### 2. Pseudo background

In the iOS application, except for some functions such as music playback, background use is not allowed.

Therefore, I implemented it as if background processing was done in the following way.

> 1. Measure the current time at the end of the application. Let this time be A, and save it in UserDefaults.
2. In order to send a notification when the timer expires during the background, set to notify when the end time of each timer comes.
3. Measure the current time at the start of the application. Let this time be B.
4. Release the set of notifications done in 2.
5. Find the difference in time between B and A, and advance the time forward.

Although detailed codes are not described here, it is a culmination that extends over a total of 1,200 lines. Thank you for downloading by all means when it is released.

## Sound source provision
ポケットサウンド – http://pocket-se.info/

## Inspiration
Time Timer

https://itunes.apple.com/us/app/time-timer/id332520417

https://www.timetimer.com/

## Special Thanks
Life is Tech!
