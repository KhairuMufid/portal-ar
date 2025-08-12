@echo off
echo Downloading Nunito fonts from Google Fonts...

echo Downloading Nunito Regular...
curl -L "https://github.com/google/fonts/raw/main/ofl/nunito/Nunito-Regular.ttf" -o "assets/fonts/Nunito-Regular.ttf"

echo Downloading Nunito SemiBold...
curl -L "https://github.com/google/fonts/raw/main/ofl/nunito/Nunito-SemiBold.ttf" -o "assets/fonts/Nunito-SemiBold.ttf"

echo Downloading Nunito Bold...
curl -L "https://github.com/google/fonts/raw/main/ofl/nunito/Nunito-Bold.ttf" -o "assets/fonts/Nunito-Bold.ttf"

echo Fonts downloaded successfully!
echo Please run 'flutter clean' and 'flutter pub get' after this.
