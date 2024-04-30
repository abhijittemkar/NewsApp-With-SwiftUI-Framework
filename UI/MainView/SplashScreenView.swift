//
//  SplashScreenView.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Abhijit Temkar on 31/03/24.
//  Copyright © 2024 Алексей Воронов. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import WebKit
import CoreData

struct splashscreenDemoApp: App {
    @State private var isSplashScreenDisplayed = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isSplashScreenDisplayed {
                    SplashScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                // Transition to the main content after 5 seconds
                                isSplashScreenDisplayed = false
                            }
                        }
                } else {
                    MainView()
                }
            }
        }
    }
}

struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        guard let url = Bundle.main.url(forResource: gifName, withExtension: "gif") else {
            return webView
        }
        webView.loadFileURL(url, allowingReadAccessTo: url)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct SplashScreenView: View {
    var body: some View {
        GeometryReader { geometry in
                GIFView(gifName: "splash_animation2")
                    .edgesIgnoringSafeArea(.all)
                    .padding(.top, -110)
        }
    }
}

