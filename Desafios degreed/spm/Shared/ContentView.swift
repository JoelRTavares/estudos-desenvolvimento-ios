//
//  ContentView.swift
//  Shared
//
//  Created by Joel Tavares on 06/06/25.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var viewModel = CompanySystemViewModel()

    @State private var isPlayingNow = true
    @State private var moviePresent: Cinema.Movie? = nil
    var body: some View {
        ScrollView{
            header
            dateButtons
            movies
        }
        .padding(4)
        .sheet(item: $moviePresent){ movie in
            MovieDetailsView(movie)
        }
    }
    var header: some View{
        HStack{
            Text("CI&T Movie DB")
            Spacer()
            Image(systemName: "magnifyingglass")
        }
        .font(.largeTitle)
        
    }
    
    var dateButtons: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.black)
            HStack{
                headerMovieDateButton(title: "Playing Now", condition: isPlayingNow, onTouchCondition: true)
                Spacer()
                headerMovieDateButton(title: "Coming soon", condition: !isPlayingNow, onTouchCondition: false)
            }
            
        }
        .padding(4)
        
    }
    
    func headerMovieDateButton(title: String, condition: Bool, onTouchCondition: Bool) -> some View{
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.red)
                .opacity(condition ? 1 : 0)
            Text(title)
                .foregroundColor(.white)
                .font(.title2)
            
        }.onTapGesture {
            isPlayingNow = onTouchCondition
        }
    }
    
    var movies: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]){
            ForEach(viewModel.searchByReleaseDateComparingNow(beforeNow: isPlayingNow)){ movie in
                MovieOnListView(movie)
                    .onTapGesture{
                        moviePresent = movie
                    }
            }
            .padding(4)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
