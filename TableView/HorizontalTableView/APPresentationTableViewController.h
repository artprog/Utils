//
//  APPresentationTableViewController.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-20.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APViewController.h"

@class APPresentationTableView;

@interface APPresentationTableViewController : APViewController
{
	@private
	APPresentationTableView *_presentationTableView;
}

@property (nonatomic, retain) APPresentationTableView *presentationTableView;

@end
