import SwiftUI
import SwiftData

struct CrosswordCell: View {
    let letter: String
    let isActive: Bool
    let isSelected: Bool
    let filledLetter: String?
    let position: (Int, Int)
    let onCellTap: ((Int, Int)) -> Void
    let isDropTarget: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isActive ? (isSelected ? Color.yellow.opacity(0.3) : Color.white) : Color.gray)
                .border(Color.black, width: isActive ? 1 : 0)
            
            if isActive && filledLetter != nil {
                Text(filledLetter!)
                    .font(.system(size: 18, weight: .bold))
            }
        }
        .frame(width: 40, height: 40)
        .onTapGesture {
            if isActive {
                onCellTap(position)
            }
        }
        .overlay(
            isDropTarget ?
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.blue, lineWidth: 2)
                : nil
        )
    }
}

struct DraggableLetter: View {
    let letter: String
    let isUsed: Bool
    let onDragStarted: (String) -> Void
    
    var body: some View {
        Text(letter)
            .font(.system(size: 18, weight: .bold))
            .frame(width: 40, height: 40)
            .background(isUsed ? Color.gray.opacity(0.5) : Color.blue.opacity(0.2))
            .cornerRadius(8)
            .opacity(isUsed ? 0.5 : 1.0)
            .onDrag {
                onDragStarted(letter)
                return NSItemProvider(object: letter as NSString)
            }
    }
}

struct CrosswordClue: Identifiable {
    let id = UUID()
    let number: Int
    let clue: String
    let answer: String
    let startPosition: (Int, Int)
    let isHorizontal: Bool
    var positions: [(Int, Int)] {
        var positions = [(Int, Int)]()
        for i in 0..<answer.count {
            if isHorizontal {
                positions.append((startPosition.0, startPosition.1 + i))
            } else {
                positions.append((startPosition.0 + i, startPosition.1))
            }
        }
        return positions
    }
}

struct CrosswordGameView: View {
    @State private var selectedClue: CrosswordClue?
    @State private var userAnswers: [String: String] = [:]
    @State private var showCompletionAlert = false
    @State private var isCorrect = false
    @State private var draggedLetter: String?
    @State private var dropTargetPosition: (Int, Int)?
    @State private var usedLetters: Set<String> = []
    
    let gridSize = 10
    let clues: [CrosswordClue] = [
        CrosswordClue(number: 1, clue: "사람의 정신 기능을 평가하는 검사", answer: "인지검사", startPosition: (0, 0), isHorizontal: true),
        CrosswordClue(number: 2, clue: "기억력, 주의력, 언어 등을 평가하는 검사의 약자", answer: "MMSE", startPosition: (0, 0), isHorizontal: false),
        CrosswordClue(number: 3, clue: "뇌의 인지 기능 중 과거의 경험을 저장하고 회상하는 능력", answer: "기억력", startPosition: (2, 3), isHorizontal: true),
        CrosswordClue(number: 4, clue: "현재 자신이 있는 시간, 장소, 상황을 아는 능력", answer: "지남력", startPosition: (3, 0), isHorizontal: true),
        CrosswordClue(number: 5, clue: "생각이나 개념을 말로 표현하는 능력", answer: "언어", startPosition: (6, 2), isHorizontal: false)
    ]
    
    // 모든 필요한 글자들을 모아서 배열로 만듭니다
    var allLetters: [String] {
        var letters = Set<String>()
        for clue in clues {
            for char in clue.answer {
                letters.insert(String(char))
            }
        }
        return Array(letters).sorted()
    }
    
    var body: some View {
        CrosswordGameContent()
    }
    
