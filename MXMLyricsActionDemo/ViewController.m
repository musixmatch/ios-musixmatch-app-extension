/**
 *
 * Musixmatch iOS Lyrics Extention Demo
 *
 * About: https://developer.musixmatch.com/documentation/ios-lyrics-extension
 * Github: https://github.com/Musixmatchdev/musixmatch-app-extension
 *
 * Copyright (c) 2014-2015 musixmatch. All rights reserved.
 */

#import "ViewController.h"
#import <MusixmatchLyricsAction/MusixmatchLyricsAction.h>

@interface ViewController () < MPMediaPickerControllerDelegate > {

    NSTimer *progressUpdateTimer;
    

}

@property(nonatomic,strong) MPMediaPickerController *pickerController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MPMusicPlayerController systemMusicPlayer] beginGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nowPlayingItmeChanged:)
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateDidChange:)
                                                 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object:nil];
    
    
    // create a simple media query of all music library
    MPMediaQuery *mediaQuery =  [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *IsMusicMediaTypePredicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    [mediaQuery addFilterPredicate:IsMusicMediaTypePredicate];
    [[MPMusicPlayerController systemMusicPlayer] setQueueWithQuery:mediaQuery];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView {
    
    MPMediaItem *item = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
    
    if (item) {
        titleTrack.text = item.title;
        artist.text = item.artist;
        album.text = item.albumTitle;
        artWork.image = [item.artwork imageWithSize:artWork.frame.size];
    }else {
        titleTrack.text = artist.text = album.text = @"";
        artWork.image = nil;
    }
    
}

#pragma mark - Buttons

- (IBAction)addMusic:(id)sender {
    
    self.pickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [self.pickerController setDelegate:self];
    [self presentViewController:self.pickerController
                       animated:YES
                     completion:nil];
}

- (IBAction)lyrics:(id)sender {
 
    MPMediaItem *item = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];

    if (item) {
        [[MXMLyricsAction sharedExtension] findLyricsForSongWithTitle:item.title
                                                               artist:item.artist
                                                                album:item.albumTitle
                                                              artWork:[item.artwork imageWithSize:artWork.frame.size]
                                                      currentProgress:[[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime]
                                                        trackDuration:item.playbackDuration
                                                    forViewController:self
                                                               sender:sender
                                                     competionHandler:^(NSError *error) {
                                                         
                                                     }];
    }
    
}

- (IBAction)switchStyleChanged:(id)sender {
    
    UISwitch *swtch = sender;
    
    [UIView animateWithDuration:0.4f
                     animations:^{
                         
                         if (!swtch.isOn) {
                             
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                             titleTrack.textColor = artist.textColor = album.textColor = style.textColor = [UIColor blackColor];
                             
                             [self.view setBackgroundColor:[UIColor whiteColor]];
                             
                         }else {
                             
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                             titleTrack.textColor = artist.textColor = album.textColor = style.textColor = [UIColor whiteColor];
                             
                             [self.view setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:1.0f]];
                             
                         }

                     }];
    
}

-(IBAction)nextTrack:(id)sender {
    [[MPMusicPlayerController systemMusicPlayer] skipToNextItem];
}

-(IBAction)prevTrack:(id)sender {
    if ([[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime] < 2.0f) {
        [[MPMusicPlayerController systemMusicPlayer] skipToPreviousItem];
    } else {
        [[MPMusicPlayerController systemMusicPlayer] skipToBeginning];
    }
}

-(IBAction)playPause:(id)sender {

    MPMusicPlaybackState playbackState = [[MPMusicPlayerController systemMusicPlayer] playbackState];
    if( playbackState == MPMoviePlaybackStatePlaying ) { // playing, pause
        [[MPMusicPlayerController systemMusicPlayer] pause];
    } else { // paused or stopped, play
        [[MPMusicPlayerController systemMusicPlayer] play];
    }
    
}

- (IBAction)seek:(UISlider*)sender {
    
    // total time
    NSTimeInterval duration = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem].playbackDuration;
    float seekTime = sender.value * duration;
    [[MPMusicPlayerController systemMusicPlayer] setCurrentPlaybackTime:seekTime];
}

#pragma mark - Notifications

- (void)playbackStateDidChange:(id)sender {

    MPMusicPlaybackState playbackState = [[MPMusicPlayerController systemMusicPlayer] playbackState];
    if( playbackState == MPMoviePlaybackStatePlaying ) { // play
        
        [playPauseButton setImage:[UIImage imageNamed:@"player_pause_button"] forState:UIControlStateNormal];
        progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                               target:self
                                                             selector:@selector(updateProgress:)
                                                             userInfo:nil
                                                              repeats:YES];
    } else { // pause
        [playPauseButton setImage:[UIImage imageNamed:@"player_play_button"] forState:UIControlStateNormal];
        if(progressUpdateTimer != nil) {
            [progressUpdateTimer invalidate];
            progressUpdateTimer = nil;
        }
    }
}

- (void)nowPlayingItmeChanged:(id)sender {
    [self updateView];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {

    [[MPMusicPlayerController systemMusicPlayer] setQueueWithItemCollection:mediaItemCollection];
    [mediaPicker dismissViewControllerAnimated:YES
                                    completion:^{
                                        [[MPMusicPlayerController systemMusicPlayer] play];
                                    }];
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES
                                    completion:nil];
}

#pragma mark - Player Control

-(void) playerUpdateInfo {
    
    // total time
    long duration = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem].playbackDuration;
    // elapsed time
    long currentPlaybackTime = [[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime];
    // remaining time
    long remainingPlaybackTime = duration - currentPlaybackTime;
    
    // elapsed minutes and seconds
    int currentMinutes = (int)((currentPlaybackTime / 60) - (currentPlaybackTime / 3600)*60);
    int currentSeconds = (currentPlaybackTime % 60);
    
    // remaining minutes and seconds
    int remainingMinutes = (int)((remainingPlaybackTime / 60) - (remainingPlaybackTime / 3600)*60);
    int remainingSeconds = ( remainingPlaybackTime % 60 );
    
    trackElapsedTime.text = [NSString stringWithFormat:@"%02d:%02d", currentMinutes, currentSeconds];
    trackRemainingTime.text  = [NSString stringWithFormat:@"-%02d:%02d",remainingMinutes,remainingSeconds];
    
}

- (void)updateProgress:(NSTimer *)_timer {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval progress = [[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime];
        NSTimeInterval duration = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem].playbackDuration;
        if ( progress >=0.0 && duration>0.0) {
            [trackProgress setValue: progress / duration animated:YES];
            [self playerUpdateInfo];
        }
    });
}

@end
