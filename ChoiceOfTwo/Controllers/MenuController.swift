//
//  MenuController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/12/2023.
//

import UIKit
import AnilistApi

class MenuController: UIViewController, AnimePreviewProtocol, SearchToolButtonProtocol, ToolsOptionsProtocol, HeaderMoreButtonProtocol {
        
    
    //MARK: - Variables
    
    
    //TODO: - change choosedHeader to enum that i'll create in the future, so it's more understandble
//    private var choosedHeader: SectionHeader?
    private var extendedCollection: CollectionType?
    //------------------|-----------------------------------------------------------------------------------
    //-----------------|-|----------------------------------------------------------------------------------
    //----------------|---|---------------------------------------------------------------------------------
    //------------------|-----------------------------------------------------------------------------------
    //------------------|-----------------------------------------------------------------------------------
    //------------------|-----------------------------------------------------------------------------------
    //----------------HE-RE---------------------------------------------------------------------------------
    
    private var choosedGenres: [Genre] = []
    
    private var choosedYear: Int?
    
    private var choosedSeason: MediaSeason?
    
    private var choosedFormats: [MediaFormat] = []
//    private var choosedFOrmats: GraphQLNullable<GraphQLEnum<MediaFormat>> = .null
    
    private var searchStringAnime: String?
    
    private var isChoosedOpened: Bool = false
    
    private var choosedTool: SearchTool?
    
    private var scrollViewX: CGFloat = .zero
    
    private var xChoosedTool: CGFloat = .zero
    
    private var shouldDetectScrollStart = false
    
    private var isFetching = false
    
    private let apiClient = ApiClient()
    
    private var activeCollViewConstraints: [NSLayoutConstraint] = [] {
      willSet {
        NSLayoutConstraint.deactivate(activeCollViewConstraints)
      }
      didSet {
        NSLayoutConstraint.activate(activeCollViewConstraints)
      }
    }
    
    private var activeSideButtonsConstraints: [NSLayoutConstraint] = [] {
        willSet {
          NSLayoutConstraint.deactivate(activeSideButtonsConstraints)
        }
        didSet {
          NSLayoutConstraint.activate(activeSideButtonsConstraints)
        }
    }
    
    private var allTimePopularAnimes: ListOfAnime?
    
    private var currentSeasonPopularAnimes: ListOfAnime?
    
    private var trendingNowAnimes: ListOfAnime?
    
    
    //MARK: - UI Components
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
    
    private let menuButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Menu")!.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(named: "Orange")
        button.imageView?.tintColor = .white
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 15
        return button
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
        
            self.apiClient.getAnimeBy(
                page: 1,
                perPage: 20,
                sort: [.case(.favouritesDesc)],
                type: .some(.case(.anime)),
                season: .some(.case(.fall)),
                seasonYear: 2023,
                formats: nil,
                genres: nil,
                search: nil) { result in
                    
                    self.currentSeasonPopularAnimes = ListOfAnime(pageInfo: result.data?.page?.pageInfo, animes: result.data?.page?.media?.compactMap({ $0 }) ?? [])
                    self.currentSeasonPopularColl.reloadData()
                    self.currentSeasonPopularColl.setNeedsDisplay()
                }
            
            self.apiClient.getAnimeBy(
                page: 1,
                perPage: 20,
                sort: [.case(.popularityDesc)],
                type: .some(.case(.anime)),
                season: nil,
                seasonYear: nil,
                formats: nil,
                genres: nil,
                search: nil) { result in
                    
                    self.allTimePopularAnimes = ListOfAnime(pageInfo: result.data?.page?.pageInfo, animes: result.data?.page?.media?.compactMap({ $0 }) ?? [])
                    self.allTimePopularColl.reloadData()
                    self.allTimePopularColl.setNeedsDisplay()

                }
            
