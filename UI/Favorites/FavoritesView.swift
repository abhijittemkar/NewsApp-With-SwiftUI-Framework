//  FavoritesView.swift


import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: LocalArticle.entity(),
        sortDescriptors: [NSSortDescriptor(key: "savingDate", ascending: false)],
        predicate: NSPredicate(format: "title != nil && title != ''")
    ) var articles: FetchedResults<LocalArticle>
    @StateObject var dataRefreshManager = DataRefreshManager()

    @State private var articleURL: URL?
    @State private var isCardView: Bool = false // State property for view mode
    
    var body: some View {
        NavigationView {
            if articles.isEmpty {
                Text("No articles in favorites")
                    .font(.headline)
                    .padding()
                    .navigationBarTitle("Favorites".localized(), displayMode: .large)
            } else {
                    VStack {
                        if isCardView {
                            LocalArticleCardView()
                                .id(dataRefreshManager.refreshData)
                                .onChange(of: articles.count) { _ in
                                        dataRefreshManager.refreshData.toggle()
                                }
                        } else {
                            ScrollView {
                                ForEach(articles, id: \.self) { article in
                                    LocalArticleRow(article: article)
                                        .onTapGesture {
                                            self.articleURL = article.url
                                        }
                                }
                            }
                        }
                }
                .navigationBarTitle("Favorites".localized(), displayMode: isCardView ? .inline : .large) // Set display mode based on isCardView
                .navigationBarItems(trailing:
                    Button(action: {
                        self.isCardView.toggle() // Toggle between card view and list view
                    }) {
                        Image(systemName: isCardView ? "rectangle.fill.on.rectangle.angled.fill" : "rectangle.grid.1x2.fill")
                            .imageScale(.large)
                            .foregroundColor(.primary)
                    }
                    .padding(.trailing) // Add some padding for spacing
                )
                .sheet(item: $articleURL) { url in
                    SafariView(url: url)
                }
            }
        }
    }
}



