# cookbock_flutter
It's a Flutter project built to demonstrate basic functionalities with Arweave, utilizing the `ardrive_ui` and `arweave` packages.

## Features
* Configuration setup for Arweave deployment.
* Usage example of using the `ardrive_ui` library
* Usage of `arweave` package, explained with an example

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
What things you need to install beforehand and how to install them.

* Flutter SDK - [Installation Guide](https://flutter.dev/docs/get-started/install)
* ArDrive Wallet

### Installation

```sh
# Clone the repo
git clone https://github.com/thiagocarvalhodev/arweave-cookbook.git

# Navigate into the directory
cd arweave-cookbook

# Install dependencies
flutter pub get
```

## Usage

How to deploy on Arweave using ArDrive

```sh
# Build the app
flutter build web
```
* Go to `build/web` folder and check if all files are there
* On a public drive, upload the web `build/web` folder
* Create a new manifest for that folder
* Open the manifest.json and copy the DataTX
* open arweave/{dataTXID} on your browser

It's linked a video explaining how to do it in the app. 

## Examples
A simple UI to fetch a transaction and visually show its information

## Contributing

Any contributions you make are greatly appreciated.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Thiago Carvalho - thiagocarvalho.dev@gmail.com

Project Link: [https://github.com/YourGitHubUsername/YourRepoName](https://github.com/YourGitHubUsername/YourRepoName)

## Acknowledgments

* Thank anyone whose code was used
* Inspiration
* etc
  

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
