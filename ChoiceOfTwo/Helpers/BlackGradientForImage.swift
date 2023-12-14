//
//  BlackGradientForImage.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 13/12/2023.
//

import Foundation
import UIKit

extension UIImageView {
    public func blackGradient() {
        
        let gradient = CAGradientLayer()
//        gradient.frame = CGRect(x: 0, y: 0, width: self.image?.size.width ?? 100, height: self.image?.size.height ?? 100)
        gradient.frame = CGRect(x: 0, y: 0, width: 180, height: 240)
        gradient.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(1.0).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.99)
        self.layer.addSublayer(gradient)
            
    }
}


//let gradient = CAGradientLayer()
//gradient.frame = CGRect(x: 0, y: 0, width: 120, height: 180)
//        gradient.colors = [UIColor.black.withAlphaComponent(1.0).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
//        gradient.locations = [0.0, 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
