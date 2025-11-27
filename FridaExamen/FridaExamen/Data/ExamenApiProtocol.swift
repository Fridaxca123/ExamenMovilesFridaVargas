//
//  ExamenApiProtocol.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//
import Foundation

struct Api {
    static let base = "https://api.api-ninjas.com/v1"
    
    struct routes {
        static let sudoku = "/sudokugenerate"
    }
}

protocol SudokuAPIProtocol {
    func generateSudoku() async -> SudokuResponse?
}

class SudokuRepository: SudokuAPIProtocol {
    static let shared = SudokuRepository()
    let nservice: NetworkAPIService

    init(nservice: NetworkAPIService = .shared) {
        self.nservice = nservice
    }

    // Cumple con el protocolo
    func generateSudoku() async -> SudokuResponse? {
        // Default: 9x9, easy
        return await generateSudoku(size: 9, difficulty: "easy")
    }

    // Función flexible con tamaño y dificultad
    func generateSudoku(size: Int, difficulty: String) async -> SudokuResponse? {
        let width = size == 4 ? 2 : 3
        let height = size == 4 ? 2 : 3
        let urlString = "https://api.api-ninjas.com/v1/sudokugenerate?width=\(width)&height=\(height)&difficulty=\(difficulty)"
        guard let url = URL(string: urlString) else { return nil }
        return await nservice.fetchSudoku(url: url)
    }

    func getSudoku(size: Int, difficulty: String) async -> [[SudokuCell]]? {
        guard let response = await generateSudoku(size: size, difficulty: difficulty) else { return nil }

        var board: [[SudokuCell]] = []
        for row in response.puzzle {
            let rowCells = row.map { value in
                SudokuCell(value: value ?? 0, isEditable: value == nil)
            }
            board.append(rowCells)
        }
        return board
    }
}

struct SudokuCell {
    var value: Int
    var isEditable: Bool
}
