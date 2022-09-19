//
//  ConversionResultCell.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import UIKit
import Kingfisher

struct ImagePlaceHolder: Placeholder {
    
    func add(to imageView: KFCrossPlatformImageView) {
        imageView.image = UIImage(systemName: "flag.fill")
    }
    
    /// How the placeholder should be removed from a given image view.
    func remove(from imageView: KFCrossPlatformImageView) {
        imageView.image = nil
    }
}

class ConversionResultCell: UICollectionViewCell {
    
    var countryFlag: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var currencyName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var conversionValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func prepareForReuse() {
        countryFlag.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(name: String, currencyCode: String, value: String) {
        currencyName.text = name + "\n(\(currencyCode))"
        conversionValue.text = value
        
        if !currencyCode.isEmpty {
            let index = currencyCode.index(currencyCode.startIndex, offsetBy: 2)
            let countryCode = currencyCode[..<index].lowercased()
            countryFlag.kf.setImage(with: URL(string: "https://flagcdn.com/48x36/\(countryCode).png"), placeholder: ImagePlaceHolder())
        }
        
    }
    
    private func setupUI() {
        
        contentView.addSubview(countryFlag)
        contentView.addSubview(currencyName)
        contentView.addSubview(conversionValue)
        
        NSLayoutConstraint.activate([
            countryFlag.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countryFlag.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            countryFlag.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            countryFlag.bottomAnchor.constraint(equalTo: currencyName.topAnchor, constant: -5),
            
            currencyName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currencyName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            currencyName.bottomAnchor.constraint(equalTo: conversionValue.topAnchor, constant: -5),
            
            conversionValue.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            conversionValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])
    
    }
}
