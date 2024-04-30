//  TabView.swift


import SwiftUI

struct TabedView : View {
    @Environment(\.colorScheme) var colorScheme
    private let context = CoreDataManager.shared.managedObjectContext
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "globe")
                        .font(.system(size: 22))
                }
            
            CategoryListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 22))
                }
            
            SearchForArticlesView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22))
                }
            
            FavoritesView()
                .environment(\.managedObjectContext, context)
                .tabItem {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 22))
                }
            
            WeatherView()
                .tabItem {
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 22))
                }
        }
        .accentColor(colorScheme == .dark ? .white : .black)
    }
}
