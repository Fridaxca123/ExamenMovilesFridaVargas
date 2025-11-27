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
    
    func generateSudoku() async -> SudokuResponse? {
        // Incluye un parámetro para que la API genere el puzzle correctamente
        guard let url = URL(string: "\(Api.base)\(Api.routes.sudoku)?difficulty=easy") else { return nil }
        return await nservice.fetchSudoku(url: url)
    }

    
    // Convierte el puzzle en un tablero de SudokuCell para SwiftUI
    func getSudoku() async -> [[SudokuCell]]? {
        guard let response = await generateSudoku() else { return nil }
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
