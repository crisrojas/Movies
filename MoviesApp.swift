import SwiftUI

let tabStates = TabStates()

final class TabStates: ObservableObject {
    @Published var videoURL: URL?
    @Published var selectedTab = Tab.home
}

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            Schemer {
                Tabbar()
                    .onAppear(perform: hideBackButtonLabel)
                    .onAppear(perform: hideTabbar)
            }
        }
    }
}

fileprivate func hideBackButtonLabel() {
    let backButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
    backButton.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    backButton.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
}

fileprivate func hideTabbar() {
   UITabBar.appearance().isHidden = true
}
