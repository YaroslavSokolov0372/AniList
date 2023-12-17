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
    private var allTimePopularAnime: [PopularAllTimeQuery.Data.Page.Medium] = [] {
        didSet {
            DispatchQueue.main.async {
                self.allTimePopularAnimeColl.reloadData()
                self.allTimePopularAnimeColl.setNeedsDisplay()
                print("All time Popular dispatch worked")
            }
        }
    }
    private var currentSeasonPopularAnime: [GetAnimeBySeasonQuery.Data.Page.Medium] = [] {
        didSet {
            DispatchQueue.main.async {
                self.currentSeasonPopularColl.reloadData()
                self.currentSeasonPopularColl.setNeedsDisplay()
                print("Current season dispatch worked")
            }
        }
    }
    private var trendingNowAnime: [PopularAllTimeQuery.Data.Page.Medium] = [] {
        didSet {
            DispatchQueue.main.async {
                self.trendingNowColl.reloadData()
                self.trendingNowColl.setNeedsDisplay()
                print("Trending now dispatch worked")
            }
        }
    }

    //MARK: - UI Components
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(named: "Black")
//        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black")
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchTools = CustomSeatchToolsView(title: "Genres")
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
    private let trendingNow = SectionHeader(text: "TRENDING NOW")
    private let trendingNowColl: UICollectionView = {
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
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor(named: "Black")
        
        
        
        Task {
//            await self.apiClient.trendingNowAnimes(
//                page: 1,
//                perPage: 20,
//                sort: nil) { result in
//                    self.trendingNowAnime = result.data?.page?.mediaTrends?.compactMap({ $0 }) ?? []
//                    print(self.currentSeasonPopularAnime.count)
////                    self.trendingNowColl.reloadData()
//                }
            
            await self.apiClient.getAnimeBySeason(
                page: 1,
                perPage: 20,
                sort: [.case(.favouritesDesc)],
                type: .some(.case(.anime)),
                season: .some(.case(.fall)),
                seasonYear: 2023) { result in
                    self.currentSeasonPopularAnime = result.data?.page?.media?.compactMap({ $0 }) ?? []
                    print(self.currentSeasonPopularAnime.count)
//                    self.currentSeasonPopularColl.reloadData()
                }
            
            await self.apiClient.getAnimeBySort([.case(.popularityDesc)]) { result in
                self.allTimePopularAnime = result.data?.page?.media?.compactMap({ $0 }) ?? []
                print(self.allTimePopularAnime.count)
            }
            await self.apiClient.getAnimeBySort([.case(.trendingDesc)]) { result in
                self.trendingNowAnime = result.data?.page?.media?.compactMap({ $0 }) ?? []
                print(self.currentSeasonPopularAnime.count)
            }
        }
        
        self.currentSeasonPopularColl.delegate = self
        self.currentSeasonPopularColl.dataSource = self
        self.allTimePopularAnimeColl.delegate = self
        self.allTimePopularAnimeColl.dataSource = self
        self.trendingNowColl.delegate = self
        self.trendingNowColl.dataSource = self
        
        self.setupUI()
        
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        

        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        self.view.addSubview(choiceOfTwoButton)
        self.contentView.addSubview(searchTools)
        self.contentView.addSubview(allTimePopularHeader)
        self.contentView.addSubview(allTimePopularAnimeColl)
        self.contentView.addSubview(currentSeasonPopularHeader)
        self.contentView.addSubview(currentSeasonPopularColl)
        self.contentView.addSubview(trendingNow)
        self.contentView.addSubview(trendingNowColl)
        
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        searchTools.translatesAutoresizingMaskIntoConstraints = false
        choiceOfTwoButton.translatesAutoresizingMaskIntoConstraints = false
        allTimePopularHeader.translatesAutoresizingMaskIntoConstraints = false
        allTimePopularAnimeColl.translatesAutoresizingMaskIntoConstraints = false
        currentSeasonPopularHeader.translatesAutoresizingMaskIntoConstraints = false
        currentSeasonPopularColl.translatesAutoresizingMaskIntoConstraints = false
        trendingNow.translatesAutoresizingMaskIntoConstraints = false
        trendingNowColl.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            self.choiceOfTwoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.choiceOfTwoButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            self.choiceOfTwoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        
            
            
            self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            self.contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            self.contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.5),
            
            self.searchTools.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            self.searchTools.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            self.searchTools.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.searchTools.heightAnchor.constraint(equalToConstant: 75),
            
//            self.allTimePopularHeader.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
//            self.allTimePopularHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.allTimePopularHeader.topAnchor.constraint(equalTo: searchTools.bottomAnchor, constant: 30),
            self.allTimePopularHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            self.allTimePopularAnimeColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.allTimePopularAnimeColl.topAnchor.constraint(equalTo: self.allTimePopularHeader.bottomAnchor, constant: 15),
            self.allTimePopularAnimeColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.allTimePopularAnimeColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
            self.currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.allTimePopularAnimeColl.bottomAnchor, constant: 30),
            self.currentSeasonPopularHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            
            self.currentSeasonPopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.currentSeasonPopularColl.topAnchor.constraint(equalTo: self.currentSeasonPopularHeader.bottomAnchor, constant: 15),
            self.currentSeasonPopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
            self.trendingNow.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
            self.trendingNow.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),

            self.trendingNowColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.trendingNowColl.topAnchor.constraint(equalTo: self.trendingNow.bottomAnchor, constant: 15),
            self.trendingNowColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
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
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.allTimePopularAnimeColl {
            return self.allTimePopularAnime.count
        } else if collectionView == self.currentSeasonPopularColl {
            print("working with current season popular")
            return self.currentSeasonPopularAnime.count
        } else {
            print("working with trending now")
            return self.trendingNowAnime.count
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.allTimePopularAnimeColl {
            guard let cell = allTimePopularAnimeColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AnimePreviewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            let preview = self.allTimePopularAnime[indexPath.row]
        cell.configure(with: AnimeType.popularAllTime(preview))
            return cell
        } else if collectionView == self.currentSeasonPopularColl {
            guard let cell = currentSeasonPopularColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AnimePreviewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            let preview = self.currentSeasonPopularAnime[indexPath.row]
            cell.configure(with: AnimeType.curentSeasonPopular(preview))
            return cell
        } else {
            guard let cell = allTimePopularAnimeColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AnimePreviewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            let preview = self.trendingNowAnime[indexPath.row]
            cell.configure(with: AnimeType.trendingNow(preview))
            return cell
        }
    }
}
