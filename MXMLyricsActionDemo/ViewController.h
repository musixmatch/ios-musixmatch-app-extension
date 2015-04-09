/**
 *
 * Musixmatch iOS Lyrics Extention Demo
 *
 * About: https://developer.musixmatch.com/documentation/ios-lyrics-extension
 * Github: https://github.com/Musixmatchdev/musixmatch-app-extension
 *
 * Copyright (c) 2014-2015 musixmatch. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "MXMLyricsAction.h"

@interface ViewController : UIViewController {
    
    IBOutlet UIImageView *artWork;
    IBOutlet UILabel *titleTrack;
    IBOutlet UILabel *artist;
    IBOutlet UILabel *album;
    IBOutlet UILabel *style;
    IBOutlet UIButton *playPauseButton;
    IBOutlet UIButton *nextTrackButton;
    IBOutlet UIButton *prevTrackButton;
    IBOutlet UISlider *trackProgress;
    IBOutlet UILabel *trackElapsedTime;
    IBOutlet UILabel *trackRemainingTime;
    
}

@end

