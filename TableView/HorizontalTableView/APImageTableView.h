//
//  APHorizontalTableView.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 ArtProg. All rights reserved.
//

@class APImageTableViewCell;

@protocol APImageTableViewDataSource;
@protocol APImageTableViewDelegate;

@interface APImageTableView : UIScrollView <UIScrollViewDelegate>
{
	@private
    id<APImageTableViewDataSource> _dataSource;
	id<APImageTableViewDelegate> _tableDelegate;
	NSMutableDictionary *_queuedCells;
	NSMutableDictionary *_visibleCells;
	CGSize _cellSize;
	NSUInteger _numberOfCells;
	NSUInteger _firstVisibleRow;
	NSUInteger _lastVisibleRow;
	BOOL _didScrollFirstTime;
	NSUInteger _numberOfColumns;
	NSUInteger _currentRow;
}

@property (nonatomic, assign) id<APImageTableViewDelegate> delegate;
@property (nonatomic, assign) id<APImageTableViewDataSource> dataSource;
@property (nonatomic) NSUInteger currentRow;
@property (nonatomic) CGSize cellSize;

// initialization
- (id)initWithFrame:(CGRect)frame;

- (APImageTableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier;
- (NSUInteger)numberOfCells;
- (APImageTableViewCell*)cellAtIndex:(NSUInteger)index;

- (void)reloadData;

- (void)prepareToRotation;
- (void)willAnimateRotation;
- (void)didRotate;

@end
