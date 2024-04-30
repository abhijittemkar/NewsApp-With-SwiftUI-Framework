//
//  TopHeadlinesFSView.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Abhijit Temkar on 15/03/24.
//  Copyright © 2024 Алексей Воронов. All rights reserved.
//

import SwiftUI

struct TopHeadlinesFSView: View {
    let topHeadlines: Articles
    
    var body: some View {
        let filteredTopHeadlines = topHeadlines.filter { article in
            return article.title != nil && !article.title!.isEmpty &&
                   article.urlToImage != nil && !article.urlToImage!.isEmpty &&
                   article.content != nil && !article.content!.isEmpty
        }
        
        return PageView(filteredTopHeadlines.map { TopHeadlinesViewFullScreen(article: $0) })
    }
}
