//
//  ListView.h
//  EnPlay
//
//  Created by Nguyen Van Toan on 30/04/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListView : UITableViewController
{
}

@property (nonatomic, assign) NSMutableArray *files;
@property (nonatomic, assign) NSString* Dir;
@property (nonatomic, assign) NSInteger pos;

- (void) refresh:(NSString*)path;
- (void) playNextItem;

@end
