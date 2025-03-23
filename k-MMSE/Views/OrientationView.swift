import SwiftUI

struct OrientationView: View {
    @Binding var test: KMMSETest
    
    var body: some View {
        List {
            Section(header: Text("시간 지남력 (5점)")) {
                Toggle("현재 연도를 알고 있습니까?", isOn: $test.timeOrientation.year)
                Toggle("현재 계절을 알고 있습니까?", isOn: $test.timeOrientation.season)
                Toggle("현재 날짜를 알고 있습니까?", isOn: $test.timeOrientation.date)
                Toggle("현재 요일을 알고 있습니까?", isOn: $test.timeOrientation.dayOfWeek)
                Toggle("현재 월을 알고 있습니까?", isOn: $test.timeOrientation.month)
                
                Text("점수: \(test.timeOrientation.score)")
                    .font(.headline)
            }
            
            Section(header: Text("장소 지남력 (5점)")) {
                Toggle("현재 있는 국가를 알고 있습니까?", isOn: $test.placeOrientation.country)
                Toggle("현재 있는 도/시를 알고 있습니까?", isOn: $test.placeOrientation.province)
                Toggle("현재 있는 구/군을 알고 있습니까?", isOn: $test.placeOrientation.district)
                Toggle("현재 있는 건물을 알고 있습니까?", isOn: $test.placeOrientation.building)
                Toggle("현재 있는 층/방을 알고 있습니까?", isOn: $test.placeOrientation.floor)
                
                Text("점수: \(test.placeOrientation.score)")
                    .font(.headline)
            }
        }
        .navigationTitle("지남력 평가")
    }
}

#Preview {
    NavigationView {
        OrientationView(test: .constant(KMMSETest()))
    }
} 