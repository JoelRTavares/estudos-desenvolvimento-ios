//
//  ContentView.swift
//  Shared
//
//  Created by Joel Tavares on 27/05/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel : EmojiMemorizeGame
    
    var body: some View {
        VStack{
            Text("MEMORIZE!")
                .font(.largeTitle)
                .foregroundColor(.green)
            Text("\(viewModel.name)")
                .font(.title)
                .foregroundColor(.orange)
            ScrollView{
                cards
                    .animation(.default, value: viewModel.cards)
            }
                .foregroundColor(.orange)
            
            HStack{
                Button("New Game"){
                    viewModel.createNewGame()
                }
                Spacer()
                Text("SCORE: \(viewModel.score)")
                Spacer()
                Button("Shufle"){
                    viewModel.shufle()
                }
            }
        }
        .padding()
    }
    var cards: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0){
            ForEach(viewModel.cards){ card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
            
        }
    }
}

struct CardView: View{
    let card: MemorizeGame<String>.Card
    
    init(_ card : MemorizeGame<String>.Card){
        self.card = card
    }
    var body : some View{
        ZStack{
            let baseRec = RoundedRectangle(cornerRadius:12)
            
            baseRec
                .foregroundColor(.green)
            baseRec
                .strokeBorder(lineWidth: 10)
            Text(card.content)
                .font(.system(size: 200))
                .minimumScaleFactor(0.01)
                .aspectRatio(1, contentMode: .fit)
            baseRec
                .opacity(card.isFaceUp ? 0 : 1)
        }
    }
}
struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel:  EmojiMemorizeGame())
    }
}
