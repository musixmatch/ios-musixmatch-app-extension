# Musixmatch Lyrics Extension

Welcome! With just a few lines of code, your app can access to the largest lyrics catalog in the world, enabling your users to:

1. See the now playing lyrics in time with the music.
2. Read unlimited lyrics also without music.

Empowering your users to use strong, unique passwords has never been easier. Let's get started!

## App Extension in Action

<a href="http://vimeo.com/111976590" target="_blank"><img src="http://cl.ly/ZFu9/Screen%20Shot%202015-01-12%20at%2014.53.35.png" width="500" height="889"></a>

## Just Give Me the Code (TL;DR)

You might be looking at this 13 KB README and think integrating with Musixmatch is very complicated. Nothing could be further from the truth!

If you're the type that just wants the code, here it is:

* [MXMLyricsAction.h](https://github.com/Musixmatchdev/musixmatch-app-extension/blob/master/MXMLyricsAction/MXMLyricsAction.h)
* [MXMLyricsAction.m](https://github.com/Musixmatchdev/musixmatch-app-extension/blob/master/MXMLyricsAction/MXMLyricsAction.m)

## Running the Demo App

Adding Musixmatch support to your app is easy. To demonstrate how it works, we have demo sample app for iOS that showcase all of the Musixmatch features.


### Step 1: Download the Source Code and Demo Apps

To get started, download the Musixmatch Extension project from https://github.com/Musixmatchdev/musixmatch-app-extension/archive/master.zip, or [clone it from GitHub](https://github.com/Musixmatchdev/musixmatch-app-extension).

Inside the downloaded folder, you'll find the resources needed to integrate with Musixmatch.

### Step 2: Chose a song

Tap on 'Add Music' button to reproduce a song

### Step 3: Open Musixmatch Extension

Tap on 'Lyrics' button and choose Musixmatch (the fist time you ave to enable if from 'More').

## Integrating Musixmatch With Your App

You can open Musixmatch whenever you want to show lyrics on time for your nowplaying track.
Just give to Musixmatch extension these datas:

1. Title
2. Artist
3. Album
4. Artwork
5. Current seek time
6. Track duration

### Add Musixmatch Files to Your Project

Add the `MXMLyricsAction.h` and `MXMLyricsAction.h` to your project and import `MXMLyricsAction.h` in your view contoller that implements the action for the 1Password button.

<img src="http://cl.ly/image/2g3B1r2O2z0L/Image%202014-07-29%20at%209.19.36%20AM.png" width="260" height="237"/>

### Use Case #1: Native App Login

In this use case we'll learn how to enable your existing users to fill their credentials into your native app's login form. If your application is using a web view to login (i.e. OAuth), you'll want to follow the web view integration steps in Use Case #3.

The first step is to add a UIButton to your login page. Use an existing 1Password image from the _1Password.xcassets_ catalog so users recognize the button.

You'll need to hide this button (or educate users on the benefits of strong, unique passwords) if no password manager is installed. You can use `isAppExtensionAvailable` to determine availability and hide the button if it isn't. For example:

```objective-c
-(void)viewDidLoad {
	[super viewDidLoad];
	[self.onepasswordSigninButton setHidden:![[OnePasswordExtension sharedExtension] isAppExtensionAvailable]];
}
```

Note that `isAppExtensionAvailable` looks to see if any app is installed that supports the generic `org-appextension-feature-password-management` feature. Any application that supports password management actions can be used.

Next we need to wire up the action for this button to this method in your UIViewController:

```objective-c
- (IBAction)findLoginFrom1Password:(id)sender {
	__weak typeof (self) miniMe = self;
	[[OnePasswordExtension sharedExtension] findLoginForURLString:@"https://www.acme.com" forViewController:self sender:sender completion:^(NSDictionary *loginDict, NSError *error) {
		if (!loginDict) {
			if (error.code != AppExtensionErrorCodeCancelledByUser) {
				NSLog(@"Error invoking 1Password App Extension for find login: %@", error);
			}
			return;
		}
		
		__strong typeof(self) strongMe = miniMe;
		strongMe.usernameTextField.text = loginDict[AppExtensionUsernameKey];
		strongMe.passwordTextField.text = loginDict[AppExtensionPasswordKey];
	}];
}
```

Aside from the [weak/strong self dance](http://dhoerl.wordpress.com/2013/04/23/i-finally-figured-out-weakself-and-strongself/), this code is pretty straight forward:

1. Provide a `URLString` that uniquely identifies your service. For example, if your app required a Twitter login, you would pass in `@"https://twitter.com"`. See _Best Practices_ for details.
2. Pass in the `UIViewController` that you want the share sheet to be presented upon.
3. Provide a completion block that will be called when the user finishes their selection. This block is guaranteed to be called on the main thread.
4. Extract the needed information from the login dictionary and update your UI elements.


### Use Case #2: New User Registration

Allow your users to access 1Password directly from your registration page so they can generate strong, unique passwords. 1Password will also save the login for future use, allowing users to easily log into your app on their other devices. The newly saved login and generated password are returned to you so you can update your UI and complete the registration.

Adding 1Password to your registration screen is very similar to adding 1Password to your login screen. In this case you'll wire the 1Password button to an action like this:

```objective-c
- (IBAction)saveLoginTo1Password:(id)sender {
	NSDictionary *newLoginDetails = @{
		AppExtensionTitleKey: @"ACME",
		AppExtensionUsernameKey: self.usernameTextField.text ? : @"",
		AppExtensionPasswordKey: self.passwordTextField.text ? : @"",
		AppExtensionNotesKey: @"Saved with the ACME app",
		AppExtensionSectionTitleKey: @"ACME Browser",
		AppExtensionFieldsKey: @{
			  @"firstname" : self.firstnameTextField.text ? : @"",
			  @"lastname" : self.lastnameTextField.text ? : @""
			  // Add as many string fields as you please.
		}
	};
	
	// Password generation options are optional, but are very handy in case you have strict rules about password lengths
	NSDictionary *passwordGenerationOptions = @{
		AppExtensionGeneratedPasswordMinLengthKey: @(6),
		AppExtensionGeneratedPasswordMaxLengthKey: @(50)
	};

	__weak typeof (self) miniMe = self;

	[[OnePasswordExtension sharedExtension] storeLoginForURLString:@"https://www.acme.com" loginDetails:newLoginDetails passwordGenerationOptions:passwordGenerationOptions forViewController:self sender:sender completion:^(NSDictionary *loginDict, NSError *error) {

		if (!loginDict) {
			if (error.code != AppExtensionErrorCodeCancelledByUser) {
				NSLog(@"Failed to use 1Password App Extension to save a new Login: %@", error);
			}
			return;
		}

		__strong typeof(self) strongMe = miniMe;

		strongMe.usernameTextField.text = loginDict[AppExtensionUsernameKey] ? : @"";
		strongMe.passwordTextField.text = loginDict[AppExtensionPasswordKey] ? : @"";
		strongMe.firstnameTextField.text = loginDict[AppExtensionReturnedFieldsKey][@"firstname"] ? : @"";
		strongMe.lastnameTextField.text = loginDict[AppExtensionReturnedFieldsKey][@"lastname"] ? : @"";
		// retrieve any additional fields that were passed in newLoginDetails dictionary
	}];
}
```

You'll notice that we're passing a lot more information into 1Password than just the `URLString` key used in the sign in example. This is because at the end of the password generation process, 1Password will create a brand new login and save it. It's not possible for 1Password to ask your app for additional information later on, so we pass in everything we can before showing the password generator screen.

An important thing to notice is the `AppExtensionURLStringKey` is set to the exact same value we used in the login scenario. This allows users to quickly find the login they saved for your app the next time they need to sign in.

## Best Practices

* Use the same `URLString` during Registration and Login.
* Ensure your `URLString` is set to your actual service so your users can easily find their logins within the main 1Password app.
* You should only ask for the login information of your own service or one specific to your app. Giving a URL for a service which you do not own or support may seriously break the customer's trust in your service/app.
* If you don't have a website for your app you should specify your bundle identifier as the `URLString`, like so: app://bundleIdentifier (e.g. app://com.acme.awesome-app).
* [Send us an icon](mailto:support+appex@agilebits.com) to use for our Rich Icon service so the user can see your lovely icon while creating new items.
* Use the icons provided in the `1Password.xcassets` asset catalog so users are familiar with what it will do. Contact us if you'd like additional sizes or have other special requirements.
* Enable users to set 1Password as their default browser for external web links.
* On your registration page, pre-validate fields before calling 1Password. For example, display a message if the username is not available so the user can fix it before activating 1Password.


## References

If you open up OnePasswordExtension.m and start poking around, you'll be interested in these references.

* [Apple Extension Guide](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/ExtensibilityPG/index.html#//apple_ref/doc/uid/TP40014214)
* [NSItemProvider](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSItemProvider_Class/index.html#//apple_ref/doc/uid/TP40014351), [NSExtensionItem](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSExtensionItem_Class/index.html#//apple_ref/doc/uid/TP40014375), and [UIActivityViewController](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIActivityViewController_Class/index.html#//apple_ref/doc/uid/TP40011976) class references.


## Contact Us

Contact us, please! We'd love to hear from you about how you integrated 1Password within your app, how we can further improve things, and add your app to [apps that integrate with 1Password](http://blog.agilebits.com/2013/04/03/ios-apps-1password-integrated-support/).

You can reach us at support+appex@agilebits.com, or if you prefer, [@1PasswordBeta](https://twitter.com/1PasswordBeta) on Twitter.
