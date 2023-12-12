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
    private var animeData: GetAnimeByQuery.Data.Page.MediaList!
    
    private let releaseDate: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont().JosefinSans(font: .regular, size: 14)
        label.text = "error"
        return label
    }()
    
    //MARK: - UI Components
    private let name: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont().JosefinSans(font: .regular, size: 14)
        label.text = "error"
        return label
    }()
    
    private let coverImage: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
//        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    //MARK: - lifecycle
//    init(animeData: GetAnimeByQuery.Data.Page.MediaList) {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.width / 2
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    public func configure(with animeData: GetAnimeByQuery.Data.Page.MediaList) {
        self.animeData = animeData
        self.releaseDate.text = String(describing: self.animeData.media?.startDate?.year)
        self.name.text = self.animeData.media?.title?.english
        
        self.coverImage.setImageFromStringrURL(stringUrl: self.animeData.media?.coverImage?.medium ?? "")
    }
    
    private func setupUI() {
        self.addSubview(coverImage)
        self.addSubview(name)
        self.addSubview(releaseDate)
        
        self.coverImage.translatesAutoresizingMaskIntoConstraints = false
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.releaseDate.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            coverImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
//            coverImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1)
        ])
    }
}



//        DispatchQueue.main.async {
//            let imageData = try? Data(contentsOf: URL(string: self.animeData.media?.coverImage?.medium ?? "")!)
//            if let imageData {
//                DispatchQueue.main.async { [weak self] in
//                    self?.coverImage.image = UIImage(data: imageData)
//                }
//            }
//        }
