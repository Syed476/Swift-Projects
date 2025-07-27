
import SwiftUI

// Define the game states
enum GameState {
    case waiting
    case player1Answering
    case player2Answering
    case showingResult
}

struct ContentView: View {
    @State private var leftCard = [String]()
    @State private var rightCard = [String]()
    @State private var currentEmoji = [String]()
    @State private var gameState: GameState = .waiting
    @State private var player1Score = 0
    @State private var player2Score = 0
    @State private var answerColor: Color = .clear
    @State private var answerScale: CGFloat = 0
    @State private var answerAnchor: UnitPoint = .center
    @State private var matchingEmoji = ""
    @State private var timeRemaining = 3.0
    @State private var timer: Timer?
    
    var itemCount: Int
    
    // Sample emoji array
    private let allEmoji = ["😀", "😂", "🤣", "😊", "😍", "🤔", "😎", "🥳", "😴", "🤯", "😱", "🥺", "😭", "😤", "🤗", "🙄", "😇", "🤠", "🥶", "🤪", "😋", "🤓", "🧐", "🤑"]
    
    func createLevel() {
        // Shuffle all emojis
        currentEmoji = allEmoji.shuffled()
        
        // Make sure we have enough emojis
        guard currentEmoji.count >= itemCount * 2 else { return }
        
        withAnimation(.spring()) {
            // Left side: first itemCount emojis
            leftCard = Array(currentEmoji[0..<itemCount])
            
            // Right side: next itemCount-1 emojis + 1 matching emoji from left
            let rightStart = itemCount
            let rightEnd = itemCount + (itemCount - 1)
            rightCard = Array(currentEmoji[rightStart..<rightEnd])
            
            // Add one random emoji from left side to right side
            matchingEmoji = leftCard.randomElement() ?? leftCard[0]
            rightCard.append(matchingEmoji)
            rightCard.shuffle()
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            PlayerButton(
                gameState: gameState,
                score: player1Score,
                color: .blue,
                onSelect: selectPlayer1
            )
            
            ZStack {
                answerColor
                    .scaleEffect(x: answerScale, anchor: answerAnchor)
                
                VStack {
                    if !leftCard.isEmpty {
                        HStack(spacing: 20) {
                            VStack {
                                Text("Find the Match!")
                                    .font(.headline)
                                    .padding(.bottom)
                                CardView(card: leftCard, isClickable: false, onEmojiTap: { _ in })
                                Text("Left Side")
                                    .font(.caption)
                            }
                            
                            VStack {
                                if gameState == .player1Answering || gameState == .player2Answering {
                                    Text("Time: \(Int(timeRemaining))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                        .padding(.bottom)
                                }
                                CardView(
                                    card: rightCard,
                                    isClickable: gameState == .player1Answering || gameState == .player2Answering,
                                    onEmojiTap: checkAnswer
                                )
                                Text("Right Side - Tap the Match!")
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    
                    if gameState == .waiting {
                        Button("New Round") {
                            createLevel()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    if gameState == .showingResult {
                        Button("Next Round") {
                            startNewRound()
                        }
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            
            PlayerButton(
                gameState: gameState,
                score: player2Score,
                color: .red,
                onSelect: selectPlayer2
            )
        }
        .ignoresSafeArea()
        .onAppear {
            createLevel()
        }
    }
    
    func selectPlayer1() {
        guard gameState == .waiting else { return }
        answerColor = .blue
        answerAnchor = .leading
        gameState = .player1Answering
        runClock()
    }
    
    func selectPlayer2() {
        guard gameState == .waiting else { return }
        answerColor = .red
        answerAnchor = .trailing
        gameState = .player2Answering
        runClock()
    }
    
    func checkAnswer(_ selectedEmoji: String) {
        timer?.invalidate()
        
        if selectedEmoji == matchingEmoji {
            // Correct answer!
            if gameState == .player1Answering {
                player1Score += 1
            } else if gameState == .player2Answering {
                player2Score += 1
            }
        } else {
            // Wrong answer!
            if gameState == .player1Answering {
                player1Score -= 1
            } else if gameState == .player2Answering {
                player2Score -= 1
            }
        }
        
        gameState = .showingResult
        answerScale = 0
        
        // Auto-start new round after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            startNewRound()
        }
    }
    
    func timeOut() {
        if gameState == .player1Answering {
            player1Score -= 1
        } else if gameState == .player2Answering {
            player2Score -= 1
        }
        gameState = .showingResult
        answerScale = 0
        
        // Auto-start new round after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            startNewRound()
        }
    }
    
    func startNewRound() {
        gameState = .waiting
        answerColor = .clear
        answerScale = 0
        timeRemaining = 3.0
        createLevel()
    }
    
    func runClock() {
        answerScale = 1
        timeRemaining = 3.0
        
        withAnimation(.linear(duration: 3.0)) {
            answerScale = 0
        }
        
        // Create a repeating timer for countdown
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            timeRemaining -= 0.1
            if timeRemaining <= 0 {
                timer?.invalidate()
                timeOut()
            }
        }
    }
}

struct PlayerButton: View {
    let gameState: GameState
    let score: Int
    let color: Color
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 10) {
                Text("\(score)")
                    .font(.system(size: 40, weight: .bold))
                Text("PRESS\nTO PLAY")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.white)
            .frame(width: 100)
            .frame(maxHeight: .infinity)
            .background(color)
        }
        .disabled(gameState != .waiting)
        .opacity(gameState == .waiting ? 1.0 : 0.6)
    }
}

struct CardView: View {
    let card: [String]
    let isClickable: Bool
    let onEmojiTap: (String) -> Void
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
            ForEach(card, id: \.self) { emoji in
                Button(action: {
                    if isClickable {
                        onEmojiTap(emoji)
                    }
                }) {
                    Text(emoji)
                        .font(.system(size: 30))
                        .frame(width: 50, height: 50)
                        .background(isClickable ? Color.yellow.opacity(0.3) : Color.clear)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isClickable ? Color.orange : Color.clear, lineWidth: 2)
                        )
                }
                .disabled(!isClickable)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(itemCount: 4) // Using 4 for better layout
    }
}
