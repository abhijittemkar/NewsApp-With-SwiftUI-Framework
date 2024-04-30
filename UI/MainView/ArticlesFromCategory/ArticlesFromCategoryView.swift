import SwiftUI

struct ArticlesFromCategoryView : View {
    @ObservedObject var viewModel = ArticlesFromCategoryViewModel()
    @State private var isFullScreen: Bool = false
    @State private var isTitleExpanded: Bool = false
    
    let category: String
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.articles.isEmpty {
                    ProgressView("Please check data connection and try again...")
                } else {
                    if isFullScreen {
                        TopHeadlinesFSView(topHeadlines: viewModel.articles)
                    } else {
                        Spacer() // Pushes the content to the bottom
                        ArticlesList(articles: viewModel.articles)
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.getArticles(from: self.category)
        }
        .navigationBarTitle(
            Text(category.localized().capitalizeFirstLetter()),
            displayMode: .inline
        )

        .navigationBarItems(trailing:
            Button(action: {
                self.isFullScreen.toggle()
            }) {
                Image(systemName: isFullScreen ? "rectangle.fill.on.rectangle.angled.fill" : "rectangle.grid.1x2.fill")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
            .padding(.trailing) // Add some padding for spacing
        )

        .navigationBarHidden(isTitleExpanded)
        
    }
}
