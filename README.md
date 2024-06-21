# Switch
Component used when a simple choice (true/false) is needed in form.

## Specifications
The switch specifications on Zeroheight is [here](https://spark.adevinta.com/1186e1705/p/58a2c6-switch).

![Figma anatomy](https://github.com/adevinta/spark-ios-component-switch/blob/main/.github/assets/anatomy.png)

## Usage
Switch is available both in UIKit and SwiftUI.

### SwitchUIView
Properties:
* `theme`: The current Spark-Theme. [You can always define your own theme.](https://github.com/adevinta/spark-ios/wiki/Theming#your-own-theming)
* `isOn`: The switch value. True if the switch is on, false if not.
* `alignment`: The switch content alignment, e.g. left (means switch on the left, text on the right), right (means switch on the right, text on the left).
* `intent`: The switch intent, e.g. main, support.
* `isEnabled`: The switch state: enabled or not.
* `images`: The optional switch images (composed of *on* and *off* state images).
* `text`: The optional switch text.
* `attributedText`: The optional switch attributed text.
* `delegate`: The delegate used to notify about some changed on switch.

Published Properties:
* `isOnChangedPublisher`: The publisher used to notify when isOn value changed on switch.

### SwitchView
Properties:
* `theme`: The current Spark-Theme. [You can always define your own theme.](https://github.com/adevinta/spark-ios/wiki/Theming#your-own-theming)
* `isOn`: The switch value. True if the switch is on, false if not. It is a binding property.
* `alignment`: The switch content alignment, e.g. left (means switch on the left, text on the right), right (means switch on the right, text on the left).
* `intent`: The switch intent, e.g. main, support.
* `images`: The optional switch images (composed of *on* and *off* state images).
* `text`: The optional switch text.
* `attributedText`: The optional switch attributed text.
* `disabled`: The switch is disabled or not.

Default values:
* `images`: `nil`
* `text`: `nil`
* `attributedText`: `nil`

Modifiers:
* `.images(SwitchImages?) -> Self`
* `.text(String?) -> Self`
* `.attributedText(AttributedString?) -> Self`
* `.disabled(Bool) -> Self`

## Initialization

### UIKit

There are four possibilities to initialize the switch.

```swift
// Initialize a new switch view without images and with text.
let switch = SwitchUIView(
    theme: theme,
    isOn: true,
    alignment: .left,
    intent: .main,
    isEnabled: true,
    text: "My Switch"
)
```

```swift
// Initialize a new switch view without images and with attributedText.
let switch = SwitchUIView(
    theme: theme,
    isOn: true,
    alignment: .left,
    intent: .main,
    isEnabled: true,
    attributedText: NSAttributedString(string: "My switch")
)
```

```swift
// Initialize a new switch view with images and without text and attributedText.
let switch = SwitchUIView(
    isEnabled: true
    theme: theme,
    isOn: true,
    alignment: .left,
    intent: .main,
    isEnabled: true,
    images: SwitchUIImages(
        on: UIImage(systemName: "on"), 
        off: UIImage(systemName: "off")
    )
)
```

```swift
// Initialize a new switch view with images and text.
let switch = SwitchUIView(
    isEnabled: true
    theme: theme,
    isOn: true,
    alignment: .left,
    intent: .main,
    isEnabled: true,
    images: SwitchUIImages(
        on: UIImage(systemName: "on"), 
        off: UIImage(systemName: "off")
    ),
    text: "My Switch"
)
```

```swift
// Initialize a new switch view with images and attributed text.
let switch = SwitchUIView(
    isEnabled: true
    theme: theme,
    isOn: true,
    alignment: .left,
    intent: .main,
    isEnabled: true,
    images: SwitchUIImages(
        on: UIImage(systemName: "on"), 
        off: UIImage(systemName: "off")
    ),
    attributedText: NSAttributedString(string: "My switch")
)
```

```swift
// Initialize a new switch view without images, text and attributedText.
let switch = SwitchUIView(
    isEnabled: true
    theme: theme,
    isOn: true,
    alignment: .left,
    intent: .main,
    isEnabled: true
)
```

There's a `SwitchUIViewDelegate` with optional function to receive tap events:
* `switchDidChange(_ SwitchUIView:, isOn: Bool)` - Event is called when user tap on switch and sends the new isOn state.

**Important note**: There is no action when the user tap on the text.

### SwiftUI

```swift
// Initialize a new switch view and update it with all modifiers.
let switch = SwitchView(
    isOn: true,
    theme: theme,
    intent: .main,
    alignment: .left
)
.images: SwitchImages(
    on: Image(systemName: "on"), 
    off: Image(systemName: "off")
)
.text: "My switch"
.attributedText: NSAttributedString(string: "My switch")
.disabled(false)
```

**Important note**: There is no action when the user tap on the text.

## License

```
MIT License

Copyright (c) 2024 Adevinta

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```