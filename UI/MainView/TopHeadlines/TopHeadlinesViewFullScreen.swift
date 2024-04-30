import Combine
import KingfisherSwiftUI
import SwiftUI
import CoreData

struct TopHeadlinesViewFullScreen: View {
    @State private var shouldPresentURL: Bool = false
    @State private var shouldShowShareSheet: Bool = false
    
    var article: Article
    
    var body: some View {
        VStack(spacing: 0) {
            KFImage(URL(string: article.urlToImage ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: UIScreen.main.bounds.height * 0.3)
                .clipped()
                .shadow(radius: 5)
            
            VStack(spacing: 8) {
                Text(article.title ?? "")
                    .font(.system(size: 24, weight: .bold)) // Adjust font size and weight
                    .foregroundColor(.white)
                    .padding(.horizontal, 16) // Add horizontal padding
                
                Spacer()

                Text("Source: \(article.source?.name ?? "")")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Date: \(article.publishedAt ?? "")")
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
                
                Spacer() // Fill remaining space
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom) // Use gradient background
            )
            .cornerRadius(10)
            .shadow(radius: 3) // Add shadow
            .onTapGesture {
                self.shouldPresentURL = true
            }
        }
        .padding(2)
    

        
        .contextMenu {
            Button(
                action: {
                    LocalArticle.saveArticle(self.article)
                    CoreDataManager.shared.saveContext()
                },
                label: {
                    Text("Add to favorites".localized())
                    Image(systemName: "heart.fill")
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
                self.article.url
            ])
        }
    }
    
    private func truncateContent(_ content: String) -> String {
        // Truncate content if too large
        let maxLength = 200 // Maximum length of content to display
        if content.count > maxLength {
            return String(content.prefix(maxLength)) + "..."
        } else {
            return content
        }
    }
    
    private func shouldShowReadMore(_ content: String) -> Bool {
        // Determine whether "Read more" button should be shown
        let maxLength = 200 // Maximum length of content to display
        return content.count > maxLength
    }
}

private extension TopHeadlinesViewFullScreen {
    func formattedDate(_ dateString: String) -> String {
        // Implement date formatting logic here if needed
        return dateString // Return original string for now
    }
}


