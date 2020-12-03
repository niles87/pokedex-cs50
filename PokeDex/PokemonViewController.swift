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
    @IBOutlet var image: UIImageView!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeLabel.text = ""
        type2Label?.text = ""
        
        let url = URL(string: pokemon.url)
        guard let req = url else {
            return
        }
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                
                let imgUrl = URL(string: pokemonData.sprites.front_default)
                guard let iu = imgUrl else { return }
                
                self.getImg(url: iu, outlet: self.image)
                
                DispatchQueue.main.async {
                    self.nameLabel.text = self.capitalize(text: self.pokemon.name)
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    for types in pokemonData.types {
                        if types.slot == 1 {
                            self.typeLabel.text = types.type.name
                        }
                        else if types.slot == 2 {
                            self.type2Label?.text = types.type.name
                        }
                    }
                }                
            }
                catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    func getImg(url: URL, outlet: UIImageView) {
        let imageTask = URLSession.shared.dataTask(with: url) { (imageData, _, imageError) in
            if let imageError = imageError { print(imageError); return }
            DispatchQueue.main.async {
                let image = UIImage(data: imageData!)
                
                outlet.image = image
            }
        }
        imageTask.resume()
    }
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
}
