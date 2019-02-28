//
//  MovieTableViewCell.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 13/02/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSumary: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func prepare(with movie: Movie){
        //ivPoster.image = UIImage(named: movie.image)
        lbTitle.text = movie.title
        lbSumary.text = movie.sumary
        lbRating.text = "⭐️ \(movie.rating)/10"
        ivPoster.image = movie.image as? UIImage
    }
}
