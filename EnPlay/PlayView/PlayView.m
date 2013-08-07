//
//  PlayView.m
//  EnPlay
//
//  Created by Nguyen Van Toan on 01/05/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayView.h"

@interface PlayView ()

@end

@implementation PlayView
@synthesize mp;
@synthesize curListView;

- (id)init
{
    self = [super init];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    keepPlaying = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [shareApp.nav.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    mp.view.frame = self.view.frame;
}

- (void) playFile:(NSString *)filename
{
    [[AVAudioSession sharedInstance] setDelegate:shareApp];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [shareApp.nav.navigationBar setHidden:YES];
    
    if(![[[shareApp.nav childViewControllers] lastObject] isKindOfClass:[PlayView class]])
    {
        [shareApp.nav pushViewController:self animated:YES];
    }
    
    keepPlaying = YES;
    
    NSURL *url = [NSURL fileURLWithPath:filename];
    
    if(mp)
    {
        if(mp.view.superview)
        {
            [mp.view removeFromSuperview];
        }
        
        [mp release];
        mp = nil;
    }
    
    if(!mp)
    {
        mp = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        
        [mp.moviePlayer setFullscreen:YES];
        [mp.moviePlayer setShouldAutoplay:YES];
        [mp.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
        [mp.moviePlayer setMovieSourceType:MPMovieSourceTypeFile];
        [mp.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    }
    
    mp.view.frame = self.view.frame;
    [self.view addSubview:mp.view];
    
    [mp.moviePlayer prepareToPlay];
    [mp.moviePlayer play];
}

- (void) onMoviePlayChangeState:(NSNotification*)notify
{
    [self performSelector:@selector(delayStatusChange) withObject:nil afterDelay:0.25];
}

- (void) delayStatusChange
{
    keepPlaying = ([mp.moviePlayer playbackState] == MPMoviePlaybackStatePlaying);
}

- (void) onGotoBackGround
{
    if(keepPlaying)
    {
        if(mp)
        {
            [mp.moviePlayer play];
        }
    }
}

- (void) onMovieFinished:(NSNotification*)notify
{
    NSDictionary *userInfor = [notify userInfo];
    
    if(userInfor)
    {
        int status = [[userInfor objectForKey:@"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue];
        if(status == 0)
        {
            if(curListView)
            {
                [curListView performSelector:@selector(playNextItem)];
            }
        }
        else //((status == 2) || (status == 1))
        {
            keepPlaying = NO;
            [shareApp.nav popViewControllerAnimated:YES];
        }
    }
}

- (BOOL) canPlayThisFile:(NSString *)filename
{
    NSString *ext = [filename pathExtension];
    
    if(ext)
    {
        ext = [ext lowercaseString];
        
        if([ext isEqualToString:@"mp4"] || [ext isEqualToString:@"mp3"] || [ext isEqualToString:@"mov"] || [ext isEqualToString:@"avi"] || [ext isEqualToString:@"ogg"] || [ext isEqualToString:@"wav"] || [ext isEqualToString:@"mpg"] || [ext isEqualToString:@"mkv"] || [ext isEqualToString:@"wma"] || [ext isEqualToString:@"wmv"] || [ext isEqualToString:@"3gp"] || [ext isEqualToString:@"mpv"])
        {
            return YES;
        }
    }
    
    return NO;
}


@end
