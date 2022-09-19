//
//  ConverterView.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import UIKit

final class ConverterView: BaseView {
    
    private var viewsLayedout = false
    
    lazy var amountTextField: TextField = {
        let textField = TextField(frame: .zero)
        textField.textAlignment = .right
        textField.textColor = .black
        textField.keyboardType = .decimalPad
        textField.placeholder = "Please enter the amount..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var selectedCurrencyView: SelectedCurrencyView = {
        let view = SelectedCurrencyView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var conversionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.maskTop(40)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 5, bottom: 0, right: 5)
        collectionView.register(ConversionResultCell.self, forCellWithReuseIdentifier: ConversionResultCell.identifier)
        collectionView.register(CurrencyErrorCell.self, forCellWithReuseIdentifier: CurrencyErrorCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var picker: UIPickerView = {
        let pickerView = UIPickerView.init()
        pickerView.backgroundColor = .white
        pickerView.autoresizingMask = .flexibleWidth
        pickerView.contentMode = .center
        pickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 150, width: UIScreen.main.bounds.size.width, height: 150)
        return pickerView
    }()
    
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
       let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
       let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        doneButton.tintColor = .appGreen
        toolBar.items = [flexibleSpace , doneButton]
        return toolBar
    }()
    
    override func layoutSubviews() {
        guard !viewsLayedout, conversionCollectionView.frame.height > 0 else { return }
        viewsLayedout.toggle()
        addGradientAndShadow()
        
    }
    
    private func addGradientAndShadow() {
        addGradient([.appBlue, .appGreen], locations: [0, 1], frame: CGRect(x: 0, y: 0, width: frame.width, height: containerView.frame.minY + 50))
        
        let view = UIView()
        let gradientFrame = CGRect(x: 0, y: 0, width: conversionCollectionView.bounds.width, height: conversionCollectionView.bounds.height)
        view.addGradient([.appGreen, .appBlue], locations: [0, 1], frame: gradientFrame)
        conversionCollectionView.backgroundView = view
        
        
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 40).cgPath
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 7
        containerView.layer.shadowOffset = CGSize(width: 0, height: -10)
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func create() {
        backgroundColor = .white
        addSubview(amountTextField)
        addSubview(selectedCurrencyView)
        addSubview(containerView)
        containerView.addSubview(conversionCollectionView)
        
        NSLayoutConstraint.activate([
            
            amountTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            amountTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            amountTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            amountTextField.heightAnchor.constraint(equalToConstant: 50),
            
            selectedCurrencyView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            selectedCurrencyView.leadingAnchor.constraint(equalTo: amountTextField.centerXAnchor),
            selectedCurrencyView.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
            selectedCurrencyView.heightAnchor.constraint(equalToConstant: 50),
            
            containerView.topAnchor.constraint(equalTo: selectedCurrencyView.bottomAnchor, constant: 40),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            conversionCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            conversionCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            conversionCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            conversionCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    @objc private func onDoneButtonTapped() {
        removePickerView()
    }
    
    func removePickerView() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
}
