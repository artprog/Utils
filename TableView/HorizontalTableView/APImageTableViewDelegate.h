//
//  APImageTableViewDelegate.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-14.
//  Copyright 2011 ArtProg. All rights reserved.
//

@protocol APImageTableViewDelegate <NSObject>
@optional
- (void)imageTableView:(UIScrollView*)tableView didClickCellAtIndex:(NSUInteger)index;
- (void)imageTableViewDidScroll:(UIScrollView*)tableView;
- (void)imageTableViewDidTap:(UIScrollView*)tableView;
- (void)imageTableView:(UIScrollView*)tableView currentPageDidChange:(NSUInteger)currentPage;
- (void)imageTableView:(UIScrollView*)tableView didShowCellAtIndex:(NSUInteger)index;
- (void)imageTableView:(UIScrollView*)tableView didHideCellAtIndex:(NSUInteger)index;
@end
