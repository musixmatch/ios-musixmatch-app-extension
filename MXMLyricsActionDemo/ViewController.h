//
//  ViewController.h
//  MXMLyricsActionDemo
//
//  Created by Martino Bonfiglioli on 29/10/14.
//  Copyright (c) 2014 musixmatch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "MXMLyricsAction.h"

@interface ViewController : UIViewController < MPMediaPickerControllerDelegate > {
    
    IBOutlet UIImageView *artWork;
    IBOutlet UILabel *titleTrack;
    IBOutlet UILabel *artist;
    IBOutlet UILabel *album;
    IBOutlet UILabel *style;
    
    MPMediaPickerController *pickerController;
    
}

@end

