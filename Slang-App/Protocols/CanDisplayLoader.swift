//
//  CanDisplayLoader.swift
//  Slang-App
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

protocol CanDisplayLoader: class {
    func showLoader()
    func hideLoader()
}

class DimmerView: UIView { }

extension CanDisplayLoader where Self: UIViewController {
    func showLoader() {
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else {
            return
        }
        
        let dimmerView = DimmerView(frame: window.bounds)
        dimmerView.backgroundColor = .black
        dimmerView.alpha = 0
        window.addSubview(dimmerView)
        
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        dimmerView.addSubview(activityIndicatorView)
        activityIndicatorView.center = dimmerView.center
        activityIndicatorView.startAnimating()
        
        UIView.animate(withDuration: 0.3) {
            dimmerView.alpha = 0.5
        }
    }
    
    func hideLoader() {
        guard
            let window = (UIApplication.shared.delegate as? AppDelegate)?.window,
            let dimmerView = window.subviews.last as? DimmerView
        else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            dimmerView.alpha = 0
        }, completion: { (_) in
            dimmerView.removeFromSuperview()
        })
    }
}
