import SwiftUI

struct Home: View {
    @Environment(\.theme) var theme: Theme
    
    // We don't want observe TabState from here as that would
    // destroy the navigation hierarchy when navigatinng to a movie as
    // it modifies tabState (videoURL)
    var goToTab: (Tab) -> Void = { Globals.tabState.selectedTab = $0 }
    @State var showStatusBarBg = false
    var body: some View {
        VStack(spacing: 0) {
            "Hello Clark".body
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
                .alignX(.leading)
                .leading(.s6)
                .top(.s8)

            "Lets explore your favorite movies".body
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
                .alignX(.leading)
                .leading(.s6)
            
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
        AsyncJSON(url: TmdbApi.popular) { items in
            Carousel(model: items, spacing: .s6) { item in
                Card(
                    image: item.backdrop_path,
                    title: item.title,
                    genres:  nil // @todo
                )
                .leading(items.first?.id == item.id ? 24 : 0)
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
        
        TwoColumnsGrid.from(FeaturedGenre.allCases) { item in
            GenreButton(model: item)
                .onTap(navigateTo: Movies(url: TmdbApi.genre(id: item.id)))
                .buttonStyle(ScaleDownButtonStyle())
        }
        .horizontal(.s6)
    }
    
    @ViewBuilder
    var nowPlayingSection: some View {
        title("Now playing")
        AsyncJSON(url: TmdbApi.now_playing) { items in
            TwoColumnsGrid.from(items) { item in
                poster(path: item.poster_path)
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
            .bottom(.s4)
            .top(.s8)
    }
}

private extension Home {
    
    func poster(path: String) -> some View {
        
        AsyncImage(url: path.movieImageURL) { image in
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
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
        }
    }
}
