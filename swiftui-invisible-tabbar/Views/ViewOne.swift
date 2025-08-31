//
//  ViewOne.swift
//  swiftui-invisible-tabbar
//
//  Created by alex on 31/8/25.
//

import Foundation
import SwiftUI

struct ViewOne: View {
    
    // MARK: - Properties
    
    @State private var text: String = "Hello, coden0w"
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            VStack {
                Text("Hello, \(Self.self)")
                Text("We can mantain the state of the view like the native TabView due behind the scenes is using the UIKit TabBar")
                TextField("", text: $text)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
}
