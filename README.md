# flutter_stripe_example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Why was this project created?

To understand the flow of how Stripe payments work. `It is an example` so, this project does not have error control and several security issues are omitted.

## Notes

- After cloning the project, create the `stripe_info.dart` file based on the `stripe_info_example.dart` file and configure the `publish` and `secret` fields, which correspond to the `Publishable key`, and the `Secret key` of your Stripe account.

- The `Secret key` should not be provided on the front end side. This information must be stored on the server side. In this project they are both on the front end because I wanted to understand the flow of payments in Stripe.



