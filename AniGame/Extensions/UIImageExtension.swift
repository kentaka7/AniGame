//
//  UIImageExtension.swift
//  AniGame
//
//  Created by takakura naohiro on 2018/10/19.
//  Copyright © 2018年 GeoMagnet. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    // 比率だけ指定する場合
    func resize(ratio: CGFloat) -> UIImage {
        let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    //横幅を基準に比率を変えずリサイズ
    func resizeUIImageByWidth(width: Double) -> UIImage {
        let aspectRate = self.size.height / self.size.width
        let resizedSize = CGSize(width: width, height: width * Double(aspectRate))
        UIGraphicsBeginImageContext(resizedSize)
        self.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    //縦幅を基準にリサイズ
    func resizeUIImageByHeight(height: Double) -> UIImage {
        let aspectRate = self.size.width / self.size.height
        let resizedSize = CGSize(width: height * Double(aspectRate), height: height)
        UIGraphicsBeginImageContext(resizedSize)
        self.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    //画像全体にレイヤーを張り合わせる
    func photoAddDarkLayer(color:UIColor,alpha:CGFloat) -> UIImage {
        let frame = CGRect(origin:CGPoint(x:0,y:0),size:self.size)
        let tempView = UIView(frame:frame)
        tempView.backgroundColor = color
        tempView.alpha = alpha
        
        // 画像を新しいコンテキストに描画する
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.draw(in: frame)
        
        // コンテキストに黒レイヤを乗せてレンダー
        context!.translateBy(x: 0, y: frame.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        context!.clip(to: frame, mask: self.cgImage!)
        tempView.layer.render(in: context!)
        
        let imageRef = context!.makeImage()
        let darkImage = UIImage(cgImage:imageRef!)
        UIGraphicsEndImageContext()
        
        return darkImage
    }
}
