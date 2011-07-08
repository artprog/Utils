//
//  APHorizontalTableViewCell.m
//  tmp
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 SMTSoftware. All rights reserved.
//

#import "APHorizontalTableViewCell.h"
#import "APHorizontalTableView.h"

@implementation APHorizontalTableViewCell

+ (CGFloat)tableView:(APHorizontalTableView*)tableView widthForObject:(id)object
{
	return tableView.bounds.size.width;
}

@end
