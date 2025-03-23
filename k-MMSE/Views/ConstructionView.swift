import SwiftUI

struct ConstructionView: View {
    @Binding var test: KMMSETest
    
    var body: some View {
        List {
            Section(header: Text("구성 능력 테스트 (1점)")) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("다음과 같은 두 개의 오각형이 서로 교차하도록 그리게 하세요:")
                        .font(.headline)
                    
                    Image(systemName: "pentagon")
                        .font(.system(size: 100))
                        .overlay(
                            Image(systemName: "pentagon")
                                .font(.system(size: 100))
                                .rotationEffect(.degrees(30))
                        )
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    Toggle("정확하게 그렸습니까?", isOn: $test.construction.drawing)
                    
                    if test.construction.drawing {
                        Text("점수: 1")
                            .font(.headline)
                    } else {
                        Text("점수: 0")
                            .font(.headline)
                    }
                }
            }
        }
        .navigationTitle("구성 능력 평가")
    }
}

#Preview {
    NavigationView {
        ConstructionView(test: .constant(KMMSETest()))
    }
} 