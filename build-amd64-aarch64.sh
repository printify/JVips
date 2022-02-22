#/bin/bash
set -xe
# Run this script on aarch64 mac

rm -rf build/all

# Take the original JVips with prebuilt libraries for x64
mkdir -p build/all
curl -L https://github.com/criteo/JVips/releases/download/8.12.1-c46e83a/JVips.jar -o build/JVips.jar
unzip -o -d build/all build/JVips.jar 'libJVips*'
unzip -o -d build/all build/JVips.jar 'JVips*'

# Build libjvips for aarch64 linux
docker build --platform linux/arm64 --build-arg ARCH=aarch64 \
  --build-arg UID=$(id -u) --build-arg GID=$(id -g) -f .github/docker/linux/Dockerfile -t builder .
docker run --rm -e CI -e ARCH=aarch64 -v $(pwd):/app -w /app builder

# Build libjvips for aarch64 darwin, and bundle JVips.jar
./build.sh --without-linux --with-macos --arch aarch64 --skip-test