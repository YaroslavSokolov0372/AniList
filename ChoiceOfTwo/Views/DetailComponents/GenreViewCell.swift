//
//  GenreVIewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 24/12/2023.
//

import UIKit

class GenreViewCell: UICollectionViewCell {
    
//    public let genre: String!
    //MARK: - UI Components
    private var genreLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        
//        label.layer.borderWidth = 12
        //        label.layer.borderColor = UIColor.red.cgColor
//                label.layer.cornerRadius = 12
        //        label.layer.borderWidth = 10
//                label.layer.cornerRadius = 10
        //        label.font = UIFont().JosefinSans(font: .regular, size: 12)
        
        label.font = UIFont().JosefinSans(font: .regular, size: 15)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI
    private func setup() {
        
        self.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            genreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            genreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            genreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            genreLabel.topAnchor.constraint(equalTo: self.topAnchor),
            genreLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
            genreLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
             
        ])
    }
}


extension GenreViewCell {
    public func configure(genreName: String, borderWidth: CGFloat, backgroundColor: String?) {
        if let hexStr = backgroundColor {
//            self.genreLabel.layer.borderColor = UIColor().hexStringToUIColor(hex: hexStr).darker(by: 20)?.cgColor
//            self.genreLabel.layer.cornerRadius = 30
            self.genreLabel.layer.cornerRadius = 30
            self.genreLabel.backgroundColor = UIColor().hexStringToUIColor(hex: hexStr).darker(by: 20)
        } else {
            self.genreLabel.backgroundColor = UIColor(.white.opacity(0.5))
//            self.genreLabel.layer.cornerRadius = 12
//            self.genreLabel.layer.borderColor = UIColor(.white.opacity(0.5)).cgColor
        }
        self.genreLabel.layer.cornerRadius = 12
        self.genreLabel.text = genreName
//        self.genreLabel.layer.borderColor = borderColor.cgColor
//        self.genreLabel.layer.borderWidth = borderWidth
    }
}


