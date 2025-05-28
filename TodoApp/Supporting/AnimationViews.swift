//
//  AnimationViews.swift
//  TodoApp
//
//  Created by Marwa Awad on 24.03.2025.
//

import UIKit

class AnimationViews: UIView {
    
    //MARK: - Singletone
    public static let shared = AnimationViews()
    
    //MARK: - Animation Functions
    func setupGradientBackground(view: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
  
  
        gradient.colors = [
            UIColor(red: 1.4, green: 0.95, blue: 1.3, alpha: 1).cgColor,
            UIColor(red: 0.88, green: 0.91, blue: 1, alpha: 1.0).cgColor
            ]

        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func animateHeader(label: UILabel) {
        label.alpha = 0
        label.transform = CGAffineTransform(translationX: 0, y: -20)
        
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            label.alpha = 1
            label.transform = .identity
        }
    }
}


// dark mode colors:
//UIColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0).cgColor,  // Soft black
// UIColor(red: 0.20, green: 0.20, blue: 0.22, alpha: 1.0).cgColor   // Warm dark gray
