//
//  APProgressView.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-26.
//  Copyright 2011 ArtProg. All rights reserved.
//

@interface APProgressView : UIView
{
	@private
    UIImage *_progressImage;
	CGFloat _progress;
	UIImage *_backgroundImage;
}

@property (nonatomic, retain) UIImage *progressImage;
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic) CGFloat progress;

@end
