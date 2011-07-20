//
//  APPresentationTableView.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-20.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APPresentationTableView.h"
#import "APImageTableViewCell.h"
#import "APImageTableViewDataSource.h"
#import "APImageTableViewDelegate.h"
#import "NSObject+APUtils.h"

@interface APPresentationTableView ()
- (CGRect)frameForCellAtIndex:(NSUInteger)index;
//- (NSInteger)cellIndexAtPoint:(CGPoint)point;
- (NSUInteger)calculateFirstVisibleCell;
- (NSUInteger)calculateLastVisibleCell;
- (NSUInteger)calculateCurrentCell;
- (void)queueReusableCells;
- (void)displayCellAtIndex:(NSUInteger)index;
- (void)userDidTap:(UIGestureRecognizer*)sender;
@end

@implementation APPresentationTableView

@synthesize delegate = _tableDelegate;
@synthesize dataSource = _dataSource;
//@synthesize maxNumberOfRows = _maxNumberOfRows;
//@synthesize maxNumberOfColumns = _maxNumberOfColumns;
@synthesize currentCell = _currentCell;

- (id)initWithFrame:(CGRect)frame
{
	if ( (self = [super initWithFrame:frame]) )
	{
		_queuedCells = [[NSMutableDictionary alloc] init];
		_visibleCells = [[NSMutableDictionary alloc] init];
		
//		_maxNumberOfColumns = 3;
//		_maxNumberOfRows = NSUIntegerMax;
		
		self.backgroundColor = [UIColor blackColor];
		[super setDelegate:self];
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap:)] autorelease];
		tapRecognizer.numberOfTapsRequired = 1;
		tapRecognizer.numberOfTouchesRequired = 1;
		[self addGestureRecognizer:tapRecognizer];
		
		_didScrollFirstTime = YES;
		_currentCell = 0;
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
	
	//NSUInteger numberOfColumns = _numberOfCells<_maxNumberOfColumns?_numberOfCells:_maxNumberOfColumns;
	//NSUInteger numberOfRows = ceil(1.0*_numberOfCells/numberOfColumns);
	CGRect frame = self.bounds;
	self.contentSize = CGSizeMake(_numberOfCells*frame.size.width, frame.size.height);
	
