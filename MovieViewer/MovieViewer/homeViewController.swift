//
//  homeViewController.swift
//  MovieViewer
//
//  Created by Archit Rathi on 1/16/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit

class homeViewController: UIViewController {

    @IBOutlet weak var flickImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        rotateImageView();
    }
    
    private func rotateImageView() {
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.flickImage.transform = CGAffineTransformRotate(self.flickImage.transform, CGFloat(M_PI_2))
            }) { (finished) -> Void in
                if finished {
                    self.rotateImageView()
                }
        }
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
