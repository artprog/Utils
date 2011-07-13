//
//  APImageTableViewController.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-13.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APViewController.h"

@class APImageTableView;

@protocol APImageTableViewDataSource;

@interface APImageTableViewController : APViewController
{
    @private
	APImageTableView *_imageTableView;
	//id<APImageTableViewDataSource> _dataSource;
}

@property (nonatomic, retain) APImageTableView *imageTableView;
//@property (nonatomic, assign) id<APImageTableViewDataSource> dataSource;

@end
