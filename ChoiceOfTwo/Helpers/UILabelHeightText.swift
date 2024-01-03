//
//  UILabelHeight.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 27/12/2023.
//

import Foundation
import UIKit


extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
//        print(label.frame.height)
        return label.frame.height
     }
}




