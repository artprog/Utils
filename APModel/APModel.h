//
//  APModel.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-11.
//  Copyright 2011 ArtProg. All rights reserved.
//

@protocol APModelDelegate;

@protocol APModel <NSObject>

@property (nonatomic, readonly) NSArray *items;

- (void)addDelegate:(id<APModelDelegate>)delegate;
- (void)removeDelegate:(id<APModelDelegate>)delegate;

- (void)load;
- (void)cancel;
- (BOOL)isLoading;
- (BOOL)isLoaded;

@end
