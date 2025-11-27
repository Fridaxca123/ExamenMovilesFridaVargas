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
    @Published var saveMessage: String?
    @Published var deleteMessage: String?
    @Published var size: Int = 9
    @Published var difficulty: String = "easy"

    private let useCase: SudokuUseCaseProtocol
    private var sudoku: Sudoku?
    private let storage = SudokuStorage() // mantener private

    init(useCase: SudokuUseCaseProtocol = SudokuUseCase()) {
        self.useCase = useCase
    }

    func hasSavedGame() -> Bool {
        return storage.load() != nil
    }

    func loadSudoku() async {
        isLoading = true
        errorMessage = nil
        checkMessage = nil

        // Primero intentamos cargar un puzzle guardado
        if let saved = storage.load() {
            size = saved.size
            difficulty = saved.difficulty
            sudoku = Sudoku(puzzle: saved.puzzle, solution: saved.current)
            board = saved.current.enumerated().map { r, row in
                row.enumerated().map { c, value in
                    SudokuCell(value: value, isEditable: sudoku!.puzzle[r][c] == nil)
                }
            }
            isLoading = false
            return
        }

        // Si no hay puzzle guardado, intentamos cargar desde la API
        do {
            guard let sudokuLoaded = try await useCase.loadSudoku(size: size, difficulty: difficulty) else {
                errorMessage = "No se pudo cargar el Sudoku"
                isLoading = false
                return
            }
            sudoku = sudokuLoaded
            board = sudokuLoaded.puzzle.map { row in
                row.map { value in
                    SudokuCell(value: value ?? 0, isEditable: value == nil)
                }
            }
        } catch {
            // Si hay error (offline o API fallida)
            errorMessage = "❌ No hay conexión. Puedes seguir jugando con el puzzle guardado."
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

    func saveGame() {
        guard let sudoku = sudoku else { return }
        storage.save(sudoku: sudoku, current: board.map { $0.map { $0.value } })
        saveMessage = "Partida guardada exitosamente"
    }

    func clearSavedGame() {
        storage.clear()
        deleteMessage = "Partida borrada exitosamente"
        Task { await loadSudoku() } // recarga un nuevo sudoku si quieres
    }
}
