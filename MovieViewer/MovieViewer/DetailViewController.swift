//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Archit Rathi on 1/18/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    var movie: NSDictionary!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String;
        
        overviewLabel.text = movie["overview"] as? String;
        
        
        let baseUrl = "http://image.tmdb.org/t/p/w500";
        
        if let posterPath = movie["poster_path"] as! String!{
            let posterUrl = NSURL(string: baseUrl+posterPath);
            posterImage.setImageWithURL(posterUrl!);
            
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

}
