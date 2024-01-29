//
//  RelationCollectionViewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 28/01/2024.
//

import UIKit
import AnilistApi

protocol relationCollectionViewCellDelegate {
    func onTapGesture(data: GetAnimeByQuery.Data.Page.Medium.Relations.Node)
}

class RelationCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    private var gesture: UITapGestureRecognizer?
    
    public var delegate: relationCollectionViewCellDelegate?
    
    private var data: GetAnimeByQuery.Data.Page.Medium.Relations.Node?
    
    private var activeNameConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeNameConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeNameConstraints)
        }
    }
    
    //MARK: - UIComponents
    private let image: UIImageView = {
        let imageV = UIImageView()
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 12
        return imageV
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.font = UIFont().JosefinSans(font: .regular, size: 17)
        label.sizeToFit()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let formatOfAnime: UILabel = {
        let label = UILabel()
        label.font = UIFont().JosefinSans(font: .regular, size: 16)
        //        label.textColor = .white
        label.textColor = UIColor(named: "Gray")
        return label
    }()
    
    private let currentState: UILabel = {
        let label = UILabel()
        label.font = UIFont().JosefinSans(font: .regular, size: 16)
        //        label.textColor = .white
        label.textColor = UIColor(named: "Gray")
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "DarkBlack")
        self.layer.cornerRadius = 12
        
        self.isUserInteractionEnabled = true
        gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(gesture!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setupUI() {
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(formatOfAnime)
        formatOfAnime.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(currentState)
        currentState.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.34),
            image.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            name.widthAnchor.constraint(equalToConstant: contentView.frame.width - image.frame.width - 20),
            
            formatOfAnime.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            formatOfAnime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            currentState.leadingAnchor.constraint(equalTo: formatOfAnime.trailingAnchor, constant: 5),
            currentState.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    //MARK: - Func
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if self.data?.format != .case(.manga) {
            self.delegate?.onTapGesture(data: self.data!)
        }
        print("DEBUG: -", "Pressed Relative cell")
    }
    
    public func configure(info: GetAnimeByQuery.Data.Page.Medium.Relations.Node) {
        self.data = info
        self.image.setImageFromStringrURL(stringUrl: info.coverImage?.extraLarge ?? "")
        
        if let englishName = info.title?.english {
            self.name.text = englishName
        } else if let userPrefered = info.title?.userPreferred {
            self.name.text = userPrefered
        }
        
        let mediaSeason = info.format?.value
        self.formatOfAnime.text = mediaSeason?.getName()
        switch info.status {
        case .case(.cancelled):
            self.currentState.text = "· Cancelled"
        case .case(.finished):
            self.currentState.text = "· Finished"
        case .case(.hiatus):
            self.currentState.text = "· Paused"
        case .case(.notYetReleased):
            self.currentState.text = "· Not yet released"
        case .case(.releasing):
            self.currentState.text = "· Releasing"
        case .none:
            return
        case .some(.unknown(_)):
            return
        }
        
        setupUI()
        
        if self.name.numberOfLines > 8 {
            self.name.numberOfLines = 8
        }
    }
}


