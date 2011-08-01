//
//  APHorizontalTableView.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APImageTableView.h"
#import "APImageTableViewCell.h"
#import "APImageTableViewDataSource.h"
#import "APImageTableViewDelegate.h"
#import "NSObject+APUtils.h"

@interface APImageTableView ()
- (CGRect)frameForCellAtIndex:(NSUInteger)index;
- (NSInteger)cellIndexAtPoint:(CGPoint)point;
- (NSUInteger)calculateFirstVisibleRow;
- (NSUInteger)calculateCurrentRow;
- (NSUInteger)calculateLastVisibleRow;
- (void)queueReusableCells;
- (void)displayCellAtIndex:(NSUInteger)index;
- (void)userDidTap:(UIGestureRecognizer*)sender;
@end

@implementation APImageTableView

@synthesize delegate = _tableDelegate;
@synthesize dataSource = _dataSource;
@synthesize cellSize = _cellSize;
@synthesize currentRow = _currentRow;

- (id)initWithFrame:(CGRect)frame
{
	if ( (self = [super initWithFrame:frame]) )
	{
		_queuedCells = [[NSMutableDictionary alloc] init];
		_visibleCells = [[NSMutableDictionary alloc] init];
		_cellSize = CGSizeMake(256, 256);
		
		self.backgroundColor = [UIColor blackColor];
		[super setDelegate:self];
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap:)] autorelease];
		tapRecognizer.numberOfTapsRequired = 1;
		tapRecognizer.numberOfTouchesRequired = 1;
		[self addGestureRecognizer:tapRecognizer];
		
		_didScrollFirstTime = YES;
		_currentRow = 0;
		_numberOfColumns = 0;
		_numberOfCells = 0;
	}
	return self;
}

