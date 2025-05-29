//
//  EmojiMemorizeGame.swift
//  estudos (iOS)
//
//  Created by Joel Tavares on 28/05/25.
//  ViewModel para o Memorize Game

import SwiftUI

class EmojiMemorizeGame : ObservableObject{
    @Published private var gameModel: MemorizeGame<String> = createMemoryGame()
    
    private static func createMemoryGame() -> MemorizeGame<String> {
            let name = EmojiConstants.emojisNames.shuffled()[0]
            let emojis = EmojiConstants.emojisDict[name] ?? []
            
            return MemorizeGame(numberOfPairsOfCards: 5, newName: name) { pairIndex in
                if emojis.indices.contains(pairIndex){
                    return emojis[pairIndex]
                }
                return "!!"//Retornar erro
            }
        }
    
    var name:String {
        return gameModel.name
    }
    var score:Int{
        return gameModel.score
    }
    var cards : Array<MemorizeGame<String>.Card>{
        return gameModel.cards
    }
    
    // MARK - Intents
    
    func choose(_ card: MemorizeGame<String>.Card){
        gameModel.choose(card)
    }
    
    func shufle(){
        gameModel.shufle()
    }
    
    func createNewGame(){
        gameModel = EmojiMemorizeGame.createMemoryGame()
    }
    
    // MARK - Constants
    private struct EmojiConstants {
            static let emojisNames = ["Faces", "Body", "Flags"]
            
            static let emojisDict: [String: [String]] = [
                "Faces": ["🥸", "🧐", "🤓", "🙃", "🥳", "😲"],
                "Body": ["👃", "🦷", "🦻", "🫁", "👀"],
                "Flags": ["🇿🇦", "🇧🇷", "🇨🇦", "🇰🇾", "🇪🇸"]
            ]
        }
    
}
