//
//  LoadingAnimePreviewCellCollectionViewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/01/2024.
//

import UIKit

class LoadingAnimePreviewCell: UICollectionViewCell {
    
    
    //MARK: - UI Components
    private var imageRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "DarkBlack")
        return view
    }()
    
    private let firstLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "DarkBlack")
        return view
    }()
    
    private let secondLine: UIView = {
        let view = UIView()
        return view
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup
    private func setup() {
        self.addSubview(imageRectangle)
        imageRectangle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(firstLine)
        firstLine.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(secondLine)
        secondLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageRectangle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            self.imageRectangle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85),
            self.imageRectangle.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.firstLine.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.firstLine.topAnchor.constraint(equalTo: self.imageRectangle.bottomAnchor, constant: 10),
        ])
    }
}
