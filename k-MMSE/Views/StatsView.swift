//
//  StatsView.swift
//  k-MMSE
//
//  Created by Cascade on 3/18/25.
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query private var results: [GameResult]
    @State private var selectedGameType: String? = nil
    
    var filteredResults: [GameResult] {
        if let selectedGameType = selectedGameType {
            return results.filter { $0.gameType == selectedGameType }
        } else {
            return results
        }
    }
    
    var gameTypes: [String] {
        Array(Set(results.map { $0.gameType })).sorted()
    }
    
    var averageScore: Double {
        guard !filteredResults.isEmpty else { return 0 }
        let sum = filteredResults.reduce(0) { $0 + $1.score }
        return Double(sum) / Double(filteredResults.count)
    }
    
    var body: some View {
        VStack {
            Text("게임 결과 통계")
                .font(.largeTitle)
                .padding()
            
            if results.isEmpty {
                Spacer()
                Text("아직 게임 결과가 없습니다")
                    .font(.title)
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                // 게임 유형 필터
                Picker("게임 유형", selection: $selectedGameType) {
                    Text("모든 게임").tag(nil as String?)
                    ForEach(gameTypes, id: \.self) { gameType in
                        Text(gameType).tag(gameType as String?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // 평균 점수 표시
                HStack {
                    VStack(alignment: .leading) {
                        Text("평균 점수")
                            .font(.headline)
                        Text(String(format: "%.1f", averageScore))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("총 게임 수")
                            .font(.headline)
                        Text("\(filteredResults.count)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // 차트 표시
                if #available(iOS 16.0, *) {
                    Chart {
                        ForEach(filteredResults.sorted(by: { $0.timestamp < $1.timestamp }).suffix(10)) { result in
                            BarMark(
                                x: .value("날짜", result.timestamp, unit: .day),
                                y: .value("점수", result.score)
                            )
                            .foregroundStyle(by: .value("게임", result.gameType))
                        }
                    }
                    .frame(height: 250)
                    .padding()
                    .chartXAxis {
                        AxisMarks(values: .automatic) { value in
                            if let date = value.as(Date.self) {
                                AxisValueLabel {
                                    Text(date, format: .dateTime.month().day())
                                }
                            }
                        }
                    }
                } else {
                    // iOS 16 미만 버전을 위한 대체 뷰
                    List {
                        ForEach(filteredResults.sorted(by: { $0.timestamp > $1.timestamp })) { result in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(result.gameType)
                                        .font(.headline)
                                    Text(result.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("점수: \(result.score)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    StatsView()
        .modelContainer(for: GameResult.self, inMemory: true)
}
