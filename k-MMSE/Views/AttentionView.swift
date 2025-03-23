import SwiftUI

struct AttentionView: View {
    @Binding var test: KMMSETest
    @State private var currentNumber = 100
    let backwardWord = ["나", "무", "젓", "가", "락"]
    
    var body: some View {
        List {
            Section(header: Text("주의력 및 계산력 테스트 (5점)")) {
                Picker("테스트 방식", selection: $test.attention.useCalculation) {
                    Text("100에서 7씩 빼기").tag(true)
                    Text("글자 거꾸로 말하기").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.vertical)
                
                if test.attention.useCalculation {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("100에서 7씩 빼기:")
                            .font(.headline)
                        
                        ForEach(0..<5) { index in
                            let expectedNumber = 100 - (7 * (index + 1))
                            Toggle("\(100 - (7 * index)) - 7 = \(expectedNumber)",
                                   isOn: $test.attention.calculations[index])
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("'나무젓가락'을 거꾸로 말하기:")
                            .font(.headline)
                        
                        ForEach(0..<5) { index in
                            Toggle("\(backwardWord[4-index])",
                                   isOn: $test.attention.backwardSpelling[index])
                        }
                    }
                }
                
                Text("점수: \(test.attention.score)")
                    .font(.headline)
            }
        }
        .navigationTitle("주의력 및 계산력 평가")
    }
}

#Preview {
    NavigationView {
        AttentionView(test: .constant(KMMSETest()))
    }
} 