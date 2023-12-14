//
//  MenuController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/12/2023.
//

import UIKit
import AnilistApi

class MenuController: UIViewController {
    
    //MARK: - Variables
    private let apiClient = ApiClient()
    private var allTimePopularAnime: [GetAnimeBySortQuery.Data.Page.Medium] = []
    private var currentSeasonPopularAnime: [GetAnimeBySeasonQuery.Data.Page.Medium] = []

    //MARK: - UI Components
    private let choiceOfTwoButton = CustomButton(title: "Choice of Two", hasCustomTint: false, customTint: nil, systemTintColor: .white)
    private let allTimePopularHeader = SectionHeader(text: "ALL TIME POPULAR")
    private let allTimePopularAnimeColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AnimePreviewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collectionView
    }()
    private let currentSeasonPopularHeader = SectionHeader(text: "POPULAR THIS SEASON")
    private let currentSeasonPopularColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AnimePreviewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collectionView
    }()
    
    
    
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "Black")
        
        self.apiClient.getAnimeBySeason(
            page: 1,
            perPage: 20,
            sort: [.case(.favouritesDesc)],
            type: .some(.case(.anime)),
            season: .some(.case(.fall)),
            seasonYear: 2023) { result in
                self.currentSeasonPopularAnime = result.data?.page?.media?.compactMap({ $0 }) ?? []
                print(self.currentSeasonPopularAnime.count)
                self.currentSeasonPopularColl.reloadData()
        }
        self.apiClient.getAnimeBySorting { result in
            self.allTimePopularAnime = result.data?.page?.media?.compactMap({ $0 }) ?? []
            print(self.allTimePopularAnime.count)
            self.allTimePopularAnimeColl.reloadData()
        }
        
        self.currentSeasonPopularColl.delegate = self
        self.currentSeasonPopularColl.dataSource = self
        self.allTimePopularAnimeColl.delegate = self
        self.allTimePopularAnimeColl.dataSource = self
        self.setupUI()
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(choiceOfTwoButton)
        self.view.addSubview(allTimePopularHeader)
        self.view.addSubview(allTimePopularAnimeColl)
        self.view.addSubview(currentSeasonPopularHeader)
        self.view.addSubview(currentSeasonPopularColl)
        
        
        choiceOfTwoButton.translatesAutoresizingMaskIntoConstraints = false
        allTimePopularHeader.translatesAutoresizingMaskIntoConstraints = false
        allTimePopularAnimeColl.translatesAutoresizingMaskIntoConstraints = false
        currentSeasonPopularHeader.translatesAutoresizingMaskIntoConstraints = false
        currentSeasonPopularColl.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.choiceOfTwoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.choiceOfTwoButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            self.choiceOfTwoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            self.allTimePopularHeader.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.allTimePopularHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            
            self.allTimePopularAnimeColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.allTimePopularAnimeColl.topAnchor.constraint(equalTo: self.allTimePopularHeader.bottomAnchor, constant: 12),
            self.allTimePopularAnimeColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.allTimePopularAnimeColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
            self.currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.allTimePopularAnimeColl.bottomAnchor, constant: 8),
            self.currentSeasonPopularHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            
            self.currentSeasonPopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.currentSeasonPopularColl.topAnchor.constraint(equalTo: self.currentSeasonPopularHeader.bottomAnchor, constant: 12),
            self.currentSeasonPopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
        ])
    }
}



extension MenuController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.44, height: collectionView.frame.height * 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allTimePopularAnime.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.allTimePopularAnimeColl {
            guard let cell = allTimePopularAnimeColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AnimePreviewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            let preview = self.allTimePopularAnime[indexPath.row]
        cell.configure(with: AnimeType.popularAllTime(preview))
            return cell
        } else {
            guard let cell = currentSeasonPopularColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AnimePreviewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            let preview = self.currentSeasonPopularAnime[indexPath.row]
            cell.configure(with: AnimeType.curentSeasonPopular(preview))
            return cell
        }
    }
}
