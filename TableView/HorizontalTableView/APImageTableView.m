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

@interface APImageTableView ()
- (CGRect)frameForCellAtPoint:(CGPoint)point;
- (CGPoint)calculateFirstVisibleCell;
- (CGPoint)calculateLastVisibleCell;
- (void)queueReusableCells;
- (void)displayCellAtPoint:(CGPoint)point;
@end

@implementation APImageTableView

//@synthesize delegate = _tableDelegate;
@synthesize dataSource = _dataSource;
@synthesize maxNumberOfRows = _maxNumberOfRows;
@synthesize maxNumberOfColumns = _maxNumberOfColumns;
@synthesize cellSize = _cellSize;

- (id)initWithFrame:(CGRect)frame
{
	if ( (self = [super initWithFrame:frame]) )
	{
		_queuedCells = [[NSMutableDictionary alloc] init];
		_visibleCells = [[NSMutableDictionary alloc] init];
		_cellSize = CGSizeMake(216, 216);
		
		_maxNumberOfColumns = 3;
		_maxNumberOfRows = NSUIntegerMax;
		
		self.backgroundColor = [UIColor blackColor];
		self.delegate = self;
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
	self.contentSize = CGSizeMake(2*tableSize.width, 2*tableSize.height);
	
	CGRect cellFrame;
	APImageTableViewCell *cell;
	for (NSUInteger x=_firstVisibleCell.x; x<_lastVisibleCell.x; ++x)
	{
		for (NSUInteger y=_firstVisibleCell.y; y<_lastVisibleCell.y; ++y)
		{
			cell = [self cellAtPoint:CGPointMake(x, y)];
			cellFrame = [self frameForCellAtPoint:CGPointMake(x, y)];
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
		APImageTableViewCell *cell = [cells anyObject];
		if ( cell )
		{
			[cells removeObject:cell];
			NSLog(@"queued cells: %d", [cells count]);
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

- (APImageTableViewCell*)cellAtPoint:(CGPoint)point
{
	APImageTableViewCell *cell = [[_visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:point.x]] objectForKey:[NSNumber numberWithUnsignedInteger:point.y]];
	if ( !cell )
	{
		cell = [_dataSource imageTableView:self cellAtPoint:point];
	}
	return cell;
}

- (void)reloadData
{
	[_visibleCells removeAllObjects];
	_numberOfCells = [_dataSource imageTableViewNumberOfCells:self];
	[self scrollViewDidScroll:self];
}

#pragma mark -
#pragma mark APHorizontalTableView ()

- (CGRect)frameForCellAtPoint:(CGPoint)point
{
	return CGRectMake(_cellSize.width*point.x, _cellSize.height*point.y, _cellSize.width, _cellSize.height);
}

- (CGPoint)calculateFirstVisibleCell
{
	CGFloat contentOffsetX = self.contentOffset.x;
	CGFloat contentOffsetY = self.contentOffset.y;
	CGPoint cell = CGPointMake(floor(contentOffsetX/_cellSize.width), floor(contentOffsetY/_cellSize.height));
	cell.x = MAX(0, cell.x);
	cell.y = MAX(0, cell.y);
	cell.x = MIN(cell.x, _maxNumberOfColumns);
	cell.y = MIN(cell.y, _maxNumberOfRows);
	return cell;
}

- (CGPoint)calculateLastVisibleCell
{
	CGFloat contentOffsetX = self.contentOffset.x+self.bounds.size.width;
	CGFloat contentOffsetY = self.contentOffset.y+self.bounds.size.height;
	CGPoint cell = CGPointMake(floor(contentOffsetX/_cellSize.width), floor(contentOffsetY/_cellSize.height));
	cell.x = MAX(0, cell.x);
	cell.y = MAX(0, cell.y);
	cell.x = MIN(cell.x, _maxNumberOfColumns);
	cell.y = MIN(cell.y, _maxNumberOfRows);
	return cell;
}

- (void)queueReusableCells
{
	NSUInteger cellIndexX;
	NSUInteger cellIndexY;
	APImageTableViewCell *cell;
	NSMutableSet *queuedCells;
	NSArray *visibleCellKeysX = [_visibleCells allKeys];
	NSArray *visibleCellKeysY;
	for (NSNumber *keyX in visibleCellKeysX)
	{
		visibleCellKeysY = [[_visibleCells objectForKey:keyX] allKeys];
		for (NSNumber *keyY in visibleCellKeysY)
		{
			cellIndexX = [keyX unsignedIntegerValue];
			cellIndexY = [keyY unsignedIntegerValue];
			if ( cellIndexX < _firstVisibleCell.x || cellIndexX > _lastVisibleCell.x || cellIndexY < _firstVisibleCell.y || cellIndexY > _lastVisibleCell.y )
			{
				cell = [[_visibleCells objectForKey:keyX] objectForKey:keyY];
				if ( cell )
				{
					[[_visibleCells objectForKey:keyX] removeObjectForKey:keyY];
					queuedCells = [_queuedCells objectForKey:cell.reuseIdentifier];
					if ( !queuedCells )
					{
						queuedCells = [NSMutableSet set];
					}
					[queuedCells addObject:cell];
					NSLog(@"queued cells: %d", [queuedCells count]);
					[_queuedCells setObject:queuedCells forKey:cell.reuseIdentifier];
				}
			}
		}
	}
}

- (void)displayCellAtPoint:(CGPoint)point
{
	APImageTableViewCell *cell = [self cellAtPoint:point];
	if ( cell )
	{
		[self addSubview:cell];
		NSMutableDictionary *cellsY = [NSMutableDictionary dictionaryWithDictionary:[_visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:point.x]]];
		[cellsY setObject:cell forKey:[NSNumber numberWithUnsignedInteger:point.y]];
		[_visibleCells setObject:cellsY forKey:[NSNumber numberWithUnsignedInteger:point.x]];
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
	CGPoint firstVisibleCellTmp = [self calculateFirstVisibleCell];
	CGPoint lastVisibleCellTmp = [self calculateLastVisibleCell];
	if ( _firstVisibleCell.x != firstVisibleCellTmp.x || _lastVisibleCell.x != lastVisibleCellTmp.x || _firstVisibleCell.y != firstVisibleCellTmp.y || _lastVisibleCell.y != lastVisibleCellTmp.y )
	{
		_firstVisibleCell = firstVisibleCellTmp;
		_lastVisibleCell = lastVisibleCellTmp;
		[self queueReusableCells];
		for (NSUInteger x=_firstVisibleCell.x; x<_lastVisibleCell.x; ++x)
		{
			for (NSUInteger y=_firstVisibleCell.y; y<_lastVisibleCell.y; ++y)
			{
				[self displayCellAtPoint:CGPointMake(x, y)];
			}
		}
	}
}

@end
