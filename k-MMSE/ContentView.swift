//
//  ContentView.swift
//  k-MMSE
//
//  Created by mac on 3/18/25.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        MainMenuView()
    }
}

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ProgressGraphView()
                    .frame(height: 200)
                    .padding()

                RandomGameStartButton()
                    .padding(.bottom)

                GameListView()
            }
            .navigationTitle("K‑MMSE 인지 게임")
        }
    }
}


// 랜덤 게임 시작 버튼을 위한 새로운 뷰
struct RandomGameStartButton: View {
    @State private var selectedGame: AnyView? = nil
    @State private var isNavigating = false

    var body: some View {
        Button("시작하기") {
            startRandomGame()
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(width: 200, height: 50)
        .background(Color.blue)
        .cornerRadius(10)
        .padding()
        .navigationDestination(isPresented: $isNavigating) {
            selectedGame ?? AnyView(EmptyView())
        }
    }

    private func startRandomGame() {
        let games: [AnyView] = [
            AnyView(WordMemoryGameView()),
            AnyView(ShapeMemoryGameView()),
            AnyView(OrientationGameView()),
            AnyView(CrosswordGameView())
        ]
        selectedGame = games.randomElement()
        isNavigating = true
    }
}



struct GameListView: View {
    var body: some View {
        List {
            Section(header: Text("기억력 게임")) {
                GameListItem(
                    destination: WordMemoryGameView(),
                    iconName: "text.book.closed",
                    iconColor: .blue,
                    title: "단어 기억하기"
                )
                
                GameListItem(
                    destination: ShapeMemoryGameView(),
                    iconName: "square.on.circle",
                    iconColor: .green,
                    title: "형상 기억하기"
                )
            }
            
            Section(header: Text("지남력 게임")) {
                GameListItem(
                    destination: OrientationGameView(),
                    iconName: "calendar",
                    iconColor: .orange,
                    title: "시간 및 장소 인지"
                )
            }
            
            Section(header: Text("고난이도 게임")) {
                GameListItem(
                    destination: CrosswordGameView(),
                    iconName: "tablecells.badge.ellipsis",
                    iconColor: .purple,
                    title: "십자말풀이"
                )
            }
            
            Section(header: Text("통계")) {
                GameListItem(
                    destination: StatsView(),
                    iconName: "chart.bar",
                    iconColor: .red,
                    title: "게임 결과 및 진행도"
                )
            }
        }
    }
}

struct GameListItem<Destination: View>: View {
    let destination: Destination
    let iconName: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                Text(title)
            }
        }
    }
}

// 진행 그래프를 위한 새로운 뷰
struct ProgressGraphView: View {
    var body: some View {
        VStack {
            Text("주간 진행 현황")
                .font(.headline)
            
            // 여기에 실제 그래프 구현
            // 예시로 간단한 막대 그래프 표시
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7) { index in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue.opacity(0.7))
                            .frame(width: 30, height: CGFloat.random(in: 50...150))                    
                    }
                }
            }
            .padding(.top)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Item.self, GameResult.self], inMemory: true)
}

#Preview {
    MainMenuView()
}
