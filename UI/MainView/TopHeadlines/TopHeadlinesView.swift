//  TopHeadlinesView.swift


import SwiftUI

struct TopHeadlinesView: View {
    let topHeadlines: [Article]
    
    var body: some View {
        let filteredTopHeadlines = topHeadlines.filter { article in
            return article.title != nil && !article.title!.isEmpty &&
                   article.urlToImage != nil && !article.urlToImage!.isEmpty &&
                   article.content != nil && !article.content!.isEmpty
        }
        
        return List {
            ForEach(filteredTopHeadlines, id: \.self) { article in
                TopHeadlineRow(article: article)
            }
        }
    }
}

