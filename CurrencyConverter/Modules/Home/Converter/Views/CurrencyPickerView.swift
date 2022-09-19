//
//  CurrencyPickerView.swift
//  CurrencyConverter
//
//  Created by rabin on 22/07/2022.
//

import UIKit

class CurrencyPickerView: UIView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addChildren()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addChildren() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        
        imageView.tintColor = .black
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -50),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 18),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
        ])
    }
    
    func configure(currencyCode: String?) {
        
        if let currencyCode = currencyCode, !currencyCode.isEmpty {
            let index = currencyCode.index(currencyCode.startIndex, offsetBy: 2)
            let countryCode = currencyCode[..<index].lowercased()
            imageView.kf.setImage(with: URL(string: "https://flagcdn.com/48x36/\(countryCode).png"), placeholder: ImagePlaceHolder())
        }
        label.text = currencyCode
    }
    
}
