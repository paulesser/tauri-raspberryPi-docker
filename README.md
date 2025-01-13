# Tauri build Image
This Image can be used in your Tauri App to build an executable for Linux Debian derivatives.
It uses pnpm as a package manger for the node project.
Add the Dockerfile and .dockerignore to the root of your Tauri project.

## Usage
```zsh
docker build -t tauri-build --target build -f Dockerfile .
docker run -v $(pwd)/release:/app/src-tauri/target/release/ tauri-build
```
The executable will be in the release folder of your project.
