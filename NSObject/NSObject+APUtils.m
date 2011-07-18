//
//  NSObject+APUtils.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-13.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "NSObject+APUtils.h"

@implementation NSObject (APUtils)

- (NSInvocation*)invocationFromSelector:(SEL)selector context:(id)context
{
	NSMutableArray *args = [NSMutableArray array];
	if ( [context isKindOfClass:[NSArray class]] )
	{
		[args addObjectsFromArray:context];
	}
	else
	{
		[args addObject:context];
	}
	NSMethodSignature *theSignature = [self methodSignatureForSelector:selector];
	NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:theSignature];
	NSUInteger parameterCount = [args count];
	NSUInteger argumentCount = [theSignature numberOfArguments] - 2;
	if (parameterCount == argumentCount)
	{
		[theInvocation setTarget:self]; // There's our index 0.
		[theInvocation setSelector:selector]; // There's our index 1.
		
		// Now for arguments 2 and up...
		NSUInteger i, count = parameterCount;
		for (i = 0; i<count; ++i)
		{
			id currentValue = [args objectAtIndex:i];
			if ( [currentValue isKindOfClass:[NSValue class]] )
			{
				void *bufferForValue;
				[currentValue getValue:&bufferForValue];
				[theInvocation setArgument:&bufferForValue atIndex:(i+2)];
				// The +2 represents the (self) and (cmd) offsets
			}
			else
			{
				[theInvocation setArgument:&currentValue atIndex:(i+2)];
				// Again, our +2 represents (self) and (cmd) offsets
			}
		}
		return theInvocation;
	}
	return nil;
}

- (void)performSelector:(SEL)selector withContext:(id)context
{
	NSInvocation *theInvocation = [self invocationFromSelector:selector context:context];
	[theInvocation performSelector:@selector(invoke) withObject:nil];
}

- (void)performSelector:(SEL)selector withObjects:(id)firstObj, ...
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
	[self performSelector:selector withContext:args];
}

- (void)performSelectorOnMainThread:(SEL)selector withContext:(id)context waitUntilDone:(BOOL)waitUntilDone
{
	NSInvocation *theInvocation = [self invocationFromSelector:selector context:context];
	[theInvocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:waitUntilDone];
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
