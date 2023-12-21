//
//  DetailInfoController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/12/2023.
//

import UIKit

class DetailInfoController: UIViewController {
    
    //MARK: - Variables
    private var animeData: AnimeType!
    
    //MARK: - UI Components
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(named: "Black")
        //        view.backgroundColor = .yellow
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black")
        //        view.backgroundColor = .red
        return view
    }()
    
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.shapeMask()
//        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let customShape: CustomShapeForImage = {
      let view = CustomShapeForImage()
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        //        self.image.layer.mask = customShape.layer
        setup()
    }
    
    
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//        
//        var insets = view.safeAreaInsets
//        insets.top = 0
//        self.scrollView.contentInset = insets
//    }
    
    //MARK: - Setup UI
    private func setup() {
//        view.addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(contentView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(image)
//        image.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(customShape)
//        customShape.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            contentView.heightAnchor.constraint(equalToConstant: 2000),
            
            
//            customShape.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            customShape.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            customShape.heightAnchor.constraint(equalToConstant: 300),
            
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.widthAnchor.constraint(equalTo: view.widthAnchor),
            image.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}

extension DetailInfoController {
    public func configure(with animeData: AnimeType) {
        self.animeData = animeData
        
        switch animeData {
        case .curentSeasonPopular(let data):
            self.image.setImageFromStringrURL(stringUrl: data.coverImage?.extraLarge ?? "")
        case .popularAllTime(let data):
            self.image.setImageFromStringrURL(stringUrl: data.coverImage?.extraLarge ?? "")
        case .trendingNow(let data):
            self.image.setImageFromStringrURL(stringUrl: data.coverImage?.extraLarge ?? "")
        }
    }
}
