//
//  SwipeSequenceGestureRecognizer.swift
//  SwipeSequenceGestureRecognizer
//
//  Created by Michael Luton on 1/11/19.
//  Copyright © 2019 Michael Luton. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

enum SwipeDirection {
  case up
  case down
  case left
  case right
}

class SwipeSequenceGestureRecognizer: UIGestureRecognizer {
  var requiredSequence: [SwipeDirection] = [.up, .up, .down, .down, .left, .right, .left, .right] {
    didSet {
      reset()
    }
  }

  private let swipeDistanceTolerance: CGFloat = 50.0
  private let minimumSwipeDistance: CGFloat = 25.0
  private let maxTimeBetweenGestures = 2.0
  private var lastGestureDate = Date()
  private var lastGestureStartPoint = CGPoint.zero
  private var enteredSequence = [SwipeDirection]()

  // MARK: - UIGestureRecognizerSubclass

  override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touchCount = event.touches(for: self)?.count, touchCount == 1 else {
      return
    }

    guard let touch = touches.first else {
      return
    }

    if state == .possible {
      state = .began
    }
    else if state == .changed {
      if Date().timeIntervalSince(lastGestureDate) > maxTimeBetweenGestures {
        state = .failed
      }
    }
    else {
      state = .failed
      return
    }

    lastGestureDate = Date()
    lastGestureStartPoint = touch.location(in: view)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touch = touches.first else {
      return
    }

    let directionToCheck = requiredSequence[enteredSequence.count]
    let currentTouchPoint = touch.location(in: view)

    if directionToCheck == .up || directionToCheck == .down {
      if abs(currentTouchPoint.x - lastGestureStartPoint.x) > swipeDistanceTolerance {
        state = .failed
      }
    }
    else {
      if abs(currentTouchPoint.y - lastGestureStartPoint.y) > swipeDistanceTolerance {
        state = .failed
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touch = touches.first else {
      return
    }

    guard state == .changed else {
      state = .failed
      return
    }

    let directionToCheck = requiredSequence[enteredSequence.count]
    let currentTouchPoint = touch.location(in: view)

    if directionToCheck == .up || directionToCheck == .down {
      let difference = currentTouchPoint.y - self.lastGestureStartPoint.y

      if !(directionToCheck == .up && difference < -1 * minimumSwipeDistance) &&
         !(directionToCheck == .down && difference > minimumSwipeDistance) {
        state = .failed
        return
      }
    }

    if directionToCheck == .left || directionToCheck == .right {
      let difference = currentTouchPoint.x - self.lastGestureStartPoint.x

      if !(directionToCheck == .left && difference < -1 * minimumSwipeDistance) &&
         !(directionToCheck == .right && difference > minimumSwipeDistance) {
        state = .failed
        return
      }
    }

    enteredSequence.append(requiredSequence[enteredSequence.count])
    lastGestureDate = Date()
    state = .changed

    if enteredSequence.count >= requiredSequence.count {
      state = .recognized
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    state = .failed
  }

  override func reset() {
    enteredSequence = []
    lastGestureStartPoint = CGPoint.zero
    super.reset()
  }
}
