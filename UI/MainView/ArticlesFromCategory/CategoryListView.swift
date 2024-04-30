// CategoryListView.swift

import SwiftUI

struct CategoryListView: View {
    private var categories: [String] = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    @ObservedObject var viewModel = SearchForArticlesViewModel()
    @State private var userCategories: [String] = UserDefaults.standard.stringArray(forKey: "UserCategories") ?? []
    let tileColors: [Color] = [.blue, .green, .orange, .purple, .pink, .yellow]
    @State private var newCategoryName: String = ""
    @State private var showAlert: Bool = false


    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(categories.indices, id: \.self) { index in
                        NavigationLink(
                            destination: ArticlesFromCategoryView(category: categories[index])
                        ) {
                            SquareCellView(color: tileColors[index % tileColors.count], text: categories[index].localized().capitalizeFirstLetter())
                        }
                    }
                }
                
                Section(header: Text("User Categories")) {
                    ForEach(userCategories.indices, id: \.self) { index in
                        NavigationLink(
                            destination: ArticlesFromUserCategoryView(userCategory: userCategories[index])
                        ) {
                            SquareCellView(color: tileColors[index % tileColors.count], text: userCategories[index].localized().capitalizeFirstLetter())
                        }
                        .contextMenu {
                            Button(action: {
                                removeCategory(at: index)
                            }) {
                                Text("Remove")
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                
                Section(header: Text("Add New Category").font(.headline)) {
                    VStack(alignment: .leading) {
                        TextField("New Category Name", text: $newCategoryName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                            .padding(.bottom, 8)
                        
                        Button(action: addCategory) {
                            Text("Add")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 8)
                }

            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("Categories".localized()), displayMode: .large)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Category Exists"),
                    message: Text("The category already exists."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func addCategory() {
        guard !newCategoryName.isEmpty else { return }

        if userCategories.contains(newCategoryName) {
            // Category already exists, show an alert
            showAlert = true
        } else {
            // Category doesn't exist, add it
            userCategories.append(newCategoryName)
            UserDefaults.standard.set(userCategories, forKey: "UserCategories")
            newCategoryName = "" // Clear the text field
        }
    }
       
    
    
    private func removeCategory(at index: Int) {
        userCategories.remove(at: index)
        UserDefaults.standard.set(userCategories, forKey: "UserCategories")
    }
}






struct SquareCellView: View {
    var color: Color
    var text: String
    
    var body: some View {
        ZStack {
            color
                .cornerRadius(10)
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding(10)
        }
    }
}

