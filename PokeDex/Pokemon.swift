//
//  Pokemon.swift
//  PokeDex
//
//  Created by Niles Bingham on 12/2/20.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: Image
    let species: SpeciesURL
}

struct SpeciesURL: Codable {
    let url: String
}

struct Image: Codable {
    let front_default: String
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct Species: Codable {
    let flavor_text_entries: [FlavorEntries]
}

struct FlavorEntries: Codable{
    let flavor_text: String
    let language: Language
}

struct Language: Codable {
    let name: String
}
