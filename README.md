## Introduction

This is a custom gesture recognizer for iOS that will recognize a sequence of swipes in the up, down, left, and right directions. This was born out of a need for a [Konami Code](https://en.wikipedia.org/wiki/Konami_Code)-like gesture, but without the button presses and the ability to specify a custom sequence of swipes instead of the traditional Konami sequence (up, up, down, down, left, right, left, right).

## Usage

To use this in your project copy [`SwipeSequenceGestureRecognizer.swift`](https://github.com/mluton/SwipeSequenceGestureRecognizer/blob/master/SwipeSequenceGestureRecognizer/SwipeSequenceGestureRecognizer.swift) into your project. By default, the swipe sequence is the same as the Konami Code D-pad sequence: up, up, down, down, left, right, left, right. This can be changed by setting the `requiredSequence` property.

```
let swipeSequence = SwipeSequenceGestureRecognizer(target: self, action: #selector(self.handleSwipeSequence))
swipeSequence.requiredSequence = [.down, .down, .up, .left]
view.addGestureRecognizer(swipeSequence)
```

The directions are provided by a `SwipeDirection` enum.

```
enum SwipeDirection {
  case up
  case down
  case left
  case right
}
```

The handler will need to test for the `.ended` state specifically as it will be called while the gesture is being entered as the state changes and each swipe is being made.

```
@objc func handleSwipeSequence(sender: UITapGestureRecognizer) {
  if sender.state == .ended {
    print("swipe sequence entered" )
  }
}
```

### Background

There are a couple of existing projects that implement the Konami Code for iOS.

- https://github.com/objectiveSee/DRKonamiCode
- https://github.com/Plopix/PlopixKonamiCodeGesture

After studying both projects, I pulled what I felt were the best ideas from each into this project. Eliminating the need to deal with the 'B' 'A' button presses also allowed for a simpler/shorter implementation. The end result is a custom gesture recognizer that recognizes a sequence of swipe gestures. This can be used to implement easter eggs or secret functionality in iOS apps.

Comments, Feedback, Suggestions: [Michael Luton](mailto:mluton@icloud.com)
