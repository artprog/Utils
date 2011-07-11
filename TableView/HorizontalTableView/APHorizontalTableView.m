//
//  APHorizontalTableView.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APHorizontalTableView.h"
#import "APHorizontalTableViewCell.h"
#import "APHorizontalTableViewDataSource.h"

@interface APHorizontalTableView ()
- (CGRect)frameForCellAtIndex:(NSUInteger)index;
- (NSUInteger)calculateFirstVisibleCell;
- (NSUInteger)calculateLastVisibleCell;
- (void)queueReusableCells;
- (void)displayCellAtIndex:(NSUInteger)index;
@end

@implementation APHorizontalTableView

@synthesize delegate = _tableDelegate;
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
	if ( (self = [super initWithFrame:frame]) )
	{
		_queuedCells = [[NSMutableDictionary alloc] init];
		_visibleCells = [[NSMutableDictionary alloc] init];
		
		self.backgroundColor = [UIColor blackColor];
	}
	return self;
}

- (void)dealloc
{
	RELEASE(_queuedCells);
	RELEASE(_visibleCells);
	
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGSize tableSize = self.bounds.size;
	self.contentSize = CGSizeMake(tableSize.width*(_lastVisibleColumn-_firstVisibleColumn+1), tableSize.height);
	
	CGRect cellFrame;
	APHorizontalTableViewCell *cell;
	for (NSUInteger index=_firstVisibleColumn; index<_lastVisibleColumn; ++index)
	{
		cell = [_visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
		cellFrame = [self frameForCellAtIndex:index];
		if ( !CGRectEqualToRect(cell.frame, cellFrame) )
		{
			cell.frame = cellFrame;
		}
	}
}

- (APHorizontalTableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier
{
	if ( identifier.length )
	{
		NSMutableSet *cells = [_queuedCells objectForKey:identifier];
		APHorizontalTableViewCell *cell = [cells anyObject];
		if ( cell )
		{
			[cells removeObject:cell];
			[_queuedCells setObject:cells forKey:identifier];
		}
		return cell;
	}
	return nil;
}

- (NSUInteger)numberOfColumns
{
	return _numberOfColumns;
}

- (APHorizontalTableViewCell*)cellForColumnAtIndex:(NSUInteger)index
{
	APHorizontalTableViewCell *cell = [_visibleCells objectForKey:[NSNumber numberWithInteger:index]];
	if ( !cell )
	{
		cell = [_dataSource tableView:self cellForColumnAtIndex:index];
	}
	return cell;
}

- (void)reloadData
{
	[_visibleCells removeAllObjects];
	_numberOfColumns = [_dataSource tableViewNumberOfColumns:self];
}

#pragma mark -
#pragma mark APHorizontalTableView ()

- (CGRect)frameForCellAtIndex:(NSUInteger)index
{
	CGSize cellSize = self.bounds.size;
	return CGRectMake(cellSize.width*index, 0, cellSize.width, cellSize.height);
}

- (NSUInteger)calculateFirstVisibleCell
{
	CGFloat contentOffsetX = self.contentOffset.x;
	CGFloat cellWidth = self.bounds.size.width;
	return floor(contentOffsetX/cellWidth);
}

- (NSUInteger)calculateLastVisibleCell
{
	CGFloat contentOffsetX = self.contentOffset.x;
	CGFloat cellWidth = self.bounds.size.width;
	return floor((contentOffsetX+cellWidth-1)/cellWidth);
}

- (void)queueReusableCells
{
	NSUInteger cellIndex;
	APHorizontalTableViewCell *cell;
	NSMutableSet *queuedCells;
	NSArray *visibleCellKeys = [_visibleCells allKeys];
	for (NSNumber *key in visibleCellKeys)
	{
		cellIndex = [key unsignedIntegerValue];
		if ( cellIndex < _firstVisibleColumn || cellIndex > _lastVisibleColumn )
		{
			cell = [_visibleCells objectForKey:key];
			if ( cell )
			{
				[_visibleCells removeObjectForKey:key];
				queuedCells = [_queuedCells objectForKey:cell.reuseIdentifier];
				if ( !queuedCells )
				{
					queuedCells = [NSMutableSet set];
				}
				[queuedCells addObject:cell];
				[_queuedCells setObject:queuedCells forKey:cell.reuseIdentifier];
			}
		}
	}
}

- (void)displayCellAtIndex:(NSUInteger)index
{
	APHorizontalTableViewCell *cell = [self cellForColumnAtIndex:index];
	[self addSubview:cell];
	[_visibleCells setObject:cell forKey:[NSNumber numberWithUnsignedInteger:index]];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
	NSUInteger firstVisibleColumnTmp = [self calculateFirstVisibleCell];
	NSUInteger lastVisibleColumnTmp = [self calculateLastVisibleCell];
	if ( _firstVisibleColumn != firstVisibleColumnTmp || _lastVisibleColumn != lastVisibleColumnTmp )
	{
		[self queueReusableCells];
		for (NSUInteger index=_firstVisibleColumn; index<_lastVisibleColumn; ++index)
		{
			[self displayCellAtIndex:index];
		}
	}
}

@end
