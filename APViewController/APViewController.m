//
//  APViewController.m
//  Utils
//
//  Created by Adam Zugaj on 11-07-13.
//  Copyright 2011 ArtProg. All rights reserved.
//

#import "APViewController.h"
#import "APModel.h"
#import "APDefaultModel.h"

@interface APLoadingView : UIView
{
	@private
	UIActivityIndicatorView *_activityIndicator;
    UILabel *_loadingLabel;
}

@property (nonatomic, readonly) UILabel *loadingLabel;

@end

@implementation APLoadingView

@synthesize loadingLabel = _loadingLabel;

- (id)initWithFrame:(CGRect)frame
{
	if ( (self = [super initWithFrame:frame]) )
	{
		_loadingLabel = [[UILabel alloc] init];
		_loadingLabel.font = [UIFont systemFontOfSize:16.f];
		_loadingLabel.textColor = [UIColor grayColor];
		_loadingLabel.text = NSLocalizedString(@"Loading...", nil);
		_loadingLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_loadingLabel];
		
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[_activityIndicator startAnimating];
		[self addSubview:_activityIndicator];
		
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)dealloc
{
	[_loadingLabel release];
	[_activityIndicator release];
	
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frame = self.bounds;
	CGSize labelSize = [_loadingLabel.text sizeWithFont:_loadingLabel.font];
	[_activityIndicator sizeToFit];
	CGSize indicatorSize = _activityIndicator.bounds.size;
	CGFloat totalWidth = labelSize.width+indicatorSize.width+8.f;
	
	CGRect indicatorFrame = CGRectZero;
	indicatorFrame.size = indicatorSize;
	indicatorFrame.origin.x = floorf((frame.size.width-totalWidth)/2.f);
	indicatorFrame.origin.y = floorf((frame.size.height-indicatorSize.height)/2.f);
	_activityIndicator.frame = indicatorFrame;
	
	CGRect labelFrame = CGRectZero;
	labelFrame.size = labelSize;
	labelFrame.origin.x = indicatorFrame.origin.x+indicatorFrame.size.width+8.f;
	labelFrame.origin.y = floorf((frame.size.height-labelSize.height)/2.f);
	_loadingLabel.frame = labelFrame;
}

@end

@interface APErrorView : UIView
{
	@private
    UILabel *_errorLabel;
}

@property (nonatomic, readonly) UILabel *errorLabel;

- (id)initWithError:(NSError*)error;

@end

@implementation APErrorView

@synthesize errorLabel = _errorLabel;

- (id)initWithError:(NSError*)error
{
	if ( (self = [super init]) )
	{
		_errorLabel = [[UILabel alloc] init];
		_errorLabel.font = [UIFont systemFontOfSize:16.f];
		_errorLabel.textColor = [UIColor grayColor];
		if ( error && ![error isKindOfClass:[NSNull class]] )
		{
			_errorLabel.text = [error localizedDescription];
		}
		else
		{
			_errorLabel.text = NSLocalizedString(@"An unexpected error occured!", nil);
		}
		_errorLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_errorLabel];
		
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)dealloc
{
	[_errorLabel release];
	
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frame = self.bounds;
	CGSize labelSize = [_errorLabel.text sizeWithFont:_errorLabel.font];
	
	CGFloat totalWidth = labelSize.width;
	
	CGRect labelFrame = CGRectZero;
	labelFrame.size = labelSize;
	labelFrame.origin.x = floorf((frame.size.width-totalWidth)/2);
	labelFrame.origin.y = floorf((frame.size.height-labelSize.height)/2.f);
	_errorLabel.frame = labelFrame;
}

@end

@implementation APViewController

@synthesize model = _model;

- (void)dealloc
{
	[self hideCoverView];
	RELEASE(_model);
	
	[super dealloc];
}

- (void)loadView
{
	CGRect frame = CGRectMake(0, 0, 320, 480);
	self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
	self.view.backgroundColor = [UIColor clearColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self createModel];
	[self.model addDelegate:self];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	[self hideCoverView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self reloadIfNeeded];
}

- (void)createModel
{
	_model = [[APDefaultModel alloc] init];
}

- (void)reloadIfNeeded
{
	@synchronized(self)
	{
		if ( ![self.model isLoading] )
		{
			if ( [self.model isLoaded] )
			{
				if ( [self.model isOutdated] )
				{
					[self.model load];
				}
			}
			else
			{
				[self.model load];
			}
		}
	}
}

- (void)showLoading
{
	[self hideCoverView];
	_coverView = [[APLoadingView alloc] init];
	_coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	_coverView.frame = self.view.bounds;
	[self.view addSubview:_coverView];
}

- (void)showError:(NSError*)error
{
	[self hideCoverView];
	_coverView = [[APErrorView alloc] initWithError:error];
	_coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	_coverView.frame = self.view.bounds;
	[self.view addSubview:_coverView];
}

- (void)hideCoverView
{
	[_coverView removeFromSuperview];
	RELEASE(_coverView);
}

#pragma mark -
#pragma mark APModelDelegate

- (void)modelDidStartLoad:(id<APModel>)model
{
	[self showLoading];
}

- (void)modelDidFinishLoad:(id<APModel>)model
{
	[self hideCoverView];
}

- (void)modelDidCancelLoad:(id<APModel>)cancel
{
}

- (void)model:(id<APModel>)model didFailLoadWithError:(NSError*)error
{
	[self showError:error];
}

@end
