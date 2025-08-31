# InvisibleTabView Component Usage Guide

## Overview
`InvisibleTabView` is a custom component that provides all the functionality
of SwiftUI's native TabView, but with a completely invisible tab bar.

## Recommended Use Cases
- When you need tab navigation but with a custom UI
- To create custom navigation bars
- When you want complete control over visual appearance
- To implement non-standard navigation patterns

## Basic Example
```swift
enum TabType: CaseIterable, Hashable {
    case home, search, profile
}

@State private var selectedTab: TabType = .home

InvisibleTabView(
    selection: $selectedTab,
    tabs: [
        (.home, AnyView(HomeView())),
        (.search, AnyView(SearchView())),
        (.profile, AnyView(ProfileView()))
    ]
)
```

## Advanced Example with Custom Control
```swift
struct CustomTabView: View {
    @State private var selectedTab: AppTab = .main
    
    var body: some View {
        ZStack {
            // The tab content (invisible)
            InvisibleTabView(
                selection: $selectedTab,
                tabs: [
                    (.main, AnyView(MainView())),
                    (.pomodoro, AnyView(PomodoroView())),
                    (.planning, AnyView(PlanningView()))
                ]
            )
            
            // Your custom navigation bar
            VStack {
                Spacer()
                CustomTabBar(selection: $selectedTab)
            }
        }
    }
}
```

## Technical Considerations

### Supported Types
Any type that conforms to `Hashable` can be used as an identifier:
- `String`, `Int`, `UUID`
- Custom enums that conform to `Hashable`
- Structs that implement `Hashable`

### Performance
- Lazy loading: Views are only created when accessed
- Reuse: Views are kept in memory for fast navigation
- No overhead: Minimal performance impact compared to native TabView

### Limitations
1. All views must be wrapped in `AnyView`
2. Does not include automatic transition animations
3. Requires manual handling of navigation UI

## Integration with Existing Architectures

### MVVM
```swift
class TabViewModel: ObservableObject {
    @Published var selectedTab: TabType = .home
    
    func selectTab(_ tab: TabType) {
        selectedTab = tab
    }
}
```

### Coordinator Pattern
```swift
class AppCoordinator: ObservableObject {
    @Published var currentTab: AppTab = .main
    
    func navigateToTab(_ tab: AppTab) {
        currentTab = tab
    }
}
```

- Important: Always synchronize state between your custom UI and the InvisibleTabView
- Note: The component automatically maintains system gesture navigation
- Warning: Do not mix this component with native TabView in the same view hierarchy

## License
This project is licensed under the MIT License.

## Author
Created by Alexandru Blaga - [LinkedIn](https://www.linkedin.com/in/alexandrublaga/)
