# Tutorial: Getting Started Developing a Chat app with the Flutter SDK

> Simple chat app to demonstrate the basic principles of creating a chat app with PubNub.  This Flutter app is written in Dart and will work cross-platform.

PubNub allows you to create chat apps from scratch or add them to your existing applications. You can focus on creating the best user experience while PubNub takes care of scalability, reliability, security, and global legislative compliance.

Create 1:1 private chat rooms, group chats, or mega chats for large scale events, for a variety of use cases.

> For the sake of simplicity, this application will only focus on a single 'group chat' room

![Screenshot](https://raw.githubusercontent.com/PubNubDevelopers/GettingStarted-Flutter-SDK-Tutorial/main/media/browser_white.png)

## Demo

A hosted demo version of this application can be seen at https://pubnub.com/demo/flutter-chat/

## Features

- [Publish and Subscribe](https://www.pubnub.com/docs/sdks/dart/api-reference/publish-and-subscribe) for messages with the PubNub Dart SDK
- Use [Presence](https://www.pubnub.com/docs/sdks/dart/api-reference/presence) APIs to determine who is currently chatting
- The [History](https://www.pubnub.com/docs/sdks/dart/api-reference/storage-and-playback) API will retrieve past messages for users newly joining the chat
- Assign a 'friendly name' to yourself which will be available to others via the PubNub [Object](https://www.pubnub.com/docs/sdks/dart/api-reference/objects) storage APIs

## Installing / Getting Started

To run this project yourself you will need a PubNub account

### Requirements
- [Flutter](https://docs.flutter.dev/get-started/install).  
- [PubNub Account](https://admin.pubnub.com/) (*Free*)

<a href="https://dashboard.pubnub.com/signup">
	<img alt="PubNub Signup" src="https://i.imgur.com/og5DDjf.png" width=260 height=97/>
</a>

### Get Your PubNub Keys

1. You’ll first need to sign up for a [PubNub account](https://dashboard.pubnub.com/signup/). Once you sign up, you can get your unique PubNub keys from the [PubNub Developer Portal](https://admin.pubnub.com/).

1. Sign in to your [PubNub Dashboard](https://admin.pubnub.com/).

1. Click Apps, then **Create New App**.

1. Give your app a name, and click **Create**.

1. Click your new app to open its settings, then click its keyset.

1. Enable the Presence feature for your keyset.  **Also tick the boxes for both 'Presence Deltas' and 'Generate Leave on TCP FIN or RST'**.  This lets the app determine who joins and leaves for busy chats, and allows it to detect the browser window being closed respectively.

1. Enable the Stream Controller feature for your keyset.

1. Enable the Persistence feature for your keyset

1. Enable the Objects feature for your keyset.  **Also enable 'user metadata events'**, which will allow the app to know when users change their 'friendly name'.

1. Copy the Publish and Subscribe keys and paste them into your app as specified in the next step.

### Building and Running

- Clone the Github repository

```
git clone https://github.com/PubNubDevelopers/GettingStarted-Flutter-SDK-Tutorial.git
```

- Navigate to the application directory

```
cd GettingStarted-Swift-SDK-Tutorial
cd flutter_sdk_tutorial
```

- And install flutter packages

```
flutter packages get
```

- Add your pub/sub keys to `app_state.dart` which can be found in the `\lib\utils` directory.

-  Run the application in Chrome: `flutter run -d chrome`.  You can also run the app with any target device you have configured Flutter for, for example an Android emulator or iPhone simulator.

## Contributing
Please fork the repository if you'd like to contribute. Pull requests are always welcome. 

## Links

Checkout the following links for more information on developing chat solutions with PubNub:

- Chat Real-Time Developer Path: https://www.pubnub.com/developers/chat-real-time-developer-path/
- Tour of PubNub features: https://www.pubnub.com/tour/introduction/
- Chat use cases with PubNub: https://www.pubnub.com/use-case/in-app-chat/

## Additional Samples

Please also see https://github.com/pubnub/flutter-ref-app-simple-chat which was developed by one of our PubNub engineers.  This app also demonstrates how to implement a typing indicator using PubNub [Signals](https://www.pubnub.com/docs/sdks/dart/api-reference/publish-and-subscribe#signal) and view [files](https://www.pubnub.com/docs/sdks/dart/api-reference/files) as part of the conversation.

## App running on other platforms

Flutter is a cross-platform framework so your app should run without changes on other platforms.  The only platform-specific consideration you might  need to make is obtaining a device id. 

### Android:

![Screenshot](https://raw.githubusercontent.com/PubNubDevelopers/GettingStarted-Flutter-SDK-Tutorial/main/media/android.png)

### iOS:

![Screenshot](https://raw.githubusercontent.com/PubNubDevelopers/GettingStarted-Flutter-SDK-Tutorial/main/media/ios.png)

### Windows desktop: 

![Screenshot](https://raw.githubusercontent.com/PubNubDevelopers/GettingStarted-Flutter-SDK-Tutorial/main/media/windows2.png)

### Linux (Ubuntu): 

![Screenshot](https://raw.githubusercontent.com/PubNubDevelopers/GettingStarted-Flutter-SDK-Tutorial/main/media/linux.png)

### Browser (Chrome):

![Screenshot](https://raw.githubusercontent.com/PubNubDevelopers/GettingStarted-Flutter-SDK-Tutorial/main/media/browser.png)

