//
//  APDefaultModel.m
//  Presentations
//
//  Created by Adam Zugaj on 11-07-11.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APDefaultModel.h"
#import "NSMutableArray+APUtils.h"
#import "NSArray+APUtils.h"
#import "APModelDelegate.h"

@implementation APDefaultModel

@synthesize items = _items;

- (id)init
{
	if ( (self = [super init]) )
	{
		_delegates = [[NSMutableArray nonRetainingArray] retain];
		_items = [[NSMutableArray array] retain];
	}
	return self;
}

- (void)dealloc
{
	RELEASE(_delegates);
	RELEASE(_items);
	
	[super dealloc];
}

- (void)didStartLoad
{
	[_delegates performSelectorOnMainThread:@selector(modelDidStartLoad:) withObjects:self, nil];
}

- (void)didFinishLoad
{
	[_delegates performSelectorOnMainThread:@selector(modelDidFinishLoad:) withObjects:self, nil];
}

- (void)didFailLoadWithError:(NSError*)error
{
	[_delegates performSelectorOnMainThread:@selector(model:didFailLoadWithError:) withObjects:self, error, nil];
}

#pragma mark -
#pragma mark APModel

- (void)addDelegate:(id<APModelDelegate>)delegate
{
	if ( delegate )
	{
		if ( [_delegates indexOfObject:delegate] == NSNotFound )
		{
			[_delegates addObject:delegate];
		}
	}
}

- (void)removeDelegate:(id<APModelDelegate>)delegate
{
	if ( delegate )
	{
		[_delegates removeObject:delegate];
	}
}

- (BOOL)isLoaded
{
	return YES;
}

- (BOOL)isLoading
{
	return NO;
}

- (BOOL)isOutdated
{
	return YES;
}

- (void)load
{
	[self didFinishLoad];
}

- (void)cancel
{
}

@end
