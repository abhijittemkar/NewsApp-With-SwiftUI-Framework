//
//  WindView.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Abhijit Temkar on 21/03/24.
//  Copyright © 2024 Алексей Воронов. All rights reserved.
//

import Foundation
import SwiftUI

struct WindView: View {
    let angle: Int
    let speed: String
    
    var body: some View {
        VStack {
            Image(systemName: "arrow.down.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(Double(angle)), anchor: .center)
            
            Text("\(speed) km/h")
                .font(.caption)
        }
    }
}
