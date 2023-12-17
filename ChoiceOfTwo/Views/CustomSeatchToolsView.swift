//
//  CustomSeatchToolsView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/12/2023.
//

import UIKit

class CustomSeatchToolsView: UIView {

    
    //MARK: UI Components
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Genres"
        label.font = UIFont().JosefinSans(font: .regular, size: 17)
        return label
    }()
    private let image: UIImageView = {
      
        let iv = UIImageView()
        iv.image = UIImage(named: "Arrow")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleToFill
        iv.tintColor = UIColor(named: "Gray")
        iv.transform = iv.transform.rotated(by: .pi / 2)
        return iv
        
    }()
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Any", for: .normal)
        button.setTitleColor(UIColor(named: "Gray"), for: .normal)
        button.titleLabel?.font = UIFont().JosefinSans(font: .regular, size: 14)
        button.backgroundColor = UIColor(named: "DarkBlack")
        button.layer.cornerRadius = 12
        return button
    }()
    
    
    //MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "Black")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SetupUI

    private func setupUI() {
        
        self.addSubview(title)
        self.addSubview(moreButton)
        moreButton.addSubview(image)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.title.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.title.heightAnchor.constraint(equalToConstant: 35),
            self.title.topAnchor.constraint(equalTo: self.topAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            self.moreButton.topAnchor.constraint(equalTo: title.bottomAnchor),
            self.moreButton.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.moreButton.heightAnchor.constraint(equalToConstant: 40),
            self.moreButton.titleLabel!.leadingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: 15),
            
            self.image.trailingAnchor.constraint(equalTo: moreButton.trailingAnchor, constant: -15),
            self.image.heightAnchor.constraint(equalToConstant: 15),
            self.image.widthAnchor.constraint(equalToConstant: 15),
            self.image.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor),
        ])
    }
}
