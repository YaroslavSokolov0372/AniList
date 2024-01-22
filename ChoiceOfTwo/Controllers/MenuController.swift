//
//  MenuController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/12/2023.
//

import UIKit
import AnilistApi
import SkeletonView

extension MenuController {
    enum CollectionType {
        case trendingNow
        case popularThisSeason
        case allTimePopular
        case animeByUsersSearch
        case none
    }
}

class MenuController: UIViewController, AnimePreviewProtocol, SearchToolButtonProtocol, ToolsOptionsProtocol, HeaderMoreButtonProtocol {
    
    //MARK: - Variables
    private var extendedCollection: CollectionType = .none
    
    private var showMessage = false {
        didSet {
            if oldValue != self.showMessage {
                if showMessage {
                    self.showScrollButton = false
                        activeMessageConstranints = [
                            messageView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
                        ]
                    print("DEBUG:", "Showing message")
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.showMessage = false
                    }
                } else {
                    activeMessageConstranints = [
                        messageView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 60),
                    ]
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    private var showScrollButton = false {
        didSet {
            if oldValue != self.showScrollButton {
                
                    if showScrollButton {
                        if !showMessage {
                            activeScrollButtonConstraints = [
                                scrollToTopButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -10),
                            ]
                            UIView.animate(withDuration: 0.3) {
                                self.view.layoutIfNeeded()
                            }
                        }
                    } else {
                        activeScrollButtonConstraints = [
                            scrollToTopButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 80),
                        ]
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                    }
                
            }
        }
    }
    
    private var choosedGenres: [Genre] = []
    
    private var choosedYear: Int?
    
    private var choosedSeason: MediaSeason?
    
    private var choosedFormats: [MediaFormat] = []
    
    private var searchStringAnime: String?
    
    private var isToolOpened: Bool = false
    
    private var choosedTool: SearchTool?
    
    private var scrollViewX: CGFloat = .zero
    
    private var xPositionChoosedTool: CGFloat = .zero
    
    private var shouldDetectScrollStart = false
    
    private var isFetching = false {
        didSet {
            if oldValue != isFetching {
                if isFetching {
                    self.allTimePopularColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
                    self.currentSeasonPopularColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
                    self.trendingNowColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
                    self.animesByUsersSearchColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
                } else {
                    self.allTimePopularColl.hideSkeleton()
                    self.currentSeasonPopularColl.hideSkeleton()
                    self.trendingNowColl.hideSkeleton()
                    self.animesByUsersSearchColl.hideSkeleton()
                }
            }
        }
    }
    
    private let apiClient = ApiClient()
    
