//
//  postListView.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import Foundation
import SwiftUI

struct PostListView: View {
    @StateObject  var postVM = PostViewModel()
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack{
            searchView
            Spacer()
            if postVM.isLoading  {
                ProgressView()
                    .padding()
            }
            Divider()
            listView
            .padding(0)
            .onAppear {
                postVM.fetchPosts()
                postVM.setUp(appState: appState)
            }
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}

private extension PostListView {
    var searchView : some View {
        VStack {
            if postVM.showSearch {
                HStack {
                    Button {
                        postVM.showSearch.toggle()
                        postVM.searchText = ""
                        postVM.fetchPosts()
                    } label: {
                        Image(systemName: "x.circle")
                            .foregroundColor(.black.opacity(0.4))
                            .padding(.leading,10)
                    }
                    TextField("Search", text: $postVM.searchText)
                        .padding(.horizontal)
                    Button {
                        postVM.searchPosts()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black.opacity(0.4))
                            .padding(.trailing,10)
                    }
                }
                .frame(height: 40)
                .background(Color.white.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
            }else{
                HStack {
                    Image("LOGO")
                        .foregroundColor(.black.opacity(0.4))
                        .padding(.leading,10)
                    Spacer()
                    Button {
                        postVM.showSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black.opacity(0.4))
                            .padding(.leading,10)
                    }
                    Button {
                        postVM.logout()
                    } label: {
                        Image(systemName: "power.circle")
                            .foregroundColor(.red.opacity(0.8))
                            .padding(.leading,10)
                    }
                }
                .frame(height: 40)
                .background(Color.white.opacity(0.2))
                .padding()
                
            }
        }
    }
}

private extension PostListView {
    var listView : some View {
        List {
            ForEach(postVM.posts, id: \.id) { post in
                VStack(alignment: .leading) {
                    HStack{
                        Image("userimage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40,height: 40)
                        VStack(alignment: .leading){
                            Text("Ahmed")
                                .font(.title3)
                            Text("2 hours ago")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.subheadline)
                    
                    Image("postimage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .onAppear {
                    if post.id == postVM.lastIdFetched {
                        postVM.loadMorePosts(currentItem: post)
                    }
                }
            }
            .padding(0)
        }
        .listStyle(PlainListStyle())
    }
}
