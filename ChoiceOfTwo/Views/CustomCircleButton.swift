//
//  CustomCircleButton.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/12/2023.
//

import UIKit

class CustomCircleButton: UIButton {
    
    //MARK: - Lifecycle
    init(hasBackground: Bool, image: UIImage, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.setImage(image.resized(to: CGSize(width: 40, height: 40)), for: .normal)
        self.imageView?.contentMode = .scaleAspectFill
        
        self.imageView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.imageView!.tintColor = .white
        self.backgroundColor = backgroundColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
