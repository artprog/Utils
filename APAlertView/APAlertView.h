//
//  APAlertView.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-25.
//  Copyright 2011 ArtProg. All rights reserved.
//

@protocol APAlertViewDelegate;

@interface APAlertView : UIView
{
	@private
	UIWindow *_alertWindow;
	BOOL _isVisible;
    UIColor *_windowBackgroundColor;
    id<APAlertViewDelegate> _delegate;
}

@property (nonatomic, assign) id<APAlertViewDelegate> delegate;
@property (nonatomic, retain) UIColor *windowBackgroundColor;

- (void)show;
- (void)dismissWithButtonAtIndex:(NSInteger)index;
- (BOOL)isVisible;

- (void)popUpAnimation;

@end

@protocol APAlertViewDelegate <NSObject>
@optional
- (void)alertView:(APAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end
