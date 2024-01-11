//
//  AdditionalSearchToolsCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 03/01/2024.
//

import UIKit
import AnilistApi

protocol ToolsOptionsProtocol {
    func optionTapped(sender: UIButton, tool: SearchTool, choosedOption: Any)
}



class ToolsOptionsCell: UICollectionViewCell {
    
    //MARK: - Variables
    var delegate: ToolsOptionsProtocol?
    private var tool: SearchTool!
    private var index: Int!
    
    //MARK: - UI Components
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleToFill
        iv.tintColor = UIColor(named: "Gray")
        iv.transform = iv.transform.rotated(by: .pi / 2)
        return iv
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Any", for: .normal)
        button.setTitleColor(UIColor(named: "Gray"), for: .normal)
        button.titleLabel?.font = UIFont().JosefinSans(font: .regular, size: 14)
        button.backgroundColor = UIColor(named: "DarkBlack")
//        button.layer.cornerRadius = 12
        return button
    }()

    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.plusButton.addTarget(self, action: #selector(optionTapped), for: .touchUpInside)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setup() {
        self.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            self.plusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.plusButton.topAnchor.constraint(equalTo: self.bottomAnchor),
            self.plusButton.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.plusButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.plusButton.heightAnchor.constraint(equalToConstant: 40),
            self.plusButton.titleLabel!.leadingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: 15),
            
            self.image.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: -15),
            self.image.heightAnchor.constraint(equalToConstant: 15),
            self.image.widthAnchor.constraint(equalToConstant: 15),
            self.image.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
        ])
        
    }
    
    //MARK: - Func
    public func markAsChoosed() {
        self.plusButton.imageView?.tintColor = .white
        self.plusButton.setTitleColor(.white, for: .normal)
        self.image.image = UIImage(named: "Checkmark")?.withRenderingMode(.alwaysTemplate)
        self.image.transform = transform.rotated(by: 0)
        self.image.tintColor = .white
    }
    
    public func markAsUnchoosed() {
        self.plusButton.imageView?.tintColor = UIColor(named: "Gray")
        self.plusButton.setTitleColor(UIColor(named: "Gray"), for: .normal)
        self.image.image = UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate)
        self.image.tintColor = UIColor(named: "Gray")
        self.image.transform = transform.rotated(by: .pi / 2)
    }
    
    public func getYear() -> Int {
        return (self.plusButton.titleLabel!.text! as NSString).integerValue
    }
    
    @objc private func optionTapped(_ sender: UIButton) {
        switch tool {
        case .genre:
            self.delegate?.optionTapped(sender: sender, tool: tool, choosedOption: Genre.allCases[index])
        case .year:
            self.delegate?.optionTapped(sender: sender, tool: tool, choosedOption: tool.currentYear - index)
        case .season:
            self.delegate?.optionTapped(sender: sender, tool: tool, choosedOption: MediaSeason.allCases[index])
        case .format:
            self.delegate?.optionTapped(sender: sender, tool: tool, choosedOption: MediaFormat.allCases[index])
        case .none:
            return
        }
    }
}

extension ToolsOptionsCell {
    public func configure(choosedTool: SearchTool, index: Int) {
        switch choosedTool {
        case .format:
            let formats = MediaFormat.allCases
            self.index = index
            self.tool = choosedTool
//            self.plusButton.setTitle(formats[index].rawValue, for: .normal)
            self.plusButton.setTitle(formats[index].getName(), for: .normal)
        case .season:
            self.index = index
            self.tool = choosedTool
            let season = MediaSeason.allCases
//            self.plusButton.setTitle(season[index].rawValue, for: .normal)
            self.plusButton.setTitle(season[index].getName(), for: .normal)
        case .genre:
            self.index = index
            self.tool = choosedTool
            self.plusButton.setTitle(Genre.allCases[index].rawValue, for: .normal)
        case .year:
            self.index = index
            self.tool = choosedTool
            self.plusButton.setTitle(String("\(choosedTool.currentYear - index)"), for: .normal)
        }
    }
}
