//
//  CustomSeatchToolsView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/12/2023.
//

import UIKit
import AnilistApi

protocol SearchToolButtonProtocol {
    func toolTapped(_ toolType: SearchTool, sender: UIButton)
    
    func removeButtonTapped(_ toolType: SearchTool)
}

class CustomSearchToolView: UIView {
    
    //MARK: - Variables
    private  var toolType: SearchTool!
    
    public var delegate: SearchToolButtonProtocol?
    
    //MARK: UI Components
    public let title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Genres"
        label.font = UIFont().JosefinSans(font: .regular, size: 17)
        return label
    }()
    
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Arrow")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleToFill
        iv.tintColor = UIColor(named: "Gray")
        iv.transform = iv.transform.rotated(by: .pi / 2)
        return iv
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Any", for: .normal)
        button.setTitleColor(UIColor(named: "Gray"), for: .normal)
        button.titleLabel?.font = UIFont().JosefinSans(font: .regular, size: 14)
        button.backgroundColor = UIColor(named: "DarkBlack")
        button.layer.cornerRadius = 12
        return button
    }()
    
    private var choosedFirstOption: UILabel = {
      let label = UILabel()
        label.font = UIFont().JosefinSans(font: .regular, size: 10)
        label.layer.masksToBounds = true
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: "Orange")
        label.layer.cornerRadius = 6
        return label
    }()
    
    private var choosedMoreOptions: UILabel = {
      let label = UILabel()
        label.font = UIFont().JosefinSans(font: .regular, size: 10)
        label.layer.masksToBounds = true
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: "Orange")
        label.layer.cornerRadius = 6
        return label
    }()
    
    private var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Cross")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.imageView?.tintColor = UIColor(named: "Gray")
        button.backgroundColor = UIColor(named: "DarkBlack")
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    
    
    //MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "Black")
        self.moreButton.addTarget(self, action: #selector(toolTapped), for: .touchUpInside)
        self.removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SetupUI
    private func setupUI() {
        
        self.addSubview(title)
        self.addSubview(moreButton)
        self.moreButton.addSubview(image)
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.title.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.title.heightAnchor.constraint(equalToConstant: 35),
            self.title.topAnchor.constraint(equalTo: self.topAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            self.moreButton.topAnchor.constraint(equalTo: title.bottomAnchor),
            self.moreButton.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.moreButton.heightAnchor.constraint(equalToConstant: 40),
            self.moreButton.titleLabel!.leadingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: 15),
            
            self.image.trailingAnchor.constraint(equalTo: moreButton.trailingAnchor, constant: -15),
            self.image.heightAnchor.constraint(equalToConstant: 15),
            self.image.widthAnchor.constraint(equalToConstant: 15),
            self.image.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor),
        ])
        
    }
    
    private func setupFirstOption(text: String) {
        
        let textWidth = text.size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 10)!]).width + 10
