//
//  APHorizontalTableViewDataSource.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 ArtProg. All rights reserved.
//

@class APImageTableViewCell;
@class APImageTableView;

@protocol APImageTableViewDataSource <NSObject>
- (APImageTableViewCell*)imageTableView:(APImageTableView*)tableView cellAtIndex:(NSUInteger)index;
- (NSUInteger)imageTableViewNumberOfCells:(APImageTableView*)tableView;
@end
