//
//  DetailInfoController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/12/2023.
//

import UIKit
import AnilistApi
import YouTubeiOSPlayerHelper
import SwiftSoup

class DetailInfoController: UIViewController, YTPlayerViewDelegate, relationCollectionViewCellDelegate {

    

    
    
    //MARK: - Variables
    private var animeData: GetAnimeByQuery.Data.Page.Medium?
    
    private var animeDataAsRelative: GetAnimeByQuery.Data.Page.Medium.Relations.Node?
    
    private var activeAnimeNameConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeAnimeNameConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeAnimeNameConstraints)
        }
    }
    
    private var activeRelativeConstraint: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeRelativeConstraint)
        }
        didSet {
            NSLayoutConstraint.activate(activeRelativeConstraint)
        }
    }
    
    private var activeAnimeDescriptionConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeAnimeDescriptionConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeAnimeDescriptionConstraints)
        }
    }
    
    private var activeContentConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeContentConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeContentConstraints)
        }
    }
    
    private var activeCharCollConstaints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeCharCollConstaints)
        }
        didSet {
            NSLayoutConstraint.activate(activeCharCollConstaints)
        }
    }
    
    //MARK: - UI Components
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(named: "Black")
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black")
        return view
    }()
    
    private let imageView = DetailAnimePreviewImage()
    
    private var animeDescription: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont().JosefinSans(font: .medium, size: 19)
        
        return label
    }()
    
    private let descriptionHeader: UILabel = {
      let label = UILabel()
        label.text = "Description"
        label.font = UIFont().JosefinSans(font: .bold, size: 18)
        label.textColor = .white
        return label
    }()
    
    private let charactersHeader: UILabel = {
      let label = UILabel()
        label.text = "Characters"
        label.font = UIFont().JosefinSans(font: .bold, size: 18)
        label.textColor = .white
        return label
    }()
    
    private let relativeHeader: UILabel = {
        let label = UILabel()
          label.text = "Relations"
          label.font = UIFont().JosefinSans(font: .bold, size: 18)
          label.textColor = .white
          return label
    }()
    
    private let trailerHeader: UILabel = {
      let label = UILabel()
        label.text = "Trailer"
        label.font = UIFont().JosefinSans(font: .bold, size: 18)
        label.textColor = .white
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Arrow")!.resized(to: CGSize(width: 28, height: 28)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
//        button.backgroundColor = UIColor(named: "DarkBlack")
//        button.layer.cornerRadius = 30
        button.imageView!.transform = button.imageView!.transform.rotated(by: .pi / 1)
        return button
    }()
    
    private let ytVideoView: YTPlayerView = {
      let ytView = YTPlayerView()
        ytView.backgroundColor = .black
        ytView.clipsToBounds = true
        ytView.layer.cornerRadius = 12
        return ytView
    }()
    
    private let animeName: UILabel = {
      let label = UILabel()
        label.text = "Hello"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont().JosefinSans(font: .bold, size: 22)
        label.textColor = .white
        return label
    }()
    
    private let genresColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GenreViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collectionView
    }()
    
    private let sideInfoColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SideInfoViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collectionView
    }()
    
    private let charactersColl: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.register(CharacterPreviewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let relativeColl: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.register(RelationCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        setup()
        genresColl.dataSource = self
        genresColl.delegate = self
        sideInfoColl.dataSource = self
        sideInfoColl.delegate = self
        scrollView.delegate = self
        charactersColl.delegate = self
        charactersColl.dataSource = self
        ytVideoView.delegate = self
        relativeColl.delegate = self
        relativeColl.dataSource = self
        backButton.addTarget(self, action: #selector(didTappedBackButton), for: .touchUpInside)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
//        let layout = relativeColl.collectionViewLayout as! UICollectionViewFlowLayout
//        let size = layout.collectionViewContentSize
        let relativeHeight = self.relativeColl.collectionViewLayout.collectionViewContentSize.height
        self.activeRelativeConstraint = [
//            self.relativeColl.heightAnchor.constraint(equalToConstant: size.height),
            self.relativeColl.heightAnchor.constraint(equalToConstant: relativeHeight),
        ]
        
        if self.animeDataAsRelative == nil {
            if let charactersCount = self.animeData!.characters?.nodes?.count {
                if charactersCount <= 3 {
                    self.activeCharCollConstaints = [
                        charactersColl.heightAnchor.constraint(equalToConstant: 210)
                    ]
                } else {
                    self.activeCharCollConstaints = [
                        charactersColl.heightAnchor.constraint(equalToConstant: 420),
                    ]
                }
            }
        } else {
            if let charactersCount = self.animeDataAsRelative!.characters?.nodes?.count {
                if charactersCount <= 3 {
                    self.activeCharCollConstaints = [
                        charactersColl.heightAnchor.constraint(equalToConstant: 210)
                    ]
                } else {
                    self.activeCharCollConstaints = [
                        charactersColl.heightAnchor.constraint(equalToConstant: 420),
                    ]
                }
            }
        }
        
        var contentRectContentView = CGRectZero
        for view in self.contentView.subviews {
            contentRectContentView = CGRectUnion(contentRectContentView, view.frame)
        }
        
        self.activeContentConstraints = [
            self.contentView.heightAnchor.constraint(equalToConstant: contentRectContentView.height + 40),
            self.scrollView.heightAnchor.constraint(equalToConstant: contentRectContentView.height + 40),
        ]
    }
        
    //MARK: - Setup UI
    private func setupRelative() {
        contentView.addSubview(relativeHeader)
        relativeHeader.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(relativeColl)
        relativeColl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            relativeHeader.topAnchor.constraint(equalTo: ytVideoView.bottomAnchor, constant: 20),
            relativeHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            relativeColl.topAnchor.constraint(equalTo: relativeHeader.bottomAnchor, constant: 10),
            relativeColl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            relativeColl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }
    
    private func setup() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(animeName)
        animeName.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(genresColl)
        genresColl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(sideInfoColl)
        sideInfoColl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(descriptionHeader)
        descriptionHeader.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(animeDescription)
        animeDescription.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(charactersHeader)
        charactersHeader.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(charactersColl)
        charactersColl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(trailerHeader)
        trailerHeader.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(ytVideoView)
        ytVideoView.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
//            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            imageView.heightAnchor.constraint(equalToConstant: 550),
            imageView.heightAnchor.constraint(equalToConstant: 450),
            
            backButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            //            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            backButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 60),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            animeName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            animeName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            animeName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            sideInfoColl.topAnchor.constraint(equalTo: animeName.bottomAnchor, constant: 15),
            sideInfoColl.heightAnchor.constraint(equalToConstant: 60),
            sideInfoColl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sideInfoColl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            genresColl.topAnchor.constraint(equalTo: sideInfoColl.bottomAnchor),
            genresColl.heightAnchor.constraint(equalToConstant: 50),
            genresColl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genresColl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionHeader.topAnchor.constraint(equalTo: genresColl.bottomAnchor, constant: 20),
            descriptionHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            animeDescription.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor, constant: 10),
            animeDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            animeDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            charactersHeader.topAnchor.constraint(equalTo: animeDescription.bottomAnchor, constant: 20),
            charactersHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            charactersColl.topAnchor.constraint(equalTo: charactersHeader.bottomAnchor, constant: 10),
            charactersColl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            charactersColl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            charactersColl.heightAnchor.constraint(equalToConstant: 420),
            
            
            trailerHeader.topAnchor.constraint(equalTo: charactersColl.bottomAnchor, constant: 20),
            trailerHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            ytVideoView.topAnchor.constraint(equalTo: trailerHeader.bottomAnchor, constant: 10),
            ytVideoView.heightAnchor.constraint(equalToConstant: 200),
            ytVideoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            ytVideoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
        ])
        
        if self.animeData != nil {
            self.setupRelative()
        }
        
        self.activeAnimeNameConstraints = [
            self.animeName.heightAnchor.constraint(equalToConstant: 20),
        ]
        
        self.activeCharCollConstaints = [
            charactersColl.heightAnchor.constraint(equalToConstant: 420),
        ]
        
        self.activeAnimeDescriptionConstraints = [
            self.animeDescription.heightAnchor.constraint(equalToConstant: 300),
        ]
        
        self.activeContentConstraints = [
//            self.contentView.heightAnchor.constraint(equalToConstant: 2000),
//            self.scrollView.heightAnchor.constraint(equalToConstant: 2000),
        ]
    }
    
    //MARK: - Func
    
    @objc private func didTappedBackButton() {
        print("DEBUG:", "Tapped back button")
        self.navigationController?.popViewController(animated: true)
    }
    
    public func configureAsRelarive(with animeData: GetAnimeByQuery.Data.Page.Medium.Relations.Node) {
        self.animeDataAsRelative = animeData
        
        if let englishName = animeData.title?.english {
            self.animeName.text = englishName
        } else if let userPrefered = animeData.title?.userPreferred {
            self.animeName.text = userPrefered
        } else {
            self.animeName.text = animeData.title?.native
        }
        
        self.animeDescription.text = animeData.description!.prepareHTMLDescription()
        let animeDesriptionHeight = self.animeDescription.text!.height(constraintedWidth: self.view.frame.width - 30, font: UIFont().JosefinSans(font: .medium, size: 19)!)
        self.activeAnimeDescriptionConstraints = [
            self.animeDescription.heightAnchor.constraint(equalToConstant: animeDesriptionHeight),
        ]
        
        self.imageView.setImageFromStringrURL(stringUrl: animeData.coverImage?.extraLarge ?? "")
        
        if let id = animeData.trailer?.id {
            self.ytVideoView.load(withVideoId: id)
        }
    }
    
    public func configureAsDefault(with animeData: GetAnimeByQuery.Data.Page.Medium) {
        self.animeData = animeData
        
        if let englishName = animeData.title?.english {
            self.animeName.text = englishName
        } else if let userPrefered = animeData.title?.userPreferred {
            self.animeName.text = userPrefered
        } else {
            self.animeName.text = animeData.title?.native
        }
        let animeNameHeight = self.animeName.text!.height(constraintedWidth: self.view.frame.width - 30, font: UIFont().JosefinSans(font: .bold, size: 22)!)
        self.activeAnimeNameConstraints = [
            self.animeName.heightAnchor.constraint(equalToConstant: animeNameHeight),
        ]
        
        self.animeDescription.text =  animeData.description!.prepareHTMLDescription()
        let animeDesriptionHeight = self.animeDescription.text!.height(constraintedWidth: self.view.frame.width - 30, font: UIFont().JosefinSans(font: .medium, size: 19)!)
        self.activeAnimeDescriptionConstraints = [
            self.animeDescription.heightAnchor.constraint(equalToConstant: animeDesriptionHeight),
        ]
        
        self.imageView.setImageFromStringrURL(stringUrl: animeData.coverImage?.extraLarge ?? "")
        
        if let id = animeData.trailer?.id {
            self.ytVideoView.load(withVideoId: id)
        }
    }
    
    func onTapGesture(data: GetAnimeByQuery.Data.Page.Medium.Relations.Node) {   
        let vc = DetailInfoController()
        vc.configureAsRelarive(with: data)
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DetailInfoController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView != charactersColl {
            return 15
        } else {
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == genresColl {
            if self.animeDataAsRelative == nil {
            let size: CGSize = animeData!.genres![indexPath.row]!.size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .bold, size: 15)!])
                return CGSize(width: size.width + 20, height: size.height + 20)
            } else {
                let size: CGSize = animeDataAsRelative!.genres![indexPath.row]!.size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .bold, size: 15)!])
                return CGSize(width: size.width + 20, height: size.height + 20)
            }
            
        } else if collectionView == sideInfoColl {
            switch indexPath.row {
            case 2:
                let sideInfoHeader = "Status"
                let headerSize = sideInfoHeader.size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                if self.animeDataAsRelative == nil {
                    switch self.animeData!.status {
                    case .case(.cancelled):
                        let size: CGSize = String("Cancelled").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    case .case(.finished):
                        let size: CGSize = String("Finished").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    case .case(.notYetReleased):
                        let size: CGSize = String("Not yet released").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    case .case(.releasing):
                        let size: CGSize = String("Releasing").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    case .case(.hiatus):
                        let size: CGSize = String("Currently paused").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    default:
                        return CGSize(width: 85, height: 40)
                    }
                } else {
                    switch self.animeDataAsRelative!.status {
                    case .case(.cancelled):
                        let size: CGSize = String("Cancelled").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    case .case(.finished):
                        let size: CGSize = String("Finished").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    case .case(.notYetReleased):
                        let size: CGSize = String("Not yet released").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    case .case(.releasing):
                        let size: CGSize = String("Releasing").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    case .case(.hiatus):
                        let size: CGSize = String("Currently paused").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                        return CGSize(width: headerSize.width > size.width ? headerSize.width : size.width + 20, height: size.height + 20)
                    default:
                        return CGSize(width: 85, height: 40)
                    }
                }
            case 3:
                let size: CGSize = String("Mean Score").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                return CGSize(width: size.width + 10, height: 40)
            case 5:
                let size: CGSize = String("End Date").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                return CGSize(width: size.width + 10, height: 40)
            default:
                return CGSize(width: 85, height: 40)
            }
        } else if collectionView == charactersColl {
            //            let size = CGSize(width: collectionView.frame.width * 0.44, height: 290)
            //TODO: - When change iphone to XR. characters coll shows only 2 object from 3. FIX IT!!
            let size = CGSize(width: collectionView.frame.width * 0.29, height: 190)
            return size
        } else {
            let size = CGSize(width: collectionView.frame.width, height: 180)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.genresColl {
            if self.animeDataAsRelative == nil {
                return animeData!.genres?.count ?? 0
            } else {
                return animeDataAsRelative!.genres?.count ?? 0
            }
        } else if collectionView == self.sideInfoColl {
            return 6
        } else if collectionView == self.charactersColl {
            if self.animeDataAsRelative == nil {
                if let charactersCount = self.animeData!.characters?.nodes?.count {
                    if charactersCount >= 6 {
                        return 6
                    } else {
                        return charactersCount
                    }
                } else {
                    return 0
                }
            } else {
                if let charactersCount = self.animeDataAsRelative!.characters?.nodes?.count {
                    if charactersCount >= 6 {
                        return 6
                    } else {
                        return charactersCount
                    }
                } else {
                    return 0
                }
            }
        } else {
            if self.animeDataAsRelative == nil {
                return self.animeData!.relations?.nodes?.count ?? 0
            } else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.genresColl {
            guard let cell = genresColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GenreViewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            if self.animeDataAsRelative == nil {
                let preview = animeData!.genres?[indexPath.row]
                cell.configure(genreName: preview ?? "Bitch", borderWidth: 2, backgroundColor: self.animeData!.coverImage?.color)
                return cell
            } else {
                let preview = animeDataAsRelative!.genres?[indexPath.row]
                cell.configure(genreName: preview ?? "?", borderWidth: 2, backgroundColor: self.animeDataAsRelative!.coverImage?.color)
                return cell
            }
        } else if collectionView == sideInfoColl {
            guard let cell = sideInfoColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
                    SideInfoViewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            if self.animeDataAsRelative == nil {
                cell.configure(info: self.animeData!, index: indexPath.row)
                return cell
            } else {
                cell.configureAsRelative(info: self.animeDataAsRelative!, index: indexPath.row)
                return cell
            }
        } else if collectionView == charactersColl {
            guard let cell = charactersColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
                    CharacterPreviewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            if self.animeDataAsRelative == nil {
                cell.configure(info: animeData!.characters?.nodes?[indexPath.row])
//                cell.delegate = self
                return cell
            } else {
                cell.configureAsRelative(info: animeDataAsRelative!.characters?.nodes?[indexPath.row])
//                cell.delegate = self
                return cell
            }
        } else {
            guard let cell = relativeColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
                    RelationCollectionViewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            if self.animeDataAsRelative == nil {
                cell.configure(info: self.animeData!.relations!.nodes![indexPath.row]!)
                cell.delegate = self
            }
            return cell
        }
    }
}
