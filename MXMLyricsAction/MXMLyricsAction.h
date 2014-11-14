//
//  MusixmatchExtension.h
//  Simple Track Playback
//
//  Created by Martino Bonfiglioli on 16/10/14.
//  Copyright (c) 2014 Your Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Empty string check macro
#ifndef StringOrEmpty
#define StringOrEmpty(A) ({ __typeof__(A) __a = (A); __a ? __a : @""; })
#endif

// Available App Extension Actions
FOUNDATION_EXPORT NSString *const kUTTypeAppExtensionFindSongLyric;

// Song Dictionary keys
FOUNDATION_EXPORT NSString *const MusixmatchExtensionTitle;     // NSString
FOUNDATION_EXPORT NSString *const MusixmatchExtensionArtist;    // NSString
FOUNDATION_EXPORT NSString *const MusixmatchExtensionAlbum;     // NSString
FOUNDATION_EXPORT NSString *const MusixmatchExtensionCoverArt;  // UIImage
FOUNDATION_EXPORT NSString *const MusixmatchExtensionDuration;  // NSString (float)
FOUNDATION_EXPORT NSString *const MusixmatchExtensionProgress;  // NSString (float)
FOUNDATION_EXPORT NSString *const MusixmatchExtensionStartDate; // NSDate

@interface MXMLyricsAction : NSObject

+ (MXMLyricsAction*)sharedExtension;

- (BOOL)isSystemAppExtensionAPIAvailable;

- (void)findLyricsForSongWithTitle:(NSString*)title
                            artist:(NSString*)artist
                             album:(NSString*)album
                           artWork:(UIImage*)image
                   currentProgress:(NSTimeInterval)progress
                     trackDuration:(NSTimeInterval)duration
                 forViewController:(UIViewController *)viewController
                            sender:(id)sender
                  competionHandler:(void (^)(NSError *error))completion;

@end
