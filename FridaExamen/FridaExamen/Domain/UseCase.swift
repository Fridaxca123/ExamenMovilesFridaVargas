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

