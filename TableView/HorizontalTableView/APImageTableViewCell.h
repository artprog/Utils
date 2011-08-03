//
//  APHorizontalTableViewCell.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-08.
//  Copyright 2011 ArtProg. All rights reserved.
//

@class APImageTableView;

@interface APImageTableViewCell : UIView
{
	@private
	NSString *_reuseIdentifier;
	@protected
	id _object;
}

@property (nonatomic, readonly) NSString *reuseIdentifier;
@property (nonatomic, retain) id object;

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)didShow;
- (void)didHide;

- (void)prepareToRotation;
- (void)willAnimateRotation;
- (void)didRotate;

@end
