//
//  NSArray+APUtils.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-13.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "NSArray+APUtils.h"
#import "NSObject+APUtils.h"

@implementation NSArray (APUtils)

- (void)performSelectorOnMainThread:(SEL)selector withContext:(id)context waitUntilDone:(BOOL)waitUntilDone
{
	NSArray *copy = [[self copy] autorelease];
	for (id object in copy)
	{
		if ( [object respondsToSelector:selector] )
		{
			[object performSelectorOnMainThread:selector withContext:context waitUntilDone:waitUntilDone];
		}
	}
}

- (void)performSelectorOnMainThread:(SEL)selector withObjects:(id)firstObj, ...
{
	id currentObject;
	va_list argList;
	NSMutableArray *args = [NSMutableArray array];
	if ( firstObj )
	{
		[args addObject:firstObj];
		va_start(argList, firstObj);
		while ( (currentObject = va_arg(argList, id)) )
		{
			[args addObject:currentObject];
		}
		va_end(argList);
	}
	
    [self performSelectorOnMainThread:selector withContext:args waitUntilDone:YES];
}

@end
