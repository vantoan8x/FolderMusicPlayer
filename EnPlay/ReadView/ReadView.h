//
//  PlayView.h
//  EnPlay
//
//  Created by Nguyen Van Toan on 01/05/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ReadView : UIViewController
{
    BOOL keepPlaying;
}

@property (nonatomic, assign) UIWebView *webView;

- (void) readFile:(NSString*)filename;
- (void) onGotoBackGround;

@end
