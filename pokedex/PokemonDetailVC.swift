//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Mohammed Owynat on 28/01/2016.
//  Copyright © 2016 Mohammed Owynat. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var evoImage1: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var evoSubView: UIView!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
        
        nameLabel.text = pokemon.name.capitalizedString
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")

        pokemon.downloadPokemonDetails { () -> () in
            //this will be called after donwload is done
            dispatch_async(dispatch_get_main_queue()) {
                self.showMoves()
                self.showBio()
                self.tableView.reloadData()
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showBio() {
        tableView.hidden = true
        evoSubView.hidden = false
        
        descriptionLabel.text = pokemon.description
        typeLabel.text = pokemon.type.capitalizedString
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        baseAttackLabel.text = pokemon.baseAttack
        pokedexIdLabel.text = "\(pokemon.pokedexId)"
        defenceLabel.text = pokemon.defence
        if pokemon.nextEvoId == ""{
            evoLabel.text = "No Evolutions"
            evoImage1.hidden = true
        } else {
            var evoString = "Next Evolution: \(pokemon.nextEvoText)"
            if Int(pokemon.nextEvoLevel) > 0 {
                evoString += " at level \(pokemon.nextEvoLevel)"
            }
            evoImage1.image = UIImage(named: pokemon.nextEvoId)
            evoLabel.text = evoString
        }
        
    }
    
    func showMoves() {
        tableView.hidden = false
        evoSubView.hidden = true

    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func segmentedControl(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            self.showMoves()
        } else {
            tableView.reloadData()
            self.showBio()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.movesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MovesCell") as? MovesCell {
            let moves = self.pokemon.movesArray[indexPath.row]
            cell.configureCell(moves)
            return cell
        } else {
            return UITableViewCell()
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}
