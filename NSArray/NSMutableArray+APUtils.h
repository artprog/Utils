//
//  NSMutableArray+APUtils.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-11.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (APUtils)

+ (NSMutableArray*)nonRetainingArray;
+ (NSMutableArray*)nonRetainingArrayWithCapacity:(NSInteger)capacity;

@end
