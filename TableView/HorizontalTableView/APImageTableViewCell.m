//
//  APHorizontalTableViewCell.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APImageTableViewCell.h"
#import "APImageTableView.h"

@implementation APImageTableViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize object = _object;

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
	if ( (self = [super init]) )
	{
		_reuseIdentifier = [reuseIdentifier copy];
	}
	return self;
}

- (void)dealloc
{
	RELEASE(_reuseIdentifier);
	RELEASE(_object);
	
	[super dealloc];
}

- (void)didShow
{
}

- (void)didHide
{
}

@end
