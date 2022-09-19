//
//  BaseView.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import UIKit

/// The base view to be inherited by all screen child
class BaseView: UIView {
    
    /// The configuaration for indicator
    var indicatorConfig: IndicatorConfig = DefaultConfig()
    
    /// The indicatorView
    private var indicatorView: IndicatorView?
    
    /// flag to check if the indicator is indicating or not
    private var indicating: Bool = false
    
    /// Flag to display or hide the indicator
    var indicate: Bool = false {
        didSet {
            if indicate {
                startIndicator()
            } else {
                endIndicator()
            }
        }
    }
    
    /// The freeze view
    private lazy var freezerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Frame Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    /// Coder initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
    }
    
    /// base function to create the subviews
    /// This function is override by different views to create their own subviews
    func create() {
        self.backgroundColor = .white
    }
    
    /// This method will add a non interactive, non visible overlay over the screen so that all elements appears to be disabled
    func freezeAll() {
        
        addSubview(freezerView)
        
        NSLayoutConstraint.activate([
            freezerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            freezerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            freezerView.topAnchor.constraint(equalTo: topAnchor),
            freezerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// This method will remove the freezer view from screen
    func unFreezeAll() {
        freezerView.removeConstraints(freezerView.constraints)
        freezerView.removeFromSuperview()
    }
    
    /// Method that will add a indicator
    func startIndicator() {
        guard let indicator = indicatorView else { return }
        addSubview(indicator)
        indicator.showIndicator(config: indicatorConfig)
        bringSubviewToFront(indicator)
        indicating = true
    }
    
    /// Method that will remove the indicator
    func endIndicator() {
        guard let indicator = indicatorView else { return }
        indicator.hideIndicator()
        indicator.removeFromSuperview()
        indicating = false
    }
    
    /// Achive the rect of view
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // check if already indicating
        if !indicating {
            
            /// initialize the indicator when rect is achieved
            self.indicatorView = IndicatorView(frame: CGRect(x: (rect.midX - (indicatorConfig.indicatorDimension.width / 2.0)), y: rect.midY - (indicatorConfig.indicatorDimension.height / 2.0), width: indicatorConfig.indicatorDimension.width, height: indicatorConfig.indicatorDimension.width))
            
            /// start the indicator if set
            if indicate {
                self.startIndicator()
            }
        }
    }
    
    deinit {
        debugPrint("De-Initialized View --> \(String(describing: self))")
    }
}

