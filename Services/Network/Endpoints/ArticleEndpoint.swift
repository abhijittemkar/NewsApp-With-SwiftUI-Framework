//  ArticleEndpoint.swift


import Foundation

enum ArticleEndpoint: EndpointProtocol {
    case getTopHeadlines
    case getArticlesFromCategory(category: String)
    case getSources
    case getArticlesFromSource(source: String)
    case searchForArticles(searchFilter: String)
    
    var baseURL: String {
        return "https://newsapi.org/v2"
    }
    
    var absoluteURL: String {
        switch self {
        case .getTopHeadlines, .getArticlesFromCategory:
            return baseURL + "/top-headlines"
            
        case .getSources:
            return baseURL + "/sources"
            
        case .getArticlesFromSource, .searchForArticles:
            return baseURL + "/everything"
        }
    }
    
    var params: [String: String] {
        var parameters: [String: String] = ["pageSize": "30"]
        
        switch self {
        case .getTopHeadlines:
            parameters["country"] = region
            
        case let .getArticlesFromCategory(category):
            parameters["country"] = region
            parameters["category"] = category
            
        case .getSources:
            parameters["language"] = locale
            parameters["country"] = region
            
        case let .getArticlesFromSource(source):
            parameters["sources"] = source
            parameters["language"] = locale
            
        case let .searchForArticles(searchFilter):
            parameters["q"] = searchFilter
            parameters["language"] = locale
        }
        
        return parameters
    }
    
    var headers: [String: String] {
        return [
            "X-Api-Key": Container.newsAPIKey,
            "Content-type": "application/json",
            "Accept": "application/json"
        ]
    }
}
