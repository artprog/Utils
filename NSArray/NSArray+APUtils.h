//
//  NSArray+APUtils.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-13.
//  Copyright 2011 ArtProg. All rights reserved.
//

@interface NSArray (APUtils)

- (void)performSelectorOnMainThread:(SEL)selector withObjects:(id)firstObj, ...;
- (void)performSelectorOnMainThread:(SEL)selector withContext:(id)context waitUntilDone:(BOOL)waitUntilDone;

@end
