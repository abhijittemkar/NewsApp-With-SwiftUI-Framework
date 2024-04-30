//  SearchBarView.swift


import SwiftUI
import UIKit

struct SearchBarView: UIViewRepresentable {
    
    @Binding var text: String
    var onSearch: () -> Void // Closure to handle search action
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onSearch: onSearch)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator // Set the delegate
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = Constants.placeholder
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text // Update search bar text when text binding changes
    }
}

extension SearchBarView {
    
    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        var onSearch: () -> Void

        init(text: Binding<String>, onSearch: @escaping () -> Void) {
            _text = text
            self.onSearch = onSearch
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            if let searchText = searchBar.text {
                text = searchText // Update the binding with the search text
                onSearch() // Trigger search action when search button is clicked
            }
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                // Handle the clearing of text
                if searchText.isEmpty {
                    text = searchText // Update the binding with the empty search text
                    onSearch() // Trigger search action when text is cleared
                }
            }
    }

}



private extension SearchBarView {
    
    struct Constants {
        static let placeholder = "Search".localized()
    }
}
