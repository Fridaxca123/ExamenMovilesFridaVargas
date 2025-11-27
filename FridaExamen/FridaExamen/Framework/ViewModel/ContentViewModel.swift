//
//  ContentViewModel.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 27/11/25.
//
import SwiftUI
import Combine
import SwiftUI

@MainActor
class SudokuViewModel: ObservableObject {
    @Published var board: [[SudokuCell]] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var checkMessage: String?

    @Published var size: Int = 9        // 4 o 9
    @Published var difficulty: String = "easy"  // easy, medium, hard

    private let repository: SudokuRepository
    private var solution: [[Int]] = []

    init(repository: SudokuRepository = .shared) {
        self.repository = repository
    }

    func loadSudoku() async {
        isLoading = true
        errorMessage = nil
        checkMessage = nil

        if let response = await repository.generateSudoku(size: size, difficulty: difficulty) {
            solution = response.solution

            board = response.puzzle.map { row in
                row.map { value in
                    SudokuCell(value: value ?? 0, isEditable: value == nil)
                }
            }
        } else {
            errorMessage = "No se pudo cargar el Sudoku"
        }

        isLoading = false
    }

    func updateCell(row: Int, col: Int, value: Int) {
        guard board.indices.contains(row),
              board[row].indices.contains(col),
              board[row][col].isEditable else { return }

        board[row][col].value = value
    }

    func checkSolution() {
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if board[row][col].value != solution[row][col] {
                    checkMessage = "❌ Sudoku incorrecto"
                    return
                }
            }
        }
        checkMessage = "✅ Sudoku correcto"
    }
}
