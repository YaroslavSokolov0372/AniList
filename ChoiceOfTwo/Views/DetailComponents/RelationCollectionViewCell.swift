//
//  RelationCollectionViewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 28/01/2024.
//

import UIKit
import AnilistApi

class RelationCollectionViewCell: UICollectionViewCell {
    
    
    //MARK: - UIComponents
    private let image: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    
    private let formatOfAnime: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let currentState: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup
    private func setupUI() {
        
    }
    
    
    //MARK: - Func
    public func configure() {
        
    }
}
