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

/**
 * You can chose the way to bring user to download Musixmatch from the AppStore
 *
 * 1. Open native AppStore view in your app just import StoreKit Framework
 * 2. Open AppStore app with an Open URL
 *
 * The Extension open navite AppStore view by default
 **/
@property (nonatomic, assign) BOOL nativeAppStoreView; // Default YES

/**
 * Before to send the users on the Musixmatch AppStore page
 *
 * An UIAlertView explain why this is needed
 *
 * This UIAlertView is enabled by default
 **/
@property (nonatomic, assign) BOOL showAlertBeforeAppStore; // Default YES


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