            self.apiClient.getAnimeBy(
                page: 1,
                perPage: 20,
                sort: [.case(.trendingDesc)],
                type: .some(.case(.anime)),
                season: nil,
                seasonYear: nil,
                formats: nil,
                genres: nil,
                search: nil) { result in
                    
                    self.trendingNowAnimes = ListOfAnime(pageInfo: result.data?.page?.pageInfo, animes: result.data?.page?.media?.compactMap({ $0 }) ?? [])
                    self.trendingNowColl.reloadData()
                    self.trendingNowColl.setNeedsDisplay()
                }
        
        
        self.scrollToTopButton.addTarget(self, action: #selector(scrollToTopButtonTapped), for: .touchUpInside)
        self.menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        self.trendingNowHeader.delegate = self
        self.allTimePopularHeader.delegate = self
        self.currentSeasonPopularHeader.delegate = self
        
        self.currentSeasonPopularColl.delegate = self
        self.currentSeasonPopularColl.dataSource = self
        self.allTimePopularColl.delegate = self
        self.allTimePopularColl.dataSource = self
        self.trendingNowColl.delegate = self
        self.trendingNowColl.dataSource = self
        self.choosedToolCollectionView.delegate = self
        self.choosedToolCollectionView.dataSource = self
        
        self.mainScrollView.delegate = self
        self.searchToolsScrollView.configureDelegate(self)
        
        self.setupUI()
        
//        setupMenuButton()
//        setupContentView()
//        setupMainScrollView()
//        setupScrollTopButton()
//        setupTrendingNowColl()
//        setupTrendingNowHeader()
//        setupAllTimePopularColl()
//        setupAllTimePopularHeader()
//        setupSearchToolScrollView()
//        setupCurrentSeasonPopularColl()
//        setupCurrentSeasonPopularHeader()
//        setupActiveCollViewConstraints()
//        setupActiveSideButtonConstraints()
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if shouldDetectScrollStart {
            scrollViewX = scrollView.contentOffset.x
        }
        shouldDetectScrollStart = false
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == searchToolsScrollView.getScrollView() {
            self.choosedToolCollectionView.frame.origin.x = self.xChoosedTool - scrollView.contentOffset.x
            choosedToolCollectionView.frame.origin.x = xChoosedTool - (scrollView.contentOffset.x - scrollViewX)
        } else if scrollView == allTimePopularColl || scrollView == trendingNowColl || scrollView == currentSeasonPopularColl {
            let offset = scrollView.contentOffset.y
            if offset > self.view.frame.height {
                
                self.activeSideButtonsConstraints = [
                    scrollToTopButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -10),
                    menuButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 80),
                ]
                
                UIView.animate(withDuration: 0.4) {
                    self.view.layoutIfNeeded()
                }
            } else {
                
                self.activeSideButtonsConstraints = [
                    
                    scrollToTopButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 80),
                    menuButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -10),
                ]
                
                UIView.animate(withDuration: 0.4) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        
    }
    
    //MARK: - Setup UI
    
