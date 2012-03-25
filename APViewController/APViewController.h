//
//  APViewController.h
//  Utils
//
//  Created by Adam Zugaj on 11-07-13.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APModelDelegate.h"

@protocol APModel;

@interface APViewController : UIViewController <APModelDelegate>
{
    @private
	id<APModel> _model;
	UIView *_coverView;
}

@property (nonatomic, retain) id<APModel> model;

- (void)createModel;

- (void)reloadIfNeeded;

- (void)showLoading;
- (void)showError:(NSError*)error;
- (void)hideCoverView;

- (UIView*)viewForError:(NSError*)error;

- (CGRect)frameForCoverView;

@end
