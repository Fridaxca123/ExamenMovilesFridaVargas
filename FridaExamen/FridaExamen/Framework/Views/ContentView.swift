//
//  ContentView.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SudokuViewModel()
    
    // 9 columnas para Sudoku 9x9
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 9)
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Cargando Sudoku...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            // Aplanamos el tablero en un array lineal con fila, columna y celda
                            ForEach(Array(viewModel.board.enumerated()).flatMap { rowIndex, row in
                                row.enumerated().map { colIndex, cell in
                                    (rowIndex, colIndex, cell)
                                }
                            }, id: \.0) { row, col, cell in
                                SudokuCellView(cell: cell)
                                    .id("\(row)-\(col)") // ID único
                                    .onTapGesture {
                                        if cell.isEditable {
                                            viewModel.updateCell(row: row, col: col, value: (cell.value + 1) % 10)
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Sudoku")
            .task {
                await viewModel.loadSudoku() // Carga solo puzzle
            }
        }
    }
}

struct SudokuCellView: View {
    let cell: SudokuCell
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(cell.isEditable ? Color.white : Color.gray.opacity(0.3))
                .border(Color.black, width: 1)
                .frame(width: 35, height: 35)
            
            if cell.value != 0 {
                Text("\(cell.value)")
                    .font(.headline)
            }
        }
    }
}
