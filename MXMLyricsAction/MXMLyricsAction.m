//
//  MusixmatchExtension.m
//  MXMLyricsActionDemo
//
//  Created by Martino Bonfiglioli on 16/10/14.
//  Copyright (c) 2014 Musixmatch. All rights reserved.
//

#import "MXMLyricsAction.h" 
#import <StoreKit/StoreKit.h>

// Empty string check macro
#ifndef StringOrEmpty
#define StringOrEmpty(A) ({ __typeof__(A) __a = (A); __a ? __a : @""; })
#endif

// Available App Extension Actions
NSString *const kUTTypeAppExtensionFindSongLyric =  @"org.appextension.find-song-lyric";

// Song Dictionary keys
NSString *const MusixmatchExtensionTitle =          @"title";
NSString *const MusixmatchExtensionArtist =         @"artist";
NSString *const MusixmatchExtensionAlbum =          @"album";
NSString *const MusixmatchExtensionCoverArt =       @"coverArt";
NSString *const MusixmatchExtensionDuration =       @"duration";
NSString *const MusixmatchExtensionProgress =       @"progress";
NSString *const MusixmatchExtensionStartDate =      @"startDate";

// View Style
NSString *const MusixmatchExtensionStatusBarStyle = @"statusBar";

// Additional infos
NSString *const MusixmatchExtensionHostBundleID =   @"hostBundle";

NSString *musixmatchAppStoreURL =   @"itms-apps://itunes.apple.com/app/id448278467";
NSString *musixmatchAppStoreAppID = @"448278467";

@interface MXMLyricsAction () < SKStoreProductViewControllerDelegate >

@end

@implementation MXMLyricsAction

#pragma mark - Singleton

+ (MXMLyricsAction*)sharedExtension {
    static dispatch_once_t onceToken;
    static MXMLyricsAction *__sharedExtension;
    
    dispatch_once(&onceToken, ^{
        __sharedExtension = [MXMLyricsAction new];
    });
    
    return __sharedExtension;
}

#pragma mark - Util

- (BOOL)isSystemAppExtensionAPIAvailable {

#ifdef __IPHONE_8_0
    return NSClassFromString(@"NSExtensionItem") != nil;
#else
    return NO;
#endif
    
}

- (BOOL)isMusixmatchExtensionAvailable {
    
#ifdef __IPHONE_8_0
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mxm-ext:"]];
#else
    return NO;
#endif
    
}

- (void)openStore {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:musixmatchAppStoreURL]];
    
}

- (void)showAppStoreForMusixmatchFromViewController:(UIViewController*)controller {
    
    //Use the in-app StoreKit view if available (iOS 6) and imported. This works in the simulator.
    if (NSStringFromClass([SKStoreProductViewController class]) != nil) {
        
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        NSNumber *appId = [NSNumber numberWithInteger:musixmatchAppStoreAppID.integerValue];
        [storeViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:nil];
        storeViewController.delegate = self;
        
        [controller presentViewController:storeViewController animated:YES completion:nil];

    }
}

#pragma mark - Lyrics action

- (void)findLyricsForSongWithTitle:(NSString*)title
                            artist:(NSString*)artist
                             album:(NSString*)album
                           artWork:(UIImage*)image
                   currentProgress:(NSTimeInterval)progress
                     trackDuration:(NSTimeInterval)duration
                 forViewController:(UIViewController *)viewController
                            sender:(id)sender
                  competionHandler:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setObject:StringOrEmpty(title)
             forKey:MusixmatchExtensionTitle];
    [dict setObject:StringOrEmpty(artist)
             forKey:MusixmatchExtensionArtist];
    [dict setObject:StringOrEmpty(album)
             forKey:MusixmatchExtensionAlbum];
    [dict setObject:image
             forKey:MusixmatchExtensionCoverArt];
    [dict setObject:[NSString stringWithFormat:@"%f", progress]
             forKey:MusixmatchExtensionProgress];
    [dict setObject:[NSString stringWithFormat:@"%f", duration]
             forKey:MusixmatchExtensionDuration];
    [dict setObject:[NSDate date]
             forKey:MusixmatchExtensionStartDate];
    [dict setObject:[NSNumber numberWithInt:[[UIApplication sharedApplication] statusBarStyle]]
             forKey:MusixmatchExtensionStatusBarStyle];
    [dict setObject:[[NSBundle mainBundle] bundleIdentifier]
             forKey:MusixmatchExtensionHostBundleID];
    
    [self findLyricsForSong:dict
          forViewController:viewController
                     sender:sender
           competionHandler:completion];
}

- (void)findLyricsForSong:(NSDictionary*)dict
        forViewController:(UIViewController *)viewController
                   sender:(id)sender
         competionHandler:(void (^)(NSError *error))completion
{
    NSAssert(dict != nil, @"dict must not be nil");
    NSAssert(viewController != nil, @"viewController must not be nil");
    
    if (![self isSystemAppExtensionAPIAvailable]) {
        NSLog(@"Failed to findLoginForURLString, system API is not available");
        completion(nil);
        return;
    }
    
    if (![self isMusixmatchExtensionAvailable]) {
        completion(nil);
        [self showAppStoreForMusixmatchFromViewController:viewController];
        return;
        [self openStore];
        return;
    }
    
#ifdef __IPHONE_8_0
    
    UIActivityViewController *activityViewController = [self activityViewControllerForItem:dict viewController:viewController sender:sender typeIdentifier:kUTTypeAppExtensionFindSongLyric];
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {

    };
    
    [viewController presentViewController:activityViewController animated:YES completion:^{

    }];
    
#endif
}

- (UIActivityViewController *)activityViewControllerForItem:(NSDictionary *)item viewController:(UIViewController*)viewController sender:(id)sender typeIdentifier:(NSString *)typeIdentifier {
#ifdef __IPHONE_8_0
    
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithItem:item typeIdentifier:typeIdentifier];
    
    NSExtensionItem *extensionItem = [[NSExtensionItem alloc] init];
    extensionItem.attachments = @[ itemProvider ];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[ extensionItem ]  applicationActivities:nil];
    
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        controller.popoverPresentationController.barButtonItem = sender;
    }
    else if ([sender isKindOfClass:[UIView class]]) {
        controller.popoverPresentationController.sourceView = [sender superview];
        controller.popoverPresentationController.sourceRect = [sender frame];
    }
    else {
        NSLog(@"sender can be nil on iPhone");
    }
    
    return controller;
#else
    return nil;
#endif
}

#pragma mark - SKStoreProductViewController Delegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
