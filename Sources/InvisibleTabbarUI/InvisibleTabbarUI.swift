// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import UIKit

// MARK: - InvisibleTabView (Generic Component)

/**
 A custom component that provides completely invisible tab functionality.
 
 `InvisibleTabView` is a wrapper around `UITabBarController` that completely hides the
 native tab bar while maintaining all tab navigation functionality. It is completely generic
 and can work with any type that conforms to `Hashable` as a tab identifier.
 
 ## Key Features:
 - Completely invisible TabBar (no visual elements)
 - Simple and clean API with array of tuples
 - Completely generic and reusable
 - Identical functionality to SwiftUI's native TabView
 - No generic extension conflicts
 - Support for any Hashable type as identifier
 
 ## Usage Example:
 ```swift
 enum MyTabType: CaseIterable, Hashable {
     case home, settings, profile
 }
 
 @State private var selectedTab: MyTabType = .home
 
 InvisibleTabView(
     selection: $selectedTab,
     tabs: [
         (.home, AnyView(HomeView())),
         (.settings, AnyView(SettingsView())),
         (.profile, AnyView(ProfileView()))
     ]
 )
 ```
 
 - Important: All views must be wrapped in `AnyView` for type conversion.
 - Note: The component automatically maintains bidirectional synchronization of selection state.
 */
public struct InvisibleTabView<SelectionValue: Hashable>: UIViewControllerRepresentable {
    
    // MARK: - Properties
    
    /// Binding that controls which tab is currently selected
    @Binding var selection: SelectionValue
    
    /// Array of tuples that defines the available tabs and their corresponding views
    let tabs: [(SelectionValue, AnyView)]
    
    // MARK: - Initializer
    
    /**
     Initializes a new InvisibleTabView.
     
     - Parameters:
        - selection: A binding to the value that identifies the currently selected tab
        - tabs: Array of tuples where each tuple contains a tab identifier and the view to display
     
     ## Example:
     ```swift
     InvisibleTabView(
         selection: $currentTab,
         tabs: [
             (.tab1, AnyView(FirstView())),
             (.tab2, AnyView(SecondView()))
         ]
     )
     ```
     */
    public init(selection: Binding<SelectionValue>, tabs: [(SelectionValue, AnyView)]) {
        self._selection = selection
        self.tabs = tabs
    }
    
    // MARK: - UIViewControllerRepresentable
    
    /**
     Creates the underlying UIKit controller.
     
     - Parameter context: The representation context provided by SwiftUI
     - Returns: A new instance of `InvisibleTabController` configured with the specified tabs
     */
    public func makeUIViewController(context: Context) -> InvisibleTabController<SelectionValue> {
        let controller = InvisibleTabController<SelectionValue>()
        controller.setup(tabs: tabs, selection: selection)
        controller.onSelectionChanged = { newSelection in
            selection = newSelection
        }
        return controller
    }
    
    /**
     Updates the UIKit controller when SwiftUI state changes.
     
     - Parameters:
        - uiViewController: The controller to update
        - context: The representation context provided by SwiftUI
     */
    public func updateUIViewController(_ uiViewController: InvisibleTabController<SelectionValue>, context: Context) {
        uiViewController.updateSelection(selection)
    }
}

// MARK: - InvisibleTabController

/**
 Internal UIKit controller that handles invisible tab logic.
 
 This class extends `UITabBarController` but completely hides the tab bar,
 providing only navigation functionality without visual elements.
 
 - Note: This class is for internal use by the `InvisibleTabView` component and should not be instantiated directly.
 */
public class InvisibleTabController<SelectionValue: Hashable>: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    /// Closure that executes when tab selection changes
    var onSelectionChanged: ((SelectionValue) -> Void)?
    
    /// Internal array that maintains tab items and their associated views
    private var tabItems: [(SelectionValue, AnyView)] = []
    
    /// The current selection value
    private var currentSelection: SelectionValue?
    
    // MARK: - Lifecycle
    
    /**
     Configures the controller when the view loads.
     
     Sets up the initial configuration of the invisible tab bar and assigns the delegate.
     */
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupHiddenTabBar()
        delegate = self
    }
    
    // MARK: - Setup Methods
    
    /**
     Configures the tab bar to be completely invisible.
     
     This method:
     - Hides the native tab bar
     - Sets alpha to 0 for complete transparency
     - Removes the visual frame
     - Removes background images and separators
     - Sets transparent background
     */
    private func setupHiddenTabBar() {
        // Hide the native tab bar completely
        tabBar.isHidden = true
        tabBar.alpha = .zero
        tabBar.frame = CGRect.zero
        
        // Remove tab bar background and separators
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = UIColor.clear
    }
    
    /**
     Configures the tabs and initial selection.
     
     - Parameters:
        - tabs: Array of tuples with tab identifiers and their views
        - selection: The initial selection value
     
     This method creates the necessary view controllers and establishes the initial configuration.
     */
    public func setup(tabs: [(SelectionValue, AnyView)], selection: SelectionValue) {
        self.tabItems = tabs
        self.currentSelection = selection
        
        let controllers = tabs.enumerated().map { index, item in
            let controller = UIHostingController(rootView: item.1) // item.1 is the view (AnyView)
            controller.tabBarItem = UITabBarItem(title: nil, image: nil, tag: index)
            return controller
        }
        
        viewControllers = controllers
        updateSelection(selection)
    }
    
    /**
     Updates the current tab selection.
     
     - Parameter newSelection: The new selection value
     
     Searches for the index corresponding to the new selection value and updates
     the tab controller's `selectedIndex` if necessary.
     */
    public func updateSelection(_ newSelection: SelectionValue) {
        currentSelection = newSelection
        if let index = tabItems.firstIndex(where: { $0.0 == newSelection }) { // $0.0 is the identifier
            if selectedIndex != index {
                selectedIndex = index
            }
        }
    }
    
    // MARK: - UITabBarControllerDelegate
    
    /**
     Handles tab selection changes.
     
     - Parameters:
        - tabBarController: The tab bar controller that made the change
        - viewController: The view controller that was selected
     
     When a new tab is selected, this method updates the internal state
     and notifies SwiftUI through the `onSelectionChanged` closure.
     */
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex < tabItems.count {
            let selectedTag = tabItems[selectedIndex].0 // .0 is the identifier
            if selectedTag != currentSelection {
                currentSelection = selectedTag
                onSelectionChanged?(selectedTag)
            }
        }
    }
}
