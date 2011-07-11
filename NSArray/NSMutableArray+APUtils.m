//
//  NSMutableArray+APUtils.m
//  Presentations
//
//  Created by Adam Zugaj on 11-07-11.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "NSMutableArray+APUtils.h"

@implementation NSMutableArray (APUtils)

+ (NSMutableArray*)nonRetainingArray
{
	return [NSMutableArray nonRetainingArrayWithCapacity:0];
}

+ (NSMutableArray*)nonRetainingArrayWithCapacity:(NSInteger)capacity
{
	CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    return (id)(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end
