//
//  SearchToolsScrollView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/12/2023.
//

import UIKit

class SearchToolsScrollView: UIView {

    
    //MARK: - Variables
    private let searchToolsViews: [UIView] = {
        var newSearchTools = [UIView]()
        for tool in searchTools.allCases {
            if tool == .search {
                newSearchTools.append(SearchTextFieldView(title: tool.rawValue))
            } else {
                newSearchTools.append(CustomSearchToolsView(title: tool.rawValue))
            }
        }
        return newSearchTools
    }()
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(named: "Black")
//        view.backgroundColor = .blue
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black")
//        view.backgroundColor = .orange
        return view
    }()
    
    //MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        self.setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI
    private func setup() {
        self.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        self.contentView.addSubview(searchToolsViews[0])
        self.contentView.addSubview(searchToolsViews[1])
        self.contentView.addSubview(searchToolsViews[2])
        self.contentView.addSubview(searchToolsViews[3])
        self.contentView.addSubview(searchToolsViews[4])
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        searchToolsViews[0].translatesAutoresizingMaskIntoConstraints = false
        searchToolsViews[1].translatesAutoresizingMaskIntoConstraints = false
        searchToolsViews[2].translatesAutoresizingMaskIntoConstraints = false
        searchToolsViews[3].translatesAutoresizingMaskIntoConstraints = false
        searchToolsViews[4].translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.scrollView.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.scrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            
            self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            self.contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            self.contentView.widthAnchor.constraint(equalToConstant: 877),
            
            self.searchToolsViews[0].topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            self.searchToolsViews[0].widthAnchor.constraint(equalToConstant: 215),
            self.searchToolsViews[0].leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.searchToolsViews[0].heightAnchor.constraint(equalToConstant: 75),
            
            self.searchToolsViews[1].topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            self.searchToolsViews[1].widthAnchor.constraint(equalToConstant: 150),
            self.searchToolsViews[1].leadingAnchor.constraint(equalTo: searchToolsViews[0].trailingAnchor, constant: 10),
            self.searchToolsViews[1].heightAnchor.constraint(equalToConstant: 75),
            
            self.searchToolsViews[2].topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            self.searchToolsViews[2].widthAnchor.constraint(equalToConstant: 150),
            self.searchToolsViews[2].leadingAnchor.constraint(equalTo: searchToolsViews[1].trailingAnchor, constant: 10),
            self.searchToolsViews[2].heightAnchor.constraint(equalToConstant: 75),
            
            self.searchToolsViews[3].topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            self.searchToolsViews[3].widthAnchor.constraint(equalToConstant: 150),
            self.searchToolsViews[3].leadingAnchor.constraint(equalTo: searchToolsViews[2].trailingAnchor, constant: 10),
            self.searchToolsViews[3].heightAnchor.constraint(equalToConstant: 75),
            
            self.searchToolsViews[4].topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            self.searchToolsViews[4].widthAnchor.constraint(equalToConstant: 150),
            self.searchToolsViews[4].leadingAnchor.constraint(equalTo: searchToolsViews[3].trailingAnchor, constant: 10),
            self.searchToolsViews[4].heightAnchor.constraint(equalToConstant: 75),
            
        ])
    }
    
}
