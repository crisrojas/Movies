import SwiftUI
import SafariServices

let states = GlobalStates()

infix operator *: AdditionPrecedence
func * <T>(lhs: T, rhs: (inout T) -> Void) -> T {
    var copy = lhs
    rhs(&copy)
    return copy
}

final class GlobalStates: ObservableObject {
    @Published var videoURL: URL?
}


enum FileBase {
    static let favorites = FileResource("favorites")
    static let ratings   = FileResource("ratings")
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
        case .profile: Profile()
        case .favorites: Favorites()
        default: self.rawValue
        }
    }
}

struct Favorites: View {
    @StateObject var favorites = FileBase.favorites
    var body: some View {
        List(favorites.data.array, id: \.id) { item in
            Text(item.title)
        }
    }
}


struct Profile: View {
    @AppStorage("colorScheme") var preferredScheme: ColorScheme?
    @Environment(\.colorScheme) var colorScheme
  
    @Environment(\.theme) var theme
    var body: some View {
        List {
            
            Section("Appearance") {
                systemRow
                row(scheme: .light)
                row(scheme: .dark)
            }
        }
    }
    
    var systemRow: some View {
        HStack(spacing: .s4) {
            systemRectangle
            "Automatic".body.fontWeight(.bold).foregroundColor(theme.textPrimary)
            Spacer()
            if preferredScheme == nil {
                checkmark
            }
        }
        .onTap {
           preferredScheme = nil
        }
    }
    
    var systemRectangle: some View {
        ZStack{
            rectangle(scheme: .light)
            rectangle(scheme: .dark)
                .clipShape(
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: .s7))
                        path.addLine(to: CGPoint(x: .s7, y: 0))
                        path.addLine(to: CGPoint(x: .s7, y: .s7))
                        path.closeSubpath()
                    }
                )
        }
    }
    
    var superior: some View {
        Rectangle()
            .frame(width: 200, height: 200)
            .foregroundColor(.blue)
            .clipShape(
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 200))
                    path.addLine(to: CGPoint(x: 200, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 0))
                    path.closeSubpath()
                }
            )

    }
    
    var inferior: some View {
        Rectangle()
            .frame(width: 200, height: 200)
            .foregroundColor(.blue)
            .clipShape(
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 200))
                    path.addLine(to: CGPoint(x: 200, y: 0))
                    path.addLine(to: CGPoint(x: 200, y: 200))
                    path.closeSubpath()
                }
            )
    }
    
    // @todo: find better name
    func rectangle(scheme: ColorScheme) -> some View {
        Rectangle()
            .size(.s7)
            .foregroundColor(scheme == .dark ? .black : .white)
            .cornerRadius(.s1)
            .overlay("A".font(.title2).foregroundColor(scheme == .dark ? .white : .black))
            .background(
                Rectangle()
                    .foregroundColor(scheme == .dark ? .stone900 : .stone400)
                    .cornerRadius(.s1h)
                    .size(.s8)
            )
    }

    func row(scheme: ColorScheme) -> some View {
        HStack(spacing: .s4) {
           rectangle(scheme: scheme)
            (scheme == .dark ? "Dark" : "Light").body.fontWeight(.bold).foregroundColor(theme.textPrimary)
            Spacer()
            if preferredScheme == scheme {
                checkmark
            }
        }
        .onTap {
            preferredScheme = scheme
        }

    }
    
    var checkmark: some View {
        Image(systemName: "checkmark")
            .foregroundColor(.blue500)
            .modify {
                if #available(iOS 16.0, *) {
                    $0.fontWeight(.bold)
                }
            }
    }
}

extension ColorScheme: RawRepresentable {
    public var rawValue: String {
        switch self {
        case .light: return "light"
        case .dark: return "dark"
        default: return "unknown"
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case "light": self = .light
        case "dark": self = .dark
        default: return nil
        }
    }
}

struct Tabbar: View {
    
    @StateObject var globals = states
    @State var selected: Tab = .home
    
    @AppStorage("colorScheme") var scheme: ColorScheme?
    @Environment(\.colorScheme) var colorScheme
    var theme: Theme {
       (scheme ?? colorScheme).theme
    }
    
    var body: some View {
        VStack(spacing: 0) {
            tabs
            customTabbar
        }
        .edgesIgnoringSafeArea(.bottom)
        .environment(\.theme, theme)
        .ifLet(scheme) { view, colorScheme in
            view.preferredColorScheme(colorScheme)
        }
    }
    
    var tabs: some View {
        TabView(selection: $selected) {
            
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.screen
                    .navigationify()
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
                        CentralButton(videoURL: globals.videoURL)
                        .onTap {
                            if let videoURL = globals.videoURL {
                                presentVideo(url: videoURL)
                            } else {
                                selected = tab
                            }
                        }
                    }
                    
                    Spacer()
                }
                Spacer()
            }
            .frame(height: .s14)
           
            Rectangle()
                .frame(height: safeAreaInsetsBottom)
                .foregroundColor(theme.tabbarBg)
        }
        .background(theme.tabbarBg)
    }
    
    func defaultItem(_ tab: Tab) -> some View {
        Item(name: tab.rawValue, systemImage: tab.systemName)
            .opacity(selected == tab ? 1 : 0.3)
            .foregroundColor(theme.textPrimary)
            .onTap {
                selected = tab
            }
    }
    
    func presentVideo(url: URL) {
        
        let safariViewController = SFSafariViewController(url: url)
        UIApplication.shared.windows.first?.rootViewController?.present(safariViewController, animated: true, completion: nil)
        
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
        @Environment(\.theme) var theme: Theme
        let videoURL: URL?
        
        var symbolName: String {
            videoURL == nil ? "popcorn" : "play.circle"
        }
        
        var color: Color {
            videoURL == nil ? .teal400 : .orange400
        }
        var body: some View {
            Circle()
                .size(.s16)
                .foregroundColor(color)
                .shadow(color: color.opacity(0.5), radius: 10)
                .overlay(symbol)
                .background(
                    Circle()
                        .foregroundColor(theme.tabbarBg)
                        .size(.s20)
                )
                .offset(y: -.s3h)
                .animation(.linear, value: videoURL == nil)
        }
        
        var symbol: some View {
            Image(systemName: symbolName)
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
