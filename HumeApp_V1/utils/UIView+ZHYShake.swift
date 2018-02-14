//
//  UIView+ZHYShake.swift
//  HumeApp_V1
//
//  Created by MileyLiu on 14/2/18.
//  Copyright © 2018 MileyLiu. All rights reserved.
//

import Foundation
import UIKit

/// 抖动方向
///
/// - horizontal: 水平抖动
/// - vertical:   垂直抖动
public enum ZHYShakeDirection: Int {
    case horizontal
    case vertical
    case curve
}

extension UIView {
    
    /// ZHY 扩展UIView增加抖动方法
    ///
    /// - Parameters:
    ///   - direction:  抖动方向    默认水平方向
    ///   - times:      抖动次数    默认5次
    ///   - interval:   每次抖动时间 默认0.1秒
    ///   - offset:     抖动的偏移量 默认2个点
    ///   - completion: 抖动结束回调
    public func shake(direction: ZHYShakeDirection = .horizontal, times: Int = 5, interval: TimeInterval = 0.1, offset: CGFloat = 10, completion: (() -> Void)? = nil) {
        
        //移动视图动画（一次）
        UIView.animate(withDuration: interval, animations: {
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform(CGAffineTransform(translationX: offset, y: 0))
            case .vertical:
                self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: offset))
            case .curve:
            
                let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
                animation.duration = interval
                animation.fromValue = Double.pi/2
                animation.toValue = Double.pi/2
               animation.repeatCount = HUGE
                animation.autoreverses = true
                self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
                self.layer.add(animation, forKey: "rotation")
            }
            
            
        }) { (complete) in
            //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) in
                    completion?()
                })
            }
                
                //如果当前不是最后一次，则继续动画，偏移位置相反
            else {
                self.shake(direction: direction, times: times - 1, interval: interval, offset: -offset, completion: completion)
            }
        }
    }
}

