//
//  NetworkAPIService.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//

import Foundation
import Alamofire

class NetworkAPIService {
    static let shared = NetworkAPIService()
    
    func fetchSudoku(url: URL) async -> SudokuResponse? {
        print("🧩 Fetching sudoku from: \(url.absoluteString)")
        
        let headers: HTTPHeaders = [
            "X-Api-Key": "wLVPN1zV08lJYF7uXqgyPw==zVwp6TlVcAO1NLUf"
        ]
        let taskRequest = AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300) 
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            
            // RAW JSON para debug
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 RAW JSON RECEIVED (Sudoku):\n\(jsonString)")
            }
            
            do {
                return try JSONDecoder().decode(SudokuResponse.self, from: data)
            } catch {
                print("❌ Error decoding Sudoku:", error)
                return nil
            }
            
        case .failure(let error):
            print("❌ Network error Sudoku:", error.localizedDescription)
            return nil
        }
    }
}
