//
//  ContentView.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("🎯 Sudoku")
                    .font(.largeTitle)
                    .bold()
                
                NavigationLink("Nueva partida") {
                    NewGameView()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                NavigationLink("Partidas guardadas") {
                    SavedGamesView()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}


