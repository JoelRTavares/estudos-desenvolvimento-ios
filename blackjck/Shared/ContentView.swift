
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : BlackJackEmojiCardGame
    typealias Card = CardGame<String>.Card
    
    @Namespace private var cardAnimation
    
    @State private var dealt = Set<Card.ID>()
        
    private func isDealt(_ card: Card.ID) -> Bool {
        dealt.contains(card)
    }
        
    private var undealtPlayerCards: [Card.ID] {
        viewModel.playerCards.map { $0.id }.filter { !isDealt($0) }
    }
    
    private var undealtDealerCards: [Card.ID] {
        viewModel.dealerCards.map { $0.id }.filter { !isDealt($0) }
    }
    private func dealPlayer() {
        var delay: TimeInterval = 0
        for card in viewModel.playerCards {
            withAnimation(.easeInOut(duration: constants.animation.insertDuration).delay(delay)) {
                if(!isDealt(card.id)){
                    _ = dealt.insert(card.id)
                }
            }
            delay += constants.animation.delay
        }
    }
    
    private func dealDealer(){
        var delay : TimeInterval = 0
        for card in viewModel.dealerCards {
            withAnimation(.easeInOut(duration: constants.animation.insertDuration).delay(delay)) {
                if(!isDealt(card.id)){
                    _ = dealt.insert(card.id)
                }
            }
            delay += constants.animation.delay
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("Dealer`s cards")
                Spacer()
                ForEach(viewModel.dealerCards){ card in
                    if isDealt(card.id){
                        cardView(card)
                            .matchedGeometryEffect(id: card.id, in: cardAnimation)
                    }
                }
                .animation(.default, value: viewModel.dealerCards)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                Spacer()
                Text("Total: \(viewModel.dealerSum)")
                
            }
            Divider()
            HStack{
                Text("Your cards")
                Spacer()
                ForEach(viewModel.playerCards){ card in
                    if isDealt(card.id){
                        cardView(card)
                            .matchedGeometryEffect(id: card.id, in: cardAnimation)
                    }
                }
                .animation(.default, value: viewModel.playerCards)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                Spacer()
                Text("Total: \(viewModel.playerSum)")
            }
            Spacer()
            HStack{
                if undealtPlayerCards.count > 0 {
                    deckOfCards(viewModel.playerCards)
                }
                else if undealtDealerCards.count > 0 {
                    deckOfCards(viewModel.dealerCards)
                }
                
                else {
                    RoundedRectangle(cornerRadius: constants.rectCornerRadius)
                        .foregroundColor(.black)
                        .frame(width: constants.cards.width, height: constants.cards.height)
                }
                
                Spacer()
                Text(viewModel.results)
                    .font(.largeTitle)
                Spacer()
                VStack{
                    Button("HIT"){
                        withAnimation(.easeInOut(duration: constants.animation.animDuration)) {
                            viewModel.hit()
                            dealPlayer()
                        }
                    }.disabled(viewModel.endPlayerRound || viewModel.playerBust)
                    Button("STAND"){
                        withAnimation(.easeInOut(duration: constants.animation.animDuration)) {
                            viewModel.stand()
                            dealDealer()
                        }
                    }.disabled(viewModel.endPlayerRound || viewModel.playerBust)
                    Button("NEW GAME"){
                        withAnimation(.easeInOut(duration: constants.animation.animDuration)) {
                            viewModel.newGame()
                            dealt = []
                            dealPlayer()
                            dealDealer()
                        }
                    }.disabled(viewModel.results == "")
                }.font(.body)
            }
        }
        .padding(constants.padd)
        .font(.title)
        .onAppear(){
            dealPlayer()
            dealDealer()
        }
    }
    
    func deckOfCards(_ cards: Array<Card>) -> some View{
        ZStack{
            ForEach(cards) { card in
                if !isDealt(card.id) {
                    cardView(card)
                        .matchedGeometryEffect(id: card.id, in: cardAnimation)
                        .frame(width: constants.cards.width, height: constants.cards.height)
                }
            }
        }
        .frame(width: constants.cards.width, height: constants.cards.height)
    }
    
    
    func cardView(_ card: Card) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: constants.rectCornerRadius)
                    .foregroundColor(.white)

                Text(card.content)
                    .font(.system(size: constants.fontSize))
                    .minimumScaleFactor(constants.minScaleFactor)
                    .multilineTextAlignment(.center)
                RoundedRectangle(cornerRadius: constants.rectCornerRadius)
                    .foregroundColor(.black)
                    .opacity(!card.isFaceUp ? 1 : 0)
                
            }
            .aspectRatio(constants.cards.aspectRatio, contentMode: .fit)
            .padding()
        }
    private struct constants{
        static let rectCornerRadius: CGFloat = 8
        static let minScaleFactor : CGFloat = 0.01
        static let fontSize : CGFloat = 200
        static let padd: CGFloat = 4
        
        struct cards {
            static let aspectRatio: CGFloat = 2/3
            static let width : CGFloat = 60
            static let height = width / aspectRatio
        }
        
        struct animation {
            static let animDuration: CGFloat = 0.6
            static let delay = 0.15
            static let insertDuration = 0.5
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: BlackJackEmojiCardGame())
    }
}
