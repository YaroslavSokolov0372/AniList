//
//  AnimePreviewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import UIKit
import AnilistApi

class AnimePreviewCell: UICollectionViewCell {
    
    //MARK: - Variables
//    private var animeData: GetAnimeBySortQuery.Data.Page.Medium!
    private var animeData: AnimeType!
    
    
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
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI

    
//    public func configure1(with animeData: GetAnimeBySeasonQuery.Data.Page.Medium) {
//        self.animeData = animeData
//        self.releaseDate.text = String(describing: self.animeData.startDate?.year)
//        self.name.text = self.animeData.title?.english ?? self.animeData.title?.native
//        self.coverImage.setImageFromStringrURL(stringUrl: self.animeData.coverImage?.extraLarge ?? "")
//    }
    
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
//            self.name.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            self.name.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -15),
//            self.name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.name.topAnchor.constraint(equalTo: self.coverImage.bottomAnchor, constant: 10),
        ])
    }
}





extension AnimePreviewCell {
    
//    public func configure(with animeData: GetAnimeBySortQuery.Data.Page.Medium) {
    public func configure(with animeData: AnimeType) {
        self.animeData = animeData
        
        switch self.animeData {
        case .curentSeasonPopular(let data):
            self.releaseDate.text = String(describing: data.startDate?.year)
            self.name.text = data.title?.english ?? data.title?.native
            self.coverImage.setImageFromStringrURL(stringUrl: data.coverImage?.extraLarge ?? "")
        case .popularAllTime(let data):
            self.releaseDate.text = String(describing: data.startDate?.year)
            self.name.text = data.title?.english ?? data.title?.native
            self.coverImage.setImageFromStringrURL(stringUrl: data.coverImage?.extraLarge ?? "")
        case .trendingNow(let data):
            self.releaseDate.text = String(describing: data.startDate?.year)
            self.name.text = data.title?.english ?? data.title?.native
            self.coverImage.setImageFromStringrURL(stringUrl: data.coverImage?.extraLarge ?? "")
        case .none:
            return
        }

    }
}
