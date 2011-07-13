//
//  APHorizontalTableView.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 ArtProg. All rights reserved.
//

@class APImageTableViewCell;

@protocol APImageTableViewDataSource;

@interface APImageTableView : UIScrollView <UIScrollViewDelegate>
{
	@private
    id<APImageTableViewDataSource> _dataSource;
	//id<UITableViewDelegate> _tableDelegate;
	NSMutableDictionary *_queuedCells;
	NSMutableDictionary *_visibleCells;
	CGSize _cellSize;
	@protected
	NSUInteger _maxNumberOfColumns;
	NSUInteger _maxNumberOfRows;
	NSUInteger _numberOfCells;
	CGPoint _firstVisibleCell;
	CGPoint _lastVisibleCell;
}

//@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) id<APImageTableViewDataSource> dataSource;
@property (nonatomic) NSUInteger maxNumberOfColumns;
@property (nonatomic) NSUInteger maxNumberOfRows;
@property (nonatomic) CGSize cellSize;

// initialization
- (id)initWithFrame:(CGRect)frame;

- (APImageTableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier;
- (NSUInteger)numberOfCells;
- (APImageTableViewCell*)cellAtPoint:(CGPoint)point;

- (void)reloadData;

@end
