//
//  MessageView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 21/01/2024.
//

import UIKit

class MessageView: UIView {

    //MARK: - UI components
    let message: UILabel = {
      let label = UILabel()
        label.font = UIFont().JosefinSans(font: .medium, size: 15)
        label.text = "Loaded more Animes"
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: "Orange")
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        return label
    }()
    
    //MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -  Setup UI
    private func setup() {
        
        self.addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.message.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            self.message.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.message.topAnchor.constraint(equalTo: self.topAnchor),
            self.message.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    public func setupMessage(_ message: String) {
        self.message.text = message
    }
}
