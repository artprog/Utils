//
//  APTableViewCell.m
//  tmp
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 SMTSoftware. All rights reserved.
//

#import "APTableViewCell.h"

@implementation APTableViewCell

@synthesize object = _object;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
