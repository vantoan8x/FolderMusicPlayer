//
//  AppDelegate.h
//  EnPlay
//
//  Created by Nguyen Van Toan on 30/04/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "ListView.h"
#import "PlayView.h"
#import "ReadView.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL isLockAnSyn;
    UIBackgroundTaskIdentifier bgRunMgr;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *nav;
@property (nonatomic, assign) NSString *appPath;
@property (nonatomic, assign) NSString *settingFile;
@property (nonatomic, assign) NSMutableArray *songPaths;
@property (nonatomic, assign) PlayView *playView;
@property (nonatomic, assign) ReadView *readView;

- (void) pushNewListView:(NSString*)title withDir:(NSString*)dir;

@end

AppDelegate *shareApp;