    // Letters component - 누락된 함수 구현
    private func LettersScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(allLetters, id: \.self) { letter in
                    DraggableLetter(
                        letter: letter,
                        isUsed: usedLetters.contains(letter),
                        onDragStarted: { self.draggedLetter = $0 }
                    )
                }
            }
            .padding()
        }
        .frame(height: 60)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    // Breaking up the body into smaller components to help compiler

    private func CrosswordGameContent() -> some View {
        VStack {
            Text("십자말풀이")
                .font(.largeTitle)
                .padding(.top)
            
            // Crossword Grid
            CrosswordGridView()
            
            // Available Letters
            LettersScrollView()
            
            // Clues Section
            CluesView()
            
            ActionButtonsView()
        }
        .alert(isPresented: $showCompletionAlert) {
            Alert(
                title: Text(isCorrect ? "축하합니다!" : "다시 시도해보세요"),
                message: Text(isCorrect ? "모든 문제를 맞추셨습니다!" : "일부 답이 틀렸습니다. 다시 시도해보세요."),
                dismissButton: .default(Text("확인"))
            )
        }
    }
    
    // Grid component
    // 셀 정보를 생성하는 함수를 별도로 분리
    private func createCellView(at position: (Int, Int)) -> some View {
        let cellInfo = getCellInfo(at: position)
        
        if !cellInfo.isActive {
            return AnyView(CrosswordCell(
                letter: "",
                isActive: false,
                isSelected: false,
                filledLetter: nil,
                position: position,
                onCellTap: { _ in },
                isDropTarget: false
            ))
        }
        
        let isTargetCell = dropTargetPosition.map { $0 == position } ?? false

        let cellLetter = cellInfo.letter
        let isSelectedCell = isPositionSelected(position)
        let userAnswer = userAnswers["\(position.0)-\(position.1)"]
        
        return AnyView(cellView(
            for: position,
            isActive: true,
            letter: cellLetter,
            isSelected: isSelectedCell,
            filledLetter: userAnswer,
            isDropTarget: isTargetCell
        ))
    }

    // 메인 CrosswordGridView 함수
    private func CrosswordGridView() -> some View {
        VStack(spacing: 0) {
            ForEach(0..<gridSize, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<gridSize, id: \.self) { col in
                        createCellView(at: (row, col))
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
    
    // Clues component
    private func CluesView() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("가로")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(clues.filter { $0.isHorizontal }, id: \.id) { clue in
                    clueView(for: clue)
                }
                
                Text("세로")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(clues.filter { !$0.isHorizontal }, id: \.id) { clue in
                    clueView(for: clue)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 200)
    }
    
    // Action buttons component
    private func ActionButtonsView() -> some View {
        HStack {
            Button("초기화") {
                resetGame()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("정답 확인하기") {
                checkAnswers()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(.bottom)
    }
    
    // Helper method to create cell views - breaking down complex expressions
    @ViewBuilder
    private func cellView(for position: (Int, Int), isActive: Bool, letter: String,
                         isSelected: Bool, filledLetter: String?, isDropTarget: Bool) -> some View {
        CrosswordCell(
            letter: letter,
            isActive: true,
            isSelected: isSelected,
            filledLetter: filledLetter,
            position: position,
            onCellTap: selectCell,
            isDropTarget: isDropTarget
        )
        .onDrop(of: [.text], isTargeted: nil) { providers, _ in
            handleDrop(at: position, providers: providers)
        }
    }
    
    // Helper method for handling drop - breaking down complex expressions
    private func handleDrop(at position: (Int, Int), providers: [NSItemProvider]) -> Bool {
        // Check if we have a selected clue
        guard let selectedClue = self.selectedClue else {
            return false
        }
        
        // Check if the position is part of the selected clue
        let positionInClue = selectedClue.positions.contains { $0 == position }
        guard positionInClue else {
            return false
        }
        
        // Check if we have a dragged letter
        guard let letter = self.draggedLetter else {
            return false
        }
        
        // Update the user's answer
        self.userAnswers["\(position.0)-\(position.1)"] = letter
        self.usedLetters.insert(letter)
        return true
    }
    
    // Helper method to create clue views - breaking down complex expressions
    @ViewBuilder
    private func clueView(for clue: CrosswordClue) -> some View {
        HStack {
            Text("\(clue.number).")
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(width: 30, alignment: .leading)
            
            Text(clue.clue)
                .font(.subheadline)
        }
        .padding(8)
        .background(selectedClue?.id == clue.id ? Color.yellow.opacity(0.3) : Color.clear)
        .cornerRadius(4)
        .onTapGesture {
            selectedClue = clue
        }
    }
    
    func getCellInfo(at position: (Int, Int)) -> (isActive: Bool, letter: String) {
        for clue in clues {
            if clue.positions.contains(where: { $0 == position }) {
                let index = clue.positions.firstIndex(where: { $0 == position })!
                let letterIndex = clue.answer.index(clue.answer.startIndex, offsetBy: index)
                return (true, String(clue.answer[letterIndex]))
            }
        }
        return (false, "")
    }
    
    func isPositionSelected(_ position: (Int, Int)) -> Bool {
        guard let selectedClue = selectedClue else { return false }
        return selectedClue.positions.contains(where: { $0 == position })
    }
    
    func selectCell(_ position: (Int, Int)) {
        for clue in clues {
            if clue.positions.contains(where: { $0 == position }) {
                selectedClue = clue
                return
            }
        }
    }
    
    func resetGame() {
        userAnswers = [:]
        usedLetters = []
    }
    
    func checkAnswers() {
        var allCorrect = true
        
        for clue in clues {
            for (index, position) in clue.positions.enumerated() {
                let userInput = userAnswers["\(position.0)-\(position.1)"] ?? ""
                let expectedIndex = clue.answer.index(clue.answer.startIndex, offsetBy: index)
                let expectedChar = String(clue.answer[expectedIndex])
                
                if userInput.isEmpty || userInput != expectedChar {
                    allCorrect = false
                    break
                }
            }
            
            if !allCorrect {
                break
            }
        }
        
        isCorrect = allCorrect
        showCompletionAlert = true
    }
}

#Preview {
    CrosswordGameView()
}
