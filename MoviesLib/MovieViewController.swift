//
//  ViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 11/02/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import AVKit //trabalhar com imagem e video


class MovieViewController: UIViewController {
    
    var movie: Movie?
    var trailer: String = ""
    var moviePlayer: AVPlayer?
    var moviePlayerController: AVPlayerViewController?
    
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbSumary: UITextView!
    @IBOutlet weak var lbRating: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = movie?.title{
            loadTrailer(title: title)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let movie = movie{
            //ivPoster.image = UIImage(named: movie.image)
            ivPoster.image = movie.image as? UIImage
            lbTitle.text = movie.title
            lbCategory.text = movie.categories
            lbDuration.text = movie.duration
            lbRating.text = "⭐️ \(movie.rating)/10"
            lbSumary.text = movie.sumary
            
        }
    }
    
    func loadTrailer(title: String){
        API.loadTrailers(title: title) { (result) in
            guard let results = result?.results, let trailer = results.first else{return}
            self.trailer = trailer.previewUrl
            DispatchQueue.main.async {
                self.prepareVideo()
            }
        }
    }
    
    func prepareVideo(){
        guard let url = URL(string: trailer) else {return}
        moviePlayer = AVPlayer(url: url)
        moviePlayerController = AVPlayerViewController()
        moviePlayerController?.player = moviePlayer
        moviePlayerController?.showsPlaybackControls = true
        
    }
    
    @IBAction func playMovieTrailler(_ sender: UIButton) {
        guard let moviePlayerController = moviePlayerController else {return}
        present(moviePlayerController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieRegisterViewController {
            vc.movie = movie
        }
    }

    
}