    private var activeCollViewConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeCollViewConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeCollViewConstraints)
        }
    }
    
    private var activeScrollButtonConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeScrollButtonConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeScrollButtonConstraints)
        }
    }
    
    private var activeMessageConstranints: [NSLayoutConstraint] = [] {
        
        willSet {
            NSLayoutConstraint.deactivate(activeMessageConstranints)
        }
        didSet {
            NSLayoutConstraint.activate(activeMessageConstranints)
        }
    }
    
    private var allTimePopularAnimes: ListOfAnime?
    
    private var currentSeasonPopularAnimes: ListOfAnime?
    
    private var trendingNowAnimes: ListOfAnime?
    
    private var animesByUsersSearch: ListOfAnime?
    
    //MARK: - UI Components
    private let messageView = MessageView()
    
    private let mainScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(named: "Black")
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black")
        return view
    }()
    
    private let searchToolsScrollView = SearchToolsScrollView()
    
    private let choosedToolCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        collectionView.backgroundColor = .red
        collectionView.backgroundColor = UIColor(named: "DarkBlack")
        collectionView.register(ToolsOptionsCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.verticalScrollIndicatorInsets.top = .zero
        collectionView.layer.cornerRadius = 12
        return collectionView
    }()
    
    private let scrollToTopButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Arrow")!.resized(to: CGSize(width: 28, height: 28)).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(named: "Orange")
        button.imageView?.tintColor = .white
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 15
        button.transform = CGAffineTransform(rotationAngle: -.pi/2)
        return button
        //        button.clipsToBounds = true
    }()
    
    private let animesByUsersSearchColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.register(MenuAnimePreviewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    private let allTimePopularHeader = SectionHeader(text: "ALL TIME POPULAR")
    
    private let allTimePopularColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MenuAnimePreviewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collectionView
    }()
    
    private let currentSeasonPopularHeader = SectionHeader(text: "POPULAR THIS SEASON")
    
    private let currentSeasonPopularColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MenuAnimePreviewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collectionView
    }()
    
    private let trendingNowHeader = SectionHeader(text: "TRENDING NOW")
    
    private let trendingNowColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Black")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MenuAnimePreviewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor(named: "Black")
        
        self.scrollToTopButton.addTarget(self, action: #selector(scrollToTopButtonTapped), for: .touchUpInside)
        self.trendingNowHeader.delegate = self
        self.allTimePopularHeader.delegate = self
        self.currentSeasonPopularHeader.delegate = self
        
        self.currentSeasonPopularColl.delegate = self
        self.currentSeasonPopularColl.dataSource = self
        self.currentSeasonPopularColl.isSkeletonable = true
        self.allTimePopularColl.delegate = self
        self.allTimePopularColl.dataSource = self
        self.allTimePopularColl.isSkeletonable = true
        self.trendingNowColl.delegate = self
        self.trendingNowColl.dataSource = self
        self.trendingNowColl.isSkeletonable = true
        self.choosedToolCollectionView.delegate = self
        self.choosedToolCollectionView.dataSource = self
        self.animesByUsersSearchColl.delegate = self
        self.animesByUsersSearchColl.dataSource = self
        self.animesByUsersSearchColl.isSkeletonable = true
        
        self.mainScrollView.delegate = self
        self.searchToolsScrollView.configureDelegate(self)
        self.setupUI()
        
        
        self.fetchPopularThisSeason(currentPage: nil)
        self.fetchAllTimePopular(currentPage: nil)
        self.fetchTrendingNow(currentPage: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.allTimePopularAnimes == nil || self.trendingNowAnimes == nil || self.currentSeasonPopularAnimes == nil {
            self.isFetching = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if shouldDetectScrollStart {
            scrollViewX = scrollView.contentOffset.x
        }
        shouldDetectScrollStart = false
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == searchToolsScrollView.getScrollView() {
            
            self.choosedToolCollectionView.frame.origin.x = self.xPositionChoosedTool - scrollView.contentOffset.x
            choosedToolCollectionView.frame.origin.x = xPositionChoosedTool - (scrollView.contentOffset.x - scrollViewX)
            
        } else if scrollView == allTimePopularColl || scrollView == trendingNowColl || scrollView == currentSeasonPopularColl {
            let offset = scrollView.contentOffset.y
            if offset > self.view.frame.height {
                self.showScrollButton = true
            } else {
                self.showScrollButton = false
            }
        }
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(mainScrollView)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainScrollView.addSubview(contentView)
        searchToolsScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(searchToolsScrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollToTopButton)
        scrollToTopButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(allTimePopularHeader)
        allTimePopularHeader.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(allTimePopularColl)
        allTimePopularColl.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(currentSeasonPopularHeader)
        currentSeasonPopularHeader.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(currentSeasonPopularColl)
        currentSeasonPopularColl.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(trendingNowHeader)
        trendingNowHeader.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(trendingNowColl)
        trendingNowColl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            messageView.heightAnchor.constraint(equalToConstant: 50),
            messageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollToTopButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            scrollToTopButton.widthAnchor.constraint(equalToConstant: 60),
            scrollToTopButton.heightAnchor.constraint(equalToConstant: 60),
            
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            
            searchToolsScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchToolsScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchToolsScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchToolsScrollView.widthAnchor.constraint(equalToConstant: 800),
            searchToolsScrollView.heightAnchor.constraint(equalToConstant: 80),
            
            trendingNowHeader.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
            trendingNowHeader.heightAnchor.constraint(equalToConstant: 20),
            trendingNowHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            trendingNowHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trendingNowColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            trendingNowColl.topAnchor.constraint(equalTo: self.trendingNowHeader.bottomAnchor, constant: 15),
            trendingNowColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            currentSeasonPopularHeader.heightAnchor.constraint(equalToConstant: 20),
            currentSeasonPopularHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            currentSeasonPopularHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            
            currentSeasonPopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            currentSeasonPopularColl.topAnchor.constraint(equalTo: self.currentSeasonPopularHeader.bottomAnchor, constant: 15),
            currentSeasonPopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            allTimePopularHeader.heightAnchor.constraint(equalToConstant: 20),
            allTimePopularHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            allTimePopularHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            allTimePopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            allTimePopularColl.topAnchor.constraint(equalTo: self.allTimePopularHeader.bottomAnchor, constant: 15),
            allTimePopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        ])
        
        
        self.setupActiveCollViewConstraints()
        self.setupActiveSideButtonConstraints()
        self.setupActiveMessageConstraints()
    }
    
    private func setupActiveMessageConstraints() {
        self.activeMessageConstranints =  [
            messageView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 60),
        ]
    }
    
    private func setupActiveSideButtonConstraints() {
        
        self.activeScrollButtonConstraints = [
            scrollToTopButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 80),
        ]
    }
    
    private func setupActiveCollViewConstraints() {
        self.activeCollViewConstraints = [
            allTimePopularHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
            currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.trendingNowColl.bottomAnchor, constant: 30),
            contentView.heightAnchor.constraint(equalToConstant: configureDefaultContentSize()),
            currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
        ]
    }
    
    private func configureDefaultContentSize() -> CGFloat {
        let searchScrollView: CGFloat = 80
        let headers: CGFloat = 20 * 3
        let colls: CGFloat = (self.view.frame.height * 0.33) * 3
        let spacing: CGFloat = 120
        return searchScrollView + headers + colls + spacing
    }
    
    private func setupAnimesBySearch() {
        self.contentView.addSubview(animesByUsersSearchColl)
        animesByUsersSearchColl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animesByUsersSearchColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            animesByUsersSearchColl.topAnchor.constraint(equalTo: self.searchToolsScrollView.bottomAnchor, constant: 20),
            animesByUsersSearchColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        ])
    }
    
    private func makeCollectionViewFullScreen(_ collectionView: CollectionType) {
        switch collectionView {
        case .trendingNow:
            self.activeCollViewConstraints = [
                trendingNowHeader.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
                trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.78),
                contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
            ]
        case .popularThisSeason:
            self.activeCollViewConstraints = [
                currentSeasonPopularHeader.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
                currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.78),
                contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
            ]
        case .allTimePopular:
            self.activeCollViewConstraints = [
                allTimePopularHeader.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
                allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.78),
                contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
            ]
        case .animeByUsersSearch:
            self.activeCollViewConstraints = [
                //                animesByUsersSearchColl.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
                animesByUsersSearchColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.78),
                contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
            ]
        default: return
        }
    }
    
    //MARK: - Func
    private func fetchDataByUserSearch(currentPage: Int?) {
        self.apiClient.getAnimeBy(
            page: GraphQLNullable<Int>(integerLiteral: currentPage == nil ? 1 : currentPage! + 1),
            perPage: 20,
            sort: [.case(.favouritesDesc)],
            type: .some(.case(.anime)),
            season: self.choosedSeason?.convertToGrapQL() ?? .none,
            seasonYear: self.choosedYear?.convertToGraphQL() ?? .none,
            formats: self.choosedFormats.isEmpty ? .none :
                GraphQLNullable.some(self.choosedFormats.convertToGraphQL()),
            genres: self.choosedGenres.isEmpty ? .none :
                    .some(self.choosedGenres.getRawValues()),
            search: self.searchStringAnime == nil ? .none :
                    .some(self.searchStringAnime!)) { result in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if self.animesByUsersSearch == nil {
                                switch result {
                                case .success(let data):
                                    self.animesByUsersSearch = ListOfAnime(pageInfo: data.data?.page?.pageInfo, animes: data.data?.page?.media?.compactMap({ $0 }) ?? [])
                                    self.isFetching = false
                                    self.animesByUsersSearchColl.reloadData()
                                case .failure(let failure):
                                    switch failure {
                                    case .internetConnection(let error):
                                        self.messageView.setupMessage(error.errorMessage)
                                        self.showMessage = true
                                    case .otherReason(let error):
                                        self.messageView.setupMessage(error.errorMessage)
                                        self.showMessage = true
                                    }
                                }
                            } else {
                                switch result {
                                case .success(let data):
                                    self.animesByUsersSearch?.animes.append(contentsOf: data.data?.page?.media?.compactMap({ $0 }) ?? [])
                                    guard let newPageInfo = data.data?.page?.pageInfo else { return }
                                    self.animesByUsersSearch?.pageInfo? = newPageInfo
                                    self.animesByUsersSearchColl.reloadSections(IndexSet(integer: 0))
                                    self.showMessage = true
                                case .failure(let failure):
                                    switch failure {
                                    case .internetConnection(let error):
                                        self.messageView.setupMessage(error.errorMessage)
                                        self.showMessage = true
                                    case .otherReason(let error):
                                        self.messageView.setupMessage(error.errorMessage)
                                        self.showMessage = true
                                    }
                                }
                            }
                        }
                    }
    }
    
    private func fetchAllTimePopular(currentPage: Int?) {
        self.apiClient.getAnimeBy(
            page: GraphQLNullable<Int>(integerLiteral: currentPage == nil ? 1 : currentPage! + 1),
            perPage: 20,
            sort: [.case(.popularityDesc)],
            type: .some(.case(.anime)),
            season: nil,
            seasonYear: nil,
            formats: nil,
            genres: nil,
            search: nil) { result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    
                    if self.allTimePopularAnimes == nil {
                        
                        switch result {
                        case .success(let data):
                            self.allTimePopularAnimes = ListOfAnime(pageInfo: data.data?.page?.pageInfo, animes: data.data?.page?.media?.compactMap({ $0 }) ?? [])
                            self.isFetching = false
                            self.allTimePopularColl.reloadData()
                        case .failure(let failure):
                            switch failure {
                            case .internetConnection(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            case .otherReason(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            }
                        }
                    } else {
                        switch result {
                        case .success(let data):
                            self.allTimePopularAnimes?.animes.append(contentsOf: data.data?.page?.media?.compactMap({ $0 }) ?? [])
                            guard let newPageInfo = data.data?.page?.pageInfo else { return }
                            self.allTimePopularAnimes?.pageInfo? = newPageInfo
                            self.isFetching = false
                            self.allTimePopularColl.reloadSections(IndexSet(integer: 0))
                        case .failure(let failure):
                            switch failure {
                            case .internetConnection(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            case .otherReason(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            }
                        }
                    }
                }
            }
    }
    
    private func fetchPopularThisSeason(currentPage: Int?) {
        self.apiClient.getAnimeBy(
            page: GraphQLNullable<Int>(integerLiteral: currentPage == nil ? 1 : currentPage! + 1),
            perPage: 20,
            sort: [.case(.favouritesDesc)],
            type: .some(.case(.anime)),
            season: .some(.case(.fall)),
            seasonYear: 2023,
            formats: nil,
            genres: nil,
            search: nil) { result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if self.currentSeasonPopularAnimes == nil {
                        
                        switch result {
                        case .success(let data):
                            self.currentSeasonPopularAnimes = ListOfAnime(pageInfo: data.data?.page?.pageInfo, animes: data.data?.page?.media?.compactMap({ $0 }) ?? [])
                            self.isFetching = false
                            self.currentSeasonPopularColl.reloadData()
                        case .failure(let failure):
                            switch failure {
                            case .internetConnection(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            case .otherReason(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            }
                        }

                    } else {
                        switch result {
                        case .success(let data):
                            self.currentSeasonPopularAnimes?.animes.append(contentsOf: data.data?.page?.media?.compactMap({ $0 }) ?? [])
                            guard let newPageInfo = data.data?.page?.pageInfo else { return }
                            self.currentSeasonPopularAnimes?.pageInfo? = newPageInfo
                            self.isFetching = false
                            self.currentSeasonPopularColl.reloadSections(IndexSet(integer: 0))
                        case .failure(let failure):
                            switch failure {
                            case .internetConnection(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            case .otherReason(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            }
                        }

                    }
                }
            }
    }
    
    private func fetchTrendingNow(currentPage: Int?) {
        self.apiClient.getAnimeBy(
            page: GraphQLNullable<Int>(integerLiteral: currentPage == nil ? 1 : currentPage! + 1),
            perPage: 20,
            sort: [.case(.trendingDesc)],
            type: .some(.case(.anime)),
            season: nil,
            seasonYear: nil,
            formats: nil,
            genres: nil,
            search: nil) { result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if self.trendingNowAnimes == nil {
                        switch result {
                        case .success(let data):
                            self.trendingNowAnimes = ListOfAnime(pageInfo: data.data?.page?.pageInfo, animes: data.data?.page?.media?.compactMap({ $0 }) ?? [])
                            self.isFetching = false
                            self.trendingNowColl.reloadData()
                        case .failure(let failure):
                            switch failure {
                            case .internetConnection(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            case .otherReason(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            }
                        }
                        
                    } else {
                        switch result {
                        case .success(let data):
                            self.trendingNowAnimes?.animes.append(contentsOf: data.data?.page?.media?.compactMap({ $0 }) ?? [])
                            guard let newPageInfo = data.data?.page?.pageInfo else { return }
                            self.trendingNowAnimes?.pageInfo? = newPageInfo
                            self.isFetching = false
                            self.trendingNowColl.reloadSections(IndexSet(integer: 0))
                            self.showMessage = true
                        case .failure(let failure):
                            switch failure {
                            case .internetConnection(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            case .otherReason(let error):
                                self.messageView.setupMessage(error.errorMessage)
                                self.showMessage = true
                            }
                        }
                        
                    }
                }
            }
    }
    
    private func searchToolsAreEmpty() -> Bool {
        if self.choosedGenres.isEmpty && self.choosedYear == nil && self.choosedFormats.isEmpty && self.choosedSeason == nil && self.searchStringAnime == nil {
            return true
        } else {
            return false
        }
    }
    
    private func makeOtherCollectionTransparent(except collection: CollectionType, unhide: Bool) {
        switch collection {
        case .trendingNow:
            self.allTimePopularHeader.alpha = unhide == true ? 1.0 : 0.0
            self.allTimePopularColl.alpha = unhide == true ? 1.0 : 0.0
            self.currentSeasonPopularHeader.alpha = unhide == true ? 1.0 : 0.0
            self.currentSeasonPopularColl.alpha = unhide == true ? 1.0 : 0.0
        case .popularThisSeason:
            self.allTimePopularHeader.alpha = unhide == true ? 1.0 : 0.0
            self.allTimePopularColl.alpha = unhide == true ? 1.0 : 0.0
            self.trendingNowHeader.alpha = unhide == true ? 1.0 : 0.0
            self.trendingNowColl.alpha = unhide == true ? 1.0 : 0.0
        case .allTimePopular:
            self.currentSeasonPopularHeader.alpha = unhide == true ? 1.0 : 0.0
            self.currentSeasonPopularColl.alpha = unhide == true ? 1.0 : 0.0
            self.trendingNowHeader.alpha = unhide == true ? 1.0 : 0.0
            self.trendingNowColl.alpha = unhide == true ? 1.0 : 0.0
        case .animeByUsersSearch:
            self.allTimePopularHeader.alpha = unhide == true ? 1.0 : 0.0
            self.allTimePopularColl.alpha = unhide == true ? 1.0 : 0.0
            self.currentSeasonPopularHeader.alpha = unhide == true ? 1.0 : 0.0
            self.currentSeasonPopularColl.alpha = unhide == true ? 1.0 : 0.0
            self.trendingNowHeader.alpha = unhide == true ? 1.0 : 0.0
            self.trendingNowColl.alpha = unhide == true ? 1.0 : 0.0
        case .none:
            self.allTimePopularHeader.alpha = unhide == true ? 1.0 : 0.0
            self.allTimePopularColl.alpha = unhide == true ? 1.0 : 0.0
            self.currentSeasonPopularHeader.alpha = unhide == true ? 1.0 : 0.0
            self.currentSeasonPopularColl.alpha = unhide == true ? 1.0 : 0.0
            self.trendingNowHeader.alpha = unhide == true ? 1.0 : 0.0
            self.trendingNowColl.alpha = unhide == true ? 1.0 : 0.0
        }
    }
    
    @objc private func scrollToTopButtonTapped(_ sender: UIButton) {
        scrollToTheTop(collectionType: self.extendedCollection)
    }
    
    private func scrollToTheTop(collectionType: CollectionType) {
        let desiredOffset = CGPoint(x: 0, y: 0)
        if collectionType == .trendingNow {
            self.trendingNowColl.setContentOffset(desiredOffset, animated: true)
        } else if extendedCollection == .popularThisSeason {
            self.currentSeasonPopularColl.setContentOffset(desiredOffset, animated: true)
        } else if extendedCollection == .allTimePopular {
            self.allTimePopularColl.setContentOffset(desiredOffset, animated: true)
        }
    }
    
    func moreButtonTapped(_ sender: UIButton) {
        print("DEBUG:", "Tapped more anime button")
        
        let superview = sender.superview as! SectionHeader
        var headersCollectionView: CollectionType = .none
        if superview == self.trendingNowHeader  {
            headersCollectionView = .trendingNow
        } else if superview == self.currentSeasonPopularHeader {
            headersCollectionView = .popularThisSeason
        } else if superview == self.allTimePopularHeader {
            headersCollectionView = .allTimePopular
        }
        
        if headersCollectionView != self.extendedCollection {
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransform(rotationAngle: .pi/4)
            }
            
            switch headersCollectionView {
            case .trendingNow:
                self.trendingNowColl.setContentOffset(.zero, animated: true)
                
                self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: false)
                
                self.trendingNowColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.trendingNowColl.hideSkeleton()
                }
                
                if let layout = self.trendingNowColl.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical
                }
            case .popularThisSeason:
                self.currentSeasonPopularColl.setContentOffset(.zero, animated: true)
                
                self.currentSeasonPopularColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.currentSeasonPopularColl.hideSkeleton()
                }
                
                
                self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: false)
                if let layout = self.currentSeasonPopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical
                }
            case .allTimePopular:
                self.allTimePopularColl.setContentOffset(.zero, animated: true)
                
                self.allTimePopularColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.allTimePopularColl.hideSkeleton()
                }
                
                
                self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: false)
                if let layout = self.allTimePopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical
                }
            case .animeByUsersSearch:
                return
            case .none:
                return
            }
        } else {
            self.trendingNowColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
            self.currentSeasonPopularColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
            self.allTimePopularColl.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor(named: "DarkBlack")!, secondaryColor: UIColor(named: "DarkOne")!), transition: .crossDissolve(0.25))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.allTimePopularColl.hideSkeleton()
                self.trendingNowColl.hideSkeleton()
                self.currentSeasonPopularColl.hideSkeleton()
            }
            
            self.setupActiveCollViewConstraints()
            self.view.layoutIfNeeded()
        }
        if self.extendedCollection != headersCollectionView {
            self.makeCollectionViewFullScreen(headersCollectionView)
            self.view.layoutIfNeeded()
            self.extendedCollection = headersCollectionView
        } else {
            
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
            }
            
            switch headersCollectionView {
            case .trendingNow:
                self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: true)
                if let layout = self.trendingNowColl.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
            case .popularThisSeason:
                self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: true)
                if let layout = self.currentSeasonPopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
            case .allTimePopular:
                self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: true)
                if let layout = self.allTimePopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
            case .none:
                return
            case .animeByUsersSearch:
                return
            }
            self.extendedCollection = .none
        }
    }
    
    func didTapCell(with type: GetAnimeByQuery.Data.Page.Medium) {
        print("DEBUG:", "Tapped Anime Cell")
        let vc = DetailInfoController()
        vc.configure(with: type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toolTapped(_ toolType: SearchTool, sender: UIButton) {
        
        let coordinats = sender.superview?.convert(sender.frame.origin, to: nil)
        self.xPositionChoosedTool = coordinats!.x
        self.shouldDetectScrollStart = true
        
        if isToolOpened {
            UIView.animate(withDuration: 0.3) {
                self.choosedToolCollectionView.frame.origin.y = self.choosedToolCollectionView.frame.origin.y - 10
                self.choosedToolCollectionView.alpha = 0.0
            } completion: { _ in
                self.isToolOpened = false
                if toolType != self.choosedTool {
                    self.toolTapped(toolType, sender: sender)
                }
                self.choosedToolCollectionView.reloadData()
                
                if !self.searchToolsAreEmpty() {
                    self.extendedCollection = .animeByUsersSearch
                    self.setupAnimesBySearch()
                    self.makeOtherCollectionTransparent(except: self.extendedCollection, unhide: false)
                    self.makeCollectionViewFullScreen(self.extendedCollection)
                    
                    self.isFetching = true
                    self.animesByUsersSearch = nil
                    self.fetchDataByUserSearch(currentPage: nil)
                    
                    
                    
                }
            }
        } else {
            if !isFetching {
                var hasChoosedToolView = false
                self.choosedTool = toolType
                
                for view in contentView.subviews {
                    if view == choosedToolCollectionView {
                        hasChoosedToolView = true
                    }
                }
                self.isToolOpened = true
                if !hasChoosedToolView {
                    self.contentView.addSubview(choosedToolCollectionView)
                }
                self.contentView.bringSubviewToFront(choosedToolCollectionView)
                choosedToolCollectionView.translatesAutoresizingMaskIntoConstraints = false
                
                self.choosedToolCollectionView.alpha = 0.0
                choosedToolCollectionView.frame = CGRect(
                    x: coordinats!.x,
                    y: 80,
                    width: 150,
                    height: choosedTool == .season ? 160 : 320
                )
                
                UIView.animate(withDuration: 0.3) {
                    self.choosedToolCollectionView.frame.origin.y = self.choosedToolCollectionView.frame.origin.y + 10
                    self.choosedToolCollectionView.alpha = 1.0
                }
                choosedToolCollectionView.reloadData()
            }
        }
    }
    
    func removeButtonTapped(_ toolType: SearchTool) {
        switch toolType {
        case .genre:
            self.choosedGenres = []
            if searchToolsAreEmpty() {
                UIView.animate(withDuration: 0.3) {
                    self.extendedCollection = .none
                    for view in self.view.subviews {
                        if view == self.animesByUsersSearchColl {
                            view.removeFromSuperview()
                        }
                        self.makeOtherCollectionTransparent(except: .none, unhide: true)
                        self.setupActiveCollViewConstraints()
                    }
                }
            } else {
                self.isFetching = true
                self.animesByUsersSearch = nil
                self.fetchDataByUserSearch(currentPage: nil)
            }
        case .year:
            self.choosedYear = nil
            if searchToolsAreEmpty() {
                UIView.animate(withDuration: 0.3) {
                    self.extendedCollection = .none
                    for view in self.view.subviews {
                        if view == self.animesByUsersSearchColl {
                            view.removeFromSuperview()
                        }
                        self.makeOtherCollectionTransparent(except: .none, unhide: true)
                        self.setupActiveCollViewConstraints()
                        
                    }
                }
            } else {
                self.isFetching = true
                self.animesByUsersSearch = nil
                self.fetchDataByUserSearch(currentPage: nil)
            }
        case .season:
            self.choosedSeason = nil
            if searchToolsAreEmpty() {
                UIView.animate(withDuration: 0.3) {
                    self.extendedCollection = .none
                    for view in self.view.subviews {
                        if view == self.animesByUsersSearchColl {
                            view.removeFromSuperview()
                        }
                        self.makeOtherCollectionTransparent(except: .none, unhide: true)
                        self.setupActiveCollViewConstraints()
                        self.animesByUsersSearch = nil
                    }
                }
            } else {
                self.isFetching = true
                self.animesByUsersSearch = nil
                self.fetchDataByUserSearch(currentPage: nil)
            }
        case .format:
            self.choosedFormats = []
            if searchToolsAreEmpty() {
                UIView.animate(withDuration: 0.3) {
                    self.extendedCollection = .none
                    for view in self.view.subviews {
                        if view == self.animesByUsersSearchColl {
                            view.removeFromSuperview()
                        }
                        self.makeOtherCollectionTransparent(except: .none, unhide: true)
                        self.setupActiveCollViewConstraints()
                        self.animesByUsersSearch = nil
                    }
                }
            } else {
                self.isFetching = true
                self.animesByUsersSearch = nil
                self.fetchDataByUserSearch(currentPage: nil)
            }
        }
        self.choosedToolCollectionView.reloadData()
    }
    
    func optionTapped(sender: UIButton, tool: SearchTool, choosedOption: Any) {
        let cell = sender.superview as! ToolsOptionsCell
        switch tool {
        case .genre:
            let choosedGenre = choosedOption as! Genre
            if self.choosedGenres.contains(choosedGenre) {
                self.choosedGenres.remove(at: self.choosedGenres.firstIndex(of: choosedGenre)!)
                self.searchToolsScrollView.removeOption(toolType: self.choosedTool!, tool: tool, option: choosedGenres)
                cell.markAsUnchoosed()
            } else {
                self.choosedGenres.append(choosedGenre)
                self.searchToolsScrollView.addOption(toolType: self.choosedTool!, option: choosedGenres)
                cell.markAsChoosed()
            }
        case .year:
            let choosedYear = choosedOption as! Int
            if self.choosedYear == choosedYear {
                self.choosedYear = nil
                self.searchToolsScrollView.removeOption(toolType: self.choosedTool!, tool: tool, option: self.choosedYear as Any)
                cell.markAsUnchoosed()
            } else {
                if self.choosedYear != nil {
                    for view in self.choosedToolCollectionView.visibleCells {
                        let view = view as! ToolsOptionsCell
                        if view.getYear() == self.choosedYear {
                            view.markAsUnchoosed()
                        }
                    }
                }
                self.choosedYear = choosedYear
                self.searchToolsScrollView.addOption(toolType: self.choosedTool!, option: self.choosedYear!)
                cell.markAsChoosed()
            }
            
        case .season:
            let choosedOption = choosedOption as! MediaSeason
            if choosedSeason == choosedOption {
                self.choosedSeason = nil
                self.searchToolsScrollView.removeOption(toolType: self.choosedTool!, tool: tool, option: choosedSeason as Any)
                cell.markAsUnchoosed()
            } else {
                if self.choosedSeason != nil {
                    let index = MediaSeason.allCases.firstIndex(of: self.choosedSeason!)
                    let previousCell = self.choosedToolCollectionView.visibleCells[index!]
                    let previousCellView = previousCell as! ToolsOptionsCell
                    previousCellView.markAsUnchoosed()
                }
                self.choosedSeason = choosedOption
                self.searchToolsScrollView.addOption(toolType: self.choosedTool!, option: choosedSeason!)
                cell.markAsChoosed()
            }
        case .format:
            let choosedFormat = choosedOption as! MediaFormat
            if self.choosedFormats.contains(choosedFormat) {
                self.choosedFormats.remove(at: self.choosedFormats.firstIndex(of: choosedFormat)!)
                self.searchToolsScrollView.removeOption(toolType: self.choosedTool!, tool: tool, option: choosedFormats)
                cell.markAsUnchoosed()
            } else {
                self.choosedFormats.append(choosedFormat)
                self.searchToolsScrollView.addOption(toolType: self.choosedTool!, option: choosedFormats)
                cell.markAsChoosed()
            }
        }
    }
}

extension MenuController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate  {
    
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "Cell"
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == self.trendingNowColl {
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                print("Scrolled to the end")
                
                guard let currentPage = self.trendingNowAnimes?.pageInfo?.currentPage, let hasNextPage = self.trendingNowAnimes?.pageInfo?.hasNextPage else { return }
                
                if hasNextPage {
                    self.fetchTrendingNow(currentPage: currentPage)
                }
            }
        } else if collectionView == self.currentSeasonPopularColl {
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                print("Scrolled to the end")
                
                guard let currentPage = self.currentSeasonPopularAnimes?.pageInfo?.currentPage, let hasNextPage = self.currentSeasonPopularAnimes?.pageInfo?.hasNextPage else { return }
                
                if hasNextPage {
                    self.fetchPopularThisSeason(currentPage: currentPage)
                }
            }
        } else if collectionView == self.allTimePopularColl {
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                print("Scrolled to the end")
                
                guard let currentPage = self.allTimePopularAnimes?.pageInfo?.currentPage, let hasNextPage = self.allTimePopularAnimes?.pageInfo?.hasNextPage else { return }
                
                if hasNextPage {
                    self.fetchAllTimePopular(currentPage: currentPage)
                }
            }
        } else if collectionView == self.animesByUsersSearchColl {
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                print("Scrolled to the end")
                guard let currentPage = self.allTimePopularAnimes?.pageInfo?.currentPage, let hasNextPage = self.allTimePopularAnimes?.pageInfo?.hasNextPage else { return }
                
                if hasNextPage {
                    self.fetchDataByUserSearch(currentPage: currentPage)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != choosedToolCollectionView {
//            let size = CGSize(width: collectionView.frame.width * 0.44, height: collectionView.frame.height * 1)
            let size = CGSize(width: collectionView.frame.width * 0.44, height: 281)
            return size
            
        } else {
            return CGSize(width: 150, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView != choosedToolCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            if layout.scrollDirection == .horizontal {
                return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
            } else {
                return UIEdgeInsets.init(top: 0, left: 10, bottom: 30, right: 12)
            }
        } else {
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView != choosedToolCollectionView {
            return 10
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView != choosedToolCollectionView {
            return 25
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView != choosedToolCollectionView {
            if collectionView == self.allTimePopularColl {
                return self.allTimePopularAnimes?.animes.count ?? 5
            } else if collectionView == self.currentSeasonPopularColl {
                return self.currentSeasonPopularAnimes?.animes.count ?? 5
            } else if collectionView == self.trendingNowColl {
                return self.trendingNowAnimes?.animes.count ?? 5
            } else {
                return self.animesByUsersSearch?.animes.count ?? 6
            }
        } else {
            switch choosedTool {
                case .format:
                    return GraphQLEnum<MediaFormat>.allCases.count
                case .season:
                    return GraphQLEnum<MediaSeason>.allCases.count
                case .genre:
                return Genre.allCases.count
                case .year:
                return choosedTool!.yearCount
                case .none:
                    return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView != choosedToolCollectionView {
            if collectionView == self.allTimePopularColl {
                guard let cell = allTimePopularColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuAnimePreviewCell else {
                    fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
                }
                if allTimePopularAnimes != nil {
                    let preview = self.allTimePopularAnimes?.animes[indexPath.row]
                    cell.configure(with: preview!)
                    cell.delegate = self
                }
                return cell
                
            } else if collectionView == self.currentSeasonPopularColl {
                guard let cell = currentSeasonPopularColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuAnimePreviewCell else {
                    fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
                }
                if currentSeasonPopularAnimes != nil {
                    let preview = self.currentSeasonPopularAnimes?.animes[indexPath.row]
                    cell.configure(with: preview!)
                    cell.delegate = self
                }
                return cell
            } else if collectionView == self.trendingNowColl {
                guard let cell = trendingNowColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuAnimePreviewCell else {
                    fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
                }
                
                if trendingNowAnimes != nil {
                    let preview = self.trendingNowAnimes?.animes[indexPath.row]
                    cell.configure(with: preview!)
                    cell.delegate = self
                }
                return cell
            }
            else {
                guard let cell = animesByUsersSearchColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
                        as? MenuAnimePreviewCell else {
                    fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
                }
                if animesByUsersSearch != nil {
                    let preview = self.animesByUsersSearch?.animes[indexPath.row]
                    cell.configure(with: preview!)
                    cell.delegate = self
                }
                return cell
            }
        } else {
            guard let cell = choosedToolCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ToolsOptionsCell else {
                fatalError("Unenable to dequeue AdditionalSearchToolsCell in MenuController")
            }
            
            switch choosedTool {
            case .format:
                let formatByIndex = MediaFormat.allCases[indexPath.row]
                if choosedFormats.first(where: { $0 == formatByIndex }) != nil {
                    cell.configure(choosedTool: choosedTool!, index: indexPath.row)
                    cell.markAsChoosed()
                } else {
                    cell.configure(choosedTool: choosedTool!, index: indexPath.row)
                    cell.markAsUnchoosed()
                }
            case .genre:
                let genreByIndex = Genre.allCases[indexPath.row]
                if choosedGenres.first(where: { $0 == genreByIndex}) != nil {
                    cell.configure(choosedTool: choosedTool!, index: indexPath.row)
                    cell.markAsChoosed()
                } else {
                    cell.configure(choosedTool: choosedTool!, index: indexPath.row)
                    cell.markAsUnchoosed()
                }
            case .season:
                let season = MediaSeason.allCases[indexPath.row]
                if choosedSeason == season {
                    cell.configure(choosedTool: choosedTool!, index: indexPath.row)
                    cell.markAsChoosed()
                } else {
                    cell.configure(choosedTool: choosedTool!, index: indexPath.row)
                    cell.markAsUnchoosed()
                }
            case .year:
                let year = SearchTool.year.currentYear - indexPath.row
                if choosedYear == year {
                    cell.configure(choosedTool: choosedTool!, index: indexPath.row)
                    cell.markAsChoosed()
                } else {
                    cell.configure(choosedTool: choosedTool!, index: indexPath.row)
                    cell.markAsUnchoosed()
                }
                
            case .none:
                cell.configure(choosedTool: choosedTool!, index: indexPath.row)
            }
            
            cell.delegate = self
            return cell
        }
    }
}


