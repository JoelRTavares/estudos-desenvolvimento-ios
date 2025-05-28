//
//  ContentView.swift
//  Shared
//
//  Created by Joel Tavares on 27/05/25.
//

import SwiftUI

struct ContentView: View {
    @State var emojis = constants.faceEmojis
    var body: some View {
        VStack{
            Text("MEMORIZE!").font(.largeTitle)
            ScrollView{
                cards
            }
                .foregroundColor(.orange)
            Spacer()
            HStack{
                changeEmoji(buttonName: "😃", newEmojis: constants.faceEmojis)
                Spacer()
                changeEmoji(buttonName: "🫀", newEmojis: constants.bodyEmojis)
                Spacer()
                changeEmoji(buttonName: "🏳️", newEmojis: constants.flagEmojis)
            }
        }
        .padding()
    }
    var cards: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]){
            ForEach(emojis.indices,id:\.self){ index in
                CardView(content: emojis[index])
            }
            .aspectRatio(2/3, contentMode: .fit)
        }
    }
    func changeEmoji(buttonName :String, newEmojis:[String]) -> some View {
        Button(buttonName){
            emojis = newEmojis.shuffled()
        }
    }
}

struct constants{
    static let faceEmojis = ["🥸", "🧐", "🤓","🙃","🥳","😲", "😃"]
    static let bodyEmojis = ["👃", "🦷", "🦻","🫁"]
    
    static let flagEmojis = ["🇿🇦", "🇧🇷", "🇨🇦","🇰🇾"]
    
}
struct CardView: View{
    @State var isFaceUp = false
    let content : String
    var body : some View{
        ZStack{
            let baseRec = RoundedRectangle(cornerRadius:12)
            
            baseRec
                .foregroundColor(.green)
            baseRec
                .strokeBorder(lineWidth: 10)
            Text(content).font(.largeTitle)
            baseRec
                .opacity(isFaceUp ? 0 : 1)
            
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
