//
//  Examen.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//

//definir cada uno de los parámetros de nuestra API que vamos a utilizar dentro de nuestro model
import Foundation

struct Country: Decodable, Identifiable {
    var id = UUID()
    let name: CountryName

    private enum CodingKeys: String, CodingKey {
        case name
    }
}

struct CountryName: Decodable {
    let common: String?
    let official: String?
}

struct CountryDetail: Decodable {
    let name: CountryName?
    let capital: [String]?
    let region: String?
    let population: Int?
    let flags: Flag?
}

struct Flag: Decodable {
    let png: String?
    let svg: String?
}
