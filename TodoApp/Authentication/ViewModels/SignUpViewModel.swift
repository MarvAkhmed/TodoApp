//
//  SignUpViewModel.swift
//  TodoApp
//
//  Created by Marwa Awad on 24.03.2025.
//

import Foundation
import Firebase
import FirebaseCore



class SignUpViewModel {
    
    public static let shared = SignUpViewModel()
    
    func regestration(email: String, password: String) -> Bool{
        print("email: \(email), password: \(password)")
        
        return true
    }
}
