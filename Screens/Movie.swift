//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

struct Movie: View, NetworkGetter {
    
    @StateObject var favorites = FileBase.favorites
    var setTabVideoURL: (URL?) -> Void = { Globals.tabState.videoURL = $0 }
    
    let props: JSON
    var body: some View {
        VStack {
            Header(props: props) * {
                $0.isFavorite = favorites.contains(props.id.string ?? "")
                $0.toggleFavorite = toggleFavorite
            }
            InfoStack(props: props).top(.s6)
            StoryLine(props: props).top(.s9)
            castSection().vertical(.s9)
        }
        .horizontal(.s6)
        .scrollify()
        .background(background.fullScreen())
        .task { await getTrailerURL() }
        .onDisappear { setTabVideoURL(nil) }
    }
    
    
    func toggleFavorite() {
        if favorites.contains(props.id.stringValue) {
            favorites.delete(props)
        } else {
            favorites.add(props)
        }
    }

    func getTrailerURL() async {
        let url = TMDb.videos(id: props.id.intValue)
        if let (data, _) = try? await fetchData(url: url) {
            let first = try? JSON(data: data).results.array.first
            if let key = first?.key.stringValue {
                setTabVideoURL(youtubeURL(key: key))
            }
        }
    }
    
    var background: Background {
        Background(url: props.backdrop_path.string?.tmdbImageURL)
    }
    
    func castSection() -> some View {
        AsyncJSON(url: TMDb.credits(id: props.id.intValue)) { json in
            Cast(props: json.cast).horizontal(-.s6)
        }
    }
}


// MARK: - Header
extension Movie {
    struct Header: View {
        let id: Int
        let title: String
        let voteAverage: Double
        let posterURL: URL?
        let trailerURL: URL?
        var isFavorite: Bool = false
        var toggleFavorite: () -> Void = {}
        @Environment(\.theme) var theme: Theme
        
        var ratingStars: String { voteAverage.makeRatingStars() }
        
        var voteAverageRounded: String {
            voteAverage.reduceScale(to: 1).description
        }
        
        var body: some View {
            
            VStack {
                
                posterView
                    .onTapScaleDown()
                    .overlay(actions, alignment: .trailing)
                    .top(.s4)
                
                Text(title)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(theme.textPrimary)
                    .top(.s8)
                
                Text(voteAverageRounded)
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(theme.textSecondary)
                    .top(.s3)
                
                Text(ratingStars)
                    .foregroundColor(Color.orange)
                    .top(.s3)
            }
        }
        
        var actions: some View {
            VStack(spacing: .s4) {
                Image(systemName: "heart.fill")
                    .opacity(isFavorite ? 1 : 0.3)
                    .onTap { toggleFavorite() }
                    .buttonStyle(ScaleDownButtonStyle())
                .foregroundColor(isFavorite ? .red600 : theme.textPrimary)
                .animation(.easeInOut, value: isFavorite)
                Image(systemName: "star.fill").opacity(0.3)
                    .onTap { }
                    .buttonStyle(ScaleDownButtonStyle())
            }
            .foregroundColor(theme.textPrimary)
            .offset(x: .s12)
        }
    }
}

private extension Movie.Header {
    var posterView: some View {
        AsyncImage(url: posterURL) { image in
            image.resizable()
        } placeholder: {
            theme.imgPlaceholder
                .overlay(ProgressView())
        }
        .cornerRadius(8)
        .shadow(radius: 8)
        .width(230)
        .height(310)
    }
}


extension Movie.Header {
    init(props: JSON) {
        id = props.id.intValue
        title = props.title.stringValue
        voteAverage = props.vote_average.doubleValue
        posterURL = props.poster_path.string?.tmdbImageURL
        trailerURL = nil//props.trailerURL.url?
        isFavorite = false
    }
}

// MARK: - InfoStack
extension Movie {
    struct InfoStack: View {
        let props: JSON
        
        var duration: String {
            guard props.runtime.intValue > 0 else {
                return "N/A"
            }
            
            return durationFormatter.string(from: TimeInterval(props.runtime.intValue) * 60) ?? "N/A"
        }
        
