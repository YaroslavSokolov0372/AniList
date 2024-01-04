//
//  AnimePreviewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import UIKit
import AnilistApi

 protocol AnimePreviewProtocol {
     func didTapCell(with type: GetAnimeByQuery.Data.Page.Medium)
}


class MenuAnimePreviewCell: UICollectionViewCell {
    
    //MARK: - Variables
    private var animeData: GetAnimeByQuery.Data.Page.Medium!
    private var gesture: UITapGestureRecognizer?
    public var delegate: AnimePreviewProtocol?

    //MARK: - UI Components
    private let releaseDate: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont().JosefinSans(font: .regular, size: 12)
        label.text = "error"
        return label
    }()
    
    private let coverImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont().JosefinSans(font: .regular, size: 14)
        label.text = "error"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.isUserInteractionEnabled = true
        gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(gesture!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        self.addSubview(coverImage)
        self.addSubview(name)
        self.addSubview(releaseDate)
        
        self.coverImage.translatesAutoresizingMaskIntoConstraints = false
        self.name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.coverImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            self.coverImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85),
            self.coverImage.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.name.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.name.topAnchor.constraint(equalTo: self.coverImage.bottomAnchor, constant: 10),
        ])
    }
    
    //MARK: - Local func
     @objc private func handleTap(_ sender: UITapGestureRecognizer) {
         self.delegate?.didTapCell(with: self.animeData)
    }
}

extension MenuAnimePreviewCell {
    
    
    public func configure(with animeData: GetAnimeByQuery.Data.Page.Medium) {
        self.animeData = animeData
        
        self.releaseDate.text = String(describing: animeData.startDate?.year)
        self.name.text = animeData.title?.english ?? animeData.title?.native
        self.coverImage.setImageFromStringrURL(stringUrl: animeData.coverImage?.extraLarge ?? "")
    }
}