import SwiftUI

struct RecallView: View {
    @Binding var test: KMMSETest
    
    var body: some View {
        List {
            Section(header: Text("기억 회상 테스트 (3점)")) {
                if test.memory.words.isEmpty {
                    Text("먼저 기억력 테스트를 완료해주세요.")
                        .foregroundColor(.red)
                } else {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("앞서 기억한 세 단어를 말씀해주세요:")
                            .font(.headline)
                        
                        ForEach(0..<3) { index in
                            Toggle("\(test.memory.words[index])",
                                   isOn: $test.recall.remembered[index])
                        }
                        
                        Text("점수: \(test.recall.score)")
                            .font(.headline)
                            .padding(.top)
                    }
                }
            }
        }
        .navigationTitle("기억 회상 평가")
    }
}

#Preview {
    NavigationView {
        RecallView(test: .constant(KMMSETest()))
    }
} 