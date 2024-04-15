//
//  _themeing.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 11/04/2024.
//

import SwiftUI

struct Schemer<Content: View>: View {
    @AppStorage("colorScheme") var scheme: ColorScheme?
    @Environment(\.colorScheme) var colorScheme
    var theme: Theme { (scheme ?? colorScheme).theme }
    var content: () -> Content
    var body: some View {
        content()
            .environment(\.theme, theme)
            .ifLet(scheme) { $0.preferredColorScheme($1) }
    }
}


// RawRepresentable conformance so we can persist to UserDefaults:
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

extension ColorScheme {
    var theme: Theme {
        switch self {
        case .dark: return .dark
        default: return .light
        }
    }
}

struct Theme: Equatable {
    var accent: Color = .sky900
    var textPrimary: Color = .sky900
    var tabbarBg: Color = .white
    
    var gradientFirst: Color = .teal600
    var gradientSecond: Color = .teal50
    
    var imgPlaceholder: Color = .neutral200
    
    var circleButtonDefault: Color = .teal400
    var circleButtonSecondary: Color = .orange400
    
    var gradient: Gradient {
        .init(colors: [gradientFirst.opacity(0.7), gradientSecond])
    }
    
    var secondGradient: Gradient {
        .init(colors: [Color.clear, tabbarBg])
    }
    
    static let light = Theme()
    static let dark = Theme() * {
        $0.accent = .white
        $0.textPrimary = .white
        $0.tabbarBg = .black
        $0.gradientFirst = .teal900
        $0.gradientSecond = .black
        $0.imgPlaceholder = .neutral800
    }
}

struct ThemeProviderKey: EnvironmentKey {
    static var defaultValue: Theme = .light
}


extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeProviderKey.self] }
        set { self[ThemeProviderKey.self] = newValue }
    }
}
