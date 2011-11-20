//
//  APTableViewCell.h
//  Utils
//
//  Created by Adam Zugaj on 20.11.2011.
//  Copyright (c) 2011 ArtProg. All rights reserved.
//

@interface APTableViewCell : UITableViewCell
{
	@protected
	id _object;
}

@property (nonatomic, retain) id object;

+ (CGFloat)tableView:(UITableView*)tableView cellHeightForObject:(id)object;

@end
