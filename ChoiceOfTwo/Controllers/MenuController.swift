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
    private var topAnimes: [GetAnimeByQuery.Data.Page.MediaList] = []
    
    //MARK: - UI Components
    private let choiceOfTwoButton = CustomButton(title: "Choice of Two", hasCustomTint: false, customTint: nil, systemTintColor: .white)
    private let bestAnimeHeader = SectionHeader(text: "Most Popular")
    private let topAnimesColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AnimePreviewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collectionView
    }()
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.backgroundColor = UIColor(named: "Blue1")
        
        self.apiClient.getAnimeBy(
            sort: [.case(.mediaPopularity)],
            page: 1, perPage: 20) { result in
                self.topAnimes = result.data?.page?.mediaList?.compactMap({ $0 }) ?? []
                print(self.topAnimes.count)
                self.topAnimesColl.reloadData()
            }
        self.topAnimesColl.delegate = self
        self.topAnimesColl.dataSource = self
        
        self.setupUI()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(choiceOfTwoButton)
//        self.view.addSubview(bestAnimeHeader)
        self.view.addSubview(topAnimesColl)
//        
        self.choiceOfTwoButton.translatesAutoresizingMaskIntoConstraints = false
//        self.bestAnimeHeader.translatesAutoresizingMaskIntoConstraints = false
        self.topAnimesColl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.choiceOfTwoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.choiceOfTwoButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            self.choiceOfTwoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            
//            self.bestAnimeHeader.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
//            self.bestAnimeHeader.widthAnchor.constraint(equalTo: self.view.widthAnchor),
//            self.bestAnimeHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            self.bestAnimeHeader.heightAnchor.constraint(equalToConstant: 50),
            
//            self.topAnimesColl.topAnchor.constraint(equalTo: self.bestAnimeHeader.bottomAnchor),
//            self.topAnimesColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.topAnimesColl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.topAnimesColl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.topAnimesColl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.topAnimesColl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        ])
    }
}



extension MenuController: UICollectionViewDataSource, UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: self.view.bounds.width / 2.5, height: self.view.bounds.height / 2)
////        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.width / 2)
//        return CGSize(width: self.view.bounds.width / 1, height: self.view.bounds.height / 1)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topAnimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = topAnimesColl.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AnimePreviewCell else {
            fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
        }
        let preview = self.topAnimes[indexPath.row]
        cell.configure(with: preview)
        
        return cell
    }
}
