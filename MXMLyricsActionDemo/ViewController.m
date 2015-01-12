//
//  ViewController.m
//  MXMLyricsActionDemo
//
//  Created by Martino Bonfiglioli on 29/10/14.
//  Copyright (c) 2014 musixmatch. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MPMusicPlayerController iPodMusicPlayer] beginGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nowPlayingItmeChanged:)
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView {
    
    MPMediaItem *item = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
    
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
    
    pickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [pickerController setDelegate:self];
    [self presentViewController:pickerController
                       animated:YES
                     completion:nil];
}

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

#pragma mark - Notifications

- (void)nowPlayingItmeChanged:(id)sender {
    [self updateView];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {

    [[MPMusicPlayerController iPodMusicPlayer] setQueueWithItemCollection:mediaItemCollection];
    [mediaPicker dismissViewControllerAnimated:YES
                                    completion:^{
                                        [[MPMusicPlayerController iPodMusicPlayer] play];
                                    }];
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES
                                    completion:nil];
}

@end
