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
            if viewModel.isLoading{
                ProgressView()
            }
            else{
                header
                dateButtons
                movies
                Button(action: {
                    themeVM.toggleTheme()
                }) {
                    Image(systemName: themeVM.themeType == .light ? Const.darkThemeImg : Const.lightThemeImg)
                        .foregroundColor(themeVM.currentTheme.accent)
                    }
                }
                
            }
            .padding(Const.padding)
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
            Image(systemName: Const.searchImg)
        }
        .foregroundColor(themeVM.currentTheme.text)
        .font(.largeTitle)
        
    }
    
    var dateButtons: some View{
        ZStack{
            RoundedRectangle(cornerRadius: Const.externDateButton)
                .foregroundColor(themeVM.currentTheme.primary)
            HStack{
                headerMovieDateButton(title: "Playing Now", condition: isPlayingNow, onTouchCondition: true)
                Spacer()
                headerMovieDateButton(title: "Coming soon", condition: !isPlayingNow, onTouchCondition: false)
            }
        }
        .padding(Const.padding)
    }
    
    func headerMovieDateButton(title: String, condition: Bool, onTouchCondition: Bool) -> some View{
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: Const.externDateButton)
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: Const.LazyMin))]){
            ForEach(viewModel.searchByReleaseDateComparingNow(beforeNow: isPlayingNow)){ movie in
                MovieOnListView(movie)
                    .environmentObject(themeVM)
                    .onTapGesture{
                        moviePresent = movie
                    }
            }
            .padding(Const.padding)
        }
    }
    private struct Const{
        static let LazyMin = 120.0
        static let padding = 4.0
        static let externDateButton = 4.0
        static let internDateButton = 6.0
        
        static let lightThemeImg = "sun.max.fill"
        static let darkThemeImg = "moon.fill"
        static let searchImg = "magnifyingglass"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

