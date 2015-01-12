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

Add the `MXMLyricsAction.h` and `MXMLyricsAction.m` to your project and import `MXMLyricsAction.h` in your view contoller that implements the action for the lyrics button.

### How to Open Musixmatch Extension

Add lyrics button on your view, you can enable it by check `isSystemAppExtensionAPIAvailable`,
Musixmatch Extension is available for every iOS8 devices.

Note that if users doesn't have Musixmatch installed or old version installed without `Lyrics Extension`
the Extension open the AppStore on Musixmatch app page to download/update.

Next we need to wire up the action for this button to this method in your UIViewController:

```objective-c
- (IBAction)lyrics:(id)sender {
 
    MPMediaItem *item = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];

    if (item) {
        [[MXMLyricsAction sharedExtension] findLyricsForSongWithTitle:item.title
                                                               artist:item.artist
                                                                album:item.albumTitle
                                                              artWork:[item.artwork imageWithSize:artWork.frame.size]
                                                      currentProgress:[[MPMusicPlayerController iPodMusicPlayer] currentPlaybackTime]
                                                        trackDuration:item.playbackDuration
                                                    forViewController:self
                                                               sender:sender
                                                     competionHandler:^(NSError *error) {
                                                         
                                                     }];
    }
    
}

```

Data needed in deep:

1. Provide a `NSString` for song title.
2. Provide a `NSString` for song artist name.
3. Pass a `NSString` for song album name.
4. Pass an `UIImage` for the view's background (artwork).
5. Provide a `NSTimeInterval` for the current seek time.
6. Provide a `NSTimeInterval` for the song duration.
7. Provide a `UIViewController` from the Extesion can appear.
8. Provide a completion block that will be called when the user finishes their selection.

## References

If you open up MXMLyricsAction.m and start poking around, you'll be interested in these references.

* [Apple Extension Guide](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/ExtensibilityPG/index.html#//apple_ref/doc/uid/TP40014214)
* [NSItemProvider](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSItemProvider_Class/index.html#//apple_ref/doc/uid/TP40014351), [NSExtensionItem](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSExtensionItem_Class/index.html#//apple_ref/doc/uid/TP40014375), and [UIActivityViewController](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIActivityViewController_Class/index.html#//apple_ref/doc/uid/TP40011976) class references.

## Contact Us

<!---
Contact us, please! We'd love to hear from you about how you integrated 1Password within your app, how we can further improve things, and add your app to [apps that integrate with 1Password](http://blog.agilebits.com/2013/04/03/ios-apps-1password-integrated-support/).
-->

You can reach us at ios@musixmatch.com, or if you prefer, [@musixmatch_api](https://twitter.com/musixmatch_api) on Twitter.
