//
//  MusixmatchExtension.h
//  MXMLyricsActionDemo
//
//  Created by Martino Bonfiglioli on 16/10/14.
//  Copyright (c) 2014 Musixmatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
