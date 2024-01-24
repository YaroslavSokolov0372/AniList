//
//  SearchView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 19/12/2023.
//

import UIKit

protocol SearchTextFieldProtocol {
    func textFieldDidChange(_ sender: UITextField)
    
    func textFieldRemoveButtonTapped(_ sender: UIButton)
}

class SearchTextFieldView: UIView {
    
    //MARK: - Variables
    var delegate: SearchTextFieldProtocol!
    
    //MARK: - UI Components
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Genres"
        label.font = UIFont().JosefinSans(font: .regular, size: 17)
        return label
    }()
 
    private let leftImage: UIImage = {
        let image = UIImage(named: "Magnifier")!.withRenderingMode(.alwaysTemplate)
        return image
    }()
    
    private let rightImage: UIImage = {
        let image = UIImage(named: "Magnifier")!.withRenderingMode(.alwaysTemplate)
        return image
    }()
    
    private var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Cross")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.backgroundColor = UIColor(named: "DarkBlack")
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(named: "DarkBlack")
        tf.layer.cornerRadius = 12
        tf.returnKeyType = .done
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
        self.textField.leftImage(self.leftImage, imageSize: CGSize(width: 15, height: 15), padding: 10)
        self.textField.rightImage(rightImage, imageSize: CGSize(width: 15, height: 15), padding: 10)
        self.textField.rightView?.alpha = 0
        
        self.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Setup UI
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
    
    private func setupRemoveButton() {
        self.textField.addSubview(removeButton)
        self.removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.removeButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -15),
            self.removeButton.heightAnchor.constraint(equalToConstant: 15),
            self.removeButton.widthAnchor.constraint(equalToConstant: 15),
            self.removeButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
        ])
    }
    
    //MARK: - Func
    public func passTextField() -> UITextField {
        return self.textField
    }
    
    public func removeRemoveButton() {
        removeButton.removeFromSuperview()
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        self.delegate.textFieldDidChange(sender)
        
        if let text = sender.text {
            if !text.isEmpty {
                self.setupRemoveButton()
            }
        } else {
            removeRemoveButton()
        }
    }
    
    @objc private func removeButtonTapped(_ sender: UIButton) {
        self.delegate.textFieldRemoveButtonTapped(sender)
        removeButton.removeFromSuperview()
        self.textField.text = nil
    }
}
