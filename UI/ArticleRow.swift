//  ArticleRow.swift

import Combine
import KingfisherSwiftUI
import SwiftUI

struct ArticleRow: View {
    let article: Article
    
    @State private var shouldShowShareSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            KFImage(URL(string: article.urlToImage ?? ""))
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 32,
                       height: 250,
                       alignment: .center)
            
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.6)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.source?.name ?? "")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .lineLimit(nil)
                
                Text(article.title ?? "")
                    .foregroundColor(.white)
                    .font(.headline)
                    .lineLimit(nil)
            }
            .padding(16)
        }
        .cornerRadius(8)
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .shadow(color: .black, radius: 5, x: 0, y: 0)
        .contextMenu {
            Button(
                action: {
                    LocalArticle.saveArticle(article)
                    CoreDataManager.shared.saveContext()
                },
                label: {
                    Text("Add to favorites".localized())
                    Image(systemName: "heart.fill")
                }
            )
            Button(
                action: {
                    shouldShowShareSheet.toggle()
                },
                label: {
                    Text("Share".localized())
                    Image(systemName: "square.and.arrow.up")
                }
            )
        }
        .sheet(isPresented: $shouldShowShareSheet) {
            ActivityViewController(activityItems: [
                article.title ?? "",
                article.url
            ])
        }
    }
}
