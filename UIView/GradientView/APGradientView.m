//
//  APGradientView.m
//  Przepisy
//
//  Created by Adam Zugaj on 10.03.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APGradientView.h"

@implementation APGradientView

@synthesize beginColor = _beginColor;
@synthesize endColor = _endColor;

- (id)init
{
    if ( (self = [super init]) )
    {
		_beginColor = [UIColor whiteColor];
		_endColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc
{
	[_beginColor release];
	[_endColor release];
	
	[super dealloc];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects:(id)_beginColor.CGColor, (id)_endColor.CGColor, nil];
	CGFloat locations[] = {0, 1};
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGColorSpaceRelease(colorSpace);
	CGRect bounds = self.bounds;
	CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
	CGContextFillRect(ctx, bounds);
	CGPoint startPoint = CGPointMake(CGRectGetMidX(bounds), 0.f);
	CGPoint endPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
}

@end
