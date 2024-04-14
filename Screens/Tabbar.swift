//
//  Tabbar.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 12/04/2024.
//

import SwiftUI
import SafariServices

enum Tab: String, CaseIterable {
    case home
    case favorites
    case button
    case stars
    case profile
    
    var systemName: String {
        switch self {
        case .home: return "house"
        case .favorites: return "heart"
        case .button: return "popcorn"
        case .stars: return "star"
        case .profile: return "person"
        }
    }
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .home     : Home()
        case .button   : Genres()
        case .profile  : Profile()
        case .favorites: Favorites()
        default: self.rawValue
        }
    }
}

struct Tabbar: View {
    
    @StateObject var states = tabStates
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(spacing: 0) {
            tabs
            customTabbar
        }
        .accentColor(theme.accent)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var tabs: some View {
        TabView(selection: $states.selectedTab) {
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
                    if tab != .button {
                        defaultItem(tab)
                    } else {
                        CentralButton(videoURL: states.videoURL)
                        .onTap {
                            if let videoURL = states.videoURL {
                                presentVideo(url: videoURL)
                            } else {
                                states.selectedTab = tab
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
            .opacity(states.selectedTab == tab ? 1 : 0.3)
            .foregroundColor(theme.textPrimary)
            .onTap { states.selectedTab = tab }
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
        @StateObject var _tabStates = tabStates
        @Environment(\.theme) var theme: Theme
        let videoURL: URL?
        
        var symbolName: String {
            videoURL == nil ? "popcorn" : "play.circle"
        }
        
        var color: Color {
            videoURL == nil ? (_tabStates.selectedTab == .button ? .orange400 : .teal400) : .orange400 // @todo: put in environment theme ? @todo selecetedtab not working
        }
        
        var body: some View {
            Circle()
                .size(.s16)
                .foregroundColor(color)
                .shadow(color: color.opacity(0.5), radius: 10)
                .animation(.easeInOut, value: _tabStates.selectedTab)
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
