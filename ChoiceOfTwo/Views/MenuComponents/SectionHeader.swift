//
//  CustomHeader.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import UIKit

class SectionHeader: UIView {
    
    
    //MARK: - UI Components
    private let title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont().JosefinSans(font: .bold, size: 15)
        label.textColor = .white
        
        return label
    }()

//    private let image: UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(named: "Arrow")?.withRenderingMode(.alwaysTemplate)
//        iv.contentMode = .scaleToFill
//        iv.tintColor = UIColor(named: "Gray")
//        iv.transform = iv.transform.rotated(by: .pi / 2)
//        return iv
//    }()
    
    private let moreButton: UIButton = {
      let button = UIButton()
        button.setImage(UIImage(named: "Arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView!.contentMode = .scaleToFill
        button.imageView!.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.imageView!.tintColor = .white
        return button
    }()
    
    
    //MARK: - Lifecycle
    init(text: String) {
        super.init(frame: .zero)
        title.text = text
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI
    private func setup() {
        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.widthAnchor.constraint(equalToConstant: 200),
            title.heightAnchor.constraint(equalToConstant: 20),
            
            moreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 20),
            moreButton.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    //MARK: - Func
    public func addDidTappedMoreButtonTarget(_ target: Any?, action: Selector) {
        moreButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
