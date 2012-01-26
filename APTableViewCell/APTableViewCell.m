//
//  APTableViewCell.m
//  Roessli
//
//  Created by Adam Zugaj on 20.11.2011.
//  Copyright (c) 2011 ArtProg. All rights reserved.
//

#import "APTableViewCell.h"

@implementation APTableViewCell

@synthesize object = _object;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) )
    {
    }
    return self;
}

- (void)dealloc
{
	RELEASE(_object);
	
	[super dealloc];
}

+ (CGFloat)tableView:(UITableView*)tableView cellHeightForObject:(id)object
{
	return 44.f;
}

@end