//	NSInteger insetTop = (self.bounds.size.height-self.contentSize.height)/2;
//	NSInteger insetLeft = (self.bounds.size.width-self.contentSize.width)/2;
//	self.contentInset = UIEdgeInsetsMake(insetTop<0?0:insetTop, insetLeft<0?0:insetLeft, insetTop<0?0:insetTop, insetLeft<0?0:insetLeft);
	
	CGRect cellFrame;
	APImageTableViewCell *cell;
	for (NSUInteger index=_firstVisibleCell; index<=_lastVisibleCell; ++index)
	{
		cell = [_visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
		if ( cell )
		{
			cellFrame = [self frameForCellAtIndex:index];
			if ( !CGRectEqualToRect(cell.frame, cellFrame) )
			{
				cell.frame = cellFrame;
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
			DLOG(@"queued cells: %d", [cells count]);
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
	_firstVisibleCell = 0;
	_lastVisibleCell = 0;
	_didScrollFirstTime = YES;
	[self scrollViewDidScroll:self];
}

//- (void)setMaxNumberOfColumns:(NSUInteger)maxNumberOfColumns
//{
//	_maxNumberOfColumns = maxNumberOfColumns;
//	_maxNumberOfRows = NSUIntegerMax;
//}
//
//- (void)setMaxNumberOfRows:(NSUInteger)maxNumberOfRows
//{
//	_maxNumberOfRows = maxNumberOfRows;
//	_maxNumberOfColumns = NSUIntegerMax;
//}

- (void)setCurrentCell:(NSUInteger)currentCell
{
	_currentCell = currentCell;
	CGPoint offset = self.contentOffset;
	offset.x = _currentCell*self.bounds.size.width;
	self.contentOffset = offset;
}
- (void)prepareToRotation
{
	[super setDelegate:nil];
}

- (void)willAnimateRotation
{
	if ( self.pagingEnabled )
	{
		self.currentCell = _currentCell;
	}
}

- (void)didRotate
{
	[super setDelegate:self];
}

#pragma mark -
#pragma mark APHorizontalTableView ()

- (CGRect)frameForCellAtIndex:(NSUInteger)index
{
	CGSize frameSize = self.bounds.size;
	return CGRectMake(index*frameSize.width, 0, frameSize.width, frameSize.height);
}

//- (NSInteger)cellIndexAtPoint:(CGPoint)point
//{
//	CGSize frameSize = self.bounds.size;
//	NSInteger column = floor(point.x/(self.pagingEnabled?frameSize.width:_cellSize.width));
//	NSInteger row = floor(point.y/(self.pagingEnabled?frameSize.height:_cellSize.height));
//	column = MAX(column, 0);
//	column = MIN(column, _maxNumberOfColumns);
//	row = MAX(row, 0);
//	row = MIN(row, _maxNumberOfRows);
//	NSUInteger numberOfColumns = _numberOfCells<_maxNumberOfColumns?_numberOfCells:_maxNumberOfColumns;
//	if ( _numberOfCells < _maxNumberOfColumns )
//	{
//		row = 0;
//	}
//	return row*numberOfColumns+column;
//}

- (NSUInteger)calculateFirstVisibleCell
{
	//return MAX([self cellIndexAtPoint:self.contentOffset]-1, 0);
	return MAX((int)_currentCell-1, 0);
}

- (NSUInteger)calculateCurrentCell
{
	CGPoint offset = self.contentOffset;
	CGSize frameSize = self.bounds.size;
	NSInteger pageIndex = ceil(1.0*offset.x/frameSize.width);
	pageIndex = MAX(pageIndex, 0);
	pageIndex = MIN(pageIndex, _numberOfCells-1);
	return pageIndex;
}

- (NSUInteger)calculateLastVisibleCell
{
//	CGFloat contentOffsetX = self.contentOffset.x+self.bounds.size.width-1;
//	CGFloat contentOffsetY = self.contentOffset.y+self.bounds.size.height-1;
//	return MIN([self cellIndexAtPoint:CGPointMake(contentOffsetX, contentOffsetY)]+1, _numberOfCells);
	return MIN(_currentCell+1, _numberOfCells);
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
		if ( cellIndex < _firstVisibleCell || cellIndex > _lastVisibleCell )
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
				DLOG(@"queued cells: %d", [queuedCells count]);
				[_queuedCells setObject:queuedCells forKey:cell.reuseIdentifier];
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
	APImageTableViewCell *cell = [self cellAtIndex:index];
	if ( cell )
	{
		[self addSubview:cell];
		[_visibleCells setObject:cell forKey:[NSNumber numberWithUnsignedInteger:index]];
		[self layoutIfNeeded]; // usunac jak bedzie zamulac
		[cell didShow];
		if ( [_tableDelegate respondsToSelector:@selector(imageTableView:didShowCellAtIndex:)] )
		{
			[_tableDelegate imageTableView:self didShowCellAtIndex:index];
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
	NSUInteger firstVisibleCellTmp = [self calculateFirstVisibleCell];
	NSUInteger lastVisibleCellTmp = [self calculateLastVisibleCell];
	if ( _firstVisibleCell != firstVisibleCellTmp || _lastVisibleCell != lastVisibleCellTmp || _didScrollFirstTime )
	{
		_didScrollFirstTime = NO;
		_firstVisibleCell = firstVisibleCellTmp;
		_lastVisibleCell = lastVisibleCellTmp;
		[self queueReusableCells];
		for (NSUInteger index=_firstVisibleCell; index<=_lastVisibleCell; ++index)
		{
			[self displayCellAtIndex:index];
		}
	}
	NSUInteger currentCellTmp = [self calculateCurrentCell];
	if ( _currentCell != currentCellTmp )
	{
		_currentCell = currentCellTmp;
		if ( [_tableDelegate respondsToSelector:@selector(imageTableView:currentPageDidChange:)] )
		{
			[_tableDelegate imageTableView:self currentPageDidChange:_currentCell];
		}
	}
	if ( [_tableDelegate respondsToSelector:@selector(imageTableViewDidScroll:)] )
	{
		[_tableDelegate imageTableViewDidScroll:self];
	}
}

@end