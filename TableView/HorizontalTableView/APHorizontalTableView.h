//
//  APHorizontalTableView.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APHorizontalTableViewCell;

@protocol APHorizontalTableViewDataSource;

@interface APHorizontalTableView : UIScrollView <UIScrollViewDelegate>
{
	@private
    id<APHorizontalTableViewDataSource> _dataSource;
	id<UITableViewDelegate> _tableDelegate;
	NSMutableDictionary *_queuedCells;
	NSMutableDictionary *_visibleCells;
	@protected
	NSUInteger _numberOfColumns;
	NSUInteger _firstVisibleColumn;
	NSUInteger _lastVisibleColumn;
}

@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) id<APHorizontalTableViewDataSource> dataSource;

// initialization
- (id)initWithFrame:(CGRect)frame;

- (APHorizontalTableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier;
- (NSUInteger)numberOfColumns;
- (APHorizontalTableViewCell*)cellForColumnAtIndex:(NSUInteger)index;

- (void)reloadData;

@end
