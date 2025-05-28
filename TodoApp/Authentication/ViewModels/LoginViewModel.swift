//
//  LoginViewModel.swift
//  TodoApp
//
//  Created by Marwa Awad on 24.03.2025.
//



class LoginViewModel {
    
    public static let shared = LoginViewModel()
    func login(email: String, password: String) -> Bool {
        print("email: \(email), password: \(password)")
        return true
    }
    

}
