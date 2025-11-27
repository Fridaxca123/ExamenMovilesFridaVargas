//
//  ContentView.swift
//  FridaExamen
//
//  Created by Frida Xcaret Vargas Trejo on 26/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CountryViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading…")
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text(error)
                        Button("Reintentar") {
                            Task { await viewModel.loadCountries() }
                        }
                    }
                } else {
                    List(viewModel.filteredCountries) { country in
                        Text(country.name.common ?? "Unknown")
                    }
                }
            }
            .navigationTitle("Countries")
            .searchable(text: $viewModel.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search country")
        }
        .task {
            await viewModel.loadCountries()
        }
    }
}

