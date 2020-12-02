//
//  ViewController.swift
//  PokeDex
//
//  Created by Niles Bingham on 12/2/20.
//

import UIKit

class ViewController: UITableViewController {

    let pokemon = [
        Pokemon(name: "Pikachu", number: 1),
        Pokemon(name: "Charmander", number: 2),
        Pokemon(name: "Squirtle", number: 3)
    ]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = pokemon[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = pokemon[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

