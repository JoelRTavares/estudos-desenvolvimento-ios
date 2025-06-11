//
//  MovieDetails.swift
//  spm
//
//  Created by Joel Tavares on 10/06/25.
//

import SwiftUI

struct MovieDetailsView: View {
    @State var showMore = false
    
    var movie : Cinema.Movie
    
    init(_ mov: Cinema.Movie){
        movie = mov
    }
    var body: some View {
        NavigationView{
            Form{
                backgroundAndInfo
                synopsis
                cast
                photos
            }
        }
    }
    
    var backgroundAndInfo: some View{
        Section{
            Image("forja_background")
                .resizable()
                .aspectRatio(16/9, contentMode: .fit)
            Text(movie.originalTitle)
                .font(.title)
            HStack{
                Text("\(String(format:"%.1f", movie.voteAverage))")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                VStack(alignment: .leading){
                    Text("\(movie.duration) | R")
                    Text("\(movie.genres.map{$0.name}.joined(separator: ", "))")
                }
                .font(.title2)
            }
        }
    }
    
    var synopsis: some View{
        Section(header: Text("Synopsis")){
            let sinText = movie.overview
            
            if sinText.count < 150 {
                Text(sinText)
            }
            else{
                if showMore{
                    Text(sinText.substring(from: 0, to: sinText.count))
                    Button("Show less"){
                        showMore.toggle()
                    }
                }else{
                    Text(sinText.substring(from: 0, to: 150) + "...")
                    Button("Show more"){
                        showMore.toggle()
                    }
                }
            }
        }
    }
    
    var cast: some View{
        Section (
            header:
                HStack {
                    Text("Cast")
                    Spacer()
                    NavigationLink("View All") {
                        FullCastView(cast: movie.cast)
                    }
                }
        ){
            let actors = movie.cast.prefix(3)

            ForEach(actors){ act in
                MovieDetailsView.castRow(name: act.actorName, role: act.roleName, profImage: act.profileImage)
            }
        }
    }
    
    var photos: some View{
        Section (
            header:
                HStack {
                    Text("Photos")
                    Spacer()
                    NavigationLink("View All") {
                        FullPhotosView(photos: movie.photos)
                    }
                }
        ){
            let photos = movie.photos.prefix(3)
            HStack{
                ForEach(photos.indices, id:\.self){ index in
                Image(photos[index])
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fit)
                }
            }
        }
    }
    
    struct FullCastView: View {
        let cast: [Cinema.Movie.Actor]

        var body: some View {
            List(cast) { actor in
                castRow(name: actor.actorName, role: actor.roleName, profImage: actor.profileImage)
            }
            .navigationTitle("Cast & Crew")
        }
    }
    
    struct FullPhotosView: View {
        let photos: [String]

        var body: some View {
            ScrollView {
                VStack(alignment:.center, spacing: 16) {
                    ForEach(photos.indices, id: \.self) { index in
                        Image(photos[index])
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fit)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Photos")
        }
    }

    private static func castRow(name: String, role: String, profImage: String?) -> some View {
        HStack {
            if let image = profImage{
                Image(image)
                    .resizable()
                    .clipShape(Circle())
            }else{
                Image(systemName: "person.crop.circle")
                
            }
           
            Text(name)
                .bold()
            Spacer()
            Text("••• " + role)
                
        }
        .font(.title3)
    }
}

struct MovieDetails_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(Cinema.Movie(id: 4 , voteAverage: 4.8, title: "A forja", originalTitle: "A Forja: O poder da transformaçao", popularity: 8.7, posterPath: "forja", backdropPath: "forja_background",
            overview: "A Forja - O Poder da Transformação é um filme dirigido por Alex Kendrick que narra a história de Isaiah Wright, um jovem de 19 anos que, após terminar o ensino médio, se sente perdido e sem rumo na vida. Criado por uma mãe solteira, ele passa seus dias jogando videogame e jogando basquete até que, pressionado por sua mãe, ele busca um emprego em uma grande empresa. Ao longo do filme, Isaiah é encorajado por sua mãe e um mentor devoto, explorando temas de fé, superação e propósito de vida.", releaseDate: Date(), genres: [Cinema.Movie.Genre(id: 1, name: "Gospel"), Cinema.Movie.Genre(id: 1, name: "Comedia")], cast: [Cinema.Movie.Actor(id: 1, actorName: "Claudio casto", roleName: "Juan")],duration: "2hr 1m", photos:["forja_background", "forja_background", "forja_background"]
                                     ))
    }
}
