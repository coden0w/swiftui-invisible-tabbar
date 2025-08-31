//
//  ViewTwo.swift
//  swiftui-invisible-tabbar
//
//  Created by alex on 31/8/25.
//

import Foundation
import SwiftUI

struct ViewTwo: View {
    
    // MARK: - Properties
    
    @State private var isSwitchOn: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
            VStack {
                Text("Hello, \(Self.self)")
                    .fontWeight(.bold)
                Toggle("Now is \(isSwitchOn ? "On" : "Off")", isOn: $isSwitchOn)
                    .tint(Color.purple)
                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
}
