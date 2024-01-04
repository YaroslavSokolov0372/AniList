//
//  MenuController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/12/2023.
//

import UIKit
import AnilistApi

class MenuController: UIViewController, AnimePreviewProtocol, SearchToolButton {
    
    //MARK: - Variables
    private let apiClient = ApiClient()
    
    private var allTimePopularAnimes: [GetAnimeByQuery.Data.Page.Medium] = [] {
        didSet {
            DispatchQueue.main.async {
                self.allTimePopularColl.reloadData()
                self.allTimePopularColl.setNeedsDisplay()
                print("All Time Puppular dispatch worked")
            }
        }
    }
    
    private var currentSeasonPopularAnimes: [GetAnimeByQuery.Data.Page.Medium] = [] {
        didSet {
            DispatchQueue.main.async {
                self.currentSeasonPopularColl.reloadData()
                self.currentSeasonPopularColl.setNeedsDisplay()
                print("Current season dispatch worked")
            }
        }
    }
    
    private var trendingNowAnimes: [GetAnimeByQuery.Data.Page.Medium] = [] {
        didSet {
            DispatchQueue.main.async {
                self.trendingNowColl.reloadData()
                self.trendingNowColl.setNeedsDisplay()
                print("Trending now dispatch worked")
            }
        }
    }
    
    private var isChoosedOpened: Bool = false
    
    private var choosedTool: SearchTools?
    
