//
//  MovesCell.swift
//  pokedex
//
//  Created by Mohammed Owynat on 31/01/2016.
//  Copyright © 2016 Mohammed Owynat. All rights reserved.
//

import UIKit

class MovesCell: UITableViewCell {

    @IBOutlet weak var moveName: UILabel!
    //@IBOutlet weak var moveDetail: UILabel!
    
    //var moveArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(move: String) {
        moveName.text = move
        // rmoveDetail.text = "test"
    }

}
