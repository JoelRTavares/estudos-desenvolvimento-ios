//
//  ContentView.swift
//  Shared
//
//  Created by Joel Tavares on 30/05/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : BlackJackEmojiCardGame

    var body: some View {
        VStack{
            HStack{
                Text("Dealer`s cards")
                ForEach(viewModel.dealerCards){ card in
                    cardView(card)
                }
                Text("Total: \(viewModel.dealerSum)")
                
            }
            HStack{
                Text("Your cards")
                ForEach(viewModel.playerCards){ card in
                    cardView(card)
                }
                Text("Total: \(viewModel.playerSum)")
            }
            Spacer()
            HStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.black)
                    .aspectRatio(2/3, contentMode: .fit)
                Spacer()
                Text(viewModel.results)
                    .font(.largeTitle)
                Spacer()
                VStack{
                    Button("HIT"){
                        viewModel.hit()
                    }.disabled(viewModel.endPlayerRound || viewModel.playerBust)
                    Button("STAND"){
                        viewModel.stand()
                    }.disabled(viewModel.endPlayerRound || viewModel.playerBust)
                    Button("NEW GAME"){
                        viewModel.newGame()
                    }.disabled(viewModel.results == "")
                }.font(.body)
            }
        }
        .padding(4)
        .font(.title)
    }
    
    func cardView(_ card: CardGame<String>.Card) -> some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)

                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .multilineTextAlignment(.center)
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.black)
                    .opacity(!card.isFaceUp ? 1 : 0)
                
            }
            .aspectRatio(2/3, contentMode: .fit)
            .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: BlackJackEmojiCardGame())
    }
}
