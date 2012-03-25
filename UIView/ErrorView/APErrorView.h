//
//  APErrorView.h
//  Przepisy
//
//  Created by Adam Zugaj on 25.03.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@interface APErrorView : UIView
{
	@private
    UILabel *_errorLabel;
	NSError *_error;
}

@property (nonatomic, copy) NSError *error;

- (id)initWithError:(NSError*)error;

- (NSString*)descriptionForEmpty;

@end