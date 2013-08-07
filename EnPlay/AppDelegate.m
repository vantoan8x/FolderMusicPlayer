//
//  AppDelegate.m
//  EnPlay
//
//  Created by Nguyen Van Toan on 30/04/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import "AppDelegate.h"

#import "ListView.h"

@implementation AppDelegate
@synthesize nav;
@synthesize appPath;
@synthesize settingFile;
@synthesize songPaths;
@synthesize playView;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (void) pushNewListView:(NSString*)title withDir:(NSString*)dir
{
    ListView *newView = [[[ListView alloc] init] autorelease];
    [newView refresh:dir];
    newView.title = [NSString stringWithFormat:@"%@", title];
    [nav pushViewController:newView animated:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Assign singleton
    shareApp = self;
    
    appPath = [[NSString alloc] initWithFormat:@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    settingFile = [[NSString alloc] initWithFormat:@"%@/ListFolder.plist", appPath];
    
    //if(![[NSFileManager defaultManager] fileExistsAtPath:settingFile])
    {
        songPaths = [[NSMutableArray alloc] init];
        [songPaths addObject:@"/"];
        [songPaths writeToFile:settingFile atomically:YES];
    }
    //else
    {
        //songPaths = [[NSMutableArray alloc] initWithContentsOfFile:settingFile];
    }
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    ListView *listView = [[ListView alloc] init];
    listView.title = @"Enplay V1.0";
    [listView refresh:[songPaths objectAtIndex:0]];
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:listView];
    
    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    
    playView = [[PlayView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:playView selector:@selector(onMovieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:playView selector:@selector(onMoviePlayChangeState:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if(bgRunMgr == UIBackgroundTaskInvalid)
    {
        bgRunMgr = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            ;
        }];
    }
    
    if(!isLockAnSyn)
    {
        isLockAnSyn = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ;
        });
    }
    
    if(playView)
    {
        [playView onGotoBackGround];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