- (void)dealloc
{
	RELEASE(_queuedCells);
	RELEASE(_visibleCells);
	_dataSource = nil;
	_tableDelegate = nil;
	
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frame = self.bounds;
	_numberOfColumns = floor(frame.size.width/_cellSize.width);
	NSUInteger numberOfRows = ceil(1.0*_numberOfCells/_numberOfColumns);
	self.contentSize = CGSizeMake(_numberOfColumns*_cellSize.width, numberOfRows*_cellSize.height);
	
	NSInteger insetTop = 0;//(self.bounds.size.height-self.contentSize.height)/2;
	NSInteger insetLeft = (self.bounds.size.width-self.contentSize.width)/2;
	self.contentInset = UIEdgeInsetsMake(insetTop<0?0:insetTop, insetLeft<0?0:insetLeft, insetTop<0?0:insetTop, insetLeft<0?0:insetLeft);
	
	CGRect cellFrame;
	APImageTableViewCell *cell;
	NSUInteger firstVisibleCell = _firstVisibleRow*_numberOfColumns;
	NSUInteger lastVisibleCell = _lastVisibleRow*_numberOfColumns+_numberOfColumns-1;
	for (NSUInteger index=firstVisibleCell; index<=lastVisibleCell; ++index)
	{
		cell = [_visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
		if ( cell )
		{
			cellFrame = [self frameForCellAtIndex:index];
			if ( !CGRectEqualToRect(cell.frame, cellFrame) )
			{
				cell.frame = cellFrame;
			}
			else
			{
				[cell setNeedsLayout];
			}
		}
	}
}

- (APImageTableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier
{
	if ( identifier.length )
	{
		NSMutableSet *cells = [_queuedCells objectForKey:identifier];
		APImageTableViewCell *cell = [[[cells anyObject] retain] autorelease];
		if ( cell )
		{
			[cells removeObject:cell];
			//DLOG(@"queued cells: %d", [cells count]);
			[_queuedCells setObject:cells forKey:identifier];
		}
		return cell;
	}
	return nil;
}

- (NSUInteger)numberOfCells
{
	return _numberOfCells;
}

- (APImageTableViewCell*)cellAtIndex:(NSUInteger)index
{
	APImageTableViewCell *cell = [_visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
	if ( !cell )
	{
		cell = [_dataSource imageTableView:self cellAtIndex:index];
	}
	return cell;
}

- (void)reloadData
{
	NSArray *viewKeys = [_visibleCells allKeys];
	UIView *view;
	for (NSNumber *viewKey in viewKeys)
	{
		view = [_visibleCells objectForKey:viewKey];
		[view removeFromSuperview];
	}
	[_visibleCells removeAllObjects];
	[_queuedCells removeAllObjects];
	_numberOfCells = [_dataSource imageTableViewNumberOfCells:self];
	_firstVisibleRow = 0;
	_lastVisibleRow = 0;
	_didScrollFirstTime = YES;
	[self scrollViewDidScroll:self];
}

- (void)prepareToRotation
{
	[super setDelegate:nil];
}

- (void)willAnimateRotation
{
	self.currentRow = _currentRow;
}

- (void)didRotate
{
	[super setDelegate:self];
}

- (void)setCurrentRow:(NSUInteger)currentRow
{
	_currentRow = currentRow;
	CGPoint offset = self.contentOffset;
	offset.y = _currentRow*_cellSize.height;
	NSUInteger maxContentOffsetY = self.contentSize.height-self.bounds.size.height;
	if ( offset.y > maxContentOffsetY )
	{
		offset.y = maxContentOffsetY;
	}
	self.contentOffset = offset;
	[self scrollViewDidScroll:self];
}

#pragma mark -
#pragma mark APHorizontalTableView ()

- (CGRect)frameForCellAtIndex:(NSUInteger)index
{
	NSUInteger column = index%_numberOfColumns;
	NSUInteger row = floor(index/_numberOfColumns);
	return CGRectMake(_cellSize.width*column, _cellSize.height*row, _cellSize.width, _cellSize.height);
}

- (NSInteger)cellIndexAtPoint:(CGPoint)point
{
	CGSize frameSize = self.bounds.size;
	NSInteger column = floor(point.x/(self.pagingEnabled?frameSize.width:_cellSize.width));
	NSInteger row = floor(point.y/(self.pagingEnabled?frameSize.height:_cellSize.height));
	column = MAX(column, 0);
	column = MIN(column, _numberOfColumns);
	row = MAX(row, 0);
	NSUInteger numberOfRows = floor(_numberOfCells/_numberOfColumns)+1;
	row = MIN(row, numberOfRows);
	NSUInteger numberOfColumns = _numberOfCells<_numberOfColumns?_numberOfCells:_numberOfColumns;
	if ( _numberOfCells < _numberOfColumns )
	{
		row = 0;
	}
	return row*numberOfColumns+column;
}

- (NSUInteger)calculateFirstVisibleRow
{
	NSUInteger currentRow = [self calculateCurrentRow];
	return MAX((int)currentRow-1, 0);
}

- (NSUInteger)calculateCurrentRow
{
	CGPoint offset = self.contentOffset;
	NSInteger rowIndex = floor((offset.y-_cellSize.height/2)/_cellSize.height)+1;
	NSUInteger numberOfRows = floor(_numberOfCells/_numberOfColumns)+1;
	rowIndex = MAX(rowIndex, 0);
	rowIndex = MIN(rowIndex, numberOfRows);
	return rowIndex;
}

- (NSUInteger)calculateLastVisibleRow
{
	NSUInteger currentRow = [self calculateCurrentRow]+floor(self.bounds.size.height/_cellSize.height);
	NSUInteger numberOfRows = floor(_numberOfCells/_numberOfColumns)+1;
	return MIN((int)currentRow+1, numberOfRows);
}

- (void)queueReusableCells
{
	NSUInteger cellIndex;
	APImageTableViewCell *cell;
	NSMutableSet *queuedCells;
	NSArray *visibleCellKeys = [_visibleCells allKeys];
	for (NSNumber *key in visibleCellKeys)
	{
		cellIndex = [key unsignedIntegerValue];
		NSUInteger firstVisibleCell = _firstVisibleRow*_numberOfColumns;
		NSUInteger lastVisibleCell = _lastVisibleRow*_numberOfColumns+_numberOfColumns-1;
		if ( cellIndex < firstVisibleCell || cellIndex > lastVisibleCell )
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
				[cell removeFromSuperview];
				//DLOG(@"queued cells: %d", [queuedCells count]);
				[_queuedCells setObject:queuedCells forKey:cell.reuseIdentifier];
				DLOG(@"hide cell at index: %d", cellIndex);
				[cell didHide];
				if ( [_tableDelegate respondsToSelector:@selector(imageTableView:didHideCellAtIndex:)] )
				{
					[_tableDelegate imageTableView:self didHideCellAtIndex:cellIndex];
				}
			}
		}
	}
}

- (void)displayCellAtIndex:(NSUInteger)index
{
	APImageTableViewCell *cell = [_visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
	if ( !cell )
	{
		cell = [_dataSource imageTableView:self cellAtIndex:index];
		if ( cell )
		{
			[self addSubview:cell];
			[_visibleCells setObject:cell forKey:[NSNumber numberWithUnsignedInteger:index]];
			[self layoutIfNeeded]; // usunac jak bedzie zamulac
			DLOG(@"display cell at index: %d", index);
			[cell didShow];
			if ( [_tableDelegate respondsToSelector:@selector(imageTableView:didShowCellAtIndex:)] )
			{
				[_tableDelegate imageTableView:self didShowCellAtIndex:index];
			}
		}
	}
}

- (void)userDidTap:(UIGestureRecognizer*)sender
{
	if ( sender.state == UIGestureRecognizerStateRecognized )
	{
		if ( [_tableDelegate respondsToSelector:@selector(imageTableViewDidTap:)] )
		{
			[_tableDelegate imageTableViewDidTap:self];
		}
		
		CGPoint location = [sender locationInView:self];
		UIView *view;
		NSArray *viewKeys = [_visibleCells allKeys];
		
		for (NSNumber *key in viewKeys)
		{
			view = [_visibleCells objectForKey:key];
			if ( [view pointInside:[self convertPoint:location toView:view] withEvent:nil] )
			{
				NSUInteger index = [key unsignedIntegerValue];
				if ( [_tableDelegate respondsToSelector:@selector(imageTableView:didClickCellAtIndex:)] )
				{
					[_tableDelegate imageTableView:self didClickCellAtIndex:index];
				}
				return;
			}
		}
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
	[self layoutIfNeeded];
	NSUInteger firstVisibleRowTmp = [self calculateFirstVisibleRow];
	NSUInteger lastVisibleRowTmp = [self calculateLastVisibleRow];
	if ( _firstVisibleRow != firstVisibleRowTmp || _lastVisibleRow != lastVisibleRowTmp || _didScrollFirstTime )
	{
		_didScrollFirstTime = NO;
		_firstVisibleRow = firstVisibleRowTmp;
		_lastVisibleRow = lastVisibleRowTmp;
		[self queueReusableCells];
		NSUInteger firstVisibleCell = _firstVisibleRow*_numberOfColumns;
		NSUInteger lastVisibleCell = _lastVisibleRow*_numberOfColumns+_numberOfColumns-1;
		for (NSUInteger index=firstVisibleCell; index<=lastVisibleCell; ++index)
		{
			[self displayCellAtIndex:index];
		}
	}
	NSUInteger currentRowTmp = [self calculateCurrentRow];
	if ( _currentRow != currentRowTmp )
	{
		_currentRow = currentRowTmp;
//		if ( [_tableDelegate respondsToSelector:@selector(imageTableView:currentPageDidChange:)] )
//		{
//			[_tableDelegate imageTableView:self currentPageDidChange:_currentPage];
//		}
	}
	if ( [_tableDelegate respondsToSelector:@selector(imageTableViewDidScroll:)] )
	{
		[_tableDelegate imageTableViewDidScroll:self];
	}
}

@end
