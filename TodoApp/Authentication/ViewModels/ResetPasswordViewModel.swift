//
//  ResetPasswordViewModel.swift
//  TodoApp
//
//  Created by Marwa Awad on 24.03.2025.
//

import Foundation



class ResetPasswordViewModel {
    
    public static let shared = ResetPasswordViewModel()
    
    func resetPassword(email: String) -> Bool{
        print("email: \(email)")
        
        return true
    }
}
