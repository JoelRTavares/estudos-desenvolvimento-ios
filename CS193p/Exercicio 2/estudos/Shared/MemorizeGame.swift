//
//  MemorizeGame.swift
//  estudos (iOS)
//
//  Created by Joel Tavares on 28/05/25.
//  O modelo de nosso jogo da velha. O primeiro M de MVVM

import Foundation

struct MemorizeGame<CardContent> where CardContent:Equatable {
    private(set) var cards: Array<Card>
    var score: Int
    let name:String
    
    var currentCardUpIndex:Int?
    
    mutating func choose(_ card: Card){
        if let chosenIndex = index(of: card){
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched{
                if currentCardUpIndex == nil{
                    for i in 0..<cards.count{
                        if !cards[i].isMatched{
                            cards[i].isFaceUp = false
                        }
                    }
                    cards[chosenIndex].isFaceUp = true
                    currentCardUpIndex = chosenIndex
                }
                else {
                    cards[chosenIndex].isFaceUp = true
                    if let potentialIndex = currentCardUpIndex{
                        if cards[potentialIndex].content == cards[chosenIndex].content{
                            
                            cards[potentialIndex].isMatched = true
                            cards[chosenIndex].isMatched = true
                            score += 2
                        }
                        else{
                            score = max(score - 1, 0)
                        }
                    }
                    currentCardUpIndex = nil
                }
            }
        }
    }
    private func index(of card:Card) -> Int?{
        for i in 0..<cards.count{
            if cards[i].id == card.id{
                return i
            }
        }
        return nil
    }
    mutating func shufle(){
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards:Int, newName:String, cardContentFactory: (Int) -> CardContent){
        cards = []
        name=newName
        score = 0
        for pairIndex in 0..<max(2,numberOfPairsOfCards){
            let cardContent = cardContentFactory(pairIndex)
            
            cards.append(Card(content: cardContent, id: "\(pairIndex+1)a"))
            cards.append(Card(content: cardContent, id: "\(pairIndex+1)b"))
        }
        cards.shuffle()
        
    }
    struct Card:Equatable, Identifiable {
        var isFaceUp = false
        var isMatched = false
        let content:CardContent
        
        let id:String
    }
}


extension Array{
    var only: Element?{
        count == 1 ? first : nil
    }
}
