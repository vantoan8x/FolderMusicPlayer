//
//  ReadView.m
//  EnPlay
//
//  Created by Nguyen Van Toan on 01/05/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import "AppDelegate.h"
#import "ReadView.h"

@interface ReadView ()

@end

@implementation ReadView
@synthesize webView;

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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

- (void) onGotoBackGround
{
    if(keepPlaying)
    {
        
    }
}

- (void) readFile:(NSString *)filename
{
    [shareApp.nav.navigationBar setHidden:NO];

    if(![[[shareApp.nav childViewControllers] lastObject] isKindOfClass:[PlayView class]])
    {
        [shareApp.nav pushViewController:self animated:YES];
    }

    if(!webView)
    {
        webView = [[UIWebView alloc] init];
    }

    webView.frame = self.view.frame;
    [self.view addSubview:webView];

    NSURL *url = [NSURL fileURLWithPath:filename];

    [webView setContentMode:UIViewContentModeScaleAspectFit];
    [webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [webView setScalesPageToFit:YES];

    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
