//
//  scrollToTheBeginning.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/01/2024.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToBeginning(isVertical: Bool) {
        if isVertical {
            let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
            setContentOffset(desiredOffset, animated: true)
        } else {
            let desiredOffset = CGPoint(x: -contentInset.left, y: 0)
            setContentOffset(desiredOffset, animated: true)
        }
   }
}
