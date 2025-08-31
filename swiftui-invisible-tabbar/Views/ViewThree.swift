//
//  ViewThree.swift
//  swiftui-invisible-tabbar
//
//  Created by alex on 31/8/25.
//

import Foundation
import SwiftUI

struct ViewThree: View {
    
    // MARK: - Properties
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                Text("Hello, \(Self.self)")
                Text("We can mantain the state of the view like the native TabView due behind the scenes is using the UIKit TabBar")
                List {
                    ForEach(1..<100) { item in
                        Text("List item \(item)")
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
            }
            .padding(.horizontal, 32)
        }
    }
}
