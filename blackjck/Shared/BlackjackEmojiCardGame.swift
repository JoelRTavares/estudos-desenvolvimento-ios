//
//  BlackjackEmojiCardGame.swift
//  blackjck
//
//  Created by Joel Tavares on 30/05/25.
//

import SwiftUI



class BlackJackEmojiCardGame:ObservableObject {
    
    
    private static func createCard(isFaceUp:Bool) -> CardGame<String>.Card{
        let cardIndex = Int.random(in: 0..<BlackJackEmojiCardGame.cards.count)
        
        let card = BlackJackEmojiCardGame.cards[cardIndex]
        let cardVal: Int
        if cardIndex < 9{
            cardVal = cardIndex + 1
        }else{
            cardVal = 10
        }
        
        return CardGame.Card(content: card, cardValue: cardVal, isFaceUp: isFaceUp, id: UUID())
        
    }
    
    private static func createBlackJackGame() -> CardGame<String>{
        return CardGame(){
            isFaceUp in createCard(isFaceUp: isFaceUp)
        }
    }
    @Published private var gameModel: CardGame<String> = createBlackJackGame()
    
    public var dealerCards : Array<CardGame<String>.Card>{
        return gameModel.dealerCards
    }
    
    public var playerCards : Array<CardGame<String>.Card>{
        return gameModel.playerCards
    }
    
    public var endPlayerRound : Bool {
        return gameModel.endPlayerRound
    }
    public var playerSum : Int {
        gameModel.playerSum
    }
    
    public var dealerSum : Int {
        gameModel.dealerSum
    }
    
    public var playerBust: Bool{
        gameModel.playerBust
    }
    
    public var dealerBust: Bool {
        gameModel.dealerBust
    }
    
    public var results: String {
        if gameModel.endPlayerRound{
            if gameModel.dealerBust {
                return "You win!"
            }
            else if playerSum == dealerSum{
                return "Draw!"
            }
            return "Dealer wins!"
        }
        
        
        if gameModel.playerBust{
            return "Dealer wins!"
        }
        return ""
    }
    // - INTENTS
    
    func hit(){
        gameModel.hit()
    }
    func stand(){
        gameModel.stand()
    }
    func newGame(){
        gameModel = BlackJackEmojiCardGame.createBlackJackGame()
    }
    private static let cards = ["🃑", "🃒", "🃃", "🃔", "🃕", "🃆", "🃗", "🃈", "🃉", "🃊", "🃋", "🃎", "🃍"]
    
}
