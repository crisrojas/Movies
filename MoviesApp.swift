import SwiftUI

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            Tabbar()
                .onAppear(perform: hideBackButtonLabel)
                .onAppear(perform: hideTabbar)
                .accentColor(.sky900)
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


enum Tab: String, CaseIterable {
    case home
    case favorites
    case centralButton
    case stars
    case profile
    
    var systemName: String {
        switch self {
        case .home: return "house"
        case .favorites: return "heart"
        case .centralButton: return "popcorn"
        case .stars: return "star"
        case .profile: return "person"
        }
    }
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .home: Home()
        case .centralButton: Genres()
        default: self.rawValue
        }
    }
}

struct Tabbar: View {
    @State var selected: Tab = .home
    
    var body: some View {
        VStack(spacing: 0) {
            tabs
            customTabbar
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var tabs: some View {
        TabView(selection: $selected) {
            
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.screen.navigationify()
                    .tabItem {
                        Label(tab.rawValue, systemImage: tab.systemName)
                    }
                    .tag(tab)
            }
        }
    }
    
    var customTabbar: some View {
        VStack {
            HStack {
                Spacer()
                ForEach(Tab.allCases, id: \.self) { tab in
                    Spacer()
                    if tab != .centralButton {
                        defaultItem(tab)
                    } else {
                        CentralButton(tab: tab)
                            .onTap { selected = tab }
                    }
                    
                    Spacer()
                }
                Spacer()
            }
            .frame(height: .s14)
           
            Rectangle()
                .frame(height: safeAreaInsetsBottom)
                .foregroundColor(.white)
        }
        .background(.white)
    }
    
    func defaultItem(_ tab: Tab) -> some View {
        Item(name: tab.rawValue, systemImage: tab.systemName)
            .opacity(selected == tab ? 1 : 0.3)
            .onTap {
                selected = tab
            }
    }
    
    var safeAreaInsetsBottom: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return 0
        }
        
        return windowScene.windows.first?.safeAreaInsets.bottom ?? 0
    }
}

extension Tabbar {
    struct CentralButton: View {
        let tab: Tab
        var body: some View {
            Circle()
                .size(.s16)
                .foregroundColor(.teal400)
                .shadow(color: .teal400.opacity(0.5), radius: 10)
                .overlay(symbol)
                .background(
                    Circle()
                        .foregroundColor(.white)
                        .size(.s20)
                )
                .offset(y: -.s3h)
        }
        
        var symbol: some View {
            Image(systemName: tab.systemName)
                .modify {
                    if #available(iOS 16.0, *) {
                        $0.fontWeight(.bold)
                    }
                }
                .foregroundColor(.white)
                .scaleEffect(1.3)
        }
    }
}

extension Tabbar {
    struct Item: View {
        let name: String
        let systemImage: String
        
        var body: some View {
            VStack {
                Image(systemName: systemImage)
                    .scaleEffect(1.3)
            }
            .accessibilityLabel(name)
        }
    }
}
