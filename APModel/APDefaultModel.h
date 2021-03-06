//
//  APDefaultModel.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-11.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APModel.h"

@interface APDefaultModel : NSObject <APModel>
{
    NSMutableArray *_delegates;
	NSMutableArray *_items;
}

- (void)didStartLoad;
- (void)didFinishLoad;
- (void)didFailLoadWithError:(NSError*)error;

@end
