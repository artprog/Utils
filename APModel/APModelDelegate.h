//
//  APModelDelegate.h
//  Presentations
//
//  Created by Adam Zugaj on 11-07-11.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APModel.h"

@protocol APModelDelegate <NSObject>
@optional
- (void)modelDidStartLoad:(id<APModel>)model;
- (void)modelDidFinishLoad:(id<APModel>)model;
- (void)modelDidCancelLoad:(id<APModel>)cancel;
- (void)model:(id<APModel>)model didFailLoadWithError:(NSError*)error;
@end
