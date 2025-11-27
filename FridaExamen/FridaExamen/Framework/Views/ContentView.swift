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
                                    
                                    SudokuCellView(cell: cell) { newValue in
                                        viewModel.updateCell(row: row, col: col, value: newValue)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    // Botón para checar la solución
                    Button("Verificar Sudoku") {
                        viewModel.checkSolution()
                    }
                    .padding()
                    
                    if let message = viewModel.checkMessage {
                        Text(message)
                            .foregroundColor(message.contains("correcto") ? .green : .red)
                            .padding()
                    }
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
    var onCommit: ((Int) -> Void)? = nil
    
    @State private var textValue: String = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(cell.isEditable ? Color.white : Color.gray.opacity(0.3))
                .border(Color.black, width: 1)
            
            if cell.isEditable {
                TextField("", text: $textValue)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .font(.headline)
                    .frame(width: 35, height: 35) // fuerza el tamaño
                    .fixedSize()
                    .onAppear {
                        textValue = cell.value == 0 ? "" : "\(cell.value)"
                    }
                    .onChange(of: textValue) { newValue in
                        if let num = Int(newValue), (1...9).contains(num) {
                            onCommit?(num)
                        } else if newValue.isEmpty {
                            onCommit?(0)
                        } else {
                            textValue = cell.value == 0 ? "" : "\(cell.value)"
                        }
                    }
            } else {
                if cell.value != 0 {
                    Text("\(cell.value)")
                        .font(.headline)
                        .frame(width: 35, height: 35)
                }
            }
        }
    }
}


