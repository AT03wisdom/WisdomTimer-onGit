//
//  SelectMonitorPresentationController.swift
//  WisdomTimerBeta
//
//  Created by 田中惇貴 on 2018/12/31.
//  Copyright © 2018 田中惇貴. All rights reserved.
//

import UIKit

class SelectMonitorPresentationController: UIPresentationController {
    
    // MenuViewの上に重なるView
    var overlayView = UIView()
    
    // 表示トランジション開始前に呼ばれる
    override func presentationTransitionWillBegin() {
        
        super.presentationTransitionWillBegin()
        
        self.overlayView = UIView(frame: containerView!.bounds)
        self.overlayView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(escape(_:)))]
        
        
        self.overlayView.backgroundColor = .black
        self.overlayView.alpha = 0.0
        containerView!.insertSubview(overlayView, at: 0)
        
        // トランジションを実行
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] context in
            self?.overlayView.alpha = 0.7
            }, completion:nil)
    }
    
    // 非表示トランジション開始前に呼ばれる
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] context in
            self?.overlayView.alpha = 0.0
            }, completion:nil)
    }
    
    // 非表示トランジション開始後に呼ばれる
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            overlayView.removeFromSuperview()
        }
    }
    
    // 子のコンテナのサイズを返す
    // margin: どのくらい余白を作るか（上下左右合わせて）
    
    let appOrientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    var wholeViewSize: CGSize!
    var margin: (x: CGFloat, y: CGFloat)!
    
    func sizeForChildContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        wholeViewSize = parentSize
        if UIDevice.current.userInterfaceIdiom == .pad {
            if appOrientation == .landscapeLeft || appOrientation == .landscapeRight {
                // iPad横向き
                margin = (x: CGFloat(parentSize.height * 1/3), y: CGFloat(parentSize.height * 1/3))
                return CGSize(width: parentSize.height * 2/3 , height: parentSize.height * 2/3 )
            } else {
                // iPad縦向き
                margin = (x: CGFloat(parentSize.width * 1/3), y: CGFloat(parentSize.width * 1/3))
                return CGSize(width: parentSize.width * 2/3 , height: parentSize.width * 2/3 )
            }
        } else {
            if appOrientation == .landscapeLeft || appOrientation == .landscapeRight {
                // iPhone横向き
                margin = (x: CGFloat(250), y: CGFloat(40))
            } else {
                // iPhone縦向き
                margin = (x: CGFloat(40), y: CGFloat(220.0))
            }
            return CGSize(width: parentSize.width - margin.x, height: parentSize.height - margin.y)
        }
    }
    
    // 呼び出し先の View Controller の Frame を返す
    override var frameOfPresentedViewInContainerView: CGRect {
        
        var presentedViewFrame = CGRect()
        let containerBounds = containerView!.bounds
        let childContentSize = sizeForChildContainer(container: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.size = childContentSize
        
        // iPhoneのモーダルビュー（図形の左上）
        if UIDevice.current.userInterfaceIdiom == .pad {
            if appOrientation == .landscapeLeft || appOrientation == .landscapeRight {
                // iPad横向き
                presentedViewFrame.origin.x = wholeViewSize.width/2 - childContentSize.width/2
                presentedViewFrame.origin.y = margin.y / 2
            } else {
                // iPad縦向き
                presentedViewFrame.origin.x = margin.x / 2
                presentedViewFrame.origin.y = wholeViewSize.height/2 - childContentSize.height/2
            }
        } else {
            presentedViewFrame.origin.x = margin.x / 2
            presentedViewFrame.origin.y = margin.y / 2
        }
        
        return presentedViewFrame
        
    }
    
    // レイアウト開始前に呼ばれる
    override func containerViewWillLayoutSubviews() {
        overlayView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
    }
    
    // レイアウト開始後に呼ばれる
    override func containerViewDidLayoutSubviews() {
    }
    
    // presentatedViewControllerをとじる（UITapGestureRecognizerによってしか使えない？？？？）
    @objc func escape(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