    //MARK: - UI Components
    private let mainScrollView: UIScrollView = {
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
    
    private let searchToolsScrollView = SearchToolsScrollView()
    
    private let choosedToolTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.register(ToolsOptionsCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private let choiceOfTwoButton = CustomMenuButtonSections(
        title: "Choice of Two",
        hasCustomTint: false,
        customTint: nil,
        systemTintColor: .white)
    
    private let menuButton: UIButton = {
        
        
        let button = UIButton()
        button.setImage(UIImage(named: "Menu")!.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
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
        
        Task {
            self.apiClient.getAnimeBy(
                page: 1,
                perPage: 20,
                sort: [.case(.favouritesDesc)],
                type: .some(.case(.anime)),
                season: .some(.case(.fall)),
                seasonYear: 2023,
                format: nil,
                genre: nil,
                search: nil) { result in
                    self.currentSeasonPopularAnimes = result.data?.page?.media?.compactMap({ $0 }) ?? []
                    print(self.currentSeasonPopularAnimes.count)
                }
            
            self.apiClient.getAnimeBy(
                page: 1,
                perPage: 20,
                sort: [.case(.popularityDesc)],
                type: .some(.case(.anime)),
                season: nil,
                seasonYear: nil,
                format: nil,
                genre: nil,
                search: nil) { result in
                    self.allTimePopularAnimes = result.data?.page?.media?.compactMap({ $0 }) ?? []
                    print(self.allTimePopularAnimes.count)
                }
            
            self.apiClient.getAnimeBy(
                page: 1,
                perPage: 20,
                sort: [.case(.trendingDesc)],
                type: .some(.case(.anime)),
                season: nil,
                seasonYear: nil,
                format: nil,
                genre: nil,
                search: nil) { result in
                    self.trendingNowAnimes = result.data?.page?.media?.compactMap({ $0 }) ?? []
                    print(self.trendingNowAnimes.count)
                }
        }
        
        self.allTimePopularHeader.addDidTappedMoreButtonTarget(self, action: #selector(didTappedMoreButton))
        self.currentSeasonPopularHeader.addDidTappedMoreButtonTarget(self, action: #selector(didTappedMoreButton))
        self.trendingNowHeader.addDidTappedMoreButtonTarget(self, action: #selector(didTappedMoreButton))
        //        self.searchToolsScrollView.addDidTappedSortTargets(self, selector: #selector(didTappedSortButton))
        
        self.currentSeasonPopularColl.delegate = self
        self.currentSeasonPopularColl.dataSource = self
        self.allTimePopularColl.delegate = self
        self.allTimePopularColl.dataSource = self
        self.trendingNowColl.delegate = self
        self.trendingNowColl.dataSource = self
        self.choosedToolTableView.delegate = self
        self.choosedToolTableView.dataSource = self
        
        searchToolsScrollView.configureDelegate(self)
        
        self.setupUI()
        
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(mainScrollView)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainScrollView.addSubview(contentView)
        searchToolsScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(searchToolsScrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(choiceOfTwoButton)
        choiceOfTwoButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
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
            
            self.choiceOfTwoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.choiceOfTwoButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            self.choiceOfTwoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 2000),
            
            searchToolsScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchToolsScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchToolsScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchToolsScrollView.widthAnchor.constraint(equalToConstant: 800),
            searchToolsScrollView.heightAnchor.constraint(equalToConstant: 80),
            
            allTimePopularHeader.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
            allTimePopularHeader.heightAnchor.constraint(equalToConstant: 20),
            allTimePopularHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            allTimePopularHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            allTimePopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            allTimePopularColl.topAnchor.constraint(equalTo: self.allTimePopularHeader.bottomAnchor, constant: 15),
            allTimePopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
            
            currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.allTimePopularColl.bottomAnchor, constant: 30),
            currentSeasonPopularHeader.heightAnchor.constraint(equalToConstant: 20),
            currentSeasonPopularHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            currentSeasonPopularHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            
            currentSeasonPopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            currentSeasonPopularColl.topAnchor.constraint(equalTo: self.currentSeasonPopularHeader.bottomAnchor, constant: 15),
            currentSeasonPopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
            trendingNowHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
            trendingNowHeader.heightAnchor.constraint(equalToConstant: 20),
            trendingNowHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            trendingNowHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trendingNowColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            trendingNowColl.topAnchor.constraint(equalTo: self.trendingNowHeader.bottomAnchor, constant: 15),
            trendingNowColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
        ])
    }
    
    
    //MARK: - Local func
    func didTapCell(with type: GetAnimeByQuery.Data.Page.Medium) {
        print("DEBUG:", "Tapped Anime Cell")
        let vc = DetailInfoController()
        vc.configure(with: type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTappedMoreButton() {
        print("DEBUG:", "Tapped more anime button")
        let vc = MoreAnimeController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getToolType(_ toolType: SearchTools, sender: UIButton) {
        
        let coordinats = sender.superview?.convert(sender.frame.origin, to: nil)
        
        if isChoosedOpened {
            
            UIView.animate(withDuration: 0.3) {
                self.choosedToolTableView.frame = CGRect(
                    x: coordinats!.x,
                    y: coordinats!.y,
                    width: CGFloat(self.choosedToolTableView.numberOfSections * 150),
                    height: CGFloat(self.choosedToolTableView.numberOfSections * 75))
                
                self.choosedToolTableView.alpha = 0.0
            }
            
            self.isChoosedOpened = false
            
        } else {
            
            self.choosedTool = toolType
            self.isChoosedOpened = true
            
            self.view.addSubview(choosedToolTableView)
            self.choosedToolTableView.alpha = 0.0
            
            choosedToolTableView.frame = CGRect(
                x: coordinats!.x,
                y: coordinats!.y,
                width: CGFloat(choosedToolTableView.numberOfSections * 150),
                height: CGFloat(choosedToolTableView.numberOfSections * 75))
            
            UIView.animate(withDuration: 0.3) {
                self.choosedToolTableView.frame = CGRect(
                    x: self.choosedToolTableView.frame.minX,
                    y: 150,
                    width: self.choosedToolTableView.frame.width,
                    height: self.choosedToolTableView.frame.height)
                
                self.choosedToolTableView.alpha = 1.0
                print(toolType.rawValue)
            }
        }
    }
    
    @objc private func didTappedSortButton(_ sender: UIButton) {
        //        print(sender.frame)
        
        
        
        let coordinats = sender.superview?.convert(sender.frame.origin, to: nil)
        
        //        print("Sender type - \(sender.toolType)")
        //        switch sender.type {
        //        case .genre:
        //            self.choosedTool = .genre
        //        case .year:
        //            self.choosedTool = .year
        //        case .season:
        //            self.choosedTool = .season
        //        case .format:
        //            self.choosedTool = .format
        //        case .none:
        //            return
        //        }
        
        guard let tool = sender.title(for: .normal) else {
            print("DEBUG:", "ChoosedToolOption is nil")
            return
        }
        print(tool)
        //        self.choosedTool = sender.type
        //        choosedToolTableView.frame = CGRect(
        //            x: coordinats!.x,
        //            y: coordinats!.x,
        //            width: CGFloat(choosedToolTableView.numberOfSections * 100),
        //            height: CGFloat(choosedToolTableView.numberOfSections * 100))
        //        self.view.addSubview(choosedToolTableView)
        //        print(sender.superview?.convert(sender.frame.origin, to: nil))
        //        let tab = AdditionalSearchToolsCell(frame:
        //                                                CGRect(
        //                                                    x: coordinats!.x,
        //                                                    y: coordinats!.y + 40,
        //                                                    width: 160,
        //                                                    height: 40))
        //
        //        self.view.addSubview(tab)
        //        let label: UILabel = {
        //            let label = UILabel()
        //            label.frame = CGRect(x: coordinats!.x, y: coordinats!.y, width: 10, height: 10)
        //            label.text = "H"
        //            label.font = UIFont().JosefinSans(font: .medium, size: 15)
        //            label.textColor = .white
        //
        //            return label
        //        }()
        //        self.view.addSubview(label)
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
        
        if collectionView == self.allTimePopularColl {
            return self.allTimePopularAnimes.count
        } else if collectionView == self.currentSeasonPopularColl {
            return self.currentSeasonPopularAnimes.count
        } else {
            return self.trendingNowAnimes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.allTimePopularColl {
            guard let cell = allTimePopularColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuAnimePreviewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            let preview = self.allTimePopularAnimes[indexPath.row]
            cell.configure(with: preview)
            cell.delegate = self
            return cell
            
        } else if collectionView == self.currentSeasonPopularColl {
            guard let cell = currentSeasonPopularColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuAnimePreviewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            let preview = self.currentSeasonPopularAnimes[indexPath.row]
            cell.configure(with: preview)
            cell.delegate = self
            return cell
        } else {
            guard let cell = allTimePopularColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MenuAnimePreviewCell else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            let preview = self.trendingNowAnimes[indexPath.row]
            cell.configure(with: preview)
            cell.delegate = self
            return cell
        }
        
        
    }
}


extension MenuController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch choosedTool {
        case .format:
            return GraphQLEnum<MediaFormat>.allCases.count
        case .season:
            return GraphQLEnum<MediaSeason>.allCases.count
        case .genre:
            return 13
        case .year:
            return 24
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ToolsOptionsCell else {
            fatalError("Unenable to dequeue AdditionalSearchToolsCell in MenuController")
        }
        cell.configure()
        
        return cell
    }
}


