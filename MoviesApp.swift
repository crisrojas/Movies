import SwiftUI

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
                .onAppear(perform: hideBackButtonLabel)
                .accentColor(.sky900)
        }
    }
}

fileprivate func hideBackButtonLabel() {
    let backButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
    backButton.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    backButton.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
}

