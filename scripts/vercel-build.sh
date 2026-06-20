#!/bin/bash
set -e

# Install Flutter (Vercel doesn't include it)
if [ ! -d "$HOME/flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$HOME/flutter"
fi
export PATH="$PATH:$HOME/flutter/bin"
flutter config --enable-web
flutter precache --web

# Create .env from Vercel environment variables
cat > .env <<EOF
APP_NAME=${APP_NAME:-GRC}
BASE_API_URL=${BASE_API_URL}
GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
RAZORPAY_KEY_ID=${RAZORPAY_KEY_ID}
EOF

flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release
