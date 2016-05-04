---
title: Apache Cordova the Easy Way on Ubuntu.
---

Today I had the pleasure of working on an Apache cordova app, my first experience with the project and my first time debugging a JS app that is supposedly compiled to "native" Java code and deployed as an APK. What I can say so far as that it was not a pleasure since the docs are not very well formed when it comes to explaining to people how to get started. Luckily for me I have had tons of experience with AndroidSDK and it was easy enough for me to make up for the documentation short-falls but I thought I would document for future people how to install Apache Cordova on Ubuntu the easiest way from start to finish.

***This tutorial is based off Ubuntu 14.04 but you can use any version.***

## Installing AndroidSDK.

The best way to install AndroidSDK (in my not so humble opinion) is to always install it in the home folder. The way some of them recommend you do it is just flat out ignorant of file-system organization and pretty dumb to say the least. I will not tell you to install it in `~/android-sdk` because that is a stupid place to put it, instead, you should first create a few folders:

```sh
mkdir -p ~/.local/lib/android/{sdk,studio}
```

_**Whether you plan to use Android Studio or not is your own personal choice but it's always good to keep the folder there so you are reminded where you should place it later...**_ And now that you have created your folders you should head to the [SDK download site](https://developer.android.com/sdk/index.html) and grab the SDK and put it into `~/.local/lib/android/sdk` and add it to your path (in `~/.bashrc`):

```sh
PATH=$PATH:$HOME/.local/lib/android/sdk/platform-tools:\
  $HOME/.local/lib/android/sdk/tools
```

### Android Emulation

The first thing you should do after sourcing your `~/.bashrc` is create a new Android image for your `cordova emulate` command. This will require you to first run `android` so that you can gain access to the SDK tools, then to update (because there always seems to be an update even for an "up to date new install") and then to install the x86 Intel image for Android v4.4\. This is all pretty much self-explanitory if you have ever worked with any UI, almost like ever, but if you need a pro-tip: The Update popup will happen when it first loads, if it doesn't the button to update is on the bottom right. The Intel X86 image will be in the main UI where all the tree menus are, look under "Android 4.4.2 (API 19)" and then "Intel x86 Atom System Image."

You should probably never use the ARM emulation unless you need ARM features or some shit because it can be slower than frozen water but if you really don't want to take my word for it, create an image with it and see for yourself.

And on... now that we have installed what we need throug `android`, we need to go and create an image we can use with `cordova emulate`. This is pretty easily done, can be named anything and might or might be used by you, you can do this by by typing `android avd`

## Apache Cordova

Now we get to the easy part, to install Apache `cordova` we will do a single line and install it via Ubuntu's own repositories (because on Ubuntu 14.04 it is up to date, including ant being up to date.)

```sh
sudo apt-get install default-jre openjdk-7-jdk ant nodejs npm
sudo npm install -g cordova
```

**_Note if you do not want to install NPM through Ubuntu (and seriously I don't blame you, I provide the latest NodeJS as a cleaner package at https://github.com/envygeeks/deb-recipes)_**

## A demo application

And now we demonstrate our win and build a demo application:

```sh
mkdir -p ~/development/public/
cd ~/development/public
cordova create myapp com.user.myapp MyApp && cd myapp
cordova platform add android && cordova emulate android
```
