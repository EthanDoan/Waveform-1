# Waveform

Waveform is a utility class for rendering wave (or "equalizer") animations on iOS or OS X using Core Animation and UIKit.
This project is basically a single UIView which offers a set of optimized layers that together create an "EQ" effect.

**WaveformView:** https://github.com/adamkaplan/Waveform/blob/master/Waveform/WaveformView.h

## Uses

- A "sound is muted" indicator on top of a playing movie or loop. It's very similar to the
sound indicator displayed in the Twitter app for iOS.
- A loading indicator or pull-to-refresh accessory
- Sample code to base your own Core Animation accelerated thinger

## Configurable Demo

![Waveform Demo Animation](https://cloud.githubusercontent.com/assets/727953/13556039/56b63d42-e39e-11e5-9592-dc80ff6e71c6.gif)

The project includes a runnable iOS demo app to help quickly prototype various configuration options.

### Configurable Options

* Bar count*
* Bar spacing
* Bar corner radius, height & width
* Bar height
* Bar width
* Bar size change animation minimum duration
* Bar size change animation maximum duration
* Bar alignment
* Bar color*
* Background color*

_\* Can be adjusted, not depicted in the demo_
