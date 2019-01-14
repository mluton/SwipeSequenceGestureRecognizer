//
//  ViewController.swift
//  SwipeSequenceGestureRecognizer
//
//  Created by Michael Luton on 1/11/19.
//  Copyright © 2019 Michael Luton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let swipeSequence = SwipeSequenceGestureRecognizer(target: self, action: #selector(self.handleSwipeSequence))
    swipeSequence.requiredSequence = [.down, .down, .up, .left]
    view.addGestureRecognizer(swipeSequence)

    print("view did load")
  }

  @objc func handleSwipeSequence(sender: UITapGestureRecognizer) {
    if sender.state == .ended {
      print("swipe sequence entered" )
    }
  }
}

