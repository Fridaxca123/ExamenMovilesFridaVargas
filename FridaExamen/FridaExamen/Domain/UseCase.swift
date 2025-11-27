//
//  UseCase.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 27/11/25.
//
import Foundation
protocol SudokuUseCaseProtocol {
    func loadSudoku(size: Int, difficulty: String) async -> Sudoku?
    func checkSudoku(sudoku: Sudoku, current: [[Int]]) -> Bool
}

class SudokuUseCase: SudokuUseCaseProtocol {
    private let repository: SudokuRepository

    init(repository: SudokuRepository = .shared) {
        self.repository = repository
    }

    func loadSudoku(size: Int, difficulty: String) async -> Sudoku? {
        guard let response = await repository.generateSudoku(size: size, difficulty: difficulty) else {
            return nil
        }
        return Sudoku(puzzle: response.puzzle, solution: response.solution)
    }

    func checkSudoku(sudoku: Sudoku, current: [[Int]]) -> Bool {
        return sudoku.isCorrect(current: current)
    }
}

class SudokuStorage {
    private let key = "saved_sudoku"

    func save(sudoku: Sudoku, current: [[Int]]) {
        let saved = SavedSudoku(
            puzzle: sudoku.puzzle,
            current: current,
            size: sudoku.puzzle.count,
            difficulty: "easy" // o la que tengas en sudoku
        )
        if let data = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load() -> SavedSudoku? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode(SavedSudoku.self, from: data) else {
            return nil
        }
        return saved
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

