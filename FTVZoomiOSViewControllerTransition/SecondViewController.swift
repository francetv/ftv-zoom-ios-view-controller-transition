//
//  DetailViewController.swift
//  FTVZoomiOSViewControllerTransition
//
//  Created by William Archimède on 26/04/2016.
//  Copyright © 2016 William Archimède. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.delegate = nil
    }
}
