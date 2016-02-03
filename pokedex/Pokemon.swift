//
//  Pokemon.swift
//  pokedex
//
//  Created by Mohammed Owynat on 26/01/2016.
//  Copyright © 2016 Mohammed Owynat. All rights reserved.
//

import Foundation
class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _defence: String!
    private var _baseAttack: String!
    private var _nextEvoText: String!
    private var _nextEvoLevel: String!
    private var _nextEvoId: String!
    private var _pokemonUrl: String!
    private var _movesList: Dictionary<String, String>!
    private var _movesArray: [String]!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var defence: String {
        if _defence == nil {
            _defence = ""
        }
        return _defence
    }
    
    var baseAttack: String {
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var nextEvoText: String {
        if _nextEvoText == nil {
            _nextEvoText = ""
            
        }
        return _nextEvoText
    }
    
    var nextEvoLevel: String {
        if _nextEvoLevel == nil {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var pokeminUrl: String {
        return _pokemonUrl
    }
    
    var movesList: Dictionary<String, String> {
        if _movesList == nil {
            _movesList = ["":""]
        }
        return _movesList
    }
    
    var movesArray: [String] {
        if _movesArray == nil {
            _movesArray = []
        }
        return _movesArray
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: self._pokemonUrl)!
        
        session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseData = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    
                    if let pokemonJSON = json as? Dictionary<String, AnyObject> {
                        
                        if let weight = pokemonJSON["weight"] as? String {
                            self._weight = weight
                        }
                        
                        if let height = pokemonJSON["height"] as? String {
                            self._height = height
                        }
                        
                        if let attack = pokemonJSON["attack"] as? Int {
                            self._baseAttack = "\(attack)"
                        }
                        
                        if let defence = pokemonJSON["defense"] as? Int {
                            self._defence = "\(defence)"
                        }
                        
                        if let types = pokemonJSON["types"] as? [Dictionary<String, String>] {
                            
                            if let name = types[0]["name"] {
                                self._type = name
                            }
                            
                            if types.count > 1 {
                                
                                for var x = 1;  x < types.count; x++ {
                                    if let name = types[x]["name"] {
                                        self._type! += "/\(name)"
                                    }
                                }
                            }
                        }
                        
                        if let descArray = pokemonJSON["descriptions"] as? [Dictionary<String, String>] {
                            
                            if let descApiUrl = descArray[0]["resource_uri"] {
                                let fullDescApiUrl = "\(URL_BASE)\(descApiUrl)"
                                
                                let descApiNSUrl = NSURL(string: fullDescApiUrl)!
                                let newSession = NSURLSession.sharedSession()
                                newSession.dataTaskWithURL(descApiNSUrl) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                                    if let newResponseData = data {
                                        do {
                                            let json = try NSJSONSerialization.JSONObjectWithData(newResponseData, options: NSJSONReadingOptions.AllowFragments)
                                            
                                            if let descJSON = json as? Dictionary<String, AnyObject> {
                                                if let desc = descJSON["description"] as? String {
                                                    self._description = desc
                                                }
                                            }
                                            completed()
                                        } catch {
                                            print("could not serialise")
                                        }
                                    }
                                }.resume()
                            }
                        }
                        
                        if let evoArray = pokemonJSON["evolutions"] as? [Dictionary<String, AnyObject>] where evoArray.count > 0 {
                            if let toName = evoArray[0]["to"] as? String {
                                if toName.rangeOfString("mega") == nil {
                                    if let uri = evoArray[0]["resource_uri"] as? String {
                                        let modifiedStrForPokeId = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                        let evoToPokeId = modifiedStrForPokeId.stringByReplacingOccurrencesOfString("/", withString: "")
                                        
                                        if let levelUp = evoArray[0]["level"] as? Int {
                                            self._nextEvoLevel = "\(levelUp)"
                                        }
                                        self._nextEvoId = evoToPokeId
                                        self._nextEvoText = toName
                                    }
                                }
                            }
                        }
                        
                        if let movesArr = pokemonJSON["moves"] as? [String] {
                            self._movesArray = []
                            
                            for var index = 0; index < movesArr.count; ++index {

                            }
                        }

                        if let movesDict = pokemonJSON["moves"] as? [Dictionary<String, AnyObject>] {

                            self._movesList = [:]
                            self._movesArray = []
                            for var index = 0; index < movesDict.count; ++index {

                                if let move = movesDict[index]["name"]! as? String {
                                    //self._movesList[move] = "Description pending"
                                    self._movesArray.append(move)
                                    if let moveDescApiUrl = movesDict[index]["resource_uri"] {
                                        let fullMoveDescApiUrl = "\(URL_BASE)\(moveDescApiUrl)"
                                        let moveDescApiNSUrl = NSURL(string: fullMoveDescApiUrl)!
                                        
                                        let movesSession = NSURLSession.sharedSession()

                                        movesSession.dataTaskWithURL(moveDescApiNSUrl) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in

                                            if let moveResponseData = data {
                                                do {
                                                    let json = try NSJSONSerialization.JSONObjectWithData(moveResponseData, options: NSJSONReadingOptions.AllowFragments)

                                                    if let moveDescJSON = json as? Dictionary<String, AnyObject> {
                                                        if let parsedMoveDesc = moveDescJSON["description"] as? String {
                                                            self._movesList[move] = parsedMoveDesc
                                                        }
                                                        completed()
                                                    }
                                                } catch {
                                                    print("could not serialise")
                                                }
                                            }
                                        }.resume()
                                    }
                                }
                            }
                        }
                    }
                    completed()
                } catch {
                    print("could not serialise")
                }
            }
        }.resume()
    }
}