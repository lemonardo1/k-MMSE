//
//  OrientationGameView.swift
//  k-MMSE
//
//  Created by Cascade on 3/18/25.
//

import SwiftUI
import SwiftData

struct OrientationGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentQuestion: Int = 0
    @State private var score: Int = 0
    @State private var showingResult: Bool = false
    @State private var selectedAnswer: String = ""
    
    // 지남력 질문 및 선택지
    private let questions = [
        Question(
            text: "오늘은 무슨 요일인가요?",
            options: ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"],
            correctAnswer: { Calendar.current.component(.weekday, from: Date()) - 1 }
        ),
        Question(
            text: "지금은 무슨 계절인가요?",
            options: ["봄", "여름", "가을", "겨울"],
            correctAnswer: { 
                let month = Calendar.current.component(.month, from: Date())
                switch month {
                case 3...5: return 0 // 봄
                case 6...8: return 1 // 여름
                case 9...11: return 2 // 가을
                default: return 3 // 겨울
                }
            }
        ),
        Question(
            text: "현재 연도는 몇 년인가요?",
            options: ["2023년", "2024년", "2025년", "2026년"],
            correctAnswer: { 2 } // 2025년
        ),
        Question(
            text: "현재 월은 몇 월인가요?",
            options: ["1월", "2월", "3월", "4월", "5월"],//, "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
            correctAnswer: { Calendar.current.component(.month, from: Date()) - 1 }
        ),
        Question(
            text: "지금은 하루 중 어느 시간대인가요?",
            options: ["아침", "점심", "저녁", "밤"],
            correctAnswer: {
                let hour = Calendar.current.component(.hour, from: Date())
                switch hour {
                case 5...11: return 0 // 아침
                case 12...16: return 1 // 점심
                case 17...20: return 2 // 저녁
                default: return 3 // 밤
                }
            }
        )
    ]
    
    var body: some View {
        VStack {
            Text("시간 및 장소 인지")
                .font(.largeTitle)
                .padding()
            
            Text("문제 \(currentQuestion + 1)/\(questions.count)")
                .font(.headline)
            
            Text("점수: \(score)")
                .font(.headline)
                .padding(.bottom)
            
            Spacer()
            
            if currentQuestion < questions.count {
                VStack(spacing: 0) {
                    Text(questions[currentQuestion].text)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    ForEach(questions[currentQuestion].options, id: \.self) { option in
                        Button(action: {
                            selectedAnswer = option
                        }) {
                            HStack {
                                Text(option)
                                    .font(.title3)
                                
                                Spacer()
                                
                                if selectedAnswer == option {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedAnswer == option ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Button(action: checkAnswer) {
                        Text("확인")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(selectedAnswer.isEmpty)
                    .padding(.top)
                }
                .padding()
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
            Text("총점: \(score)/\(questions.count)")
        }
        .onDisappear {
            if currentQuestion > 0 && !showingResult {
                saveGameResult()
            }
        }
    }
    
    private func checkAnswer() {
        let correctIndex = questions[currentQuestion].correctAnswer()
        let correctOption = questions[currentQuestion].options[correctIndex]
        
        if selectedAnswer == correctOption {
            score += 1
        }
        
        selectedAnswer = ""
        
        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
        } else {
            showingResult = true
        }
    }
    
    private func resetGame() {
        score = 0
        currentQuestion = 0
        selectedAnswer = ""
        showingResult = false
    }
    
    private func saveGameResult() {
        let result = GameResult(gameType: "시간 및 장소 인지", score: score)
        modelContext.insert(result)
    }
}

struct Question {
    let text: String
    let options: [String]
    let correctAnswer: () -> Int // 함수로 정답 인덱스 계산
}

#Preview {
    OrientationGameView()
        .modelContainer(for: GameResult.self, inMemory: true)
}
