//
//  MainMenuView.swift
//  k-MMSE
//
//  Created by Cascade on 3/18/25.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("기억력 게임")) {
                    NavigationLink(destination: WordMemoryGameView()) {
                        HStack {
                            Image(systemName: "text.book.closed")
                                .foregroundColor(.blue)
                            Text("단어 기억하기")
                        }
                    }
                    
                    NavigationLink(destination: ShapeMemoryGameView()) {
                        HStack {
                            Image(systemName: "square.on.circle")
                                .foregroundColor(.green)
                            Text("형상 기억하기")
                        }
                    }
                }
                
                Section(header: Text("지남력 게임")) {
                    NavigationLink(destination: OrientationGameView()) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.orange)
                            Text("시간 및 장소 인지")
                        }
                    }
                }
                
                Section(header: Text("고난이도 게임")) {
                    NavigationLink(destination: CrosswordGameView()) {
                        HStack {
                            Image(systemName: "tablecells.badge.ellipsis")
                                .foregroundColor(.purple)
                            Text("십자말풀이")
                        }
                    }
                }
                
                Section(header: Text("통계")) {
                    NavigationLink(destination: StatsView()) {
                        HStack {
                            Image(systemName: "chart.bar")
                                .foregroundColor(.red)
                            Text("게임 결과 및 진행도")
                        }
                    }
                }
            }
            .navigationTitle("K-MMSE 인지 게임")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MainMenuView()
}
