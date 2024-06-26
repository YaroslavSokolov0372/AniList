//
//  ImageShape.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 21/12/2023.
//

import Foundation
import UIKit

extension CAShapeLayer {
    func createImageDetailView() {
        
        let curveRadius = CGFloat(50)
        let path = UIBezierPath()
        path.move(to: .zero)
            path.addLine(to: CGPoint(x: frame.width, y: 0))
        
//        path.addLine(to: CGPoint(x: frame.width, y: frame.height * 0.65))
//        path.addCurve(
//            to: CGPoint(x: frame.width - curveRadius, y: frame.height * 0.75),
//            controlPoint1: CGPoint(x: frame.width, y: frame.height * 0.75),
//            controlPoint2: CGPoint(x: frame.width, y: frame.height * 0.75))
//        path.addLine(to: CGPoint(x: frame.width * 0.85, y: frame.height * 0.75))
        
        path.addLine(to: CGPoint(x: frame.width, y: frame.height * 0.75))
        path.addCurve(
            to: CGPoint(x: frame.width - curveRadius, y: frame.height * 0.85),
            controlPoint1: CGPoint(x: frame.width, y: frame.height * 0.85),
            controlPoint2: CGPoint(x: frame.width, y: frame.height * 0.85))
        path.addLine(to: CGPoint(x: frame.width * 0.85, y: frame.height * 0.85))
        
        
        path.addCurve(
            to: CGPoint(x: frame.width * 0.78, y: (frame.height * 0.85) + curveRadius),
            controlPoint1: CGPoint(x: frame.width * 0.78, y: frame.height * 0.85),
            controlPoint2: CGPoint(x: frame.width * 0.78, y: frame.height * 0.85))
        
//        path.addCurve(
//            to: CGPoint(x: frame.width * 0.78, y: (frame.height * 0.75) + curveRadius),
//            controlPoint1: CGPoint(x: frame.width * 0.78, y: frame.height * 0.75),
//            controlPoint2: CGPoint(x: frame.width * 0.78, y: frame.height * 0.75))
        
        
        
        path.addCurve(
            to: CGPoint(x: frame.width * 0.70, y: frame.height),
            controlPoint1: CGPoint(x: frame.width * 0.78, y: frame.height),
            controlPoint2: CGPoint(x: frame.width * 0.78, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width * 0.32, y: frame.height))
        
        
//        path.addCurve(
//            to: CGPoint(x: frame.width * 0.22, y: frame.height - curveRadius),
//            controlPoint1: CGPoint(x: frame.width * 0.22, y: frame.height),
//            controlPoint2: CGPoint(x: frame.width * 0.22, y: frame.height))
//        path.addLine(to: CGPoint(x: frame.width * 0.22, y: frame.height * 0.85))
//        path.addCurve(
//            to: CGPoint(x: frame.width * 0.22 - curveRadius, y: frame.height * 0.75),
//            controlPoint1: CGPoint(x: frame.width * 0.22, y: frame.height * 0.75),
//            controlPoint2: CGPoint(x: frame.width * 0.22, y: frame.height * 0.75))
//        path.addLine(to: CGPoint(x: frame.width * 0.1, y: frame.height * 0.75))
        
        path.addCurve(
            to: CGPoint(x: frame.width * 0.22, y: frame.height - curveRadius),
            controlPoint1: CGPoint(x: frame.width * 0.22, y: frame.height),
            controlPoint2: CGPoint(x: frame.width * 0.22, y: frame.height))
        
        path.addLine(to: CGPoint(x: frame.width * 0.22, y: frame.height * 0.95))
        
        path.addCurve(
            to: CGPoint(x: frame.width * 0.22 - curveRadius, y: frame.height * 0.85),
            controlPoint1: CGPoint(x: frame.width * 0.22, y: frame.height * 0.85),
            controlPoint2: CGPoint(x: frame.width * 0.22, y: frame.height * 0.85))
        path.addLine(to: CGPoint(x: frame.width * 0.1, y: frame.height * 0.85))
        
        
//        path.addCurve(
//            to: CGPoint(x: 0, y: frame.height * 0.75 - curveRadius),
//            controlPoint1: CGPoint(x: 0, y: frame.height * 0.75),
//            controlPoint2: CGPoint(x: 0, y: frame.height * 0.75))
        path.addCurve(
            to: CGPoint(x: 0, y: frame.height * 0.85 - curveRadius),
            controlPoint1: CGPoint(x: 0, y: frame.height * 0.85),
            controlPoint2: CGPoint(x: 0, y: frame.height * 0.85))
        
        path.close()
        self.path = path.cgPath
    }
}
