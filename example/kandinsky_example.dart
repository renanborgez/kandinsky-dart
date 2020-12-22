import 'package:kandinsky/kandinsky.dart';

void main() {
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
