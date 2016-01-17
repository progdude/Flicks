//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Archit Rathi on 1/5/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var movies:[NSDictionary]?;
    var filteredResults: [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;
        networkLabel.hidden = true;
        searchBar.delegate = self;
        

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary];
                            self.filteredResults = self.movies;
                            self.tableView.reloadData();
                    }
                }
                else{
                    self.tableView.hidden = true;
                    self.networkLabel.hidden = false;
                }
        });
        task.resume()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let filteredResults = filteredResults {
            return filteredResults.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell;
        
        let movie = filteredResults[indexPath.row];
        let title = movie["title"] as! String;
        let rating = movie["vote_average"] as! Double;
        let overview = movie["overview"] as! String;
        let posterPath = movie["poster_path"] as! String!;
        
        let baseUrl = "http://image.tmdb.org/t/p/w500";
        
        let imageUrl = NSURL(string: baseUrl+posterPath);
        cell.ratingLabel.text = "\(rating)";
        cell.overviewLabel.text = overview;
        cell.titleLabel.text = title;
        cell.posterView.setImageWithURLRequest(NSURLRequest(URL: imageUrl!), placeholderImage: nil, success: { (request, response, image) in
            cell.posterView.image = image
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                cell.posterView.alpha = 1.0
                }, completion: nil)
            }, failure: nil);
        
        
        
        return cell;
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        EZLoadingActivity.show("Loading...", disableUI: true);
        delay(2, closure: {
            self.refreshControl.endRefreshing()
            EZLoadingActivity.hide(success: true, animated: true)
        })
        
    }
    

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredResults = searchText.isEmpty ? movies : movies!.filter({ (movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        self.tableView.reloadData()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true);
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
