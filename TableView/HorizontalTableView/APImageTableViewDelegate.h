//
//  APImageTableViewDelegate.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-14.
//  Copyright 2011 ArtProg. All rights reserved.
//

@class APImageTableView;

@protocol APImageTableViewDelegate <NSObject>
@optional
- (void)imageTableView:(APImageTableView*)tableView didClickCellAtIndex:(NSUInteger)index;
- (void)imageTableViewDidScroll:(APImageTableView*)tableView;
@end
