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

#Preview {
    ContentView()
        .modelContainer(for: [Item.self, GameResult.self], inMemory: true)
}
