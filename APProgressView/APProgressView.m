//
//  APProgressView.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-26.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APProgressView.h"

@implementation APProgressView

@synthesize progressImage = _progressImage;
@synthesize progress = _progress;
@synthesize backgroundImage = _backgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) )
    {
		_progress = 0;
		_progressImage = nil;
		_backgroundImage = nil;
    }
    return self;
}

- (void)dealloc
{
	RELEASE(_progressImage);
	RELEASE(_backgroundImage);
	
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
	CGFloat filledWidth = _progress>0?_progress<1?_progress*width:width:0;
	[_backgroundImage drawInRect:rect];
	[_progressImage drawInRect:CGRectMake(rect.origin.x, rect.origin.y, filledWidth, rect.size.height)];
}

- (void)setProgress:(CGFloat)progress
{
	_progress = progress;
	[self setNeedsDisplay];
}

@end
