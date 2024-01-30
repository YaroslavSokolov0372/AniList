//
//  CustomCircleButton.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/12/2023.
//

import UIKit

class CustomSaveButton: UIButton {
    
    //MARK: - Properties
    private var isSaved: Bool?
    //    private var isBooked: Bool?
    
    //MARK: - Lifecycle
    init(hasBackground: Bool, image: UIImage, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.setImage(
            image.resized(to: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.imageView?.contentMode = .scaleAspectFill
        self.imageView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.backgroundColor = backgroundColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    public func addDidTappedCircleButtonTarget(_ target: Any?, action: Selector) {
        configureButton()
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    public func animateView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5) {
            
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        } completion: { _ in
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn) {
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    public func saved() {
        if isSaved! {
            isSaved = false
        } else {
            isSaved = true
        }
    }
    
    public func checkSaved() -> Bool {
        if let saved = isSaved {
            if saved {
                return true
            } else {
                return false
            }
        } else {
            print("DEBUG:", "isBooked propertie is nil")
            return false
        }
    }
    
    private func configureButton() {
        if isSaved == nil {
            isSaved = true
        }
    }
}
    
