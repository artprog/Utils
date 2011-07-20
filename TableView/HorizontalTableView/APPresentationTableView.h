//
//  APPresentationTableView.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-20.
//  Copyright 2011 ArtProg. All rights reserved.
//

@class APImageTableViewCell;

@protocol APImageTableViewDataSource;
@protocol APImageTableViewDelegate;

@interface APPresentationTableView : UIScrollView <UIScrollViewDelegate>
{
	@private
    id<APImageTableViewDataSource> _dataSource;
	id<APImageTableViewDelegate> _tableDelegate;
	NSMutableDictionary *_queuedCells;
	NSMutableDictionary *_visibleCells;
	NSUInteger _numberOfCells;
	NSUInteger _firstVisibleCell;
	NSUInteger _lastVisibleCell;
	BOOL _didScrollFirstTime;
	NSUInteger _currentCell;
}

@property (nonatomic, assign) id<APImageTableViewDelegate> delegate;
@property (nonatomic, assign) id<APImageTableViewDataSource> dataSource;
@property (nonatomic) NSUInteger currentCell;

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
