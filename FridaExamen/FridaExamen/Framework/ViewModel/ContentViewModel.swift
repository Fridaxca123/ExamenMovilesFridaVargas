//
//  ContentViewModel.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 27/11/25.
//
import SwiftUI
import Combine

@MainActor
final class CountryViewModel: ObservableObject {
    @Published var countryList: [Country] = []
    @Published var searchText: String = ""       
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // Computed property que regresa los países filtrados
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countryList
        } else {
            return countryList.filter {
                $0.name.common?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }

    func loadCountries() async {
        isLoading = true
        defer { isLoading = false }

        if let result = await CountryRepository.shared.getCountries() {
            self.countryList = result
        } else {
            self.errorMessage = "No se pudieron cargar los países."
        }
    }
}


