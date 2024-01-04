//
//  AdditionalSearchToolsCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 03/01/2024.
//

import UIKit


class ToolsOptionsCell: UITableViewCell {
    
    //MARK: - UI Components
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Arrow")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleToFill
        iv.tintColor = UIColor(named: "Gray")
        iv.transform = iv.transform.rotated(by: .pi / 2)
        return iv
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Any", for: .normal)
        button.setTitleColor(UIColor(named: "Gray"), for: .normal)
        button.titleLabel?.font = UIFont().JosefinSans(font: .regular, size: 14)
        button.backgroundColor = UIColor(named: "DarkBlack")
        button.layer.cornerRadius = 12
        return button
    }()

    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(named: "DarkBlack")
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setup() {
        self.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            self.plusButton.topAnchor.constraint(equalTo: self.bottomAnchor),
            self.plusButton.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.plusButton.heightAnchor.constraint(equalToConstant: 40),
            self.plusButton.titleLabel!.leadingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: 15),
            
            self.image.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: -15),
            self.image.heightAnchor.constraint(equalToConstant: 15),
            self.image.widthAnchor.constraint(equalToConstant: 15),
            self.image.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
        ])
    }
}

extension ToolsOptionsCell {
    
    public func configure() {
        
    }
}
