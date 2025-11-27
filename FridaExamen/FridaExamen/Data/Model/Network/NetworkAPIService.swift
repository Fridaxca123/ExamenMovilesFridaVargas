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
    
    func fetchCountries(url: URL) async -> [Country]? {
        print("🌍 Fetching countries from: \(url.absoluteString)")

        let taskRequest = AF.request(url, method: .get).validate()
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            
            // ⬅️ AGREGA ESTO PARA VER QUÉ ESTÁ LLEGANDO
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 RAW JSON RECEIVED:\n\(jsonString)")
            }
            
            do {
                return try JSONDecoder().decode([Country].self, from: data)
            } catch {
                print("❌ Error decoding countries:", error)
                return nil
            }
            
        case .failure(let error):
            print("❌ Network error:", error.localizedDescription)
            return nil
        }
    }
}
