//
//  SelectedCurrencyView.swift
//  CurrencyConverter
//
//  Created by rabin on 21/07/2022.
//

import UIKit

final class SelectedCurrencyView: UIView {
    
    lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Select currency"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pickerButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(currencyLabel)
        addSubview(pickerButton)
        
        NSLayoutConstraint.activate([
            
            currencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            currencyLabel.trailingAnchor.constraint(equalTo: pickerButton.leadingAnchor, constant: -18),
            currencyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            pickerButton.widthAnchor.constraint(equalToConstant: 25),
            pickerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            pickerButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
