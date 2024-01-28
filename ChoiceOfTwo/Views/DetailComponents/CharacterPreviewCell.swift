//
//  CharacterPreviewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 27/01/2024.
//

import UIKit
import AnilistApi

class CharacterPreviewCell: UICollectionViewCell {
    
    
    //MARK: - Variables
    
    //MARK: - UI Components
    var name: UILabel = {
        let label = UILabel()

        label.textColor = .white
        label.font = UIFont().JosefinSans(font: .regular, size: 14)
        return label
    }()
    
    var image: UIImageView = {
      let imageV = UIImageView()
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 12
        return imageV
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupUI
    private func setup() {
        self.contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//            image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
//            image.heightAnchor.constraint(equalToConstant: 100),
//            image.widthAnchor.constraint(equalToConstant: 70),
            image.heightAnchor.constraint(equalToConstant: 160),
            image.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
        ])
    }
    
    //MARK: - Func
    public func configure(info: GetAnimeByQuery.Data.Page.Medium.Characters.Node?) {
        if let largeImage = info?.image?.large {
            self.image.setImageFromStringrURL(stringUrl: largeImage)
        } else if let mediumImage = info?.image?.medium {
            self.image.setImageFromStringrURL(stringUrl: mediumImage)
        }
        
        if let userPreferedName = info?.name?.userPreferred {
            name.text = userPreferedName
        } else if let fullName = info?.name?.full {
            name.text = fullName
        } else {
            name.text = "?"
        }
    }
}
