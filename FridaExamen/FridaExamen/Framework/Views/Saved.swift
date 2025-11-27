//
//  Saved.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 27/11/25.
//
import SwiftUI

struct SavedGamesView: View {
    @StateObject private var viewModel = SudokuViewModel()
    @State private var showingDeleteAlert = false
    var body: some View {
        VStack {
            if viewModel.hasSavedGame() {
                Text("🔄 Partida guardada encontrada")
                    .foregroundColor(.blue)
                    .padding()

                Button("Cargar partida") {
                    Task { await viewModel.loadSudoku() }
                }
                .buttonStyle(.borderedProminent)
                .padding()

                SudokuBoardView(viewModel: viewModel)
                
                Button("Borrar partida") {
                    viewModel.clearSavedGame()
                    showingDeleteAlert = true
                }
                .tint(.red)
                .buttonStyle(.borderedProminent)
                .padding()
                .alert("Borrado", isPresented: $showingDeleteAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(viewModel.deleteMessage ?? "")
                }

            } else {
                Text("No hay partidas guardadas")
                    .padding()
            }
        }
        .navigationTitle("Partidas guardadas")
    }
}
