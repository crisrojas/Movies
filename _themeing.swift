//
//  _themeing.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 11/04/2024.
//

import SwiftUI


extension ColorScheme {
    var theme: Theme {
        switch self {
        case .dark: return .dark
        default: return .light
        }
    }
}

enum Scheme: String {
    case light
    case dark
    case system
}


extension Scheme {
    
    // @todo
    var label: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "Automatic"
        }
    }
    

    
    var theme: Theme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system:
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return .dark
            } else {
                return .light
            }
        }
    }
    
    var systemScheme: ColorScheme {
        if UITraitCollection.current.userInterfaceStyle == .dark { return .dark }
        else { return .light }
    }
    
    var colorScheme: ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return systemScheme
        }
    }
}

struct Theme: Equatable {
    var accent: Color = .teal900
    var textPrimary: Color = .sky900
    var tabbarBg: Color = .white
    
    var gradientFirst: Color = .teal600
    var gradientSecond: Color = .teal50
    
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

extension View {
    func theme(_ theme: Theme) -> some View {
        self.environment(\.theme, theme)
    }
}
