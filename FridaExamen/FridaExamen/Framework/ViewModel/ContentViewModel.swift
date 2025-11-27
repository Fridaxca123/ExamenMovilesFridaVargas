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

    @Published var size: Int = 9
    @Published var difficulty: String = "easy"

    private let useCase: SudokuUseCaseProtocol
    private var sudoku: Sudoku?

    init(useCase: SudokuUseCaseProtocol = SudokuUseCase()) {
        self.useCase = useCase
    }

    func loadSudoku() async {
        isLoading = true
        errorMessage = nil
        checkMessage = nil

        if let sudoku = await useCase.loadSudoku(size: size, difficulty: difficulty) {
            self.sudoku = sudoku
            board = sudoku.puzzle.map { row in
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
        guard let sudoku = sudoku else { return }
        checkMessage = useCase.checkSudoku(sudoku: sudoku, current: board.map { $0.map { $0.value } }) ? "✅ Sudoku correcto" : "❌ Sudoku incorrecto"
    }
}
