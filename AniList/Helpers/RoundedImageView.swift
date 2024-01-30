//
//  RoundedImageView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/01/2024.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
