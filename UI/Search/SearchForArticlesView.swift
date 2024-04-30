//  SearchForArticlesView.swift

import SwiftUI
import UIKit


struct SearchForArticlesView: View {
    @ObservedObject var viewModel = SearchForArticlesViewModel()
    @State private var isFullScreen: Bool = false
    @State private var isTitleExpanded: Bool = false
    @State private var isScrolling: Bool = false // Track scrolling state
    @State private var isTextinBar: Bool = false


    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(text: $viewModel.searchText, onSearch: {
                    // Perform search action here
                    viewModel.searchForArticles(searchFilter: viewModel.searchText)
                    isTextinBar = true
                })
                .padding([.leading, .trailing], 8)
                
                if viewModel.articles.isEmpty && !isTextinBar{
                    ProgressView("Enter your keywords to start searching for news...")
                } else if viewModel.articles.isEmpty && isTextinBar{
                    ProgressView("Please check data connection and try again...")
                } else {
                    if isFullScreen {
                        TopHeadlinesFSView(topHeadlines: viewModel.articles)
                            .navigationBarTitle(Text(Constants.title), displayMode: .inline)


                    } else {
                        ArticlesList(articles: viewModel.articles)
                            .navigationBarTitle(Text(Constants.title), displayMode: .inline)

                    }
                }
            }
            .navigationBarTitle(Text(Constants.title), displayMode: .automatic)
            .navigationBarItems(trailing:
                Button(action: {
                    self.isFullScreen.toggle() // Toggle between card view and list view
                }) {
                    Image(systemName: isFullScreen ? "rectangle.fill.on.rectangle.angled.fill" : "rectangle.grid.1x2.fill")
                        .imageScale(.large)
                        .foregroundColor(.primary)
                }
                .padding(.trailing) // Add some padding for spacing
            )
        }
    }
}

private extension SearchForArticlesView {
    struct Constants {
        static let title = "Search".localized()
    }
}
