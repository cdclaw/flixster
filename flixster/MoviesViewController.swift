//
//  MoviesViewController.swift
//  flixster
//
//  Created by Lang Luo on 1/25/19.
//  Copyright © 2019 cdc. All rights reserved.
//

import UIKit
import AlamofireImage
// Step 1: add UITableDataSource, UITableViewDelegate here
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView! // after adding a tableView in storyboard, make an outlet to here
    var movies = [[String:Any]]() //a dictionary used to store data from api
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Step 3: add these
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
            
                // TODO: Get the array of movies
                
                // TODO: Store the movies in a property to use elsewhere
                self.movies = dataDictionary["results"] as! [[String:Any]]
                // TODO: Reload your table view data
                self.tableView.reloadData()
                
            }
        }
        task.resume()
    }
    // Step2: Implement these two functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell //reuse this cell for many times
        
        let movie = movies[indexPath.row] //movies is the dictinonary who stored fetched movie data from API (see viewDidLoad())
        let title = movie["title"] as! String // as! means cast in String type
        let synopsis = movie["overview"] as! String
        

        //cell.textLabel!.text = "row: \(indexPath.row)"
        //cell.textLabel!.text = title
        cell.titleLable.text = title
        cell.synopsisLable.text = synopsis
        
        // Getting the URL of poster from API
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL+posterPath) //using function URL() 
        
        
        cell.posterView.af_setImage(withURL: posterURL!)
        return cell
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Find the selected movie
        
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        
        let detailsViewController = segue.destination as! MovieDetailViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true) // to de-select the cell (make the gray disappear!)
    }
    

}
