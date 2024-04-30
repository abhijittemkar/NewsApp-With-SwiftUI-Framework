//  SearchForArticlesViewModel.swift


import SwiftUI
import Combine
import UIKit

final class SearchForArticlesViewModel: ObservableObject {
    private let apiProvider = APIProvider<ArticleEndpoint>()
    
    private var bag = Set<AnyCancellable>()
    
    @Published var searchText: String = "" {
        didSet {
            searchForArticles(searchFilter: searchText)
        }
    }
    @Published private (set) var articles: Articles = []
    
    func searchForArticles(searchFilter: String) {
        self.articles = []
        apiProvider.getData(from: .searchForArticles(searchFilter: searchFilter))
            .decode(type: ArticlesResponse.self, decoder: Container.jsonDecoder)
            .map { $0.articles.prefix(30) } // Limit to first 30 articles
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] articles in
                self?.articles = Array(articles) // Convert to array and assign to articles property
            })
            .store(in: &bag)
    }
}
