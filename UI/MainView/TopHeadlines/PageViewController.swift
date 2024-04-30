//  PageViewController.swift


import SwiftUI
import UIKit
import CoreData

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .vertical)
        
        pageViewController.dataSource = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        if !controllers.isEmpty {
            pageViewController.setViewControllers(
                [controllers[0]], direction: .forward, animated: true)
        } else {
            // Show message when there are no articles in favorites
            pageViewController.setViewControllers(
                [UIHostingController(rootView: Text("No articles in favorites"))], direction: .forward, animated: true)
        }
    }
    

    
    class Coordinator: NSObject, UIPageViewControllerDataSource {
        private let parent: PageViewController
        
        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return parent.controllers.last
            }
            return parent.controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            return parent.controllers[index + 1]
        }
    }
}
