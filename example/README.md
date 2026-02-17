# Hybrid Map Marker - Example

This example demonstrates how to use the `hybrid_map_marker` package to create custom Google Maps markers from Flutter widgets.

## Features Demonstrated

This example shows:

- **Icon markers** - Using Flutter's built-in `Icon` widget
- **SVG markers** - Using SVG images via `flutter_svg`
- **Asset image markers** - Using JPG and PNG images from assets
- **Network image markers** - Using images loaded from the network
- **Asset caching** - Pre-caching SVGs, images, and network images for correct rendering

## What This Example Does

The app displays a Google Map with five custom markers:

1. **Location Marker** - A circular amber container with a `Icons.location_on_outlined` icon
2. **SVG Marker** - A circular amber container with an SVG user icon
3. **JPG Marker** - A circular amber container with a JPG bird image
4. **PNG Marker** - A circular amber container with a PNG bird image
5. **Network Marker** - A circular amber container with an image loaded from a URL

All markers share a common circular amber style and are created using `HybridMapMarkerImpl.instance`.

## Setup

### 1. Get a Google Maps API Key

If you don't have a Google Maps API key:

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the **Maps SDK for Android** and **Maps SDK for iOS**
4. Create credentials (API Key)

### 2. Add Your Google Maps API Key

#### iOS

Edit `ios/Runner/AppDelegate.swift` and replace the placeholder with your actual API key:

```swift
GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY")
```

#### Android

Edit `android/app/src/main/AndroidManifest.xml` and add your API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY"/>
```

### 3. Run the Example

```bash
flutter pub get
flutter run
```

## Code Overview

### Asset Caching

Before creating markers, all assets are cached in parallel using `Future.wait`:

```dart
await Future.wait([
  _hybridMapMarker.cacheSvg(path: 'assets/user.svg'),
  _hybridMapMarker.cacheImage(path: 'assets/bird.jpg'),
  _hybridMapMarker.cacheImage(path: 'assets/bird.png'),
  _hybridMapMarker.cacheNetworkImage(
    path: 'https://docs.flutter.dev/assets/images/dash/Dash.png',
  ),
]);
```

### Marker Creation

Each marker is a Flutter widget converted to a `BitmapDescriptor` via `createIcon()`:

```dart
final icon = await _hybridMapMarker.createIcon(
  myWidget,
  size: Size(64, 64),
);
```

### Key Takeaways

1. **Always cache assets before creating markers** — SVGs, local images, and network images must be pre-cached so they render correctly.
2. **Any Flutter widget works** — Icons, SVGs, asset images, and network images can all be used as markers.
3. **Use a shared base widget** — The example uses a `_circleMarker()` helper to apply a consistent circular amber style to all markers.

## Assets

The example uses the following assets (declared in `pubspec.yaml`):

- `assets/user.svg` — SVG icon for the SVG marker
- `assets/bird.jpg` — JPG image for the JPG marker
- `assets/bird.png` — PNG image for the PNG marker

## Learn More

For more information about the `hybrid_map_marker` package, check the main [README](../README.md).
