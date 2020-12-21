import 'dart:math' as math;
import 'package:test/test.dart';

import 'package:kandinsky/kandinsky.dart';

const errorMargin = 255 / 100;
const hslErrorMargin = 360 / 100;
num errorCorrect(num n) => num.parse(n.toStringAsFixed(2));

void main() {
  test('convert a rgb array to a hsl array', () {
    var rgb = [175, 103, 31];
    var expected = [30 / 360, 70 / 100, 40 / 100].map((e) => e.round());

    expect(rgb2hsl(rgb).map((e) => e.round()), expected);
  });

  test('convert a hsl array to a rgb array', () {
    const hsl = [30 / 360, 70 / 100, 40 / 100];
    const expected = [175, 103, 31];

    var converted = hsl2rgb(hsl);

    var diff = [
      [converted[0], expected[0]].reduce(math.max) -
          [converted[0], expected[0]].reduce(math.min),
      [converted[1], expected[1]].reduce(math.max) -
          [converted[1], expected[1]].reduce(math.min),
      [converted[2], expected[2]].reduce(math.max) -
          [converted[2], expected[2]].reduce(math.min),
    ];

    for (var i = 0; i < diff.length; i++) {
      expect(diff[i] < errorMargin, true);
    }
  });

  test('linear interpolate a vector3', () {
    const a = [0.0, 0.0, 0.0];
    const b = [255.0, 255.0, 255.0];

    const expected1 = a;
    const expected2 = [127.5, 127.5, 127.5];
    const expected3 = b;

    var converted1 = lerp3(0, a, b);
    var converted2 = lerp3(0.5, a, b);
    var converted3 = lerp3(1, a, b);

    expect(converted1, expected1);
    expect(converted2, expected2);
    expect(converted3, expected3);
  });

  test('create a linear gradient between two vector3 colors', () {
    const a = [0.0, 0.0, 0.0];
    const b = [255.0, 255.0, 255.0];
    const n = 10;

    var out = linearGradient(10, a, b);

    var expected = List.generate(n, (i) => lerp3(i / (n - 1), a, b));
    expect(out, expected);
  });

  test('create a rounded linear gradient between two vector3 colors', () {
    const a = [0.0, 0.0, 0.0];
    const b = [255.0, 255.0, 255.0];
    const n = 10;

    var out = rLinearGradient(10, a, b);

    var expected =
        List.generate(n, (i) => lerp3(i / (n - 1), a, b).map((e) => e.round()));
    expect(out, expected);
  });

  test('create a linear gradient of multiple vector3 colors', () {
    const a = [0.0, 0.0, 0.0];
    const b = [255.0, 255.0, 255.0];
    const c = [23.0, 45.0, 67.0];
    const d = [99.0, 101.0, 222.0];
    const n = 10;

    for (var i = 1; i < 101; i += 1) {
      var mg2 = multiGradient(i, [a, b]);
      expect(mg2.length, i);
    }

    var g1 = [
      ...linearGradient((n / 3).ceil(), a, b),
      ...linearGradient((n / 3).round(), b, c),
      ...linearGradient((n / 3).ceil(), c, d),
    ];

    var g2 = multiGradient(n, [a, b, c, d]);

    expect(g1, g2);
  });

  test('create a rounded linear gradient of multiple vector3 colors', () {
    const a = [0.0, 0.0, 0.0];
    const b = [255.0, 255.0, 255.0];
    const c = [23.0, 45.0, 67.0];
    const d = [99.0, 101.0, 222.0];
    const n = 10;

    for (var i = 1; i < 101; i += 1) {
      var mg2 = multiGradient(i, [a, b]);
      expect(mg2.length, i);
    }

    var g1 = [
      ...linearGradient((n / 3).ceil(), a, b),
      ...linearGradient((n / 3).round(), b, c),
      ...linearGradient((n / 3).ceil(), c, d),
    ].map((color) => color.map((x) => x.round()));

    var g2 = rMultiGradient(n, [a, b, c, d]);

    expect(g1, g2);
  });

  test('create a nonlinear gradient between two vector3 colors', () {
    const a = [0, 0, 0];
    const b = [255, 255, 255];
    const n = 10;

    num easeFn(num t) => math.pow(t, 2);

    var out = gradient(easeFn, 10, a, b);
    var expected = List.generate(n, (i) => lerp3(easeFn(i / (n - 1)), a, b));

    expect(out, expected);
  });

  test('create a rounded nonlinear gradient between two vector3 colors', () {
    const a = [0, 0, 0];
    const b = [255, 255, 255];
    const n = 10;

    num easeFn(num t) => math.pow(t, 2);

    var out = rGradient(easeFn, 10, a, b);
    var expected = List.generate(
        n, (i) => lerp3(easeFn(i / (n - 1)), a, b).map((e) => e.round()));

    expect(out, expected);
  });

  test('convert a hex code to a rgb array', () {
    const hex = '#FF0000';
    const hexNoHash = 'FF0000';
    const expected = [0xFF, 0, 0];

    expect(hex2rgb(hex), expected);
    expect(hex2rgb(hexNoHash), expected);
  });

  test('convert a rgb array to a hex code', () {
    const expected = '#ff0000';
    const rgb = [0xFF, 0.0, 0.0];

    expect(rgb2hex(rgb), expected);
  });

  test('convert a hex code to a hsl array', () {
    const hex = '#af671f';
    var expected = [30 / 360, 70 / 100, 40 / 100].map(errorCorrect);

    expect(hex2hsl(hex).map(errorCorrect), expected);
  });

  test('convert a hsl array to a hex code', () {
    var expected = hex2rgb('#af671f');
    const hsl = [30 / 360, 70 / 100, 40 / 100];
    var converted = hex2rgb(hsl2hex(hsl));

    var diff = [
      [converted[0], expected[0]].reduce(math.max) -
          [converted[0], expected[0]].reduce(math.min),
      [converted[1], expected[1]].reduce(math.max) -
          [converted[1], expected[1]].reduce(math.min),
      [converted[2], expected[2]].reduce(math.max) -
          [converted[2], expected[2]].reduce(math.min),
    ];

    for (var i = 0; i < diff.length; i++) {
      expect(diff[i] < errorMargin, true);
    }
  });

  test('darken an rgb color', () {
    const rgb = [0x66, 0x99, 0xCC];
    const expected = [0x52, 0x7a, 0xa3];
    var converted = darkenRgb(0.2, rgb);

    expect(converted, expected);
  });

  test('lighten an rgb color', () {
    const rgb = [0x66, 0x99, 0xCC];
    const expected = [0x7a, 0xb8, 0xf5];
    var converted = lightenRgb(0.2, rgb);

    expect(converted, expected);
  });

  test('darken a hsl color', () {
    var hsl = [210 / 360, 0.5, 0.6].map(errorCorrect).toList();
    var expected =
        [210 / 360, 0.5, 0.6 - (0.6 * 0.2)].map(errorCorrect).toList();
    var converted = darkenHsl(0.2, hsl);

    expect(converted, expected);
  });

  test('lighten a hsl color', () {
    var hsl = [210 / 360, 0.5, 0.6].map(errorCorrect).toList();
    var expected =
        [210 / 360, 0.5, 0.6 + (0.6 * 0.2)].map(errorCorrect).toList();
    var converted = lightenHsl(0.2, hsl);

    expect(converted, expected);
  });

  test('lighten a hex code', () {
    const hex = '#6699CC';
    const expected = '#7ab8f5';
    var converted = lightenHex(0.2, hex);

    expect(converted, expected);
  });

  test('darken a hex code', () {
    const hex = '#6699CC';
    const expected = '#527aa3';
    var converted = darkenHex(0.2, hex);

    expect(converted, expected);
  });

  test('create a hsl complimentary colour pallete', () {
    var c = hex2hsl('#ff0000');
    var expected2 = ['#ff0000', '#00ffff']
        .map(hex2hsl)
        .map((c) => c.map(errorCorrect).toList())
        .toList();
    var result2 = complimentHsl(2, c);

    var diffs2 = List.generate(
        expected2.length,
        (i) => [
              [result2[i][0], expected2[i][0]].reduce(math.max) -
                  [result2[i][0], expected2[i][0]].reduce(math.min),
              [result2[i][1], expected2[i][1]].reduce(math.max) -
                  [result2[i][1], expected2[i][1]].reduce(math.min),
              [result2[i][2], expected2[i][2]].reduce(math.max) -
                  [result2[i][2], expected2[i][2]].reduce(math.min),
            ]).toList();

    for (var i = 0; i < diffs2.length; i++) {
      for (var j = 0; j < diffs2[i].length; j++) {
        expect(diffs2[i][j] < hslErrorMargin, true);
      }
    }

    var expected3 = ['#ff0000', '#0000ff', '#00ff00']
        .map(hex2hsl)
        .map((c) => c.map(errorCorrect).toList())
        .toList();
    var result3 =
        complimentHsl(3, c).map((c) => c.map(errorCorrect).toList()).toList();

    var diffs3 = List.generate(
        expected3.length,
        (i) => [
              [result3[i][0], expected3[i][0]].reduce(math.max) -
                  [result3[i][0], expected3[i][0]].reduce(math.min),
              [result3[i][1], expected3[i][1]].reduce(math.max) -
                  [result3[i][1], expected3[i][1]].reduce(math.min),
              [result3[i][2], expected3[i][2]].reduce(math.max) -
                  [result3[i][2], expected3[i][2]].reduce(math.min),
            ]).toList();

    for (var i = 0; i < diffs3.length; i++) {
      for (var j = 0; j < diffs3[i].length; j++) {
        expect(diffs3[i][j] < hslErrorMargin, true);
      }
    }

    var expected4 = ['#ff0000', '#7f00ff', '#00ffff', '#80ff00']
        .map(hex2hsl)
        .map((c) => c.map(errorCorrect).toList())
        .toList();
    var result4 =
        complimentHsl(4, c).map((c) => c.map(errorCorrect).toList()).toList();
    var diffs4 = List.generate(
        expected4.length,
        (i) => [
              [result4[i][0], expected4[i][0]].reduce(math.max) -
                  [result4[i][0], expected4[i][0]].reduce(math.min),
              [result4[i][1], expected4[i][1]].reduce(math.max) -
                  [result4[i][1], expected4[i][1]].reduce(math.min),
              [result4[i][2], expected4[i][2]].reduce(math.max) -
                  [result4[i][2], expected4[i][2]].reduce(math.min),
            ]);

    for (var i = 0; i < diffs4.length; i++) {
      for (var j = 0; j < diffs4[i].length; j++) {
        expect(diffs4[i][j] < hslErrorMargin, true);
      }
    }
  });

  test('create a rgb complimentary colour pallete', () {
    var c = hex2rgb('#ff0000');
    var expected2 = ['#ff0000', '#00ffff'].map(hex2rgb).toList();
    var result2 = complimentRgb(2, c);

    var diffs2 = List.generate(
        expected2.length,
        (i) => [
              [result2[i][0], expected2[i][0]].reduce(math.max) -
                  [result2[i][0], expected2[i][0]].reduce(math.min),
              [result2[i][1], expected2[i][1]].reduce(math.max) -
                  [result2[i][1], expected2[i][1]].reduce(math.min),
              [result2[i][2], expected2[i][2]].reduce(math.max) -
                  [result2[i][2], expected2[i][2]].reduce(math.min),
            ]);

    for (var i = 0; i < diffs2.length; i++) {
      for (var j = 0; j < diffs2[i].length; j++) {
        expect(diffs2[i][j] < hslErrorMargin, true);
      }
    }

    var expected3 = ['#ff0000', '#0000ff', '#00ff00'].map(hex2rgb).toList();
    var result3 = complimentRgb(3, c);

    var diffs3 = List.generate(
        expected3.length,
        (i) => [
              [result3[i][0], expected3[i][0]].reduce(math.max) -
                  [result3[i][0], expected3[i][0]].reduce(math.min),
              [result3[i][1], expected3[i][1]].reduce(math.max) -
                  [result3[i][1], expected3[i][1]].reduce(math.min),
              [result3[i][2], expected3[i][2]].reduce(math.max) -
                  [result3[i][2], expected3[i][2]].reduce(math.min),
            ]);

    for (var i = 0; i < diffs3.length; i++) {
      for (var j = 0; j < diffs3[i].length; j++) {
        expect(diffs3[i][j] < hslErrorMargin, true);
      }
    }

    var expected4 =
        ['#ff0000', '#7f00ff', '#00ffff', '#80ff00'].map(hex2rgb).toList();
    var result4 = complimentRgb(4, c);

    var diffs4 = List.generate(
        expected4.length,
        (i) => [
              [result4[i][0], expected4[i][0]].reduce(math.max) -
                  [result4[i][0], expected4[i][0]].reduce(math.min),
              [result4[i][1], expected4[i][1]].reduce(math.max) -
                  [result4[i][1], expected4[i][1]].reduce(math.min),
              [result4[i][2], expected4[i][2]].reduce(math.max) -
                  [result4[i][2], expected4[i][2]].reduce(math.min),
            ]);

    for (var i = 0; i < diffs4.length; i++) {
      for (var j = 0; j < diffs4[i].length; j++) {
        expect(diffs4[i][j] < hslErrorMargin, true);
      }
    }
  });

  test('create a hex complimentary colour pallete', () {
    const c = '#ff0000';
    const expected2 = ['#ff0000', '#00ffff'];
    var result2 = complimentHex(2, c);
    expect(result2, expected2);

    const expected3 = ['#ff0000', '#0000ff', '#00ff00'];
    var result3 = complimentHex(3, c);
    expect(result3, expected3);

    const expected4 = ['#ff0000', '#7f00ff', '#00ffff', '#80ff00'];
    var result4 = complimentHex(4, c);
    expect(expected4, result4);
  });

  test('get a css string from an rgb color', () {
    const expected1 = 'rgba(255, 128, 64, 1)';
    expect(rgb2css(1, [255, 128, 64]), expected1);

    const expected2 = 'rgba(255, 128, 64, 1)';
    expect(rgb2css(1.5, [255, 128, 64]), expected2);

    const expected3 = 'rgba(255, 128, 64, 0.3)';
    expect(rgb2css(0.3, [255, 128, 64]), expected3);
  });

  test('get a css string from an hsl color', () {
    const expected1 = 'hsl(101, 62%, 41%, 1)';
    expect(hsl2css(1, [0.28, 0.62, 0.414]), expected1);

    const expected2 = 'hsl(101, 62%, 41%, 0.12)';
    expect(hsl2css(0.12, [0.28, 0.62, 0.414]), expected2);

    const expected3 = 'hsl(101, 62%, 41%, 1)';
    expect(hsl2css(1.5, [0.28, 0.62, 0.414]), expected3);
  });
}
