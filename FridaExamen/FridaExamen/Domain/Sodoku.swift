//
//  Sodoku.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 27/11/25.
//
import Foundation
struct Sudoku {
    var puzzle: [[Int?]]
    var solution: [[Int]]
    
    func isCorrect(current: [[Int]]) -> Bool {
        for row in 0..<solution.count {
            for col in 0..<solution[row].count {
                if current[row][col] != solution[row][col] {
                    return false
                }
            }
        }
        return true
    }
}
