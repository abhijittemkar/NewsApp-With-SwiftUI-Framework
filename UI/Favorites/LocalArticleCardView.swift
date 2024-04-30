import SwiftUI
import KingfisherSwiftUI
import Combine
import CoreData

struct LocalArticleCardView: View {
    @FetchRequest(
        entity: LocalArticle.entity(),
        sortDescriptors: [NSSortDescriptor(key: "savingDate", ascending: false)],
        predicate: NSPredicate(format: "title != nil && title != ''")
    ) var fetchedArticles: FetchedResults<LocalArticle>
    
    @StateObject var dataRefreshManager = DataRefreshManager() // Create DataRefreshManager instance
    
    var body: some View {
        PageView(fetchedArticles.map {
            ArticleView(article: $0, dataRefreshManager: dataRefreshManager) // Pass DataRefreshManager instance
        })
        .id(dataRefreshManager.refreshData) // Ensure refresh when dataRefreshManager.refreshData changes
        .frame(height: UIScreen.main.bounds.height * 0.8)
    }
}



// Define the ArticleView
struct ArticleView: View {
    let article: LocalArticle
    @State private var shouldPresentURL: Bool = false
    @State private var shouldShowShareSheet: Bool = false
   // @Binding var refreshView: Bool // Binding to refreshView
    @ObservedObject var dataRefreshManager: DataRefreshManager // <<-- Inject DataRefreshManager


    
    var body: some View {
        VStack {
            KFImage(URL(string: article.urlToImage ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: UIScreen.main.bounds.height * 0.3)
                .clipped()
                .shadow(radius: 5)
            
            VStack(spacing: 8) {
                Text(article.title ?? "")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                
                Text("Source: \(article.source?.name ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Text("Date: \(article.publishedAt ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Text(truncateContent(article.content ?? ""))
                    .font(.body)
                    .foregroundColor(.white)
                
                if shouldShowReadMore(article.content ?? "") {
                    Button(action: {
                        self.shouldPresentURL = true
                    }) {
                        Text("Read more")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(10)
            .shadow(radius: 3)
            .onTapGesture {
                self.shouldPresentURL = true
            }
        }
        .padding(2)
        .contextMenu {
            Button(
                action: {
                    CoreDataManager.shared.managedObjectContext.delete(self.article)
                    CoreDataManager.shared.saveContext()
               //     self.refreshView.toggle() // Toggle refreshView using binding
                    dataRefreshManager.refresh()

                },
                label: {
                    Text(Constants.removeFromFavorites)
                    Image(systemName: Constants.removeFromFavoritesImageName)
                }
            )
            Button(
                action: {
                    self.shouldShowShareSheet.toggle()
                },
                label: {
                    Text("Share".localized())
                    Image(systemName: "square.and.arrow.up")
                }
            )
        }
        .sheet(isPresented: $shouldPresentURL) {
            SafariView(url: self.article.url)
        }
        .sheet(isPresented: $shouldShowShareSheet) {
            ActivityViewController(activityItems: [
                self.article.title ?? "",
                self.article.url as Any
            ])
        }
        
    }
    
    private func truncateContent(_ content: String) -> String {
        // Truncate content if too large
        let maxLength = 200
        if content.count > maxLength {
            return String(content.prefix(maxLength)) + "..."
        } else {
            return content
        }
    }
    
    private func shouldShowReadMore(_ content: String) -> Bool {
        // Determine whether "Read more" button should be shown
        let maxLength = 200
        return content.count > maxLength
    }
}




private extension ArticleView {
    
    struct Constants {
        static let removeFromFavorites = "Remove from favorites".localized()
        static let removeFromFavoritesImageName = "heart.slash.fill"
    }
}