//    private func setupMainScrollView() {
//        self.view.addSubview(mainScrollView)
//        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        ])
//    }
//    
//    private func setupContentView() {
//        self.contentView.addSubview(searchToolsScrollView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
//            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
//            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
//        ])
//    }
//    
//    private func setupSearchToolScrollView() {
//        self.contentView.addSubview(searchToolsScrollView)
//        searchToolsScrollView.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        NSLayoutConstraint.activate([
//            searchToolsScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            searchToolsScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            searchToolsScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            searchToolsScrollView.widthAnchor.constraint(equalToConstant: 800),
//            searchToolsScrollView.heightAnchor.constraint(equalToConstant: 80),
//        ])
//    }
//    
//    private func setupScrollTopButton() {
//        self.view.addSubview(scrollToTopButton)
//        scrollToTopButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            self.scrollToTopButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
//            self.scrollToTopButton.widthAnchor.constraint(equalToConstant: 60),
//            self.scrollToTopButton.heightAnchor.constraint(equalToConstant: 60),
//        ])
//    }
//    
//    private func setupMenuButton() {
//        self.view.addSubview(menuButton)
//        menuButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            self.menuButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
//            self.menuButton.widthAnchor.constraint(equalToConstant: 60),
//            self.menuButton.heightAnchor.constraint(equalToConstant: 60),
//        ])
//    }
//    
//    private func setupAllTimePopularHeader() {
//        self.contentView.addSubview(allTimePopularHeader)
//        allTimePopularHeader.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            allTimePopularHeader.heightAnchor.constraint(equalToConstant: 20),
//            allTimePopularHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
//            allTimePopularHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
//        ])
//    }
//    
//    private func setupAllTimePopularColl() {
//        self.contentView.addSubview(allTimePopularColl)
//        allTimePopularColl.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            allTimePopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            allTimePopularColl.topAnchor.constraint(equalTo: self.allTimePopularHeader.bottomAnchor, constant: 15),
//            allTimePopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
//        ])
//    }
//    
//    private func setupCurrentSeasonPopularHeader() {
//        self.contentView.addSubview(currentSeasonPopularHeader)
//        currentSeasonPopularHeader.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        NSLayoutConstraint.activate([
//            currentSeasonPopularHeader.heightAnchor.constraint(equalToConstant: 20),
//            currentSeasonPopularHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
//            currentSeasonPopularHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
//        ])
//    }
//    
//    private func setupCurrentSeasonPopularColl() {
//        self.contentView.addSubview(currentSeasonPopularColl)
//        currentSeasonPopularColl.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            currentSeasonPopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            currentSeasonPopularColl.topAnchor.constraint(equalTo: self.currentSeasonPopularHeader.bottomAnchor, constant: 15),
//            currentSeasonPopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
//        ])
//    }
//    
//    private func setupTrendingNowHeader() {
//        self.contentView.addSubview(trendingNowHeader)
//        trendingNowHeader.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            trendingNowHeader.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
//            trendingNowHeader.heightAnchor.constraint(equalToConstant: 20),
//            trendingNowHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
//            trendingNowHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
//        ])
//    }
//    
//    private func setupTrendingNowColl() {
//        
//        self.contentView.addSubview(trendingNowColl)
//        trendingNowColl.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            currentSeasonPopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            currentSeasonPopularColl.topAnchor.constraint(equalTo: self.currentSeasonPopularHeader.bottomAnchor, constant: 15),
//            currentSeasonPopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
//        ])
//        
//    }
    
    private func setupActiveSideButtonConstraints() {
        self.activeSideButtonsConstraints = [
            scrollToTopButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 80),
            menuButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -10),
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
    
    private func setupUI() {
        
        self.view.addSubview(mainScrollView)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainScrollView.addSubview(contentView)
        searchToolsScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(searchToolsScrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(choiceOfTwoButton)
//        choiceOfTwoButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollToTopButton)
        scrollToTopButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(menuButton)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        
        
        NSLayoutConstraint.activate([
            
//            self.choiceOfTwoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            self.choiceOfTwoButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
//            self.choiceOfTwoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            self.scrollToTopButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            self.scrollToTopButton.widthAnchor.constraint(equalToConstant: 60),
            self.scrollToTopButton.heightAnchor.constraint(equalToConstant: 60),
            
            self.menuButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            self.menuButton.widthAnchor.constraint(equalToConstant: 60),
            self.menuButton.heightAnchor.constraint(equalToConstant: 60),
            
            
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
//            contentView.heightAnchor.constraint(equalToConstant: 2000),
            
//            contentView.heightAnchor.constraint(equalToConstant: configureDefaultContentSize()),
            
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
            
//            trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
//            currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.trendingNowColl.bottomAnchor, constant: 30),
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
//        self.activeSideButtonsConstraints = [
//            scrollToTopButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 80),
//            menuButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -10),
//        ]
//        
//        self.activeCollViewConstraints = [
//            allTimePopularHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
//            currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.trendingNowColl.bottomAnchor, constant: 30),
//            contentView.heightAnchor.constraint(equalToConstant: configureDefaultContentSize()),
//            currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//            allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//            trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//        ]
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
        default: return
        }
    }
    
//    private func setupUIAfterMoreButtonTapped(view: UIView, backToNormal: Bool) {
//        
//        if backToNormal {
//            if view == self.allTimePopularHeader {
//                self.activeCollViewConstraints = [
//                    allTimePopularHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
//                    currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.trendingNowColl.bottomAnchor, constant: 30),
//                    
//                    currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//                    allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//                    trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//                    contentView.heightAnchor.constraint(equalToConstant: configureDefaultContentSize())
//                ]
//                
//            } else if view == self.currentSeasonPopularHeader {
//                self.activeCollViewConstraints = [
//                    allTimePopularHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
//                    currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.trendingNowColl.bottomAnchor, constant: 30),
//                    
//                    currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//                    allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//                    trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//                    
//                    contentView.heightAnchor.constraint(equalToConstant: configureDefaultContentSize())
//
//                ]
//            } else if view == self.trendingNowHeader {
//                self.activeCollViewConstraints = [
//                    allTimePopularHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
//                    currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.trendingNowColl.bottomAnchor, constant: 30),
//                    
//                    currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//                    allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//                    trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
//                    contentView.heightAnchor.constraint(equalToConstant: configureDefaultContentSize())
//                ]
//            }
//        } else {
//            if view == self.allTimePopularHeader {
//                self.activeCollViewConstraints = [
//                    view.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
////                    allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 3.5),
////                    contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1),
//                    
//                    allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.78),
//                    contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
//                ]
//            } else if view == self.currentSeasonPopularHeader {
//                self.activeCollViewConstraints = [
//                    view.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
////                    currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 3.5),
////                    contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1),
//                    
//                    currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.78),
//                    contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
//                ]
//            } else if view == self.trendingNowHeader {
//                guard let currentPage = trendingNowAnimes?.pageInfo?.currentPage else { return }
//                self.activeCollViewConstraints = [
////                    trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 3.5),
////                    trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.78),
//                    trendingNowColl.heightAnchor.constraint(equalToConstant: (self.view.frame.height * 0.78) * CGFloat(currentPage)),
//                    contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
//                ]
//            }
//            
////            makeCollectionViewFullScreen(<#T##collectionView: verticalCollView##verticalCollView#>, header: <#T##SectionHeader#>)
//        }
//    }
    
    //MARK: - Func
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
        case .none:
            return
        }
    }
    
    @objc private func menuButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func scrollToTopButtonTapped(_ sender: UIButton) {
        
//        let desiredOffset = CGPoint(x: 0, y: -51)
        let desiredOffset = CGPoint(x: 0, y: 0)
//        if choosedHeader == self.trendingNowHeader {
        if extendedCollection == .trendingNow {
            self.trendingNowColl.setContentOffset(desiredOffset, animated: true)
//        } else if choosedHeader == self.currentSeasonPopularHeader {
        } else if extendedCollection == .popularThisSeason {
            self.currentSeasonPopularColl.setContentOffset(desiredOffset, animated: true)
//        } else if choosedHeader == self.allTimePopularHeader {
        } else if extendedCollection == .allTimePopular {
            self.allTimePopularColl.setContentOffset(desiredOffset, animated: true)
        }
    }
    
    func moreButtonTapped(_ sender: UIButton) {
        print("DEBUG:", "Tapped more anime button")
//        self.isFetching = true
        
        let superview = sender.superview as! SectionHeader
        var headersCollectionView: CollectionType = .none
        if superview == self.trendingNowHeader  {
            headersCollectionView = .trendingNow
        } else if superview == self.currentSeasonPopularHeader {
            headersCollectionView = .popularThisSeason
        } else if superview == self.allTimePopularHeader {
            headersCollectionView = .allTimePopular
        }
        
        UIView.animate(withDuration: 0.4) {
            if headersCollectionView != self.extendedCollection {
                sender.transform = CGAffineTransform(rotationAngle: .pi/4)
                
                switch headersCollectionView {
                case .trendingNow:
                    self.trendingNowColl.setContentOffset(.zero, animated: true)
                    self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: false)
                    if let layout = self.trendingNowColl.collectionViewLayout as? UICollectionViewFlowLayout {
                        layout.scrollDirection = .vertical
                    }
                case .popularThisSeason:
                    self.currentSeasonPopularColl.setContentOffset(.zero, animated: true)
                    self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: false)
                    if let layout = self.currentSeasonPopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
                        layout.scrollDirection = .vertical
                    }
                case .allTimePopular:
                    self.allTimePopularColl.setContentOffset(.zero, animated: true)
                    self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: false)
                    if let layout = self.allTimePopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
                        layout.scrollDirection = .vertical
                    }
                case .none:
                    return
                }
                
