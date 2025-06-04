//
//  CardGame.swift
//  blackjck
//
//  Created by Joel Tavares on 30/05/25.
//

import Foundation

struct CardGame<CardContent> where CardContent:Equatable{
    private(set) var dealerCards : Array<Card>
    private(set) var playerCards : Array<Card>
    let cardFactory : (Bool) -> Card
    var endPlayerRound = false
    var playerBust = false
    var dealerBust = false
    
    mutating func stand(){//Parar de jogar. Vez da mesa
        endPlayerRound = true
        dealerCards[1].isFaceUp = true
        while dealerSum < playerSum {
            dealerCards.append(cardFactory(true))
        }
        if dealerSum > 21{
            dealerBust = true
        } 
    }
    mutating func hit(){//Pedir mais uma
        playerCards.append(cardFactory(true))
        if playerSum > 21 {
            playerBust = true
        }
    }
    
    var playerSum : Int {
        let cardsWithoutAce = playerCards.contains { $0.isAce }
        let cardsSum = playerCards.reduce(0) { $0 + $1.cardValue}
        if cardsWithoutAce && cardsSum + 10 <= 21 {
            return cardsSum + 10
        }
        
        return cardsSum
    }
    
    var dealerSum : Int {
        let cardsWithoutAce = dealerCards.contains { $0.isAce }
        let cardsSum = dealerCards.filter {$0.isFaceUp} .reduce(0) { $0 + $1.cardValue}
        if cardsWithoutAce && cardsSum + 10 <= 21 {
            return cardsSum + 10
        }
        
        return cardsSum
        
    }
    
    init(cardFactory: @escaping (Bool) -> Card){
        dealerCards = []
        dealerCards.append(cardFactory(true))
        dealerCards.append(cardFactory(false))
        
        playerCards = []
        playerCards.append(cardFactory(true))
        playerCards.append(cardFactory(true))
        
        self.cardFactory = cardFactory
    }
    
    
    struct Card: Identifiable, Equatable{
        let content: CardContent
        let cardValue: Int
        var isFaceUp = false
        let isAce : Bool
        
        let id: UUID 
    }
}
