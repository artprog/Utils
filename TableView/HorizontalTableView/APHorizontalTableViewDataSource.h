//
//  APHorizontalTableViewDataSource.h
//  tmp
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 SMTSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APHorizontalTableViewCell;
@class APHorizontalTableView;

@protocol APHorizontalTableViewDataSource <NSObject>
- (APHorizontalTableViewCell*)tableView:(APHorizontalTableView*)tableView cellForColumnAtIndex:(NSUInteger)index;
- (NSUInteger)tableViewNumberOfColumns:(APHorizontalTableView*)tableView;
@end
