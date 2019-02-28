//
//  MovieRegisterViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 18/02/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import CoreData

class MovieRegisterViewController: UIViewController {
    
    var movie: Movie?

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var tfCategories: UITextField!
    @IBOutlet weak var tvSumary: UITextView!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var ivPoster: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            btAddEdit.setTitle("Alterar", for: .normal)
            
            tfTitle.text = movie.title
            tfRating.text = "\(movie.rating)"
            tfDuration.text = movie.duration
            tfCategories.text = movie.categories
            tvSumary.text = movie.sumary
            ivPoster.image = movie.image as? UIImage
            
        }
        
    }
    
    @IBAction func addEditMovie(_ sender: UIButton) {
        if movie == nil {
            movie = Movie(context: context)
        }
        movie?.title = tfTitle.text
        movie?.rating = Double(tfRating.text!) ?? 0
        movie?.duration = tfDuration.text
        movie?.categories = tfCategories.text
        movie?.sumary = tvSumary.text
        movie?.image = ivPoster.image
        
        do{
            try context.save()
            navigationController?.popViewController(animated: true)
        }catch{
            print(error)
        }
        
        
    }
    
    func selectPicture(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectPoster(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar pôster", message: "De onde você quer escolher o pôster?", preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.selectPicture(source: .camera)
        }
        alert.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (_) in
            self.selectPicture(source: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            print("funcinou o Cancelar")
        }

        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension MovieRegisterViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
           ivPoster.image = image
            
        }
        dismiss(animated: true, completion: nil)
    }
}
