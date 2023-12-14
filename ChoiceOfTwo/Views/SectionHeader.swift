//
//  CustomHeader.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import UIKit

class SectionHeader: UILabel {

    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = UIFont().JosefinSans(font: .bold, size: 17)
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
