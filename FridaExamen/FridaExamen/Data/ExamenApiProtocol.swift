//
//  ExamenApiProtocol.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//

import Foundation

//api route y rutas
struct Api {
    static let base = "https://restcountries.com/v3.1"
    
    struct routes {
        static let allCountries = "/all"
    }
}

//protocolo de servicio
protocol CountryAPIProtocol {
    func getAllCountries() async -> [Country]?
}
//protocolo del servicio de API
//Esta clase es la que se conectará a nuestro Protocolo y a partir de ella se podrán cargar los datos hacia el ContentView

class CountryRepository {
    static let shared = CountryRepository()
    let nservice: NetworkAPIService
    
    init(nservice: NetworkAPIService = .shared) {
        self.nservice = nservice
    }
    
    func getCountries() async -> [Country]? {
        let url = URL(string: "https://restcountries.com/v3.1/all?fields=name")!
        return await nservice.fetchCountries(url: url)
    }
}



