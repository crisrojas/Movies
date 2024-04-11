//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

/* @todo:
 - Fetch videos
 - Persistence
 - Dark mode
 */
struct Movie: View {
    let props: MJ
    var body: some View {
        VStack {
            Header(props: props)
            InfoStack(props: props).top(.s5)
            StoryLine(props: props)
            castSection().vertical(.s6)
        }
        .horizontal(.s6)
        .scrollify()
        .background(background.fullScreen())
    }
    
    var background: Background {
        Background(url: props.backdrop_path.movieImageURL)
    }
    
    func castSection() -> some View {
        JSON(url: TmdbApi.credits(id: props.id.intValue), keyPath: "cast") {
            if $0.array.isNotEmpty {
                Cast(props: $0)
            }
        }
    }
}

// MARK: - Header
extension Movie {
    struct Header: View {
        let title: String
        let voteAverage: Double
        let posterURL: URL?
        let trailerURL: URL?
        
        var ratingStars: String { voteAverage.makeRatingStars() }
        
        var voteAverageRounded: String {
            voteAverage.reduceScale(to: 1).description
        }
        
        var body: some View {
            
            VStack(spacing: 0) {
                
                posterView
                
                Text(title)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(.sky900)
                    .top(28)
                
                Text(voteAverageRounded)
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(.sky900)
                    .top(10)
                
                Text(ratingStars)
                    .foregroundColor(Color.orange)
                    .top(10)
            }
        }
    }
}

private extension Movie.Header {
    var posterView: some View {
        AsyncImage(url: posterURL) { image in
            image.resizable()
        } placeholder: {
            Color.neutral100
                .overlay(ProgressView())
        }
        .cornerRadius(8)
        .shadow(radius: 8)
        .width(230)
        .height(310)
    }
}


extension Movie.Header {
    init(props: MJ) {
        title = props.title
        voteAverage = props.vote_average.doubleValue
        posterURL = props.poster_path.movieImageURL
        trailerURL = props.trailerURL.url
    }
}

// MARK: - InfoStack
extension Movie {
    struct InfoStack: View {
        let props: MJ
        
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
                
                Info(title: "Vote count", value: "\(props.vote_count)")
            }
        }
    }
}

extension Movie {
    struct Info: View {
        let title: String
        let value: String
        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.sky900)
                    .fontWeight(.heavy)
                Text(value)
                    .fontWeight(.heavy)
                    .foregroundColor(.sky900)
                    .padding(.top, 5)
            }.font(.footnote)
        }
    }
}

// MARK: - StoryLine
extension Movie {
    struct StoryLine: View {
        let props: MJ
        var body: some View {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                Text("Storyline")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(.sky900)

                Text(props.overview)
                    .font(.system(.footnote, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.sky900)
            }
            .alignX(.leading)
            .top(30)
        }
    }
}

// MARK: - Cast
extension Movie {
    struct Cast: View {
        let props: MJ
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: .s6) {
                
                Text("Cast")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(.sky900)
                
                Carousel(model: props, spacing: 8) { item in
                    actorAvatar(
                        path: item.profile_path,
                        id: item.credit_id
                    )
                    .leading(item.id == props.first?.id ? .s6 : 0)
                    .trailing(item.id == props.last?.id ? .s6 : 0)
                }
                .horizontal(-.s6)
            }
        }
        
        func actorAvatar(path: String, id: String?) -> some View {
            let profileURL = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            
            return AsyncImage(url: profileURL) { image in
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .width(60)
                    .height(60)
                    .cornerRadius(8)
                
                
            } placeholder: {
                imagePlaceholder
                
            }
        }
        
        var imagePlaceholder: some View {
            
            Color.sky900
                .opacity(0.5)
                .font(.largeTitle)
                .width(60)
                .height(60)
                .cornerRadius(12)
                .opacity(0.3)
                .overlay(ProgressView())
            
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
                    .clipped()
                    .edgesIgnoringSafeArea(.top)
                    .overlay(DefaultBackground())
                    .overlay(WhiteGradient())
            } placeholder: {
                DefaultBackground().fullScreen()
            }
        }
    }
}

extension Movie.Background {
    struct WhiteGradient: View {
        let gradient = Gradient(colors: [
            Color.clear,
            Color.white
        ])

        var body: some View {
            LinearGradient(
                gradient: gradient,
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

