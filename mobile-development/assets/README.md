# Assets Directory

This directory contains all static assets for the Kooka application.

## Structure

```
assets/
├── images/
│   ├── icons/          # App icons and UI icons
│   ├── illustrations/  # Character illustrations for AR content
│   ├── backgrounds/    # Background images and patterns
│   └── thumbnails/     # Thumbnail images for AR content
├── animations/         # Lottie files and other animations
├── sounds/            # Sound effects and background music
└── fonts/             # Custom fonts (if any)
```

## Image Guidelines

### Thumbnails
- Resolution: 512x512px minimum
- Format: PNG with transparency support
- Naming: snake_case (e.g., `forest_adventure.png`)
- Optimization: Compressed for mobile performance

### Icons
- Vector format preferred (SVG)
- Multiple resolutions for different screen densities
- Consistent style matching neumorphism design

### Illustrations
- High resolution for AR quality
- Child-friendly and colorful
- Consistent art style across all content

## Naming Convention

Use descriptive, lowercase names with underscores:
- `forest_adventure_thumbnail.png`
- `dino_castle_icon.svg`
- `background_gradient_blue.png`

## Asset Registration

Remember to register new assets in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/animations/
    - assets/sounds/
```

## Copyright & Licensing

All assets should be:
- Original creations or properly licensed
- Child-safe and appropriate
- Optimized for mobile performance
- Accessible (high contrast, clear visibility)

## Future Assets

Planned assets for upcoming releases:
- AR content thumbnails (6 initial themes)
- Character animations for loading states
- Sound effects for interactions
- Background music tracks
- UI element illustrations
