//
//  ViewController.swift
//  LayoutScroll
//
//  Created by Brian on 9/11/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var refreshControl: UIRefreshControl!
    
    @objc func refreshData(sender: UIRefreshControl) {
        print("refresh data")
        sender.endRefreshing()
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refrsh Data")
        scrollView.refreshControl = refreshControl
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

