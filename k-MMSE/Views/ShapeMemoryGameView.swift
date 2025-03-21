//
//  ShapeMemoryGameView.swift
//  k-MMSE
//
//  Created by Cascade on 3/18/25.
//

import SwiftUI
import SwiftData

struct ShapeMemoryGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var gameState: GameState = .ready
    @State private var currentShapeIndex: Int = 0
    @State private var options: [Int] = []
    @State private var correctAnswerIndex: Int = 0
    @State private var score: Int = 0
    @State private var round: Int = 1
    @State private var totalRounds: Int = 5
    @State private var showingResult: Bool = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining: Int = 3
    
    // 도형 정의
    private let shapes = ["circle", "square", "triangle", "rectangle", "diamond", "hexagon"]
    private let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink]
    
    var body: some View {
        VStack {
            Text("형상 기억하기")
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
                    shapeView(for: currentShapeIndex)
                        .frame(width: 200, height: 200)
                    
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
                    Text("방금 보신 도형은 무엇인가요?")
                        .font(.headline)
                        .padding()
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { index in
                            Button(action: {
                                checkAnswer(index)
                            }) {
                                shapeView(for: options[index])
                                    .frame(width: 100, height: 100)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
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
    
    private func shapeView(for index: Int) -> some View {
        let shapeIndex = index % shapes.count
        let colorIndex = index % colors.count
        
        switch shapes[shapeIndex] {
        case "circle":
            return AnyView(Circle()
                .fill(colors[colorIndex])
                .overlay(Circle().stroke(Color.black, lineWidth: 2)))
        case "square":
            return AnyView(Rectangle()
                .fill(colors[colorIndex])
                .overlay(Rectangle().stroke(Color.black, lineWidth: 2)))
        case "triangle":
            return AnyView(Triangle()
                .fill(colors[colorIndex])
                .overlay(Triangle().stroke(Color.black, lineWidth: 2)))
        case "rectangle":
            return AnyView(Rectangle()
                .fill(colors[colorIndex])
                .frame(width: 100, height: 60)
                .overlay(Rectangle().stroke(Color.black, lineWidth: 2)))
        case "diamond":
            return AnyView(Diamond()
                .fill(colors[colorIndex])
                .overlay(Diamond().stroke(Color.black, lineWidth: 2)))
        case "hexagon":
            return AnyView(Hexagon()
                .fill(colors[colorIndex])
                .overlay(Hexagon().stroke(Color.black, lineWidth: 2)))
        default:
            return AnyView(Circle()
                .fill(colors[colorIndex])
                .overlay(Circle().stroke(Color.black, lineWidth: 2)))
        }
    }
    
    private func startGame() {
        setupRound()
        gameState = .showingWord
    }
    
    private func setupRound() {
        // 랜덤 도형 선택
        currentShapeIndex = Int.random(in: 0..<(shapes.count * colors.count))
        
        // 선택지 생성 (정답 포함 3개)
        var tempOptions = [currentShapeIndex]
        while tempOptions.count < 3 {
            let randomIndex = Int.random(in: 0..<(shapes.count * colors.count))
            if !tempOptions.contains(randomIndex) {
                tempOptions.append(randomIndex)
            }
        }
        
        // 선택지 섞기
        tempOptions.shuffle()
        options = tempOptions
        
        // 정답 인덱스 저장
        correctAnswerIndex = tempOptions.firstIndex(of: currentShapeIndex) ?? 0
        
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
        let result = GameResult(gameType: "형상 기억하기", score: score)
        modelContext.insert(result)
    }
}

// 커스텀 도형 구조체
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let sides = 6
        let angle = 2 * .pi / Double(sides)
        
        var path = Path()
        let startPoint = CGPoint(x: center.x + radius * cos(0), y: center.y + radius * sin(0))
        path.move(to: startPoint)
        
        for i in 1..<sides {
            let x = center.x + radius * cos(angle * Double(i))
            let y = center.y + radius * sin(angle * Double(i))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    ShapeMemoryGameView()
        .modelContainer(for: GameResult.self, inMemory: true)
}
