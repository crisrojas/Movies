import SwiftUI

struct Home: View {
    
    var body: some View {
        VStack(spacing: 0) {
            "Hello Clark".body
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.sky900)
                .alignX(.leading)
                .leading(.s6)
                .top(.s8)
            
            "Lets explore your favorite movies".body
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.sky900)
                .alignX(.leading)
                .leading(.s6)
            
            popularSection
            genresSection
            nowPlayingSection
        }
        .scrollify()
        .background(DefaultBackground())
        .navigationify()
    }
    
    @ViewBuilder
    var popularSection: some View {
        title("Popular movies")
        JSON(url: TmdbApi.popular) { items in
            Carousel(model: items, spacing: .s6) { item in
                Card(
                    image: item.backdrop_path,
                    title: item.title,
                    genres:  nil // @todo
                )
                .leading(items.first?.id == item.id ? 24 : 0)
                .onTap(navigateTo: Movie(props: item))
            }
        }
    }
    
    @ViewBuilder
    var genresSection: some View {
        HStack {
            title("Categories")
            Spacer()
            Heading(text: "View all")
                .onTap(navigateTo: Genres())
                .trailing(.s6)
        }
        
        TwoColumnsGrid.from(FeaturedGenre.allCases) { item in
            GenreButton(model: item)
                .onTap(navigateTo: Movies(url: TmdbApi.genre(id: item.id)))
        }
        .horizontal(.s6)
    }
    
    @ViewBuilder
    var nowPlayingSection: some View {
        title("Now playing")
        JSON(url: TmdbApi.now_playing) { items in
            TwoColumnsGrid.from(items) { item in
                backdrop(path: item.backdrop_path)
                    .onTap(navigateTo: Movie(props: item))
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
    
    func backdrop(path: String) -> some View {
        
        AsyncImage(url: path.backdropURL) { image in
            image
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(210/297, contentMode: .fill)
                .cornerRadius(10)
        } placeholder: {
            gridImagePlaceholder
        }
    }
    
    
    var gridImagePlaceholder: some View {
        Color.neutral300
            .frame(maxWidth: .infinity)
            .aspectRatio(210/297, contentMode: .fill)
            .cornerRadius(10)
            .overlay(ProgressView())
    }
    
    struct Heading: View {
        let text: String
        var body: Text {
            Text(text)
                .fontWeight(.bold)
                .foregroundColor(.sky900)
        }
    }
}
