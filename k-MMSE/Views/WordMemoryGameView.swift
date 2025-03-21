//
//  WordMemoryGameView.swift
//  k-MMSE
//
//  Created by Cascade on 3/18/25.
//

import SwiftUI
import SwiftData

struct WordMemoryGameView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var gameState: GameState = .ready
    @State private var currentWord: String = ""
    @State private var options: [String] = []
    @State private var correctAnswerIndex: Int = 0
    @State private var score: Int = 0
    @State private var round: Int = 1
    @State private var totalRounds: Int = 5
    @State private var showingResult: Bool = false
    
    // 한국어 단어 목록
    private let words = [
        "사과", "바나나", "오렌지", "포도", "딸기", 
        "자동차", "비행기", "기차", "버스", "자전거",
        "의자", "책상", "침대", "소파", "옷장",
        "학교", "병원", "공원", "도서관", "영화관",
        "컴퓨터", "전화기", "텔레비전", "냉장고", "세탁기"
    ]
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining: Int = 3
    
    var body: some View {
        VStack {
            Text("단어 기억하기")
                .font(.largeTitle)
                .padding()
            
            Text("라운드: \(round)/\(totalRounds)")
                .font(.headline)
            
            Text("점수: \(score)")
                .font(.headline)
                .padding(.bottom)
            
            Spacer()
            
            switch gameState {
            case .ready:
                Button(action: startGame) {
                    Text("시작하기")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
            case .showingWord:
                VStack {
                    Text(currentWord)
                        .font(.system(size: 48, weight: .bold))
                        .padding()
                    
                    Text("\(timeRemaining)초 후 사라집니다")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        gameState = .question
                        timeRemaining = 3
                    }
                }
                
            case .question:
                VStack {
                    Text("방금 보신 단어는 무엇인가요?")
                        .font(.headline)
                        .padding()
                    
                    ForEach(0..<3) { index in
                        Button(action: {
                            checkAnswer(index)
                        }) {
                            Text(options[index])
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .alert("게임 결과", isPresented: $showingResult) {
            Button("메인 메뉴로", role: .cancel) {
                saveGameResult()
                self.presentationMode.wrappedValue.dismiss()
            }
            Button("다시 하기") {
                saveGameResult()
                resetGame()
            }
        } message: {
            Text("총점: \(score)/\(totalRounds)")
        }
        .onDisappear {
            if gameState != .ready && !showingResult {
                saveGameResult()
            }
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    private func startGame() {
        setupRound()
        gameState = .showingWord
    }
    
    private func setupRound() {
        // 랜덤 단어 선택
        currentWord = words.randomElement() ?? "사과"
        
        // 선택지 생성 (정답 포함 3개)
        var tempOptions = [currentWord]
        while tempOptions.count < 3 {
            if let randomWord = words.randomElement(), !tempOptions.contains(randomWord) {
                tempOptions.append(randomWord)
            }
        }
        
        // 선택지 섞기
        tempOptions.shuffle()
        options = tempOptions
        
        // 정답 인덱스 저장
        correctAnswerIndex = tempOptions.firstIndex(of: currentWord) ?? 0
        
        // 타이머 초기화
        timeRemaining = 3
    }
    
    private func checkAnswer(_ selectedIndex: Int) {
        if selectedIndex == correctAnswerIndex {
            score += 1
        }
        
        if round < totalRounds {
            round += 1
            setupRound()
            gameState = .showingWord
        } else {
            showingResult = true
        }
    }
    
    private func resetGame() {
        score = 0
        round = 1
        showingResult = false
        gameState = .ready
    }
    
    private func saveGameResult() {
        let result = GameResult(gameType: "단어 기억하기", score: score)
        modelContext.insert(result)
    }
}

enum GameState {
    case ready, showingWord, question
}

#Preview {
    WordMemoryGameView()
        .modelContainer(for: GameResult.self, inMemory: true)
}
