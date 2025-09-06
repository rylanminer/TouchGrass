//
//  ContentView.swift
//  APP NAME: TouchGrass
//  NAMES AND EMAILS: Rylan Miner (ryminer@iu.edu) & Maya Iyer (iyermaya@iu.edu)
//  SUBMISSION DATE: 05.05.25 @ 5PM
//
//  Created by Rylan Miner on 4/16/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 2
    @StateObject private var model = TouchGrassModel() // shared instance

    var body: some View {
        TabView(selection: $selection) {
            HistoryView(model: model)
                .tabItem {
                    Label("History", systemImage: "tray.full.fill")
                }
                .tag(1)

            ARGameView(model: model)
                .ignoresSafeArea(edges: .top)
                .tabItem {
                    Label("Play", systemImage: "gamecontroller.fill")
                }
                .tag(2)

            SettingsView(model: model)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(.green)
    }
}



#Preview {
    ContentView()
}
