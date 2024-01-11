//
//  SearchView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 19/12/2023.
//

import UIKit

class SearchTextFieldView: UIView {

    
    //MARK: - UI Components
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Genres"
        label.font = UIFont().JosefinSans(font: .regular, size: 17)
        return label
    }()
 
    private let image: UIImage = {
        let image = UIImage(named: "Magnifier")!.withRenderingMode(.alwaysTemplate)
        return image
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(named: "DarkBlack")
        tf.layer.cornerRadius = 12
        
        tf.font = UIFont().JosefinSans(font: .regular, size: 14)
        tf.textColor = .white
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
        tf.rightViewMode = .always
        return tf
    }()
    
    
    //MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "Black")
        self.title.text = title
        self.textField.leftImage(self.image, imageSize: CGSize(width: 15, height: 15), padding: 10)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Setup UI
    private func setupUI() {
        
        self.addSubview(title)
        self.addSubview(textField)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            self.title.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.title.heightAnchor.constraint(equalToConstant: 35),
            self.title.topAnchor.constraint(equalTo: self.topAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            self.textField.topAnchor.constraint(equalTo: title.bottomAnchor),
            self.textField.heightAnchor.constraint(equalToConstant: 40),
            self.textField.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }
}
