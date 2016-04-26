//
//  MasterViewController.swift
//  FTVZoomiOSViewControllerTransition
//
//  Created by William Archimède on 26/04/2016.
//  Copyright © 2016 William Archimède. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
}

// MARK: - UINavigationControllerDelegate

extension FirstViewController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FTVCustomAnimatedTransitioning()
    }
}


