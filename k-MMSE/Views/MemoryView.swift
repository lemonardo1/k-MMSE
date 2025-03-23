import SwiftUI

struct MemoryView: View {
    @Binding var test: KMMSETest
    @State private var showingWords = true
    @State private var words = ["나무", "자동차", "모자"]
    
    var body: some View {
        List {
            Section(header: Text("기억력 테스트 (3점)")) {
                if showingWords {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("다음 세 단어를 잘 기억하세요:")
                            .font(.headline)
                        
                        ForEach(words, id: \.self) { word in
                            Text("• \(word)")
                                .font(.title2)
                        }
                        
                        Button("단어 숨기기") {
                            withAnimation {
                                showingWords = false
                                test.memory.words = words
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    ForEach(0..<3) { index in
                        Toggle("\(test.memory.words[index])를 기억했습니까?", 
                               isOn: $test.memory.remembered[index])
                    }
                    
                    Text("점수: \(test.memory.score)")
                        .font(.headline)
                }
            }
        }
        .navigationTitle("기억력 평가")
    }
}

#Preview {
    NavigationView {
        MemoryView(test: .constant(KMMSETest()))
    }
} 