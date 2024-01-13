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
    private var choosedHeader: SectionHeader?
    
    private var choosedGenres: [Genre] = []
    
    private var choosedYear: Int?
    
    private var choosedSeason: MediaSeason?
    
    private var choosedFormats: [MediaFormat] = []
    
    private var searchStringAnime: String?
    
    private var isChoosedOpened: Bool = false
    
    private var choosedTool: SearchTool?
    
    private var scrollViewX: CGFloat = .zero
    
    private var xChoosedTool: CGFloat = .zero
    
    private var shouldDetectScrollStart = false
    
    private var isFetching = false
    
    private let apiClient = ApiClient()
    
    private var activeViewConstraints: [NSLayoutConstraint] = [] {
      willSet {
        NSLayoutConstraint.deactivate(activeViewConstraints)
      }
      didSet {
        NSLayoutConstraint.activate(activeViewConstraints)
      }
    }
    
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
        
        self.searchToolsScrollView.configureDelegate(self)
        
        self.setupUI()
        
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
        }
    }
    
    //MARK: - Setup UI
    private func configureDefaultContentSize() -> CGFloat {
        let searchScrollView: CGFloat = 80
        let headers: CGFloat = 20 * 3
        let colls: CGFloat = (self.view.frame.height * 0.38) * 3
        
        return searchScrollView + headers + colls
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
            
            
            
//            currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            
//            allTimePopularHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
            
            allTimePopularHeader.heightAnchor.constraint(equalToConstant: 20),
            allTimePopularHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            allTimePopularHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            allTimePopularColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            allTimePopularColl.topAnchor.constraint(equalTo: self.allTimePopularHeader.bottomAnchor, constant: 15),
            allTimePopularColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
//            allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            

            
        ])
        
        self.activeViewConstraints = [
            allTimePopularHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
            currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.trendingNowColl.bottomAnchor, constant: 30),
            
            contentView.heightAnchor.constraint(equalToConstant: configureDefaultContentSize()),
            
            
            currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
            trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
        ]
    }
    
    private func setupUIAfterMoreButton(view: UIView, backToNormal: Bool) {
        
        if backToNormal {
            if view == self.allTimePopularHeader {
                self.activeViewConstraints = [
                    allTimePopularHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
                    currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.trendingNowColl.bottomAnchor, constant: 30),
                    
                    currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
                    allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
                    trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
                    contentView.heightAnchor.constraint(equalToConstant: configureDefaultContentSize())
                ]
                
            } else if view == self.currentSeasonPopularHeader {
                self.activeViewConstraints = [
                    allTimePopularHeader.topAnchor.constraint(equalTo: self.currentSeasonPopularColl.bottomAnchor, constant: 30),
                    currentSeasonPopularHeader.topAnchor.constraint(equalTo: self.trendingNowColl.bottomAnchor, constant: 30),
                    
                    currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
                    allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
                    trendingNowColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33),
                    
                    contentView.heightAnchor.constraint(equalToConstant: configureDefaultContentSize())

                ]
            }
        } else {
            if view == self.allTimePopularHeader {
                self.activeViewConstraints = [
                    view.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
                    allTimePopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 3.5),
                    contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 3.5),
                ]
            } else if view == self.currentSeasonPopularHeader {
                self.activeViewConstraints = [
                    view.topAnchor.constraint(equalTo: searchToolsScrollView.bottomAnchor, constant: 20),
                    currentSeasonPopularColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 3.5),
                    contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 3.5),
                ]
            }
        }
    }
    
    
    //MARK: - Func
    func moreButtonTapped(_ sender: UIButton) {
        print("DEBUG:", "Tapped more anime button")
        self.isFetching = true
        
        let superview = sender.superview as! SectionHeader
        
        UIView.animate(withDuration: 0.4) {
            if superview != self.choosedHeader {
                sender.transform = CGAffineTransform(rotationAngle: .pi/4)
                
                if superview == self.allTimePopularHeader {
                    self.currentSeasonPopularHeader.alpha = 0.0
                    self.currentSeasonPopularColl.alpha = 0.0
                    self.trendingNowHeader.alpha = 0.0
                    self.trendingNowColl.alpha = 0.0
                } else if superview == self.currentSeasonPopularHeader {
                    self.allTimePopularHeader.alpha = 0.0
                    self.allTimePopularColl.alpha = 0.0
                    self.trendingNowHeader.alpha = 0.0
                    self.trendingNowColl.alpha = 0.0
                } else if superview == self.trendingNowHeader {
                    self.allTimePopularHeader.alpha = 0.0
                    self.allTimePopularColl.alpha = 0.0
                    self.currentSeasonPopularHeader.alpha = 0.0
                    self.currentSeasonPopularColl.alpha = 0.0
                }
            } else {
                self.setupUIAfterMoreButton(view: superview, backToNormal: true)
                self.view.layoutIfNeeded()
            }
        } completion: { finish in
            UIView.animate(withDuration: 0.4) {
                if self.choosedHeader != superview {
                    self.setupUIAfterMoreButton(view: superview, backToNormal: false)
                    self.view.layoutIfNeeded()
                    self.choosedHeader = superview
                } else {
                    sender.transform = CGAffineTransform(rotationAngle: .pi)
                    if superview == self.allTimePopularHeader {
                        self.currentSeasonPopularHeader.alpha = 1
                        self.currentSeasonPopularColl.alpha = 1
                        self.trendingNowHeader.alpha = 1
                        self.trendingNowColl.alpha = 1
                    } else if superview == self.currentSeasonPopularHeader {
                        self.allTimePopularHeader.alpha = 1
                        self.allTimePopularColl.alpha = 1
                        self.trendingNowHeader.alpha = 1
                        self.trendingNowColl.alpha = 1
                    } else if superview == self.trendingNowHeader {
                        self.allTimePopularHeader.alpha = 1
                        self.allTimePopularColl.alpha = 1
                        self.currentSeasonPopularHeader.alpha = 1
                        self.currentSeasonPopularColl.alpha = 1
                    }
                    self.choosedHeader = nil
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != choosedToolCollectionView {
            return CGSize(width: collectionView.frame.width * 0.44, height: collectionView.frame.height * 1)
        } else {
            return CGSize(width: 150, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView != choosedToolCollectionView {
            return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
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
                return self.allTimePopularAnimes.count
            } else if collectionView == self.currentSeasonPopularColl {
                return self.currentSeasonPopularAnimes.count
            } else {
                return self.trendingNowAnimes.count
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
//                switch self.apiClient.state {
//                
//                }
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
