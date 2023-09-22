//
//  postViewModel.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import Foundation
import Combine
// PostViewModel.swift
class PostViewModel: ObservableObject {
  
    var appState :AppState?

    //Public Properties
    @Published var posts: [Post] = []
    @Published var searchText: String = ""
    @Published var showSearch: Bool = false
    @Published var isLoading: Bool = false
    var lastIdFetched = 0

    //private properties
    private var currentPage = 0
    private var stopFetching = false
    private let apiManager = APIManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else {return}
                if !text.isEmpty {
                    self.searchPosts()
                }
            }
            .store(in: &cancellables)
    }
    func fetchPosts(reset: Bool = false, startSearch: Bool = false) {
        
        var param = ["limit":"10","skip":"\(currentPage)"]
        var endPoint = EndPoint.posts
        
        if !self.searchText.isEmpty && startSearch == true {
            endPoint = EndPoint.search
            param["q"] = self.searchText
        }
        
        isLoading = true

        apiManager.request(endpoint: endPoint.rawValue, httpMethod: .GET, parameters: param)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    print("GET request completed successfully.")
                case .failure(let error):
                    print("GET request failed with error: \(error)")
                }
            } receiveValue: { response in
                let data: postResponseModel = response.value
                self.posts.append(contentsOf: data.posts)
                if data.total == self.posts.last?.id {
                    self.stopFetching = true
                }else{
                    self.lastIdFetched = self.posts.last?.id ?? 0
                }
            }
            .store(in: &cancellables)
    }
    
    func searchPosts(reset: Bool = false) {
        if self.searchText.isEmpty {
            return
        }
        isLoading = true
        posts.removeAll()
        currentPage = 0
        self.fetchPosts(startSearch: true)
    }
    
    func loadMorePosts(currentItem item: Post) {
        if item.id == lastIdFetched && stopFetching == false {
            currentPage += 10
            fetchPosts()
        }
    }
    
    func setUp(appState: AppState)  {
        self.appState = appState
    }
    
    func logout() {
        appState?.removeSession()
    }
}
