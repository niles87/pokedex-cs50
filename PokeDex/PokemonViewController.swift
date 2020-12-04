//
//  PokemonViewController.swift
//  PokeDex
//
//  Created by Niles Bingham on 12/2/20.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var type2Label: UILabel?
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var button: UIButton!
    
    var pokemon: Pokemon!
    var caught = UserDefaults.standard
    var state = CatchDict.init(c: [:])
    
    @IBAction func toggleCatch() {
        
        if state.c[pokemon.name] == false || state.c[pokemon.name] == nil {
            caught.set(true, forKey: pokemon.name)
            state.c[pokemon.name] = true
            button.setTitle("Free", for: .normal)
            return
        }
        
        state.c[pokemon.name] = false
        caught.set(false, forKey: pokemon.name)
        button.setTitle("Catch 'em", for: .normal)
    }
    
    func getImg(url: URL) {
        URLSession.shared.dataTask(with: url) { (imageData, _, imageError) in
            if let imageError = imageError { print(imageError); return }
            DispatchQueue.main.async {
                let image = UIImage(data: imageData!)
                self.image.image = image
            }
        }.resume()
    }
    
    func getDescription(url: URL) {
        var desc = ""
        URLSession.shared.dataTask(with: url) { (descData, descRes, descError) in
            guard let data = descData else { return }
            do {
                let speciesData = try JSONDecoder().decode(Species.self, from: data)
                
                for fText in speciesData.flavor_text_entries{
                    if fText.language.name == "en" {
                        desc = fText.flavor_text
                        break
                    }
                }
                desc = desc.replacingOccurrences(of: "\n", with: " ")
                desc = desc.replacingOccurrences(of: "\t", with: " ")
                desc = desc.replacingOccurrences(of: "\u{000C}", with: " ")
                DispatchQueue.main.async {
                    self.descriptionText.text = desc
                }
                
            } catch let error {
                print(error)
            }
        }.resume()
        
    }
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        numberLabel.text = ""
        typeLabel.text = ""
        type2Label?.text = ""
        descriptionText.text = ""
        
        let url = URL(string: pokemon.url)
        guard let req = url else { return }
        
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                
                let imgUrl = URL(string: pokemonData.sprites.front_default)
                guard let iu = imgUrl else { return }
                
                self.getImg(url: iu)
                
                let descURL = URL(string: pokemonData.species.url)
                guard let du = descURL else { return }
                
                self.getDescription(url: du)
                
                DispatchQueue.main.async {
                    self.nameLabel.text = self.capitalize(text: self.pokemon.name)
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    if self.caught.bool(forKey: self.pokemon.name) == true {
                        self.state.c[self.pokemon.name] = true
                    }
                    
                    if self.state.c[self.pokemon.name] == false || self.state.c[self.pokemon.name] == nil {
                        self.button.setTitle("Catch 'em", for: .normal)
                    } else {
                        self.button.setTitle("Free", for: .normal)
                    }
                    
                    for types in pokemonData.types {
                        if types.slot == 1 {
                            self.typeLabel.text = self.capitalize(text: types.type.name)
                        }
                        else if types.slot == 2 {
                            self.type2Label?.text = self.capitalize(text: types.type.name)
                        }
                    }
                }                
            }
                catch let error {
                print("\(error)")
            }
        }.resume()
    }

}
