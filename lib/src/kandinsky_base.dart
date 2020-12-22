import 'dart:math' as math;

String _padHex(String hexStr) => hexStr.length == 1 ? '0$hexStr' : hexStr;

num _wrapValue(num m, num _m, num v) {
  if (v < m) {
    var diff = _m - v - 1;
    return _wrapValue(m, _m, _m - diff);
  }
  if (v > _m) {
    var diff = v - _m - 1;
    return _wrapValue(m, _m, m + diff);
  }
  return v;
}

num _wrapNorm(num n) => _wrapValue(0, 1, n);

num _clamp(num min, num max, num n) {
  if (n < min) {
    return min;
  }
  if (n > max) {
    return max;
  }
  return n;
}

num _clampNorm(num n) => _clamp(0, 1, n);

/// returns a hsl array
List<num> rgb2hsl(List<num> color) {
  var r = color[0];
  var g = color[1];
  var b = color[2];

  var nr = r / 255;
  var ng = g / 255;
  var nb = b / 255;

  var max = [nr, ng, nb].reduce(math.max);
  var min = [nr, ng, nb].reduce(math.min);
  var h;
  var s;
  var l = (max + min) / 2;

  if (max == min) {
    h = 0;
    s = 0;
  } else {
    var d = max - min;
    s = (l > 0.5) ? d / (2 - max - min) : d / (max + min);

    if (max == nr) {
      h = (ng - nb) / d + (ng < nb ? 6 : 0);
    }
    if (max == ng) {
      h = (nb - nr) / d + 2;
    }
    if (max == nb) {
      h = (nr - ng) / d + 4;
    }

    h /= 6;
  }
  return [h, s, l];
}

/// returns a color saturation
num color2hue(num colorValue, num shading, num tint) {
  if (tint < 0) tint += 1;
  if (tint > 1) tint -= 1;

  if (tint < 1 / 6) {
    return colorValue + (shading - colorValue) * 6 * tint;
  }
  if (tint < 1 / 2) {
    return shading;
  }
  if (tint < 2 / 3) {
    return colorValue + (shading - colorValue) * (2 / 3 - tint) * 6;
  }

  return colorValue;
}

/// returns a rgb array
List<num> hsl2rgb(List<num> color) {
  var h = color[0];
  var s = color[1];
  var l = color[2];

  var r, g, b;

  if (s == 0) {
    r = g = b = l;
  } else {
    var q = (l < 0.5) ? l * (1 + s) : l + s - l * s;

    var p = 2 * l - q;

    r = color2hue(p, q, h + 1 / 3);
    g = color2hue(p, q, h);
    b = color2hue(p, q, h - 1 / 3);
  }

  return [(r * 255).round(), (g * 255).round(), (b * 255).round()];
}

/// returns a rgb array
List<num> hex2rgb(String hex) {
  var hs = hex[0] == '#' ? hex.substring(1) : hex;
  return [
    int.parse(hs[0] + hs[1], radix: 16),
    int.parse(hs[2] + hs[3], radix: 16),
    int.parse(hs[4] + hs[5], radix: 16)
  ];
}

/// returns a hex string
String rgb2hex(List<num> rgb) =>
    rgb.fold('#', (hex, c) => hex + _padHex(c.round().toRadixString(16)));

/// returns a hex string
List<num> hex2hsl(String hex) => rgb2hsl(hex2rgb(hex));

/// returns a hex string
String hsl2hex(List<num> color) => rgb2hex(hsl2rgb(color));

/// returns a darkened rgb array. `amount` is a value in the range `[0, 1]`
List<num> darkenRgb(num amount, List<num> rgb) {
  return rgb
      .map((c) => [
            [0, c + (c * -amount)].reduce(math.max),
            255
          ].reduce(math.min).round())
      .toList();
}

/// returns a lightened rgb array. `amount` is a value in the range `[0, 1]`
List<num> lightenRgb(num amount, List<num> rgb) => rgb
    .map((c) => [
          [0, c + (c * amount)].reduce(math.max),
          255
        ].reduce(math.min).round())
    .toList();

/// returns a darkened hsl array. `amount` is a value in the range `[0, 1]`
List<num> darkenHsl(num amount, List<num> color) {
  var h = color[0];
  var s = color[1];
  var l = color[2];
  return [h, s, _clampNorm(l - (l * amount))];
}

/// returns a lightened hsl array. `amount` is a value in the range `[0, 1]`
List<num> lightenHsl(num amount, List<num> color) {
  var h = color[0];
  var s = color[1];
  var l = color[2];
  return [h, s, _clampNorm(l + (l * amount))];
}

/// returns a lightened hex string. `amount` is a value in the range `[0, 1]`
String lightenHex(num amount, String hex) {
  var rgb = hex2rgb(hex);
  var ligthen = lightenRgb(amount, rgb);

  return rgb2hex(ligthen);
}

/// returns a darkened hex string. `amount` is a value in the range `[0, 1]`
String darkenHex(num amount, String hex) {
  var rgb = hex2rgb(hex);
  var ligthen = darkenRgb(amount, rgb);

  return rgb2hex(ligthen);
}

