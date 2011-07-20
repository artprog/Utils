//
//  APPresentationTableViewController.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-20.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APPresentationTableViewController.h"
#import "APPresentationTableView.h"

@interface APPresentationTableViewController ()
@end

@implementation APPresentationTableViewController

@synthesize presentationTableView = _presentationTableView;

- (id)init
{
	if ( (self = [super init]) )
	{
	}
	return self;
}

- (void)dealloc
{
	RELEASE(_presentationTableView);
	
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	
	[self.view addSubview:self.presentationTableView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	RELEASE(_presentationTableView);
}

- (APPresentationTableView*)presentationTableView
{
	if ( !_presentationTableView )
	{
		_presentationTableView = [[APPresentationTableView alloc] initWithFrame:self.view.bounds];
		_presentationTableView.autoresizingMask = self.view.autoresizingMask;
	}
	return _presentationTableView;
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
		[_presentationTableView reloadData];
	}
}

@end