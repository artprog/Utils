//
//  APImageTableViewController.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-13.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APImageTableViewController.h"
#import "APImageTableView.h"

@interface APImageTableViewController ()
@end

@implementation APImageTableViewController

@synthesize imageTableView = _imageTableView;

- (id)init
{
	if ( (self = [super init]) )
	{
	}
	return self;
}

- (void)dealloc
{
	RELEASE(_imageTableView);
	
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	
	[self.view addSubview:self.imageTableView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	RELEASE(_imageTableView);
}

- (APImageTableView*)imageTableView
{
	if ( !_imageTableView )
	{
		_imageTableView = [[APImageTableView alloc] initWithFrame:self.view.bounds];
		_imageTableView.autoresizingMask = self.view.autoresizingMask;
	}
	return _imageTableView;
}

#pragma mark -
#pragma mark APImageTableViewController ()

#pragma mark -
#pragma mark APModelDelegate

- (void)modelDidFinishLoad:(id<APModel>)model
{
	[super modelDidFinishLoad:model];
	
	if ( model == self.model )
	{
		[_imageTableView reloadData];
	}
}

@end
