//
//  New.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 27/11/25.
//
import SwiftUI
struct NewGameView: View {
    @StateObject private var viewModel = SudokuViewModel()

    var body: some View {
        VStack {
            // Selección tamaño y dificultad
            HStack {
                Picker("Tamaño", selection: $viewModel.size) {
                    Text("4x4").tag(4)
                    Text("9x9").tag(9)
                }
                .pickerStyle(.segmented)

                Picker("Dificultad", selection: $viewModel.difficulty) {
                    Text("Easy").tag("easy")
                    Text("Medium").tag("medium")
                    Text("Hard").tag("hard")
                }
                .pickerStyle(.segmented)
            }
            .padding()

            Button("Cargar Sudoku") {
                Task { await viewModel.loadSudoku() }
            }
            .buttonStyle(.borderedProminent)
            .padding()

            SudokuBoardView(viewModel: viewModel)
        }
        .navigationTitle("Nueva partida")
    }
}
