//
//  ConverterController.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import UIKit
import CoreData

class ConverterController: BaseController {

    lazy var screenView: ConverterView = {
       baseView as! ConverterView
    }()
    
    lazy var viewModel: ConverterViewModelProtocol = {
        baseViewModel as! ConverterViewModelProtocol
    }()
    
    override func setupUI() {
        
        screenView.indicate = true
        screenView.amountTextField.delegate = self
        screenView.amountTextField.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        performFetch()
    }
    
    override func observeEvents() {
        viewModel.currencyResult.sink { result in
            switch result {
            case .success:
                self.performFetch()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }.store(in: &viewModel.bag)
        
        viewModel.selectedCurrencyInformation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currencyInformation in
            guard let self = self, let currencyInformation = currencyInformation else { return }
            self.screenView.selectedCurrencyView.currencyLabel.text = currencyInformation.currency.code ?? ""
            self.screenView.conversionCollectionView.reloadData()
        }.store(in: &viewModel.bag)
        
        viewModel.newAmount
            .debounce(for: .seconds(0.25), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] amount in
            guard let self = self else { return }
            self.screenView.conversionCollectionView.reloadData()
        }.store(in: &viewModel.bag)
        
    }
    
    private func performFetch() {
        
        do {
            try viewModel.addFetchControllerDelegate(self)
            DispatchQueue.main.async {
                self.screenView.indicate = false
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCurrencySelectionTap))
                self.screenView.selectedCurrencyView.addGestureRecognizer(tapGesture)
                self.screenView.conversionCollectionView.delegate = self
                self.screenView.conversionCollectionView.dataSource = self
            }
        }
        catch {
            alert(title: "Error", msg: "failed to fetch currencies from database", actions: [Constant.Alert.ok]).sink(receiveValue: {_ in }).store(in: &viewModel.bag)
        }
    }
    
    @objc private func handleCurrencySelectionTap() {
        screenView.amountTextField.resignFirstResponder()
        addPickerView()
    }

}

extension ConverterController {
    
    private func setupPickerView() {
        
        screenView.picker.delegate = self
        screenView.picker.dataSource = self
        
        if let selectedCurrencyInformation = viewModel.selectedCurrencyInformation.value {
            screenView.picker.selectRow(selectedCurrencyInformation.index, inComponent: 0, animated: true)
        } else {
            guard let firstCurrency = viewModel.currencies.first?.createObject() else { return }
            viewModel.selectedCurrencyInformation.value = (firstCurrency, 0)
        }
    }
    
    private func addPickerView() {
        setupPickerView()
        screenView.addSubview(screenView.picker)
        screenView.addSubview(screenView.toolBar)
    }
    
}
extension ConverterController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
    let data = viewModel.currencies[row]
    let reuseView = (view != nil ? view! : CurrencyPickerView()) as! CurrencyPickerView
        reuseView.configure(currencyCode: data.code)
        return reuseView
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let data = viewModel.currencies[row].createObject()
        viewModel.selectedCurrencyInformation.value = (data, row)
    }
    
}

extension ConverterController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard viewModel.canConvert() else { return CGSize(width: collectionView.bounds.width, height: 100) }
        let width = collectionView.frame.width * 0.3
        let height = collectionView.frame.width * 0.4
        return CGSize(width: width, height: height)
    }
    
}

extension ConverterController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.canConvert() ? viewModel.currencies.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard viewModel.canConvert() else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyErrorCell.identifier, for: indexPath) as! CurrencyErrorCell
            cell.configureCell(text: viewModel.validateAmountAndCurrency()?.errorDescription ?? "Something went wrong")
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConversionResultCell.identifier, for: indexPath) as! ConversionResultCell
        let item = viewModel.currencies[indexPath.row]
        cell.configureCell(name: item.name ?? "", currencyCode: item.code ?? "", value: "\(viewModel.getConvertedAmount(for: item.rate))")
        return cell
    }
    
}

extension ConverterController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.screenView.conversionCollectionView.reloadData()
        }
    }
    
}

extension ConverterController: UITextFieldDelegate {
    
    //hanndle the textChange in textfield
    @objc private func textChanged(textField: UITextField) {
        let text = textField.text ?? "0"
        let amount = Float(text.isEmpty ? "0" : text) ?? -1
        viewModel.newAmount.send(amount)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        screenView.removePickerView()
    }
    
}

