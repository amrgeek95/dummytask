//
//  loginView.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import SwiftUI
struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    @State var show = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image("loginimage")
                    .resizable()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(maxHeight: UIScreen.main.bounds.height/2)
                    .aspectRatio(contentMode: .fit)
                Spacer()
                Text("Welcome")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("primaryColor"))
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                VStack(alignment: .leading, spacing: 15) {
                    Text("Username")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                    TextField("Enter your username", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityIdentifier("username")
                    Text("Password")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                    SecureField("Enter your password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityIdentifier("password")
                    Button(action: {
                        viewModel.login()
                    }) {
                        Text("Sign IN")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color("primaryColor"))
                            .cornerRadius(30)
                    }
                    .accessibilityIdentifier("loginButton")
                    .alert(isPresented: $viewModel.showError) {
                        Alert(title: Text(viewModel.errorMessage), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
                if let loginResponse = viewModel.loginResponse {
                    Text("User ID: \(loginResponse.id)")
                    Text("Token: \(loginResponse.token)")
                }
            }
        }
        .onAppear{
            viewModel.setUp(appState: appState)
        }
        .ignoresSafeArea()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