//                if superview == self.allTimePopularHeader {
//                    self.allTimePopularColl.setContentOffset(.zero, animated: true)
//                    self.currentSeasonPopularHeader.alpha = 0.0
//                    self.currentSeasonPopularColl.alpha = 0.0
//                    self.trendingNowHeader.alpha = 0.0
//                    self.trendingNowColl.alpha = 0.0
//                    
//                    if let layout = self.allTimePopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
//                        layout.scrollDirection = .vertical
//                    }
//                    
//                } else if superview == self.currentSeasonPopularHeader {
//                    self.currentSeasonPopularColl.setContentOffset(.zero, animated: true)
//                    self.allTimePopularHeader.alpha = 0.0
//                    self.allTimePopularColl.alpha = 0.0
//                    self.trendingNowHeader.alpha = 0.0
//                    self.trendingNowColl.alpha = 0.0
//                    
//                    if let layout = self.currentSeasonPopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
//                        layout.scrollDirection = .vertical
//                    }
//                    
//                    
//                } else if superview == self.trendingNowHeader {
//                    self.trendingNowColl.setContentOffset(.zero, animated: true)
//                    self.allTimePopularHeader.alpha = 0.0
//                    self.allTimePopularColl.alpha = 0.0
//                    self.currentSeasonPopularHeader.alpha = 0.0
//                    self.currentSeasonPopularColl.alpha = 0.0
//                    
//                    if let layout = self.trendingNowColl.collectionViewLayout as? UICollectionViewFlowLayout {
//                        layout.scrollDirection = .vertical
//                    }
//                }
            } else {
//                self.setupUIAfterMoreButtonTapped(view: superview, backToNormal: true)
                self.setupActiveCollViewConstraints()
                
                self.view.layoutIfNeeded()
            }
        } completion: { finish in
            UIView.animate(withDuration: 0.4) {
                if self.extendedCollection != headersCollectionView {
//                    self.setupUIAfterMoreButtonTapped(view: superview, backToNormal: false)
                    
                    
                    
                    
                    
                    self.makeCollectionViewFullScreen(headersCollectionView)
                    self.view.layoutIfNeeded()
//                    self.choosedHeader = superview
                    self.extendedCollection = headersCollectionView
                } else {
                    
                    sender.transform = CGAffineTransform(rotationAngle: .pi)
                    
                    switch headersCollectionView {
                    case .trendingNow:
//                        self.trendingNowColl.setContentOffset(.zero, animated: true)
                        self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: true)
                        if let layout = self.trendingNowColl.collectionViewLayout as? UICollectionViewFlowLayout {
                            layout.scrollDirection = .horizontal
                        }
                    case .popularThisSeason:
//                        self.currentSeasonPopularColl.setContentOffset(.zero, animated: true)
                        self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: true)
                        if let layout = self.currentSeasonPopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
                            layout.scrollDirection = .horizontal
                        }
                    case .allTimePopular:
//                        self.allTimePopularColl.setContentOffset(.zero, animated: true)
                        self.makeOtherCollectionTransparent(except: headersCollectionView, unhide: true)
                        if let layout = self.allTimePopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
                            layout.scrollDirection = .horizontal
                        }
                    case .none:
                        return
                    }
                    
                    
