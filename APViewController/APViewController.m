//
//  APViewController.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-13.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APViewController.h"
#import "APModel.h"
#import "APDefaultModel.h"

@implementation APViewController

@synthesize model = _model;

- (void)dealloc
{
	RELEASE(_model);
	
	[super dealloc];
}

- (void)loadView
{
	CGRect frame = CGRectMake(0, 0, 320, 480);
	self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
	self.view.backgroundColor = [UIColor clearColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self createModel];
	[self.model addDelegate:self];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ( ![self.model isLoading] && [self.model isOutdated] )
	{
		[self.model load];
	}
}

- (void)createModel
{
	_model = [[APDefaultModel alloc] init];
}

#pragma mark -
#pragma mark APModelDelegate

- (void)modelDidStartLoad:(id<APModel>)model
{
}

- (void)modelDidFinishLoad:(id<APModel>)model
{
}

- (void)modelDidCancelLoad:(id<APModel>)cancel
{
}

- (void)model:(id<APModel>)model didFailLoadWithError:(NSError*)error
{
}

@end
