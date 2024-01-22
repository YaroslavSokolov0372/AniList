//
//  DetailInfoController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/12/2023.
//

import UIKit
import AnilistApi

class DetailInfoController: UIViewController {
    
    //MARK: - Variables
    private var animeData: GetAnimeByQuery.Data.Page.Medium!
    
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
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Arrow")!.resized(to: CGSize(width: 28, height: 28)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView!.transform = button.imageView!.transform.rotated(by: .pi / 1)
        return button
    }()
    
    private let bookmarkButton = CustomSaveButton(
        hasBackground: true,
        image: UIImage(named: "BookmarkFilled")!,
        backgroundColor: .clear)
    
    private let likeButton = CustomSaveButton(
        hasBackground: true,
        image: UIImage(named: "HeartFilled")!,
        backgroundColor: .clear)
    
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
        
        backButton.addTarget(self, action: #selector(didTappedBackButton), for: .touchUpInside)
        
        //MARK: - Temporary
        
        likeButton.addDidTappedCircleButtonTarget(self, action: #selector(didTappedLikeButton))
        bookmarkButton.addDidTappedCircleButtonTarget(self, action: #selector(didTappedBookmarkButton))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.imageView.setupMask(frame: self.imageView.frame)
    }
    
    //MARK: - Setup UI
    private func setup() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bookmarkButton)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
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
//            contentView.heightAnchor.constraint(equalToConstant: 1300),
            contentView.heightAnchor.constraint(equalToConstant: configureContentSize() + 50),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 550),
            
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 40),
            bookmarkButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            bookmarkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            likeButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            animeName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            animeName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            animeName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
//            animeName.heightAnchor.constraint(equalToConstant: 80),
//            animeName.heightAnchor.constraint(equalToConstant: self.animeName.requiredHeight()),
            animeName.heightAnchor.constraint(equalToConstant: (animeName.text!.height(constraintedWidth: view.frame.width - 30, font: UIFont().JosefinSans(font: .medium, size: 19)!)) + 10),
            
            sideInfoColl.topAnchor.constraint(equalTo: animeName.bottomAnchor, constant: 15),
            sideInfoColl.heightAnchor.constraint(equalToConstant: 60),
            sideInfoColl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sideInfoColl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            genresColl.topAnchor.constraint(equalTo: sideInfoColl.bottomAnchor),
            genresColl.heightAnchor.constraint(equalToConstant: 50),
            genresColl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genresColl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionHeader.topAnchor.constraint(equalTo: genresColl.bottomAnchor, constant: 15),
            descriptionHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            animeDescription.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor, constant: 10),
            animeDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            animeDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    //MARK: - Func
    @objc private func didTappedBookmarkButton() {
        if bookmarkButton.checkSaved() {
            bookmarkButton.setImage(UIImage(named: "BookmarkStroke")!.resized(to: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysTemplate), for: .normal)
            bookmarkButton.saved()
            bookmarkButton.animateView(bookmarkButton)
        } else {
            bookmarkButton.setImage(UIImage(named: "BookmarkFilled")!.resized(to: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysTemplate), for: .normal)
            bookmarkButton.saved()
            bookmarkButton.animateView(bookmarkButton)
        }
    }
    
    @objc private func didTappedLikeButton() {
        if likeButton.checkSaved() {
            likeButton.setImage(UIImage(named: "HeartStroke")!.resized(to: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysTemplate), for: .normal)
            likeButton.saved()
            likeButton.animateView(likeButton)
        } else {
            likeButton.setImage(UIImage(named: "HeartFilled")!.resized(to: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysTemplate), for: .normal)
            likeButton.saved()
            likeButton.animateView(likeButton)
        }
    }
    
    @objc private func didTappedBackButton() {
        print("DEBUG:", "Tapped back button")
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailInfoController {
    
    public func configure(with animeData: GetAnimeByQuery.Data.Page.Medium) {
        if let hexStr = animeData.coverImage?.color {
            self.bookmarkButton.tintColor = UIColor().hexStringToUIColor(hex: hexStr).darker(by: 20)
            self.likeButton.tintColor = UIColor().hexStringToUIColor(hex: hexStr).darker(by: 20)
        } else {
//            self.bookmarkButton.tintColor = UIColor(named: "Yellow")
            self.bookmarkButton.tintColor = UIColor(.white.opacity(0.5))
//            self.likeButton.tintColor = UIColor(named: "Red")
            self.likeButton.tintColor = UIColor(.white.opacity(0.5))
        }
        
        self.animeData = animeData
        
        if let englishName = animeData.title?.english {
            self.animeName.text = englishName
        } else if let userPrefered = animeData.title?.userPreferred {
            self.animeName.text = userPrefered
        } else {
            self.animeName.text = animeData.title?.native
        }
//        self.animeName.text = animeData.title?.english
        self.animeDescription.text = animeData.description?.replacingOccurrences(of: "<br>", with: "")
//        self.imageView.setupImage(with: animeData.coverImage?.extraLarge ?? "")
        self.imageView.setImageFromStringrURL(stringUrl: animeData.coverImage?.extraLarge ?? "")
//        self.imageView.setImageFromStringrURL(stringUrl: animeData.bannerImage ?? "")
    }
    
    private func configureContentSize() -> CGFloat {
        let imageHeight: CGFloat = 550
        
        
        //TODO: - solve the problem when the name is on chinize
        let textHeight = ((animeName.text!.height(constraintedWidth: view.frame.width - 30, font: UIFont().JosefinSans(font: .medium, size: 19)!)) + 10) + 15
        
        
        let sideInfoCollHeight: CGFloat = 75
        let genreCollHeight: CGFloat = 50
        let descriptionHeaderHeight = descriptionHeader.text!.height(constraintedWidth: view.frame.width, font: UIFont().JosefinSans(font: .bold, size: 18)!) + 15
        let animeDescriptionHeight = animeDescription.text!.height(constraintedWidth: view.frame.width - 30, font: UIFont().JosefinSans(font: .medium, size: 19)!)
        
        let height = imageHeight + textHeight + sideInfoCollHeight + genreCollHeight + descriptionHeaderHeight + animeDescriptionHeight
        return height
    }
}

extension DetailInfoController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
     
            return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.genresColl {
            let size: CGSize = animeData.genres![indexPath.row]!.size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
            return CGSize(width: size.width + 20, height: size.height + 20)
        } else {
            switch indexPath.row {
            case 3:
                let size: CGSize = String("Mean Score").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                return CGSize(width: size.width + 10, height: 40)
            case 5:
                let size: CGSize = String("End Date").size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 15)!])
                return CGSize(width: size.width + 5, height: 40)
            default:
                return CGSize(width: 85, height: 40)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.genresColl {
            return animeData.genres?.count ?? 0
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.genresColl {
            guard let cell = genresColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GenreViewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            let preview = animeData.genres?[indexPath.row]
            cell.configure(genreName: preview ?? "Bitch", borderWidth: 2, backgroundColor: self.animeData.coverImage?.color)
            return cell
        } else {
            guard let cell = sideInfoColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
                    SideInfoViewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            cell.configure(info: self.animeData, index: indexPath.row)
            return cell
        }
    }
}
