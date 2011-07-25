//
//  APAlertView.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-25.
//  Copyright 2011 ArtProg. All rights reserved.
//

@interface APAlertView : UIView
{
	@private
	UIWindow *_alertWindow;
	BOOL _isVisible;
}

- (void)show;
- (void)hide;

@end
