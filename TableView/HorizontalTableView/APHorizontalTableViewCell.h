//
//  APHorizontalTableViewCell.h
//  tmp
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 SMTSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APTableViewCell.h"

@class APHorizontalTableView;

@interface APHorizontalTableViewCell : APTableViewCell

+ (CGFloat)tableView:(APHorizontalTableView*)tableView widthForObject:(id)object;

@end
