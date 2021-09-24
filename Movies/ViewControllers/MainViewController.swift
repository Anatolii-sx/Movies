//
//  ViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 24.09.2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private let token = "c94f7e9a57d0752ffa00454d4c5912f4"
    private var url: String {
        "https://api.kinopoisk.cloud/movies/all/page/1/token/\(token)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
}

extension MainViewController {
    private func fetchData() {
        guard let url = URL(string: self.url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error with taking data")
                return
            }
            
            do {
                let allMoviesDescriptions = try JSONDecoder().decode(AllMoviesDescriptions.self, from: data)
                
                print(allMoviesDescriptions)
                
                DispatchQueue.main.async {
                    self.titleLabel.text = "\(allMoviesDescriptions.movies?.first?.title ?? "")"
                }
                
                DispatchQueue.global().async {
                    let https = "https:"
                    
                    guard let url = URL(string: https + (allMoviesDescriptions.movies?.first?.poster ?? "")) else { return }
                    guard let imageData = try? Data(contentsOf: url) else { return }
                    
                    DispatchQueue.main.async {
                        self.posterImage.image = UIImage(data: imageData)
                    }
                }
                
                
                
                
                
                
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
}

