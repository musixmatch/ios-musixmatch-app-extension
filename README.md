# Musixmatch Lyrics Extension

With just a few lines of code your app can access the world's largest lyrics catalog to provide a better experience to your users.

With the Musixmatch extension you can:

 1. See the synced lyrics for the now playing song in your app
 2. Read the lyrics for any song directly from your app.

## App Extension in Action

<<<<<<< HEAD
<iframe src="//player.vimeo.com/video/111976590" width="500" height="889" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="http://vimeo.com/111976590">Musixmatch Lyrics Extension</a> from <a href="http://vimeo.com/user15913205">Martino Bonfiglioli</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

<a href="https://vimeo.com/102142106" target="_blank"><img src="http://cl.ly/image/3Q232U370v0W/1PasswordAppExtensionPlayVideo.png" width="640" height="360"></a>
=======
<a href="http://vimeo.com/111976590" target="_blank"><img src="http://cl.ly/ZFu9/Screen%20Shot%202015-01-12%20at%2014.53.35.png" width="500" height="889"></a>
>>>>>>> 11bd63665477bae46664f4eac37bb4b824909ce6

## Just Give Me the Code

Integrating the Musixmatch extension is very easy, just include the following files in your project.

* [MXMLyricsAction.h](https://github.com/Musixmatchdev/musixmatch-app-extension/blob/master/MXMLyricsAction/MXMLyricsAction.h)
* [MXMLyricsAction.m](https://github.com/Musixmatchdev/musixmatch-app-extension/blob/master/MXMLyricsAction/MXMLyricsAction.m)

## Running the Demo App

Adding Musixmatch support to your app is easy. To demonstrate how it works, we have demo sample app for iOS that showcase all of the Musixmatch features.


### Step 1: Download the Source Code and Demo Apps

To get started, download the Musixmatch Extension project from https://github.com/Musixmatchdev/musixmatch-app-extension/archive/master.zip, or [clone it from GitHub](https://github.com/Musixmatchdev/musixmatch-app-extension).

Inside the downloaded folder, you'll find the resources needed to integrate with Musixmatch.

<<<<<<< HEAD
### Step 2: Install the Latest Musixmatch

The sample project depends upon having the latest version of Xcode 6, as well as the Musixmatch installed on your iOS device.

<!---
If you are developing for OS X, you can enable betas within the 1Password > Preferences > Updates window (as shown [here](i.agilebits.com/Preferences_197C0C6B.png)) and enabling the _Include beta builds_ checkbox. Mac App Store users should [download the web store version](https://agilebits.com/downloads) in order to enable betas.
-->

### Step 3: Run the Apps

Open `1Password Extension Demos` Xcode workspace from within the `Demos` folder with Xcode 6, and then select the `ACME` target and set it to run your iOS device:
=======
### Step 2: Chose a song
>>>>>>> 11bd63665477bae46664f4eac37bb4b824909ce6

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

You can open Musixmatch Extension from your app without any specific UI, it could be standard "Lyircs button" or if you need a specific Musixmatch logo contact us, infos are below.

### Add Musixmatch Files to Your Project

Add the `MXMLyricsAction.h` and `MXMLyricsAction.m` to your project and import `MXMLyricsAction.h` in your view contoller that implements the action for the lyrics button.

### How to Open Musixmatch Extension

Add lyrics button on your view, you can enable it by check `isSystemAppExtensionAPIAvailable`,
Musixmatch Extension is available for every iOS8 devices.

Note that if users doesn't have Musixmatch installed or old version installed without **Lyrics Extension**
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

### Customize Extension

As the Extension can't change the **Status Bar**, there are two possible view styles

1. StatusBar White
2. StatusBar Black

You can try the two different style by change the 'UISwitch' in the Demo App.
Here an example:

**StatusBar White**

<img src="http://f.cl.ly/items/453m2w3D2n1L3m2N0P39/IMG_1463.PNG" alt="StatusBar White" width="500" height="889">

**StatusBar Black**

<img src="http://cl.ly/image/0o2w0x072K3i/IMG_1464.PNG" alt="StatusBar Black" width="500" height="889">

## References

If you open up MXMLyricsAction.m and start poking around, you'll be interested in these references.

* [Apple Extension Guide](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/ExtensibilityPG/index.html#//apple_ref/doc/uid/TP40014214)
* [NSItemProvider](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSItemProvider_Class/index.html#//apple_ref/doc/uid/TP40014351), [NSExtensionItem](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSExtensionItem_Class/index.html#//apple_ref/doc/uid/TP40014375), and [UIActivityViewController](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIActivityViewController_Class/index.html#//apple_ref/doc/uid/TP40011976) class references.

## Contact Us

You can reach us at ios@musixmatch.com, or if you prefer, [@musixmatch_api](https://twitter.com/musixmatch_api) on Twitter.
