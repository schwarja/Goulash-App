# Goulash App

Goulash App is the one and only app where you can find list of restaurants that offer goulash on their menu.

This app serves as a sample app for implementing scenes and multiple window support.

## Scenes

At WWDC 2019, Apple introduced support for running multiple windows of one app next to each other which required app life-cycle updates. And that's the reason why [scenes](https://developer.apple.com/documentation/uikit/app_and_environment) were introduced.

The Goulash App contains two separate scenes:

1. The default scene runs on all platforms and it contains all app screens.
2. The detail scene can be opened only on iPadOS and macOS and contains just a restaurant detail.

## Issues

The app fetches restaurants from Firestore and it is dependant on Firestore SDK which has its own dependencies with some issues. If you want to build the app for macOS you need to manually set signing for gRPC-C C++.