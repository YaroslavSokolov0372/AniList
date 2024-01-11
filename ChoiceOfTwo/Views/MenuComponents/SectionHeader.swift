//
//  CustomHeader.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import UIKit

protocol HeaderMoreButtonProtocol {
    func moreButtonTapped(_ sender: UIButton)
}

class SectionHeader: UIView {
    
    
    //MARK: - Variables
    var delegate: HeaderMoreButtonProtocol?
    
    //MARK: - UI Components
    private let title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont().JosefinSans(font: .bold, size: 15)
        label.textColor = .white
        
        return label
    }()
    
    private let moreButton: UIButton = {
      let button = UIButton()
        button.setImage(UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView!.contentMode = .scaleToFill
        button.imageView!.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.imageView!.tintColor = .white
        return button
    }()
    
    
    //MARK: - Lifecycle
    init(text: String) {
        super.init(frame: .zero)
        title.text = text
        self.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
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
    @objc private func moreButtonTapped(_ sender: UIButton) {
        self.delegate?.moreButtonTapped(sender)
    }
}
