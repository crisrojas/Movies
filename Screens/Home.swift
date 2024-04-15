import SwiftUI

struct Home: View {
    @Environment(\.theme) var theme: Theme
    
    // We don't want observe TabState from here as that would
    // destroy the navigation hierarchy when navigatinng to a movie as
    // it modifies tabState (videoURL)
    var goToTab: (Tab) -> Void = { Globals.tabState.selectedTab = $0 }
    @State var showStatusBarBg = false
    var body: some View {
        VStack {
            "Hello Clark".body
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
                .alignX(.leading)
                .leading(.s6)
                .top(.s16)

            "Lets explore your favorite movies".body
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
                .alignX(.leading)
                .leading(.s6)
                .top(.s2)
            
            popularSection
            genresSection
            nowPlayingSection
        }
        .scrollify { showStatusBarBg = $0 >= 40 }
        .statusBarBackground(showStatusBarBg ? .ultraThin : nil)
        .animation(.easeInOut(duration: 0.4), value: showStatusBarBg)
        .background(DefaultBackground())
    }
    
    @ViewBuilder
    var popularSection: some View {
        title("Popular movies")
            .top(.s8)
            .bottom(.s6)
        
        AsyncJSON(url: TMDb.popular) { items in
            Carousel(model: items.results, spacing: .s6) { item in
                Backdrop(props: item)
                .leading(items.results.array.first?.id == item.id ? 24 : 0)
                .onTap(navigateTo: Movie(props: item))
                .buttonStyle(ScaleDownButtonStyle())
            }
        }
    }
    
    @ViewBuilder
    var genresSection: some View {
        HStack {
            title("Categories")
            Spacer()
            Heading(text: "View all")
                .onTap { goToTab(.button) }
                .trailing(.s6)
        }
        .top(.s8)
        .bottom(.s6)
        
        TwoColumnsGrid.from(FeaturedGenre.allCases) { item in
            GenreButton(model: item)
                .onTap(navigateTo: Movies(url: TMDb.genre(id: item.id)))
                .buttonStyle(ScaleDownButtonStyle())
        }
        .horizontal(.s6)
    }
    
    @ViewBuilder
    var nowPlayingSection: some View {
        title("Now playing")
            .top(.s8)
            .bottom(.s6)
        
        AsyncJSON(url: TMDb.now_playing) { items in
            TwoColumnsGrid.from(items.results) { item in
                poster(path: item.poster_path.stringValue)
                    .onTap(navigateTo: Movie(props: item))
                    .buttonStyle(ScaleDownButtonStyle())
            }
        }
        .horizontal(.s6)
    }
    
    func title(_ text: String) -> some View {
        Heading(text: text)
            .alignX(.leading)
            .leading(.s6)
    }
}

private extension Home {
    
    func poster(path: String) -> some View {
        
        AsyncImage(url: path.tmdbImageURL) { image in
            image
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(210/297, contentMode: .fit)
                
        } placeholder: {
            gridImagePlaceholder
        }
        .cornerRadius(.s3)
    }
    
    
    var gridImagePlaceholder: some View {
        theme.imgPlaceholder
            .frame(maxWidth: .infinity)
            .aspectRatio(210/297, contentMode: .fill)
            .overlay(ProgressView())
    }
    
    struct Heading: View {
        @Environment(\.theme) var theme: Theme
        let text: String
        var body: Text {
            Text(text)
                .font(.system(.body, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
        }
    }
}