/// returns a Vector3 colour somewhere between `c1` and `c2`. `t` is the "time" value in the range `[0, 1]`
List<num> lerp3(num t, List<num> color1, List<num> color2) {
  var r1 = color1[0];
  var g1 = color1[1];
  var b1 = color1[2];

  var r2 = color2[0];
  var g2 = color2[1];
  var b2 = color2[2];

  return [
    r1 + (t * (r2 - r1)),
    g1 + (t * (g2 - g1)),
    b1 + (t * (b2 - b1)),
  ].toList();
}

/// returns an length `n` array of Vector3 colours. colours are evenly spaced between `color1` and `color2`.
List<List<num>> linearGradient(
  num n,
  List<num> color1,
  List<num> color2,
) {
  var d = (n - 1 != 0) ? n - 1 : 1;
  var result = List.generate(n, (i) => lerp3(i / d, color1, color2)).toList();
  return result;
}

/// returns an length `n` array of Vector3 colours. colours are between `color1` and `color2`, and are spaced according to the easing function `easeFn`.
List<List<num>> gradient(
    Function ease, int n, List<num> color1, List<num> color2) {
  var d = (n - 1 != 0) ? n - 1 : 1;
  var result =
      List.generate(n, (i) => lerp3(ease(i / d), color1, color2)).toList();
  return result;
}

/// returns a length `n` array of Vector3 colours. colours are the ones formed from the `linearGradient(n/(numColours-1), color1, color2)` for all colours `color1, color2, ..., colorN`
List<List<num>> multiGradient(num n, List<List<num>> colors) {
  var i = -1;
  return colors.fold([], (grad, color) {
    i = i + 1;
    if (i == 0) {
      return grad;
    }
    var color1 = colors[i - 1];
    var color2 = color;

    var values = (n / (colors.length - 1)).round();
    if (i == colors.length - 1 || i == 1) {
      values = (n / (colors.length - 1)).ceil();
    }

    return [...grad, ...linearGradient(values, color1, color2)];
  });
}

/// returns a rounded, length `n` array of Vector3 colours. colours are the ones formed from the `linearGradient(n/(numColours-1), color1, color2)` for all colours `color1, color2, ..., colorN`
List<List<num>> rMultiGradient(num n, List<List<num>> colors) {
  return multiGradient(n, colors)
      .map((color) => color.map((c) => c.round()).toList())
      .toList();
}

/// returns a rounded, length `n` array of Vector3 colours. colours are between `color1` and `color2`, and are spaced according to the easing function `easeFn`.
List<List<num>> rGradient(
        Function ease, num n, List<num> color1, List<num> color2) =>
    gradient(ease, n, color1, color2)
        .map((color) => color.map((c) => c.round()).toList())
        .toList();

/// returns a rounded, length `n` array of Vector3 colours. colours are evenly spaced between `color1` and `color2`.
List<List<num>> rLinearGradient(num n, List<num> color1, List<num> color2) {
  return linearGradient(n, color1, color2)
      .map((color) => color.map((c) => c.round()).toList())
      .toList();
}

/// returns an length `n` array of hsl Vector3. The 0th color is the same as the input `hsl`, while the others are colours corresponding to an eve turn around the colour wheel. If `n` is 3 for example, the two other colours would represent a 1/3 and 2/3 rotation of the colour wheel.
List<List<num>> complimentHsl(num n, List<num> color) {
  var h = color[0];
  var s = color[1];
  var l = color[2];
  return List.generate(n, (i) => [_wrapNorm(h - (i / n)), s, l]);
}

/// returns an length `n` array of rgb Vector3. The 0th color is the same as the input `rgb`, while the others are colours corresponding to an eve turn around the colour wheel. If `n` is 3 for example, the two other colours would represent a 1/3 and 2/3 rotation of the colour wheel.
List<List<num>> complimentRgb(num n, List<num> color) {
  return complimentHsl(n, rgb2hsl(color)).map(hsl2rgb).toList();
}

/// returns an length `n` array of hex strings. The 0th color is the same as the input `hexString`, while the others are colours corresponding to an eve turn around the colour wheel. If `n` is 3 for example, the two other colours would represent a 1/3 and 2/3 rotation of the colour wheel.
List<String> complimentHex(num n, String hex) {
  var hsl = hex2hsl(hex);
  return complimentHsl(n, hsl).map(hsl2hex).toList();
}

/// returns an rgba css string like `rgba(255, 255, 255, 1)` from the rgb color and alpha value
String rgb2css(num alpha, List<num> color) {
  var rgb = color.map((e) => _clamp(0, 255, e.round())).toList();
  var r = rgb[0];
  var g = rgb[1];
  var b = rgb[2];

  return 'rgba($r, $g, $b, ${_clampNorm(alpha)})';
}

/// returns an hsl css string like `hsl(222, 50%, 75%, 0.6)` from the hsl color and alpha value
String hsl2css(num alpha, List<num> hsl) {
  var h = hsl[0];
  var s = hsl[1];
  var l = hsl[2];

  var _h = (h * 360).round();
  var _s = (s * 100).round();
  var _l = (l * 100).round();
  return 'hsl($_h, $_s%, $_l%, ${_clampNorm(alpha)})';
}
