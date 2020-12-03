//
//  ViewController.swift
//  PokeDex
//
//  Created by Niles Bingham on 12/2/20.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    var pokemon: [Pokemon] = []
    var searchedPokemon: [Pokemon]! = []
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        guard let req = url else {
            return
        }
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                
                self.pokemon = pokemonList.results
                self.searchedPokemon = self.pokemon
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error{
                print("\(error)")
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: searchedPokemon[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = pokemon[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedPokemon = searchText.isEmpty ? pokemon : pokemon.filter { $0.name.contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