//        print(textWidth)
        
        self.choosedFirstOption.translatesAutoresizingMaskIntoConstraints = false
        self.moreButton.addSubview(choosedFirstOption)
        
        //MARK: - Option, maybe should remove it
        choosedFirstOption.removeConstraints(choosedFirstOption.constraints)
        
        NSLayoutConstraint.activate([
            choosedFirstOption.leadingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: 10),
            choosedFirstOption.topAnchor.constraint(equalTo: moreButton.topAnchor, constant: 10),
            choosedFirstOption.widthAnchor.constraint(equalToConstant: textWidth),
            choosedFirstOption.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor),
        ])
        
    }
    
    private func setupChoosedMoreOptions(text: String) {
        
        let textWidth = text.size(withAttributes: [NSAttributedString.Key.font: UIFont().JosefinSans(font: .regular, size: 10)!]).width + 10
        
        self.choosedMoreOptions.translatesAutoresizingMaskIntoConstraints = false
        self.moreButton.addSubview(choosedMoreOptions)
        
        choosedMoreOptions.removeConstraints(choosedMoreOptions.constraints)
        
        NSLayoutConstraint.activate([
            choosedMoreOptions.leadingAnchor.constraint(equalTo: choosedFirstOption.trailingAnchor, constant: 7),
            choosedMoreOptions.topAnchor.constraint(equalTo: moreButton.topAnchor, constant: 10),
            choosedMoreOptions.widthAnchor.constraint(equalToConstant: textWidth),
            choosedMoreOptions.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor),
        ])
    }
    
    private func setupRemoveButton() {
        self.moreButton.addSubview(removeButton)
        self.removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.removeButton.trailingAnchor.constraint(equalTo: moreButton.trailingAnchor, constant: -15),
            self.removeButton.heightAnchor.constraint(equalToConstant: 15),
            self.removeButton.widthAnchor.constraint(equalToConstant: 15),
            self.removeButton.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor),
        ])
    }
    
    //MARK: - Func
    @objc private func toolTapped() {
        self.delegate?.toolTapped(toolType, sender: moreButton)
    }
    
    @objc private func removeButtonTapped() {
        self.delegate?.removeButtonTapped(self.toolType)
//        self.choosedFirstOption.removeConstraints(choosedFirstOption.constraints)
//        self.choosedMoreOptions.removeConstraints(choosedMoreOptions.constraints)
//        self.removeButton.removeConstraints(removeButton.constraints)
        
        self.choosedFirstOption.removeFromSuperview()
        self.choosedMoreOptions.removeFromSuperview()
        self.removeButton.removeFromSuperview()
        print("DEBUG:", "removeButtonTapped")
    }
    
    public func removeOption(text: String, toolType: SearchTool, option: Any) {
        switch toolType {
        case .genre:
            let genresArray = option as! [Genre]
            
            if genresArray.isEmpty {
                self.choosedFirstOption.removeFromSuperview()
                self.removeButton.removeFromSuperview()
            } else if genresArray.count == 1 {
                self.choosedFirstOption.text = genresArray.first!.rawValue
                setupFirstOption(text: genresArray.first!.rawValue)
                self.choosedMoreOptions.removeFromSuperview()
            }
            else if genresArray.count > 1 {
                self.choosedFirstOption.text = genresArray.first!.rawValue
                setupFirstOption(text: genresArray.first!.rawValue)
                self.choosedMoreOptions.text = String("\(genresArray.count - 1)+")
                setupChoosedMoreOptions(text: self.choosedMoreOptions.text!)
            }//
        case .year:
            return
        case .season:
            return
        case .format:
            return
        }
    }
    
    public func addOption(text: String, toolType: SearchTool, option: Any) {
        
        switch toolType {
        case .genre:
            let genresArray = option as! [Genre]
            if genresArray.isEmpty {
            } else if genresArray.count == 1  {
                self.choosedFirstOption.text = genresArray.first!.rawValue
                setupFirstOption(text: text)
                setupRemoveButton()
            } else if genresArray.count > 1 {
                self.choosedMoreOptions.text = String("\(genresArray.count - 1)+")
                setupChoosedMoreOptions(text: self.choosedMoreOptions.text!)
                
            }
        case .year:
            let year = option as! Int
            self.choosedFirstOption.text = String(year)
            setupFirstOption(text: choosedFirstOption.text!)
            setupRemoveButton()
        case .season:
            let season = option as! MediaSeason
            self.choosedFirstOption.text = season.rawValue
            setupFirstOption(text: choosedFirstOption.text!)
            setupRemoveButton()
        case .format:
            let formatArray = option as! [MediaFormat]
            if formatArray.isEmpty {
                
            } else if formatArray.count > 1 {
                self.choosedFirstOption.text = formatArray.first!.rawValue
                setupFirstOption(text: choosedFirstOption.text!)
                setupRemoveButton()
            } else if formatArray.count > 1 {
                self.choosedMoreOptions.text = String("\(formatArray.count - 1)+")
                setupChoosedMoreOptions(text: self.choosedMoreOptions.text!)
            }
        
        }
    }
    
    public func getViewByTool(_ toolType: SearchTool) -> CustomSearchToolView? {
        if self.toolType == toolType {
            print(toolType.rawValue)
            return self
        } else {
            return nil
        }
    }
    
    public func configure(with tool: SearchTool) {
        self.title.text = tool.rawValue
        self.toolType = tool
    }
}
