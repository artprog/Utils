//
//  APGradientView.h
//  Przepisy
//
//  Created by Adam Zugaj on 10.03.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@interface APGradientView : UIView
{
	@private
	UIColor *_beginColor;
	UIColor *_endColor;
}

@property (nonatomic, retain) UIColor *beginColor;
@property (nonatomic, retain) UIColor *endColor;

@end
