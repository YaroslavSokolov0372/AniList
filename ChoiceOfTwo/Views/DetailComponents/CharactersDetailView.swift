//
//  CharactersDetailView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 29/01/2024.
//

import UIKit
import AnilistApi

class CharactersDetailView: UIView {
    
    //MARK: - UI Components
    private let image: UIImageView = {
        let imageV = UIImageView()
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 12
        return imageV
    }()
    
    private let charName: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let charDescription: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
    }
    
    
    //MARK: - Func
    public func configure(data: GetAnimeByQuery.Data.Page.Medium.Characters.Node) {
        if let largeImage = data.image?.large {
            self.image.setImageFromStringrURL(stringUrl: largeImage)
        } else if let mediumImage = data.image?.medium {
            self.image.setImageFromStringrURL(stringUrl: mediumImage)
        }
        
        
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(charName)
        charName.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(charDescription)
        charDescription.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalTo: self.heightAnchor),
            image.widthAnchor.constraint(equalTo: self.widthAnchor),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        ])
        
        
    }
    
    public func configureAsRelative(data: GetAnimeByQuery.Data.Page.Medium.Relations.Node.Characters.Node) {
        
    }
    
    public func animate() {
        
    }
}
