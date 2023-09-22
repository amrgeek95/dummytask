//
//  loginViewModel.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @AppStorage("userData") var userData = Data()
    @Published var isLoggedIn:Bool = false {
        didSet {
            @AppStorage("isLoggedIn") var logged = isLoggedIn
        }
    }
    @Published var userInfo:UserModel? {
        didSet {
            @AppStorage("userData") var appUserData = Data()
            if let appData = try? JSONEncoder().encode(userInfo) {
                userData = appData
            }
        }
        
    }
    
    init() {
        if let decodeData = try? JSONDecoder().decode(UserModel.self, from: userData) {
            self.isLoggedIn = true
            self.userInfo = decodeData
        }
        else{
            self.isLoggedIn = false
        }
    }
    func removeSession(){
        self.isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userData")
    }
    
    
}


class LoginViewModel: ObservableObject {
    
    var appState :AppState?

    @Published var loginResponse: UserModel?
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false

    private let apiManager = APIManager()
    private var cancellables = Set<AnyCancellable>()

    func setUp(appState:AppState){
        self.appState = appState
    }
    
    func login() {
        if username.isEmpty {
            self.errorMessage = "Username is required"
            self.showError = true
            return
        }
        if password.isEmpty {
            self.errorMessage = "Password is required"
            self.showError = true
            return
        }
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]

        apiManager.request(endpoint: EndPoint.login.rawValue, httpMethod: .POST, parameters: parameters)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    print("GET request completed successfully.")
                case .failure( _):
                    self.errorMessage = "Invalid credentials"
                    self.loginResponse = nil
                    self.showError = true
                }
            } receiveValue: { [weak self] response in
                guard let self = self else {
                    return
                }
                if let data: UserModel = response.value {
                    self.loginResponse = data
                    self.appState?.isLoggedIn = true
                    self.appState?.userInfo = data
                    self.showError = false
                    self.errorMessage = ""
                }else{
                    self.showError = true
                    self.errorMessage = "Invalid username or passwrod"

                }
                
            }
            .store(in: &cancellables)
        
    }
}

