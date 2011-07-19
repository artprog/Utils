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
- (NSUInteger)calculateFirstVisibleCell;
- (NSUInteger)calculateLastVisibleCell;
- (NSUInteger)calculateCurrentPage;
- (void)queueReusableCells;
- (void)displayCellAtIndex:(NSUInteger)index;
- (void)userDidTap:(UIGestureRecognizer*)sender;
@end

@implementation APImageTableView

@synthesize delegate = _tableDelegate;
@synthesize dataSource = _dataSource;
@synthesize maxNumberOfRows = _maxNumberOfRows;
@synthesize maxNumberOfColumns = _maxNumberOfColumns;
@synthesize cellSize = _cellSize;
@synthesize currentPage = _currentPage;

- (id)initWithFrame:(CGRect)frame
{
	if ( (self = [super initWithFrame:frame]) )
	{
		_queuedCells = [[NSMutableDictionary alloc] init];
		_visibleCells = [[NSMutableDictionary alloc] init];
		_cellSize = CGSizeMake(256, 256);
		
		_maxNumberOfColumns = 3;
		_maxNumberOfRows = NSUIntegerMax;
		
		self.backgroundColor = [UIColor blackColor];
		[super setDelegate:self];
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap:)] autorelease];
		tapRecognizer.numberOfTapsRequired = 1;
		tapRecognizer.numberOfTouchesRequired = 1;
		[self addGestureRecognizer:tapRecognizer];
		
		_didScrollFirstTime = YES;
		_currentPage = 0;
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
	
	NSUInteger numberOfColumns = _numberOfCells<_maxNumberOfColumns?_numberOfCells:_maxNumberOfColumns;
	NSUInteger numberOfRows = ceil(1.0*_numberOfCells/numberOfColumns);
	if ( self.pagingEnabled )
	{
		CGRect frame = self.bounds;
		self.contentSize = CGSizeMake(numberOfColumns*frame.size.width, numberOfRows*frame.size.height);
	}
	else
	{
		self.contentSize = CGSizeMake(numberOfColumns*_cellSize.width, numberOfRows*_cellSize.height);
	}
	NSInteger insetTop = (self.bounds.size.height-self.contentSize.height)/2;
	NSInteger insetLeft = (self.bounds.size.width-self.contentSize.width)/2;
	self.contentInset = UIEdgeInsetsMake(insetTop<0?0:insetTop, insetLeft<0?0:insetLeft, insetTop<0?0:insetTop, insetLeft<0?0:insetLeft);
	
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

- (void)setMaxNumberOfColumns:(NSUInteger)maxNumberOfColumns
{
	_maxNumberOfColumns = maxNumberOfColumns;
	_maxNumberOfRows = NSUIntegerMax;
}

- (void)setMaxNumberOfRows:(NSUInteger)maxNumberOfRows
{
	_maxNumberOfRows = maxNumberOfRows;
	_maxNumberOfColumns = NSUIntegerMax;
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
	_currentPage = currentPage;
	CGPoint offset = self.contentOffset;
	offset.x = _currentPage*self.bounds.size.width;
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
		self.currentPage = _currentPage;
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
	NSUInteger column = index%_maxNumberOfColumns;
	NSUInteger row = floor(index/_maxNumberOfColumns);
	if ( self.pagingEnabled )
	{
		CGSize frameSize = self.bounds.size;
		return CGRectMake(column*frameSize.width, row*frameSize.height, frameSize.width, frameSize.height);
	}
	else
	{
		return CGRectMake(_cellSize.width*column, _cellSize.height*row, _cellSize.width, _cellSize.height);
	}
}

- (NSInteger)cellIndexAtPoint:(CGPoint)point
{
	CGSize frameSize = self.bounds.size;
	NSInteger column = floor(point.x/(self.pagingEnabled?frameSize.width:_cellSize.width));
	NSInteger row = floor(point.y/(self.pagingEnabled?frameSize.height:_cellSize.height));
	column = MAX(column, 0);
	column = MIN(column, _maxNumberOfColumns);
	row = MAX(row, 0);
	row = MIN(row, _maxNumberOfRows);
	NSUInteger numberOfColumns = _numberOfCells<_maxNumberOfColumns?_numberOfCells:_maxNumberOfColumns;
	if ( _numberOfCells < _maxNumberOfColumns )
	{
		row = 0;
	}
	return row*numberOfColumns+column;
}

- (NSUInteger)calculateFirstVisibleCell
{
	return MAX([self cellIndexAtPoint:self.contentOffset]-1, 0);
}

- (NSUInteger)calculateCurrentPage
{
	if ( self.pagingEnabled )
	{
		CGPoint offset = self.contentOffset;
		CGSize frameSize = self.bounds.size;
		return ceil(1.0*offset.x/frameSize.width);
	}
	return 0;
}

- (NSUInteger)calculateLastVisibleCell
{
	CGFloat contentOffsetX = self.contentOffset.x+self.bounds.size.width-1;
	CGFloat contentOffsetY = self.contentOffset.y+self.bounds.size.height-1;
	return MIN([self cellIndexAtPoint:CGPointMake(contentOffsetX, contentOffsetY)]+1, _numberOfCells);
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
	NSUInteger currentPageTmp = [self calculateCurrentPage];
	if ( _currentPage != currentPageTmp )
	{
		_currentPage = currentPageTmp;
		if ( [_tableDelegate respondsToSelector:@selector(imageTableView:currentPageDidChange:)] )
		{
			[_tableDelegate imageTableView:self currentPageDidChange:_currentPage];
		}
	}
	if ( [_tableDelegate respondsToSelector:@selector(imageTableViewDidScroll:)] )
	{
		[_tableDelegate imageTableViewDidScroll:self];
	}
}

@end
