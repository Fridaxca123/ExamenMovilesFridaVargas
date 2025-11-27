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
    @Published var board: [[SudokuCell]] = Array(
        repeating: Array(repeating: SudokuCell(value: 0, isEditable: true), count: 9),
        count: 9
    )
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: SudokuRepository
    
    init(repository: SudokuRepository = .shared) {
        self.repository = repository
    }
    
    // Función para cargar el Sudoku desde la API
    func loadSudoku() async {
        isLoading = true
        errorMessage = nil
        
        if let newBoard = await repository.getSudoku() {
            board = newBoard
        } else {
            errorMessage = "No se pudo cargar el Sudoku"
        }
        
        isLoading = false
    }
    
    // Función opcional para actualizar un valor de celda
    func updateCell(row: Int, col: Int, value: Int) {
        guard board.indices.contains(row),
              board[row].indices.contains(col),
              board[row][col].isEditable else { return }
        
        board[row][col].value = value
    }
}
