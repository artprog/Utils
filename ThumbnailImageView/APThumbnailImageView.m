//
//  APThumbnailImageView.m
//  tmp
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 SMTSoftware. All rights reserved.
//

#import "APThumbnailImageView.h"

static const CGFloat _thumbnailImageViewWidth = 216;
static const CGFloat _thumbnailImageViewMargin = 30;

@interface ThumbnailImageView ()
- (CGPoint)firstThumbnailImageOffset;
- (CGFloat)rowHeight;
@end

@implementation ThumbnailImageView

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	NSUInteger numberOfRows = [self numberOfRows];
	CGPoint offset = [self firstThumbnailImageOffset];
	CGFloat rowHeight = _thumbnailImageViewWidth+_thumbnailImageViewMargin;
	self.contentSize = CGSizeMake(self.bounds.size.width, rowHeight*numberOfRows+2*offset.y);
}

- (NSUInteger)numberOfColumns
{
	return floor(self.bounds.size.width/(_thumbnailImageViewWidth+_thumbnailImageViewMargin));
}

- (NSUInteger)numberOfRows
{
	return ceil(_numberOfColumns/[self numberOfColumns]);
}

#pragma mark -
#pragma mark ThumbnailImageView ()

- (CGFloat)rowHeight
{
	return _thumbnailImageViewWidth+_thumbnailImageViewMargin;
}

- (CGRect)frameForCellAtIndex:(NSUInteger)index
{
	CGFloat cellSize = _thumbnailImageViewWidth;
	NSUInteger numberOfColumns = [self numberOfColumns];
	CGFloat thumbanilSizeWidthMargin = _thumbnailImageViewWidth+_thumbnailImageViewMargin;
	CGPoint offset = [self firstThumbnailImageOffset];
	NSUInteger column = index%numberOfColumns;
	NSUInteger row = floor(index/numberOfColumns);
	return CGRectMake(offset.x+thumbanilSizeWidthMargin*column, offset.y+thumbanilSizeWidthMargin*row, cellSize, cellSize);
}

- (CGPoint)firstThumbnailImageOffset
{
	NSUInteger numberOfColumns = [self numberOfColumns];
	CGFloat thumbanilSizeWidthMargin = _thumbnailImageViewWidth+_thumbnailImageViewMargin;
	CGFloat thumbnailsSizeWithMargins = numberOfColumns*thumbanilSizeWidthMargin-_thumbnailImageViewMargin;
	CGFloat offset = floor((self.bounds.size.width-thumbnailsSizeWithMargins)/2);
	return CGPointMake(offset, offset);
}

- (NSUInteger)calculateFirstVisibleCell
{
	CGPoint offset = [self firstThumbnailImageOffset];
	CGFloat contentOffsetY = self.contentOffset.y-offset.y;
	CGFloat rowHeight = [self rowHeight];
	NSInteger firstRow = MAX(floor(contentOffsetY/rowHeight), 0);
	NSUInteger columns = [self numberOfColumns];
	return firstRow*columns;
}

- (NSUInteger)calculateLastVisibleCell
{
	CGPoint offset = [self firstThumbnailImageOffset];
	CGFloat contentOffsetY = self.contentOffset.y-offset.y+self.bounds.size.height;
	CGFloat rowHeight = [self rowHeight];
	NSInteger lastRow = MIN(floor(contentOffsetY/rowHeight), [self numberOfRows]);
	NSUInteger columns = [self numberOfColumns];
	return (lastRow+1)*columns-1;
}

@end
