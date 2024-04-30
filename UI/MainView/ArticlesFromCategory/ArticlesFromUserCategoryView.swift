//
//  ArticlesFromUserCategoryView.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Abhijit Temkar on 06/04/24.
//  Copyright © 2024 Алексей Воронов. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit


    struct ArticlesFromUserCategoryView : View {
        @ObservedObject var viewModel = ArticlesFromUserCategoryViewModel()
        @State private var isFullScreen: Bool = false
        @State private var isTitleExpanded: Bool = false
        
        let userCategory: String
        
        var body: some View {
            NavigationView {
                VStack {
                    if viewModel.articles.isEmpty {
                        ProgressView("Please check data connection and try again...")
                    } else {
                        if isFullScreen {
                            TopHeadlinesFSView(topHeadlines: viewModel.articles)

                        } else {
                            Spacer()
                            ArticlesList(articles: viewModel.articles)
                        }
                    }
                }
            }
            .onAppear {
                self.viewModel.searchForArticles(searchFilter: userCategory) // Pass userCategory here
            }
            .navigationBarTitle(
                Text(userCategory.localized().capitalizeFirstLetter()),
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
