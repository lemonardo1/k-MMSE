import SwiftUI

struct LanguageView: View {
    @Binding var test: KMMSETest
    
    var body: some View {
        List {
            Section(header: Text("이름 대기 (2점)")) {
                Toggle("시계를 보고 이름을 말했습니까?", isOn: $test.language.naming[0])
                Toggle("연필을 보고 이름을 말했습니까?", isOn: $test.language.naming[1])
            }
            
            Section(header: Text("따라 말하기 (1점)")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("다음 문장을 따라 말하게 하세요:")
                        .font(.headline)
                    Text("\"오늘은 날씨가 매우 덥습니다.\"")
                        .font(.title3)
                    Toggle("정확하게 따라 말했습니까?", isOn: $test.language.repetition)
                }
            }
            
            Section(header: Text("3단계 명령 이행 (3점)")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("다음 명령을 순서대로 수행하게 하세요:")
                        .font(.headline)
                    Text("\"오른손으로 종이를 잡으세요.\"")
                    Toggle("첫 번째 단계를 수행했습니까?", isOn: $test.language.threeStageCommand[0])
                    
                    Text("\"반으로 접으세요.\"")
                    Toggle("두 번째 단계를 수행했습니까?", isOn: $test.language.threeStageCommand[1])
                    
                    Text("\"무릎 위에 놓으세요.\"")
                    Toggle("세 번째 단계를 수행했습니까?", isOn: $test.language.threeStageCommand[2])
                }
            }
            
            Section(header: Text("읽고 수행하기 (1점)")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("다음 문장을 보여주고 수행하게 하세요:")
                        .font(.headline)
                    Text("\"눈을 감으세요.\"")
                        .font(.title3)
                    Toggle("지시대로 수행했습니까?", isOn: $test.language.reading)
                }
            }
            
            Section(header: Text("쓰기 (1점)")) {
                Toggle("완전한 문장을 썼습니까?", isOn: $test.language.writing)
            }
            
            Section {
                Text("총점: \(test.language.score)")
                    .font(.headline)
            }
        }
        .navigationTitle("언어 능력 평가")
    }
}

#Preview {
    NavigationView {
        LanguageView(test: .constant(KMMSETest()))
    }
} 