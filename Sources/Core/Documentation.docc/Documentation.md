# ``SparkSwitch``

## Overview

The switch/toggle is available on **UIKit** and **SwiftUI** and requires at least **iOS 16**.

It is a control that toggles between on and off states.

### Implementation

- On SwiftUI, you need to use the ``SparkToggle`` View.
- On UIKit, you need to use the ``SparkUISwitch`` which inherit from an UIControl.

### Rendering

- Default :
![Component rendering.](component.png)

- When the isOn value is false :
![Component rendering.](component_off.png)

- With a short title : 
![Component rendering with a short title.](component_with_title.png)

- With a multiline title : 
![Component rendering with a multiline title.](component_with_mutliline.png)

- When the disabled state is active : 
![Component rendering when isEnabled is false.](component_disabled.png)

## A11y

- If the *UIAccessibility.isOnOffSwitchLabelsEnabled* is true, the icons will be displayed.
- If the *UIAccessibility.isReduceMotionEnabled* is true, no animation will be played when the isOn value changed.
- If the high contrasts is enabled, , the icons will be displayed.
- If you not provide a text, you must set the **accessibilityLabel**.

## Resources

- Specification on [ZeroHeight](https://zeroheight.com/1186e1705/p/58a2c6-switch)
- Design on [Figma](https://www.figma.com/design/0QchRdipAVuvVoDfTjLrgQ/Spark-Component-Specs?node-id=267-8340)
