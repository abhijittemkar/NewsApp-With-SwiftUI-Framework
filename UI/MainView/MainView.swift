import SwiftUI
import UIKit
import WebKit

struct MainView : View {
    @ObservedObject var viewModel = MainViewModel()
    @State private var isFullScreen: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.topHeadlines.isEmpty {
                    ProgressView("Please check data connection and try again...")
                } else {
                    if isFullScreen {
                        TopHeadlinesFSView(topHeadlines: viewModel.topHeadlines)
                            .clipped()
                            .listRowInsets(EdgeInsets())
                    } else {
                        TopHeadlinesView(topHeadlines: viewModel.topHeadlines)
                            .clipped()
                            .listRowInsets(EdgeInsets())
                    }
                }
            }
            .onAppear {
                self.viewModel.getTopHeadlines()
            }
            .navigationBarTitle(Text("Top Headlines".localized()), displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        isFullScreen.toggle()
            }) {
                Image(systemName: isFullScreen ? "rectangle.fill.on.rectangle.angled.fill" : "rectangle.grid.1x2.fill")
                    .imageScale(.large)
                    .foregroundColor(.primary)
                    .padding()
            })
        }
    }
}
