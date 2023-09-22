//
//  ContentView.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isLoggedIn {
                PostListView()
            } else {
                LoginView(viewModel: LoginViewModel())
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
        
    }
}
