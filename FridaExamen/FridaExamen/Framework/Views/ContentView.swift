//
//  ContentView.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//
import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SudokuViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Selección tamaño y dificultad
                HStack {
                    Picker("Tamaño", selection: $viewModel.size) {
                        Text("4x4").tag(4)
                        Text("9x9").tag(9)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Picker("Dificultad", selection: $viewModel.difficulty) {
                        Text("Easy").tag("easy")
                        Text("Medium").tag("medium")
                        Text("Hard").tag("hard")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()

                Button("Cargar Sudoku") {
                    Task { await viewModel.loadSudoku() }
                }
                .padding()

                if viewModel.isLoading {
                    ProgressView("Cargando Sudoku...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
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
                    }

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


