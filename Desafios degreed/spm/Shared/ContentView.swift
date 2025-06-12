//
//  ContentView.swift
//  Shared
//
//  Created by Joel Tavares on 06/06/25.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var viewModel = CompanySystemViewModel()
    @EnvironmentObject var themeVM: ThemeViewModel

    @State private var isPlayingNow = true
    @State private var moviePresent: Cinema.Movie? = nil
    var body: some View {
        ScrollView{
            header
            dateButtons
            movies
            
            Button(action: {
                themeVM.toggleTheme()
            }) {
                Image(systemName: themeVM.themeType == .light ? "moon.fill" : "sun.max.fill")
                    .foregroundColor(themeVM.currentTheme.accent)
            }
        }
        .padding(4)
        .background(themeVM.currentTheme.background)
        .sheet(item: $moviePresent){ movie in
            MovieDetailsView(movie)
                .environmentObject(themeVM)
        }
        .background(themeVM.currentTheme.background)
    }
    var header: some View{
        HStack{
            Text("CI&T Movie DB")
            Spacer()
            Image(systemName: "magnifyingglass")
        }
        .foregroundColor(themeVM.currentTheme.text)
        .font(.largeTitle)
        
    }
    
    var dateButtons: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(themeVM.currentTheme.primary)
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
                    .environmentObject(themeVM)
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

