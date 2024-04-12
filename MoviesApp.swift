import SwiftUI

let states = GlobalStates()

final class GlobalStates: ObservableObject {
    @Published var videoURL: URL?
}

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            Tabbar()
                .onAppear(perform: hideBackButtonLabel)
                .onAppear(perform: hideTabbar)
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
