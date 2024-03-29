//
//  AnimePreviewImage.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/12/2023.
//

import UIKit

class DetailAnimePreviewImage: UIImageView {
    
    //MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    public func setupImage(with url: String) {
        self.setImageFromStringrURL(stringUrl: url)
        self.setNeedsDisplay()
    }
    
    public func setupMask(frame: CGRect) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = frame
        shapeLayer.createImageDetailView()
        self.layer.mask = shapeLayer
        self.setNeedsDisplay()
    }

}

