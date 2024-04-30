//
//  DataRefreshManager.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Abhijit Temkar on 07/04/24.
//  Copyright © 2024 Алексей Воронов. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class DataRefreshManager: ObservableObject {
    @Published var refreshData = false
    
    func refresh() {
        refreshData.toggle()
    }
}
