//
//  ContentView.swift
//  swiftui-invisible-tabbar
//
//  Created by alex on 31/8/25.
//

import SwiftUI

// MARK: - Enum

enum NumberTab: Hashable {
    case one
    case two
    case three
}

// MARK: - View

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var selectedTab: NumberTab = .one
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            InvisibleTabView(selection: $selectedTab,
                             tabs: [
                                (NumberTab.one, AnyView(ViewOne())),
                                (NumberTab.two, AnyView(ViewTwo())),
                                (NumberTab.three, AnyView(ViewThree())),
                             ])
            .ignoresSafeArea()
            HStack {
                Spacer()
                customDesignTabView
            }
        }
    }
}

// MARK: - Private Views

private extension ContentView {
    @ViewBuilder var customDesignTabView: some View {
        VStack {
            buttonAction(icon: .init(systemName: "triangle"),
                         isSelected: selectedTab == .one,
                         color: .red) {
                selectedTab = .one
            }
            buttonAction(icon: .init(systemName: "circle"),
                         isSelected: selectedTab == .two,
                         color: .yellow) {
                selectedTab = .two
            }
            buttonAction(icon: .init(systemName: "square"),
                         isSelected: selectedTab == .three,
                         color: .blue) {
                selectedTab = .three
            }
        }
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 24.0))
        .padding()
        
    }
    
    @ViewBuilder func buttonAction(icon: Image,
                                   isSelected: Bool,
                                   color: Color,
                                   action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24.0,
                           height: 24.0,
                           alignment: .center)
                    .foregroundStyle(color)
                    .fontWeight(.bold)
                    .padding(5)
                    .background(isSelected ? color.opacity(0.3) : .clear)
                    .clipShape(Circle())
                    
            }
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
