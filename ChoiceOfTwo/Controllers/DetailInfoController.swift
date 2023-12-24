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
        //        view.backgroundColor = .yellow
        
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black")
        //        view.backgroundColor = .red
        return view
    }()
    private let imageView = DetailAnimePreviewImage()
//    private let imageView: UIImageView = {
//      let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        return iv
//    }()
    
    private var animeDescription: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont().JosefinSans(font: .medium, size: 19)
        
        return label
    }()
    
    private let bookmarkButton = CustomCircleButton(
        hasBackground: true,
        image: UIImage(named: "BookmarkFilled")!,
        backgroundColor: .clear)
    private let likeButton = CustomCircleButton(
        hasBackground: true,
        image: UIImage(named: "HeartFilled")!,
        backgroundColor: .clear)
    private let animeName: UILabel = {
      let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont().JosefinSans(font: .bold, size: 23)
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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        setup()
        
//        print(self.animeData.genres?.count)
        genresColl.dataSource = self
        genresColl.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
//        self.imageView.setNeedsLayout()
        self.imageView.setupMask(frame: self.imageView.frame)
//        print(self.imageView.frame)
    }
    
    
    
    //MARK: - Setup UI
    private func setup() {
        
//        view.addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bookmarkButton)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(animeName)
        animeName.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(genresColl)
        genresColl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(animeDescription)
        animeDescription.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            
//            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: view.topAnchor),
//            imageView.heightAnchor.constraint(equalToConstant: 400),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 2000),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 550),
            
//            bookmarkButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 40),
            bookmarkButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            bookmarkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            likeButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            animeName.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            animeName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            animeName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            animeName.heightAnchor.constraint(equalToConstant: 80),
            
            
            genresColl.topAnchor.constraint(equalTo: animeName.bottomAnchor),
            genresColl.heightAnchor.constraint(equalToConstant: 50),
            genresColl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genresColl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
            animeDescription.topAnchor.constraint(equalTo: genresColl.bottomAnchor, constant: 10),
            animeDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            animeDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
}

extension DetailInfoController {
    public func configure(with animeData: GetAnimeByQuery.Data.Page.Medium) {
//        if let hexStr = animeData.coverImage?.color {
//            
//            self.contentView.backgroundColor = UIColor().hexStringToUIColor(hex: hexStr)
//        }
        
        self.animeData = animeData
        self.animeName.text = animeData.title?.english
        self.animeDescription.text = animeData.description?.replacingOccurrences(of: "<br>", with: "")
//        self.imageView.setupImage(with: animeData.coverImage?.extraLarge ?? "")
        self.imageView.setImageFromStringrURL(stringUrl: animeData.coverImage?.extraLarge ?? "")
//        self.imageView.setImageFromStringrURL(stringUrl: animeData.bannerImage ?? "")
    }
}

extension DetailInfoController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
                let size: CGSize = animeData.genres![indexPath.row]!.size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 12)!])
                return CGSize(width: size.width + 20, height: size.height + 20)
        
//        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return animeData.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = genresColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GenreViewCell else {
            fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
        }
        
        let preview = animeData.genres?[indexPath.row]
        cell.configure(genreName: preview ?? "Bitch", borderColor: UIColor.red, borderWidth: 1)
        return cell
    }
}
