# kandinsky-dart

[![Pub Version](https://img.shields.io/pub/v/kandinsky?color=purple&style=plastic)](https://pub.dev/packages/kandinsky)

Full ported version of [francisrstokes/kandinsky-js]

A tiny color library to create (dymanic and fixed) radial and linear gradients,
convert rgb, hue, hex, hsl and css colors.

## Documentation

Pub dev package: https://pub.dev/packages/kandinsky

Online documentation: http://kandinsky-dart.borges.ninja/

## Install
1. Depend on it

Add this to your package's pubspec.yaml file:

```yml
dependencies:
  kandinsky: any
```

2. Install it

You can install packages from the command line:

```sh
# with pub:
$ pub get

# with Flutter:
$ flutter pub get
```

## Usage

A simple usage example:

```dart
import 'package:kandinsky/kandinsky.dart' as kandinsky;

main() {
  var darkenHexColor = darkenHex(0.5, '#6699CC');
  print('my darken hex color: ${darkenHexColor}');

  var lightenHexColor = lightenHex(0.5, '#06795C');
  print('my lighten hex color: ${lightenHexColor}');

  var darkenRgbColor = darkenRgb(0.5, [180, 40, 20]);
  print('my darken rgb color: ${darkenRgbColor}');

  var lightenRgbColor = lightenRgb(0.5, [155, 90, 60]);
  print('my lighten rgb color: ${lightenRgbColor}');

  var myDynamicGradient = linearGradient(10, [255, 100, 50], [30, 200, 255]);
  print('my gradient with 10 colors: ${myDynamicGradient}');

  var myHslColorFromRgb = rgb2hsl([255, 255, 255]);
  print('my hsl color from a rgb color: ${myHslColorFromRgb}');
}
```

## API

You can check the online version here: http://kandinsky-dart.borges.ninja/

### __rgb2hsl(rgbArray)__

> returns a hsl array

---
```dart
List<num> rgb2hsl(List<num> color)
```
---

### __hsl2rgb(hslArray)__

> returns an rgb array

---
```dart
List<num> hsl2rgb(List<num> color)
```
---

### __hex2rgb(hexString)__

> returns an rgb array

---
```dart
List<num> hex2rgb(String hex)
```
---

### __rgb2hex(rgbArray)__

> returns a hex string

---
```dart
String rgb2hex(List<num> rgb)
```
---

### __hex2hsl(hexString)__

> returns a hsl array

---
```dart
List<num> hex2hsl(String hex)
```
---

### __hsl2hex(hslArray)__

> returns a hex string

---
```dart
String hsl2hex(List<num> color)
```
---

### __darkenRgb(amount, rgbArray)__

> returns a darkened rgb array. `amount` is a value in the range `[0, 1]`

---
```dart
List<num> darkenRgb(num amount, List<num> rgb)
```
---

### __lightenRgb(amount, rgbArray)__

> returns a lightened rgb array. `amount` is a value in the range `[0, 1]`

---
```dart
List<num> lightenRgb(num amount, List<num> rgb)
```
---

### __darkenHsl(amount, hslArray)__

> returns a darkened hsl array. `amount` is a value in the range `[0, 1]`

---
```dart
List<num> darkenHsl(num amount, List<num> color)
```
---

### __lightenHsl(amount, hslArray)__

> returns a lightened hsl array. `amount` is a value in the range `[0, 1]`

---
```dart
List<num> lightenHsl(num amount, List<num> color)
```
---

### __lightenHex(amount, hexString)__

> returns a lightened hex string. `amount` is a value in the range `[0, 1]`

---
```dart
String lightenHex(num amount, String hex)
```
---

### __darkenHex(amount, hexString)__

> returns a darkened hex string. `amount` is a value in the range `[0, 1]`

---
```dart
String darkenHex(num amount, String hex)
```
---

### __lerp3(t, c1, c2)__

> returns a Vector3 colour somewhere between `c1` and `c2`. `t` is the "time" value in the range `[0, 1]`

---
```dart
List<num> lerp3(num t, List<num> color1, List<num> color2)
```
---

### __linearGradient(n, c1, c2)__

> returns an length `n` array of Vector3 colours. colours are evenly spaced between `c1` and `c2`.

---
```dart
List<List<num>> linearGradient(num n, List<num> color1, List<num> color2)
```
---

### __gradient(easeFn, n, c1, c2)__

> returns an length `n` array of Vector3 colours. colours are between `color1` and `color2`, and are spaced according to the easing function `easeFn`.

---
```dart
List<List<num>> gradient(Function ease, int n, List<num> color1, List<num> color2)
```
---

### __multiGradient(n, [col1, col3, ..., colN])__

> returns a length `n` array of Vector3 colours. colours are the ones formed from the `linearGradient(n/(numColours-1), col1, col2)` for all colours `col1, col2, ..., colN`

---
```dart
List<List<num>> multiGradient(num n, List<List<num>> colors)
```
---


### __rLinearGradient(n, c1, c2)__

> returns a rounded, length `n` array of Vector3 colours. colours are evenly spaced between `color1` and `color2`.

---
```dart
List<List<num>> rLinearGradient(num n, List<num> color1, List<num> color2)
```
---

### __rGradient(easeFn, n, c1, c2)__

> returns a rounded, length `n` array of Vector3 colours. colours are between `color1` and `color2`, and are spaced according to the easing function `easeFn`.

---
```dart
List<List<num>> rGradient(Function ease, num n, List<num> color1, List<num> color2)
```
---

### __rMultiGradient(n, [col1, col3, ..., colN])__

> returns a rounded, length `n` array of Vector3 colours. colours are the ones formed from the `linearGradient(n/(numColours-1), col1, col2)` for all colours `col1, col2, ..., colN`

---
```dart
List<List<num>> rMultiGradient(num n, List<List<num>> colors)
```
---

### __complimentHex(n, hexString)__

> returns an length `n` array of hex strings. The 0th color is the same as the input `hexString`, while the others are colours corresponding to an eve turn around the colour wheel. If `n` is 3 for example, the two other colours would represent a 1/3 and 2/3 rotation of the colour wheel.

---
```dart
List<String> complimentHex(num n, String hex)
```
---

### __complimentHsl(n, hsl)__

> returns an length `n` array of hsl Vector3. The 0th color is the same as the input `hsl`, while the others are colours corresponding to an eve turn around the colour wheel. If `n` is 3 for example, the two other colours would represent a 1/3 and 2/3 rotation of the colour wheel.

---
```dart
List<List<num>> complimentHsl(num n, List<num> color)
```
---

### __complimentRgb(n, rgb)__

> returns an length `n` array of rgb Vector3. The 0th color is the same as the input `rgb`, while the others are colours corresponding to an eve turn around the colour wheel. If `n` is 3 for example, the two other colours would represent a 1/3 and 2/3 rotation of the colour wheel.

---
```dart
List<List<num>> complimentRgb(num n, List<num> color)
```
---

### __rgb2css(alpha, rgb)__

> returns an rgba css string like `rgba(255, 255, 255, 1)` from the rgb color and alpha value

---
```dart
String rgb2css(num alpha, List<num> color)
```
---

### __hsl2css(alpha, hsl)__

> returns an hsl css string like `hsl(222, 50%, 75%, 0.6)` from the hsl color and alpha value

---
```dart
String hsl2css(num alpha, List<num> hsl)
```
---

### __color2hue(num p, num q, num t)__

> returns a saturation of a specific color value

---
```dart
num color2hue(num colorValue, num shading, num tint)
```
---

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/renanborgez/kandinsky-dart/issues
[francisrstokes/kandinsky-js]: https://github.com/francisrstokes/kandinsky-js
