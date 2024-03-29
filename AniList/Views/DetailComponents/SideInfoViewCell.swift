//
//  SideInfoViewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 27/12/2023.
//

import UIKit
import AnilistApi

class SideInfoViewCell: UICollectionViewCell {
    
    
    //MARK: - UI Components
    private let sideInfoHeader: UILabel = {
      let label = UILabel()
        label.font = UIFont().JosefinSans(font: .bold, size: 15)
        label.textColor = .white
        
        return label
    }()
    
    private let sideInfoDescription: UILabel = {
      let label = UILabel()
        label.font = UIFont().JosefinSans(font: .regular, size: 15)
        label.textColor = .lightGray
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
        self.addSubview(sideInfoHeader)
        sideInfoHeader.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(sideInfoDescription)
        sideInfoDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sideInfoHeader.topAnchor.constraint(equalTo: self.topAnchor),
            sideInfoHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sideInfoHeader.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sideInfoHeader.heightAnchor.constraint(equalToConstant: 15),
            
            sideInfoDescription.topAnchor.constraint(equalTo: sideInfoHeader.bottomAnchor, constant: 10),
            sideInfoDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sideInfoDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sideInfoDescription.heightAnchor.constraint(equalToConstant: 15),
        ])
        
    }
    
    
}


extension SideInfoViewCell {
    public func configure(info: GetAnimeByQuery.Data.Page.Medium, index: Int) {
        
        switch index + 1 {
        case 1:
            self.sideInfoHeader.text = "Format"
            switch info.format {
            case .case(.movie):
                self.sideInfoDescription.text = "Movie"
            case .case(.music):
                self.sideInfoDescription.text = "Music"
            case .case(.novel):
                self.sideInfoDescription.text = "Novel"
            case .case(.ona):
                self.sideInfoDescription.text = "ONA"
            case .case(.oneShot):
                self.sideInfoDescription.text = "One Shot"
            case .case(.ova):
                self.sideInfoDescription.text = "OVA"
            case .case(.special):
                self.sideInfoDescription.text = "Special"
            case .case(.tv):
                self.sideInfoDescription.text = "TV"
            case .case(.tvShort):
                self.sideInfoDescription.text = "TV Short"
            case .case(.manga):
                self.sideInfoDescription.text = "Manga"
            case .none:
                return
            case .some(.unknown(_)):
                return
            }

        case 2:
            self.sideInfoHeader.text = "Episodes"
            if info.episodes != nil {
                self.sideInfoDescription.text = String("\(info.episodes!)")
            } else {
                self.sideInfoDescription.text = "___"
            }
        case 3:
            self.sideInfoHeader.text = "Status"
            switch info.status {
            case .case(.cancelled):
                self.sideInfoDescription.text = "Cancelled"
            case .case(.finished):
                self.sideInfoDescription.text = "Finished"
            case .case(.notYetReleased):
                self.sideInfoDescription.text = "Not yet released"
            case .case(.releasing):
                self.sideInfoDescription.text = "Releasing"
            case .case(.hiatus):
                self.sideInfoDescription.text = "Currently paused"
            case .none:
                return
            case .some(.unknown(_)):
                return
            }
        case 4:
            self.sideInfoHeader.text = "Mean Score"
            if info.meanScore != nil {
                self.sideInfoDescription.text = String("\(info.meanScore!)%")
            } else {
                self.sideInfoDescription.text = "___"
            }
        case 5:
            self.sideInfoHeader.text = "Start Date"

            self.sideInfoDescription.text = info.configureDate(isStartDate: true)
        case 6:
            self.sideInfoHeader.text = "End Date"
            self.sideInfoDescription.text = info.configureDate(isStartDate: false)
        default:
            return
            
        }
    }
    
    public func configureAsRelative(info: GetAnimeByQuery.Data.Page.Medium.Relations.Node, index: Int) {
        
        switch index + 1 {
        case 1:
            self.sideInfoHeader.text = "Format"
            switch info.format {
            case .case(.movie):
                self.sideInfoDescription.text = "Movie"
            case .case(.music):
                self.sideInfoDescription.text = "Music"
            case .case(.novel):
                self.sideInfoDescription.text = "Novel"
            case .case(.ona):
                self.sideInfoDescription.text = "ONA"
            case .case(.oneShot):
                self.sideInfoDescription.text = "One Shot"
            case .case(.ova):
                self.sideInfoDescription.text = "OVA"
            case .case(.special):
                self.sideInfoDescription.text = "Special"
            case .case(.tv):
                self.sideInfoDescription.text = "TV"
            case .case(.tvShort):
                self.sideInfoDescription.text = "TV Short"
            case .case(.manga):
                self.sideInfoDescription.text = "Manga"
            case .none:
                return
            case .some(.unknown(_)):
                return
            }

        case 2:
            self.sideInfoHeader.text = "Episodes"
            if info.episodes != nil {
                self.sideInfoDescription.text = String("\(info.episodes!)")
            } else {
                self.sideInfoDescription.text = "___"
            }
        case 3:
            self.sideInfoHeader.text = "Status"
            switch info.status {
            case .case(.cancelled):
                self.sideInfoDescription.text = "Cancelled"
            case .case(.finished):
                self.sideInfoDescription.text = "Finished"
            case .case(.notYetReleased):
                self.sideInfoDescription.text = "Not yet released"
            case .case(.releasing):
                self.sideInfoDescription.text = "Releasing"
            case .case(.hiatus):
                self.sideInfoDescription.text = "Currently paused"
            case .none:
                return
            case .some(.unknown(_)):
                return
            }
        case 4:
            self.sideInfoHeader.text = "Mean Score"
            if info.meanScore != nil {
                self.sideInfoDescription.text = String("\(info.meanScore!)%")
            } else {
                self.sideInfoDescription.text = "___"
            }
        case 5:
            self.sideInfoHeader.text = "Start Date"
            self.sideInfoDescription.text = info.configureDate(isStartDate: true)
        case 6:
            self.sideInfoHeader.text = "End Date"
            self.sideInfoDescription.text = info.configureDate(isStartDate: false)
        default:
            return
            
        }
    }
}
