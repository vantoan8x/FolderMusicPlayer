//
//  ListView.m
//  EnPlay
//
//  Created by Nguyen Van Toan on 30/04/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import "AppDelegate.h"
#import "ListView.h"

int finderSortWithLocale(id string1, id string2, void *locale)
{
    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    
    NSRange string1Range = NSMakeRange(0, [string1 length]);
    
    return [string1 compare:string2 options:comparisonOptions range:string1Range locale:(NSLocale *)locale];
}

@interface ListView ()

@end

@implementation ListView
@synthesize files;
@synthesize Dir;
@synthesize pos;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        self.accessibilityTraits = UIAccessibilityTraitButton;
    }
    
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) playPreviousItem
{
    [self refresh:[NSString stringWithFormat:@"%@", Dir]];
    
    if(pos > 0)
    {
        BOOL isPlayNextFile = NO;
        while((--pos>=0) && (!isPlayNextFile))
        {
            BOOL isPath;
            NSString *file = [NSString stringWithFormat:@"%@/%@", Dir, [files objectAtIndex:pos]];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isPath])
            {
                if((!isPath) && [shareApp.playView canPlayThisFile:file])
                {
                    isPlayNextFile = YES;
                    [shareApp.playView playFile:file];
                    shareApp.playView.curListView = self;
                    return;
                }
            }
        }
        
        if(!isPlayNextFile)
        {
            [shareApp.nav popViewControllerAnimated:YES];
        }
    }
}

- (void) playNextItem
{
    [self refresh:[NSString stringWithFormat:@"%@", Dir]];
    
    if(pos < [files count])
    {
        BOOL isPlayNextFile = NO;
        while((++pos<[files count]) && (!isPlayNextFile))
        {
            BOOL isPath;
            NSString *file = [NSString stringWithFormat:@"%@/%@", Dir, [files objectAtIndex:pos]];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isPath])
            {
                if((!isPath) && [shareApp.playView canPlayThisFile:file])
                {
                    isPlayNextFile = YES;
                    [shareApp.playView playFile:file];
                    shareApp.playView.curListView = self;
                    return;
                }
            }
        }
        
        if(!isPlayNextFile)
        {
            [shareApp.nav popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefreshPress)];
    UIBarButtonItem *btnRoot = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(onPushRoot)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btn, btnRoot, nil];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], UITextAttributeTextColor, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
}

- (void) onPushRoot
{
    if([Dir length] > 2)
    {
        [shareApp pushNewListView:@"/" withDir:@"/"];
        NSString *appPath = [[NSString alloc] initWithFormat:@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
        [[[[UIAlertView alloc] initWithTitle:@"App Path" message:appPath delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    else
    {
        [shareApp.nav popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onRefreshPress
{
    [self refresh:[NSString stringWithFormat:@"%@", Dir]];
}

- (void) refresh:(NSString *)path
{
    if(Dir)
    {
        [Dir release];
        Dir = nil;
    }
    
    if(files)
    {
        [files release];
        files = nil;
    }
    
    Dir = [[NSString alloc] initWithFormat:@"%@", path];
    files = [[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:Dir error:nil]];
    [files removeObjectsInArray:[NSArray arrayWithObjects:@".DS_Store", @".forward", @".file", @".Trashes", @".fseventsd", @".bash", @".bash_history", nil]];
    
    [files sortUsingFunction:finderSortWithLocale context:[NSLocale currentLocale]];
    
    [self reloadInputViews];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(files)
    {
        return [files count];
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];//[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        NSString *filename = [files objectAtIndex:MAX(0, MIN([indexPath row], [files count]-1))];
        NSString *file = [NSString stringWithFormat:@"%@/%@", Dir, filename];
        
        BOOL isPath = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isPath])
        {
            if(isPath)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", filename];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor blueColor];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *fileName = [files objectAtIndex:indexPath.row];
    NSString *file = [NSString stringWithFormat:@"%@/%@", Dir, fileName];
    
    BOOL isPath;
    if([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isPath])
    {
        if(isPath)
        {
            [shareApp pushNewListView:fileName withDir:file];
        }
        else if([shareApp.playView canPlayThisFile:file])
        {
            pos = indexPath.row;
            [shareApp.playView playFile:file];
            shareApp.playView.curListView = self;
        }
        else if([shareApp.playView canReadThisFile:file])
        {
            [shareApp.readView readFile:file];
        }
        else
        {
            [self reloadInputViews];
        }
    }
}

@end