        var year: String {
            guard let releaseDate = dateFormatter.date(from: props.release_date.stringValue) else {
                return "N/A"
            }
            return yearFormatter.string(from: releaseDate)
        }
        
        
        private let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            return dateFormatter
        }()
        
        private let yearFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter
        }()
        
        private let durationFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .abbreviated
            formatter.allowedUnits = [.hour, .minute]
            return formatter
        }()
        
        var body: some View {
            HStack {
                Info(title: "Length", value: duration)
                Spacer()
                
                Info(title: "Year", value: year)
                Spacer()
                
                Info(title: "Language", value: props.original_language.string ?? "N/A")
                Spacer ()
                
                Info(title: "Vote count", value: "\(props.vote_count.intValue)")
            }
        }
    }
}

extension Movie {
    struct Info: View {
        @Environment(\.theme) var theme: Theme
        let title: String
        let value: String
        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(theme.textPrimary)
                    .fontWeight(.heavy)
                Text(value.uppercased())
                    .fontWeight(.heavy)
                    .foregroundColor(theme.textSecondary)
                    .padding(.top, 5)
            }.font(.footnote)
        }
    }
}

// MARK: - StoryLine
extension Movie {
    struct StoryLine: View {
        @Environment(\.theme) var theme: Theme
        let props: JSON
        var body: some View {
            VStack(
                alignment: .leading,
                spacing: .s5
            ) {
                Text("Storyline")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(theme.textPrimary)

                Text(props.overview.stringValue)
                    .font(.system(.footnote, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(theme.textSecondary)
            }
            .alignX(.leading)
        }
    }
}

struct MovieCast: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let profile_path: String?
    let credit_id: String?
    
    var profileURL: URL? {
        guard let profilePath = profile_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")
    }
}

struct CastResponse: Decodable {
    let cast: [MovieCast]
}
// MARK: - Cast
extension Movie {
    struct Cast: View {
        @Environment(\.theme) var theme: Theme
        let props: JSON
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: .s6) {
                
                Text("Cast")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(theme.textPrimary)
                    .leading(.s6)
                
                Carousel(model: props, spacing: .s2) { item in
                    ActorAvatar(
                        path: item.profile_path.stringValue,
                        id: item.credit_id.string ?? ""
                    )
                    .onTapScaleDown()
                    .leading(item.id == props.first?.id ? .s6 : 0)
                    .trailing(item.id == props.last?.id ? .s6 : 0)
                }
            }
        }
    }
}

extension Movie.Cast {
    struct ActorAvatar: View {
        @Environment(\.theme) var theme
        let path: String
        let id: String?
        var profileURL: URL? {
            URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        
        var body: some View {
            AsyncImage(url: profileURL) { image in
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                
                
            } placeholder: {
                imagePlaceholder
            }
            .size(.s14)
            .cornerRadius(.s2)
        }
        var imagePlaceholder: some View {
            
            theme.imgPlaceholder
                .font(.largeTitle)
                .overlay(Text(randomEmoji()))
        }
        
        func randomEmoji() -> String {
            ["🤓", "😎","🥸","🧐","🤠"][Int.random(in: 0...4)]
        }
    }
}

// MARK: - Background
extension Movie {
    struct Background: View {
        let url: URL?
        
        var body: some View {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .fullScreen()
                    .opacity(0.7)
                    .saturation(0.0)
                    .blur(radius: .s1)
                    .clipped()
                    .edgesIgnoringSafeArea(.top)
                    .overlay(DefaultBackground().opacity(0.5))
                    .overlay(WhiteGradient())
            } placeholder: {
                DefaultBackground().fullScreen()
            }
        }
    }
}

extension Movie.Background {
    struct WhiteGradient: View {
        @Environment(\.theme) var theme: Theme

        var body: some View {
            LinearGradient(
                gradient: theme.secondGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}


// MARK: - Extension
fileprivate extension Double {
    func makeRatingStars() -> String {
        let rating = Int(self/2)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        if rating < 5 {
            let numOfMissingStars = 5 - rating
            var missingStars = ""
            for _ in 1...numOfMissingStars {
                missingStars.append("✩")
            }
            return ratingText + missingStars
        }
        return ratingText
    }
}

fileprivate extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}

