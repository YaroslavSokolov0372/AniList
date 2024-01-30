//
//  LeftImageTexField.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 19/12/2023.
//

import Foundation
import UIKit


extension UITextField {
    func leftImage(_ image: UIImage?, imageSize: CGSize, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageSize.width, height: imageSize.height)
        imageView.contentMode = .scaleToFill
        imageView.tintColor = UIColor(named: "Gray")
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize.width + (2 * padding), height: imageSize.height))
        containerView.addSubview(imageView)
        leftView = containerView
        leftViewMode = .always
    }
}


extension UITextField {
    func rightImage(_ image: UIImage?, imageSize: CGSize, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageSize.width, height: imageSize.height)
        imageView.contentMode = .scaleToFill
        imageView.tintColor = UIColor(named: "Gray")
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize.width + (2 * padding), height: imageSize.height))
        containerView.addSubview(imageView)
        rightView = containerView
        rightViewMode = .always
    }
}
