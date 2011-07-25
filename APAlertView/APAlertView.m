//
//  APAlertView.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-25.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "APAlertViewController.h"

@interface APAlertView ()
- (void)popUpAnimation;
@end

@implementation APAlertView

- (id)init
{
	return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
	if ( (self = [super initWithFrame:frame]) )
	{
	}
	return self;
}

- (void)dealloc
{
	DLOG(@"alert view dealloc", nil);
    [super dealloc];
}

- (void)show
{
	if ( !_isVisible )
	{
		_isVisible = YES;
		_alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		_alertWindow.windowLevel = UIWindowLevelAlert;
		_alertWindow.backgroundColor = [UIColor clearColor];
		_alertWindow.hidden = NO;
		APAlertViewController *viewController = [[[APAlertViewController alloc] init] autorelease];
		viewController.view.backgroundColor = [UIColor lightGrayColor];
		viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.center = viewController.view.center;
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
		[viewController.view addSubview:self];
		_alertWindow.rootViewController = viewController;
		[self popUpAnimation];
		[self performSelector:@selector(hide) withObject:nil afterDelay:3];
	}
}

- (void)hide
{
	if ( _isVisible )
	{
		[UIView animateWithDuration:0.3
						 animations:^(void) {
							 _alertWindow.alpha = 0;
						 }
						 completion:^(BOOL finished) {
							 if ( finished )
							 {
								 _isVisible = NO;
								 RELEASE(_alertWindow);
							 }
						 }];
	}
}

#pragma mark -
#pragma mark APAlertView ()

- (void)popUpAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
									  animationWithKeyPath:@"transform"];
	
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
	
    NSArray *frameValues = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:scale1],
							[NSValue valueWithCATransform3D:scale2],
							[NSValue valueWithCATransform3D:scale3],
							[NSValue valueWithCATransform3D:scale4],
							nil];
    [animation setValues:frameValues];
	
    NSArray *frameTimes = [NSArray arrayWithObjects:
						   [NSNumber numberWithFloat:0.0],
						   [NSNumber numberWithFloat:0.5],
						   [NSNumber numberWithFloat:0.9],
						   [NSNumber numberWithFloat:1.0],
						   nil];    
    [animation setKeyTimes:frameTimes];
	
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
	
    [self.layer addAnimation:animation forKey:@"popup"];
}

@end
