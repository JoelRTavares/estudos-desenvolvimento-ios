//
//  MovieDetails.swift
//  spm
//
//  Created by Joel Tavares on 10/06/25.
//

import SwiftUI

struct MovieDetailsView: View {
    @EnvironmentObject var themeVM: ThemeViewModel
    @State var showMore = false
    
    var movie : Cinema.Movie
    
    init(_ mov: Cinema.Movie) {
            movie = mov
            
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
            UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        NavigationView{
            ZStack{
                themeVM.currentTheme.background
                            .edgesIgnoringSafeArea(.all)
                Form{
                    backgroundAndInfo
                    synopsis
                    cast
                    photos
                }
                .background(themeVM.currentTheme.background)
                
            }
        }
        
        .background(themeVM.currentTheme.background)
    }
    
    var backgroundAndInfo: some View{
        Section{
            AsyncImage(url: URL(string: movie.backdropPath))
            { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(DetailsConst.Img.aspectRatio, contentMode: .fit)
                case .failure:
                    Image(systemName: DetailsConst.Img.defaultImgNotFound)
                        .resizable()
                        .aspectRatio(DetailsConst.Img.aspectRatio, contentMode: .fit)
                @unknown default:
                    EmptyView()
                }
            }
                
            Text(movie.originalTitle)
                .font(.title)
                .foregroundColor(themeVM.currentTheme.text)
            HStack{
                Text("\(String(format:DetailsConst.voteFormat, movie.voteAverage))")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                VStack(alignment: .leading){
                    Text("2Hr 10m | R")
                    Text("\(movie.genres.map{$0.name}.joined(separator: ", "))")
                }
                .font(.title2)
                .foregroundColor(themeVM.currentTheme.text)
            }
                
        }
        .listRowBackground(themeVM.currentTheme.background)
    }
    
    var synopsis: some View{
        Section(header: Text("Synopsis")){
            let sinText = movie.overview
            
            if sinText.count < DetailsConst.maxCharCount {
                Text(sinText)
            }
            else{
                if showMore{
                    Text(sinText.substring(from: 0, to: sinText.count))
                    Button("Show less"){
                        showMore.toggle()
                    }
                }else{
                    Text(sinText.substring(from: 0, to: DetailsConst.maxCharCount) + "...")
                    Button("Show more"){
                        showMore.toggle()
                    }
                }
            }
        }
        .foregroundColor(themeVM.currentTheme.text)
        .listRowBackground(themeVM.currentTheme.background)
    }
    
    var cast: some View{
        Section (
            header:
                HStack {
                    Text("Cast")
                        .foregroundColor(themeVM.currentTheme.text)
                    Spacer()
                    NavigationLink("View All") {
                        FullCastView(cast: movie.cast)
                        .environmentObject(themeVM)
                        
                    }
                }
        ){
            let actors = movie.cast.prefix(DetailsConst.prefixItems)

            ForEach(actors){ act in
                MovieDetailsView.castRow(name: act.name, role: act.character, profImage: act.profile_path, themeVM)
            }
        }
        .listRowBackground(themeVM.currentTheme.background)
    }
    
    var photos: some View{
        Section (
            header:
                HStack {
                    Text("Photos")
                        .foregroundColor(themeVM.currentTheme.text)
                    Spacer()
                    NavigationLink("View All") {
                        FullPhotosView(photos: movie.photos)
                            .environmentObject(themeVM)
                    }
                }
        ){
            let photos = movie.photos.prefix(DetailsConst.prefixItems)
            HStack{
                ForEach(photos.indices, id:\.self){ index in
                    AsyncImage(url: URL(string: photos[index]))
                    { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: DetailsConst.Img.circleSize, height: DetailsConst.Img.circleSize)
                                
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(DetailsConst.Img.aspectRatio, contentMode: .fit)
                                .cornerRadius(DetailsConst.Img.cornerRadius)
                                
                        case .failure:
                            Image(systemName: DetailsConst.Img.defaultImgNotFound)
                            .resizable()
                            .aspectRatio(DetailsConst.Img.aspectRatio, contentMode: .fit)
                            .cornerRadius(DetailsConst.Img.cornerRadius)
                                
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .listRowBackground(themeVM.currentTheme.background)
    }
    
    struct FullCastView: View {
        @EnvironmentObject var themeVM: ThemeViewModel
        let cast: [Cinema.Movie.Actor]

        var body: some View {
            ScrollView {
                VStack(alignment:.center, spacing: DetailsConst.Img.spacing) {
                    Text("Cast & Crew")
                        .font(.title)
                        .foregroundColor(themeVM.currentTheme.text)
                    ForEach(cast) { act in
                        castRow(name: act.name, role: act.character, profImage: act.profile_path, themeVM)
                    }
                }
                .background(themeVM.currentTheme.background)
                .padding()
            }
            .background(themeVM.currentTheme.background)
            
            .foregroundColor(themeVM.currentTheme.text)
        }
    }
    
    struct FullPhotosView: View {
        @EnvironmentObject var themeVM: ThemeViewModel
        let photos: [String]

        var body: some View {
            ScrollView {
                VStack(alignment:.center, spacing: DetailsConst.Img.spacing) {
                    Text("Photos")
                        .font(.title)
                        .foregroundColor(themeVM.currentTheme.text)                    
                    ForEach(photos.indices, id: \.self) { index in
                        AsyncImage(url: URL(string: photos[index]))
                        { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: DetailsConst.Img.circleSize, height: DetailsConst.Img.circleSize)
                                    
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(DetailsConst.Img.aspectRatio, contentMode: .fit)
                                    .cornerRadius(DetailsConst.Img.cornerRadius)
                                    
                            case .failure:
                                Image(systemName: DetailsConst.Img.defaultImgNotExists)
                                .resizable()
                                .aspectRatio(DetailsConst.Img.aspectRatio, contentMode: .fit)
                                .cornerRadius(DetailsConst.Img.cornerRadius)
                                    
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .background(themeVM.currentTheme.background)
                .padding()
            }
            .background(themeVM.currentTheme.background)
            .foregroundColor(themeVM.currentTheme.text)
        }
    }

    private static func castRow(name: String, role: String, profImage: String?, _ themeVM: ThemeViewModel) -> some View {
        
        return HStack {
            if let image = profImage{
                AsyncImage(url: URL(string: image))
                { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: DetailsConst.Img.circleSize, height: DetailsConst.Img.circleSize)
                            
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: DetailsConst.Img.circleSize, height: DetailsConst.Img.circleSize)
                            .clipShape(Circle())
                            
                    case .failure:
                        Image(systemName: DetailsConst.Img.defaultImgNotFound) // Imagem de fallback
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: DetailsConst.Img.circleSize, height: DetailsConst.Img.circleSize)
                            .clipShape(Circle())
                            
                    @unknown default:
                        EmptyView()
                    }
                }
                    
            }else{
                Image(systemName: DetailsConst.Img.defaultImgNotExists)
                    .frame(width: DetailsConst.Img.circleSize, height: DetailsConst.Img.circleSize)
                    .clipShape(Circle())
            }
           
            Text(name)
                .bold()
            Spacer()
            Text("•••")
            Spacer()
            Text(role)
        }
        .font(.title3)
        .foregroundColor(themeVM.currentTheme.text)
    }
    
    private struct DetailsConst{
        static let maxCharCount = 150
        static let prefixItems = 3
        static let voteFormat = "%.1f"
        
        struct Img{
            static let circleSize = 48.0
            static let aspectRatio = 16.0/9
            static let cornerRadius = 8.0
            static let spacing = 16.0
            static let defaultImgNotFound = "photo"
            static let defaultImgNotExists = "person.crop.circle"
        }
    }
}

struct MovieDetails_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(Cinema.Movie(id: 4 , voteAverage: 4.8, title: "A forja", originalTitle: "A Forja: O poder da transformaçao", popularity: 8.7, posterPath: "forja", backdropPath: "forja_background",
            overview: "A Forja - O Poder da Transformação é um filme dirigido por Alex Kendrick que narra a história de Isaiah Wright, um jovem de 19 anos que, após terminar o ensino médio, se sente perdido e sem rumo na vida. Criado por uma mãe solteira, ele passa seus dias jogando videogame e jogando basquete até que, pressionado por sua mãe, ele busca um emprego em uma grande empresa. Ao longo do filme, Isaiah é encorajado por sua mãe e um mentor devoto, explorando temas de fé, superação e propósito de vida.", releaseDate: Date(), genres: [Cinema.Movie.Genre(id: 1, name: "Gospel"), Cinema.Movie.Genre(id: 1, name: "Comedia")], cast: [Cinema.Movie.Actor(id: 1, name: "Claudio casto", character: "Juan")], photos:["forja_background", "forja_background", "forja_background"]
                                     ))
    }
}
