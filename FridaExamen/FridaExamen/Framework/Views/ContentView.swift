//
//  ContentView.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SudokuViewModel()
    
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
                    VStack(spacing: 2) {
                        ForEach(0..<viewModel.board.count, id: \.self) { row in
                            HStack(spacing: 2) {
                                ForEach(0..<viewModel.board[row].count, id: \.self) { col in
                                    let cell = viewModel.board[row][col]
                                    SudokuCellView(cell: cell)
                                        .onTapGesture {
                                            if cell.isEditable {
                                                viewModel.updateCell(row: row, col: col, value: (cell.value + 1) % 10)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Sudoku")
            .task {
                await viewModel.loadSudoku()
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

