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
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 10
        label.layer.cornerRadius = 10
        label.font = UIFont().JosefinSans(font: .regular, size: 12)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
//    init() {
//        super.init(frame: .zero)
//        setup()
//    }
    
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
    public func configure(genreName: String, borderColor: UIColor, borderWidth: CGFloat) {
        self.genreLabel.text = genreName
        self.genreLabel.layer.borderColor = borderColor.cgColor
        self.genreLabel.layer.borderWidth = borderWidth
    }
}


