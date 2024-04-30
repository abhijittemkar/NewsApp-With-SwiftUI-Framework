//  ArticlesList.swift


import SwiftUI

struct ArticlesList: View {
    @State private var articleURL: URL?
    @State private var articles: [Article]

    init(articles: [Article]) {
        // Filter articles to exclude those with missing title, URL to image, or content
        self._articles = State(initialValue: articles.filter { article in
            return article.title != nil && !article.title!.isEmpty &&
                   article.urlToImage != nil && !article.urlToImage!.isEmpty &&
                   article.content != nil && !article.content!.isEmpty
        })
        print("Number of articles loaded: \(articles.count)") // Print the count of loaded articles for debugging

    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                ForEach(articles, id: \.self) { article in
                    ArticleRow(article: article)
                        .animation(.spring())
                        .onTapGesture {
                            self.articleURL = article.url
                        }
                }
            }
        }
        .sheet(item: $articleURL) { url in
            SafariView(url: url)
        }
    }
}
