//
//  ContentView.swift
//  Shared
//
//  Created by Joel Tavares on 06/06/25.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var viewModel = CompanySystem()

    var body: some View {
        //let filmes = viewModel.searchMoviesByGenre(genre: Cinema.Movie.Genre(id: 1, name: "comedia"))
        let filmes = viewModel.orderByTitle()
        
        //let filmes = viewModel.orderByReleaseDate()
        VStack{
            ForEach(filmes){filme in
                Text("\(filme.title) - \(filme.releaseDate.toFormat("dd-MM-yyyy")) - Genero: \(filme.genres.map{$0.name}.joined(separator: ", "))")
                
            }
            .multilineTextAlignment(.center)
        }
        .padding(4)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
