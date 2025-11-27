//
//  Examen.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//

//definir cada uno de los parámetros de nuestra API que vamos a utilizar dentro de nuestro model
import Foundation

// Modelo para la respuesta de la API de Sudoku
struct SudokuResponse: Codable {
    let puzzle: [[Int?]]      // Cada celda puede ser un número o nil
    let solution: [[Int]]     // La solución siempre tendrá todos los números
}
