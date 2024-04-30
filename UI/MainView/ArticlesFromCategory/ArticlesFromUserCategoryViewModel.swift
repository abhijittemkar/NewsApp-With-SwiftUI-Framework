//
//  ArticlesFromUserCategoryViewModel.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Abhijit Temkar on 06/04/24.
//  Copyright © 2024 Алексей Воронов. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UIKit

final class ArticlesFromUserCategoryViewModel: ObservableObject {
    private let apiProvider = APIProvider<ArticleEndpoint>()
    
    private var bag = Set<AnyCancellable>()
    @Published private(set) var articles: Articles = []

    func searchForArticles(searchFilter: String) {
        apiProvider.getData(from: ArticleEndpoint.searchForArticles(searchFilter: searchFilter)) // Use the passed searchFilter
            .decode(type: ArticlesResponse.self, decoder: Container.jsonDecoder)
            .map { $0.articles }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: \.articles, on: self)
            .store(in: &bag)
    }
}



    
    
