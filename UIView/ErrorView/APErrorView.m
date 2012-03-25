//
//  APErrorView.m
//  Przepisy
//
//  Created by Adam Zugaj on 25.03.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APErrorView.h"

@implementation APErrorView

@synthesize error = _error;

- (id)init
{
	return [self initWithError:nil];
}

- (id)initWithError:(NSError*)error
{
	if ( (self = [super init]) )
	{
		_errorLabel = [[UILabel alloc] init];
		_errorLabel.font = [UIFont systemFontOfSize:16.f];
		_errorLabel.textColor = [UIColor grayColor];
		_errorLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_errorLabel];
		
		[self setError:error];
		
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)dealloc
{
	[_errorLabel release];
	[_error release];
	
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frame = self.bounds;
	CGSize labelSize = [_errorLabel.text sizeWithFont:_errorLabel.font];
	
	CGFloat totalWidth = labelSize.width;
	
	CGRect labelFrame = CGRectZero;
	labelFrame.size = labelSize;
	labelFrame.origin.x = floorf((frame.size.width-totalWidth)/2);
	labelFrame.origin.y = floorf((frame.size.height-labelSize.height)/2.f);
	_errorLabel.frame = labelFrame;
}

- (void)setError:(NSError*)error
{
	[_error autorelease];
	_error = [error copy];
	if ( _error && ![_error isKindOfClass:[NSNull class]] )
	{
		_errorLabel.text = [_error localizedDescription];
	}
	else
	{
		_errorLabel.text = [self descriptionForEmpty];
	}
}

- (NSString*)descriptionForEmpty
{
	return NSLocalizedString(@"An unexpected error occured!", nil);
}

@end
