import 'dart:math' as math;

String padHex(String hexStr) => hexStr.length == 1 ? '0$hexStr' : hexStr;

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

num hue2rgb(num p, num q, num t) {
  if (t < 0) t += 1;
  if (t > 1) t -= 1;

  if (t < 1 / 6) {
    return p + (q - p) * 6 * t;
  }
  if (t < 1 / 2) {
    return q;
  }
  if (t < 2 / 3) {
    return p + (q - p) * (2 / 3 - t) * 6;
  }

  return p;
}

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

    r = hue2rgb(p, q, h + 1 / 3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1 / 3);
  }

  return [(r * 255).round(), (g * 255).round(), (b * 255).round()];
}

List<num> hex2rgb(String hex) {
  var hs = hex[0] == '#' ? hex.substring(1) : hex;
  return [
    int.parse(hs[0] + hs[1], radix: 16),
    int.parse(hs[2] + hs[3], radix: 16),
    int.parse(hs[4] + hs[5], radix: 16)
  ];
}

String rgb2hex(List<num> rgb) =>
    rgb.fold('#', (hex, c) => hex + padHex(c.round().toRadixString(16)));

List<num> hex2hsl(String hex) => rgb2hsl(hex2rgb(hex));

String hsl2hex(List<num> color) => rgb2hex(hsl2rgb(color));

List<num> darkenRgb(num amount, List<num> rgb) {
  return rgb
      .map((c) => [
            [0, c + (c * -amount)].reduce(math.max),
            255
          ].reduce(math.min).round())
      .toList();
}

List<num> lightenRgb(num amount, List<num> rgb) => rgb
    .map((c) => [
          [0, c + (c * amount)].reduce(math.max),
          255
        ].reduce(math.min).round())
    .toList();

List<num> darkenHsl(num amount, List<num> color) {
  var h = color[0];
  var s = color[1];
  var l = color[2];
  return [h, s, _clampNorm(l - (l * amount))];
}

List<num> lightenHsl(num amount, List<num> color) {
  var h = color[0];
  var s = color[1];
  var l = color[2];
  return [h, s, _clampNorm(l + (l * amount))];
}

String lightenHex(num amount, String hex) {
  var rgb = hex2rgb(hex);
  var ligthen = lightenRgb(amount, rgb);

  return rgb2hex(ligthen);
}

String darkenHex(num amount, String hex) {
  var rgb = hex2rgb(hex);
  var ligthen = darkenRgb(amount, rgb);

  return rgb2hex(ligthen);
}

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

List<List<num>> linearGradient(
  num n,
  List<num> color1,
  List<num> color2,
) {
  var d = (n - 1 != 0) ? n - 1 : 1;
  var result = List.generate(n, (i) => lerp3(i / d, color1, color2)).toList();
  return result;
}

List<List<num>> gradient(
    Function ease, int n, List<num> color1, List<num> color2) {
  var d = (n - 1 != 0) ? n - 1 : 1;
  var result =
      List.generate(n, (i) => lerp3(ease(i / d), color1, color2)).toList();
  return result;
}

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

List<List<num>> rMultiGradient(num n, List<List<num>> colors) {
  return multiGradient(n, colors)
      .map((color) => color.map((c) => c.round()).toList())
      .toList();
}

List<List<num>> rGradient(
        Function ease, num n, List<num> color1, List<num> color2) =>
    gradient(ease, n, color1, color2)
        .map((color) => color.map((c) => c.round()).toList())
        .toList();

List<List<num>> rLinearGradient(num n, List<num> color1, List<num> color2) {
  return linearGradient(n, color1, color2)
      .map((color) => color.map((c) => c.round()).toList())
      .toList();
}

List<List<num>> complimentHsl(num n, List<num> color) {
  var h = color[0];
  var s = color[1];
  var l = color[2];
  return List.generate(n, (i) => [_wrapNorm(h - (i / n)), s, l]);
}

List<List<num>> complimentRgb(num n, List<num> color) {
  return complimentHsl(n, rgb2hsl(color)).map(hsl2rgb).toList();
}

List<String> complimentHex(num n, String hex) {
  var hsl = hex2hsl(hex);
  return complimentHsl(n, hsl).map(hsl2hex).toList();
}

String rgb2css(num alpha, List<num> color) {
  var rgb = color.map((e) => _clamp(0, 255, e.round())).toList();
  var r = rgb[0];
  var g = rgb[1];
  var b = rgb[2];

  return 'rgba($r, $g, $b, ${_clampNorm(alpha)})';
}

String hsl2css(num alpha, List<num> hsl) {
  var h = hsl[0];
  var s = hsl[1];
  var l = hsl[2];

  var _h = (h * 360).round();
  var _s = (s * 100).round();
  var _l = (l * 100).round();
  return 'hsl($_h, $_s%, $_l%, ${_clampNorm(alpha)})';
}
