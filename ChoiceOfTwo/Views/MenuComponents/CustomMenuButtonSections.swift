//
//  CustomButton.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import UIKit

class CustomMenuButtonSections: UIButton {

    init(title: String, hasCustomTint: Bool, customTint: String?, systemTintColor: UIColor?) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont().JosefinSans(font: .bold, size: 19)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
        
        let background = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        self.addSubview(background)
        
        if hasCustomTint {
            self.tintColor = UIColor(named: customTint ?? "")
        } else {
            self.tintColor = systemTintColor ?? .black
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
