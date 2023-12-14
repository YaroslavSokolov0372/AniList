//
//  FontExtension.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import Foundation
import UIKit

extension UIFont {
    
     enum JosefinSans: String {
        case bold = "JosefinSans-Bold"
        case semiBold = "JosefinSans-SemiBold"
        case extraLight = "JosefinSans-ExtraLight"
        case light = "JosefinSans-Light"
        case medium = "JosefinSans-Medium"
        case regular = "JosefinSans-Regular"
        case thin =  "JosefinSans-Thin"
    }
    
    func JosefinSans(font: JosefinSans, size: CGFloat) -> UIFont? {
        return UIFont(name: font.rawValue, size: size)
    }
}