//                    if superview == self.allTimePopularHeader {
//                        self.currentSeasonPopularHeader.alpha = 1
//                        self.currentSeasonPopularColl.alpha = 1
//                        self.trendingNowHeader.alpha = 1
//                        self.trendingNowColl.alpha = 1
//                        
//                        if let layout = self.allTimePopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
//                            layout.scrollDirection = .horizontal
//                        }
//                        
//                    } else if superview == self.currentSeasonPopularHeader {
//                        self.allTimePopularHeader.alpha = 1
//                        self.allTimePopularColl.alpha = 1
//                        self.trendingNowHeader.alpha = 1
//                        self.trendingNowColl.alpha = 1
//                        
//                        if let layout = self.currentSeasonPopularColl.collectionViewLayout as? UICollectionViewFlowLayout {
//                            layout.scrollDirection = .horizontal
//                        }
//                    } else if superview == self.trendingNowHeader {
//                        self.allTimePopularHeader.alpha = 1
//                        self.allTimePopularColl.alpha = 1
//                        self.currentSeasonPopularHeader.alpha = 1
//                        self.currentSeasonPopularColl.alpha = 1
//                        
//                        if let layout = self.trendingNowColl.collectionViewLayout as? UICollectionViewFlowLayout {
//                            layout.scrollDirection = .horizontal
//                        }
//                    }
                    self.extendedCollection = nil
                }
            }
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
        self.xChoosedTool = coordinats!.x
        self.shouldDetectScrollStart = true
        
        
        if isChoosedOpened {
            UIView.animate(withDuration: 0.3) {
                self.choosedToolCollectionView.frame.origin.y = self.choosedToolCollectionView.frame.origin.y - 10
                self.choosedToolCollectionView.alpha = 0.0
            } completion: { _ in
                self.isChoosedOpened = false
                
                if toolType != self.choosedTool {
                    self.toolTapped(toolType, sender: sender)
                }
                self.choosedToolCollectionView.reloadData()
                print("Make request")
            }
        } else {
            
            self.choosedTool = toolType
            self.isChoosedOpened = true
            self.contentView.addSubview(choosedToolCollectionView)
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
            choosedToolCollectionView.setNeedsLayout()
            choosedToolCollectionView.setNeedsDisplay()
        }
    }
    
    func removeButtonTapped(_ toolType: SearchTool) {
        switch toolType {
        case .genre:
            self.choosedGenres = []
        case .year:
            self.choosedYear = nil
        case .season:
            self.choosedSeason = nil
        case .format:
            self.choosedFormats = []
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




extension MenuController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == self.trendingNowColl {
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                print("Scrolled to the end")
                
                guard let currentPage = self.trendingNowAnimes?.pageInfo?.currentPage, let hasNextPage = self.trendingNowAnimes?.pageInfo?.hasNextPage else { return }
                
                
                if hasNextPage {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.apiClient.getAnimeBy(
                            page: GraphQLNullable<Int>(integerLiteral: currentPage + 1),
                            perPage: 20,
                            sort: [.case(.trendingDesc)],
                            type: .some(.case(.anime)),
                            season: nil,
                            seasonYear: nil,
                            formats: nil,
                            genres: nil,
                            search: nil) { result in
                                self.trendingNowAnimes?.animes.append(contentsOf: result.data?.page?.media?.compactMap({ $0 }) ?? [])
                                guard let newPageInfo = result.data?.page?.pageInfo else { return }
                                self.trendingNowAnimes?.pageInfo? = newPageInfo
                                self.trendingNowColl.reloadSections(IndexSet(integer: 0))
                            }
                    }
                }
            }
        } else if collectionView == self.currentSeasonPopularColl {
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                print("Scrolled to the end")
                
                guard let currentPage = self.currentSeasonPopularAnimes?.pageInfo?.currentPage, let hasNextPage = self.currentSeasonPopularAnimes?.pageInfo?.hasNextPage else { return }
                
                if hasNextPage {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.apiClient.getAnimeBy(
                            page: GraphQLNullable<Int>(integerLiteral: currentPage + 1),
                            perPage: 20,
                            sort: [.case(.favouritesDesc)],
                            type: .some(.case(.anime)),
                            season: .some(.case(.fall)),
                            seasonYear: 2023,
                            formats: nil,
                            genres: nil,
                            search: nil) { result in
                                self.currentSeasonPopularAnimes?.animes.append(contentsOf: result.data?.page?.media?.compactMap({ $0 }) ?? [])
                                guard let newPageInfo = result.data?.page?.pageInfo else { return }
                                self.currentSeasonPopularAnimes?.pageInfo? = newPageInfo
                                self.currentSeasonPopularColl.reloadSections(IndexSet(integer: 0))
                            }
                    }
                    
                }
                
            }
        } else if collectionView == self.allTimePopularColl {
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                print("Scrolled to the end")
                
                guard let currentPage = self.allTimePopularAnimes?.pageInfo?.currentPage, let hasNextPage = self.allTimePopularAnimes?.pageInfo?.hasNextPage else { return }
                
                if hasNextPage {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.apiClient.getAnimeBy(
                            page: GraphQLNullable<Int>(integerLiteral: currentPage + 1),
                            perPage: 20,
                            sort: [.case(.popularityDesc)],
                            type: .some(.case(.anime)),
                            season: nil,
                            seasonYear: nil,
                            formats: nil,
                            genres: nil,
                            search: nil) { result in
                                self.allTimePopularAnimes?.animes.append(contentsOf: result.data?.page?.media?.compactMap({ $0 }) ?? [])
                                guard let newPageInfo = result.data?.page?.pageInfo else { return }
                                self.allTimePopularAnimes?.pageInfo? = newPageInfo
                                self.allTimePopularColl.reloadSections(IndexSet(integer: 0))
                            }
                    }
                    
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
//                return self.allTimePopularAnimes.count
//                return self.allTimePopularAnimes?.page?.media?.count ?? 0
                return self.allTimePopularAnimes?.animes.count ?? 0
                
            } else if collectionView == self.currentSeasonPopularColl {
//                return self.currentSeasonPopularAnimes.count
//                return self.currentSeasonPopularAnimes?.page?.media?.count ?? 0
                return self.currentSeasonPopularAnimes?.animes.count ?? 0
            } else {
//                return self.trendingNowAnimes.count
//                return self.trendingNowAnimes?.page?.media?.count ?? 0
                return self.trendingNowAnimes?.animes.count ?? 0
//                return 20
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
                
//                    let preview = self.allTimePopularAnimes[indexPath.row]
//                let preview = self.allTimePopularAnimes?.page?.media![indexPath.row]
                let preview = self.allTimePopularAnimes?.animes[indexPath.row]
                    cell.configure(with: preview!)
                    cell.delegate = self
                    return cell
                
            } else if collectionView == self.currentSeasonPopularColl {
                guard let cell = currentSeasonPopularColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuAnimePreviewCell else {
                    fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
                }
                
//                let preview = self.currentSeasonPopularAnimes[indexPath.row]
//                let preview = self.currentSeasonPopularAnimes?.page?.media![indexPath.row]
                let preview = self.currentSeasonPopularAnimes?.animes[indexPath.row]
                cell.configure(with: preview!)
                cell.delegate = self
                return cell
            } else {
                guard let cell = trendingNowColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuAnimePreviewCell else {
                    fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
                }
                
//                let preview = self.trendingNowAnimes[indexPath.row]
//                let preview = self.trendingNowAnimes?.page?.media![indexPath.row]
                let preview = self.trendingNowAnimes?.animes[indexPath.row]
                cell.configure(with: preview!)
                cell.delegate = self
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

extension MenuController {
    func fetchData() {
        self.apiClient.getAnimeBy(
            page: 1,
            perPage: 20,
            sort: [.case(.favouritesDesc)],
            type: .some(.case(.anime)),
            season: self.choosedSeason?.convertToGrapQL() ?? .none,
            seasonYear: self.choosedYear?.convertToGraphQL() ?? .none,
            formats: self.choosedFormats.isEmpty ? nil : GraphQLNullable.some(self.choosedFormats.convertToGraphQL()),
            genres: self.choosedGenres.isEmpty ? nil :
                    .some(self.choosedGenres.getRawValues()),
            search: self.searchStringAnime == nil ? nil :
                    .some(self.searchStringAnime!)) { result in
                        self.trendingNowAnimes?.animes = result.data?.page?.media?.compactMap({ $0 }) ?? []
                        self.trendingNowColl.reloadData()
                    }
    }
}


extension MenuController {
    enum CollectionType {
        case trendingNow
        case popularThisSeason
        case allTimePopular
        case none
    }
}
