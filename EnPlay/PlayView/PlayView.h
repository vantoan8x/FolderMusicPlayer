//
//  PlayView.h
//  EnPlay
//
//  Created by Nguyen Van Toan on 01/05/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayView : UIViewController
{
    BOOL keepPlaying;
}

@property (nonatomic, assign) MPMoviePlayerViewController *mp;
@property (nonatomic, assign) ListView *curListView;

- (void) playFile:(NSString*)filename;
- (BOOL) canPlayThisFile:(NSString*)filename;
- (BOOL) canReadThisFile:(NSString*)filename;
- (void) onMovieFinished:(NSNotification*)notify;
- (void) onMoviePlayChangeState:(NSNotification*)notify;
- (void) onGotoBackGround;

@end
