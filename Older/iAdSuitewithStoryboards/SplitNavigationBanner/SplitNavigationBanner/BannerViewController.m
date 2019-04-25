/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
container view controller that manages an ADBannerView and a content view controller.
 */

@import iAd;

#import "BannerViewController.h"

NSString * const BannerViewActionWillBegin = @"BannerViewActionWillBegin";
NSString * const BannerViewActionDidFinish = @"BannerViewActionDidFinish";

@interface BannerViewController () <ADBannerViewDelegate, UISplitViewControllerDelegate>

@property (nonatomic, strong) ADBannerView *bannerView;
@property (nonatomic, strong) UISplitViewController *splitViewController;

@end

@implementation BannerViewController

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // on iOS 6 ADBannerView introduces a new initializer, use it when available
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    }
    else {
        _bannerView = [[ADBannerView alloc] init];
    }
    self.bannerView.delegate = self;
    
    [self.view addSubview:self.bannerView];
    
    self.splitViewController = self.childViewControllers[0];  // remember who our content child is
    
    self.splitViewController.delegate = self;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.splitViewController preferredInterfaceOrientationForPresentation];
}

- (void)viewDidLayoutSubviews {
    CGRect contentFrame = self.view.bounds, bannerFrame = CGRectZero;
    
    // Ask the banner for a size that fits into the layout area we are using.
    // At this point in this method contentFrame=self.view.bounds, so we'll use that size for the layout.
    bannerFrame.size = [self.bannerView sizeThatFits:contentFrame.size];
    
    if (self.bannerView.bannerLoaded) {
        contentFrame.size.height -= bannerFrame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    }
    else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    self.splitViewController.view.frame = contentFrame;
    self.bannerView.frame = bannerFrame;
}


#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [UIView animateWithDuration:0.25 animations:^{
        // viewDidLayoutSubviews will handle positioning the banner view so that it is visible.
        // You must not call [self.view layoutSubviews] directly.  However, you can flag the view
        // as requiring layout...
        [self.view setNeedsLayout];
        // ... then ask it to lay itself out immediately if it is flagged as requiring layout...
        [self.view layoutIfNeeded];
        // ... which has the same effect.
    }];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"didFailToReceiveAdWithError %@", error);
    
    [UIView animateWithDuration:0.25 animations:^{
        // viewDidLayoutSubviews will handle positioning the banner view so that it is visible.
        // You must not call [self.view layoutSubviews] directly.  However, you can flag the view
        // as requiring layout...
        [self.view setNeedsLayout];
        // ...then ask it to lay itself out immediately if it is flagged as requiring layout...
        [self.view layoutIfNeeded];
        // ...which has the same effect.
    }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionWillBegin object:self];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionDidFinish object:self];
}

#pragma mark - UISplitViewControllerDelegate

- (UIViewController *)primaryViewControllerForCollapsingSplitViewController:(UISplitViewController *)splitViewController {
    //  Identify the master view controller's navigation controller as the primary view controller
    //  for collapsing the UISplitViewController on iPhone
    return splitViewController.viewControllers.firstObject;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController {
    //  Return YES to indicate that you do not want the split view controller to do anything with the secondary view controller
    return YES;
}

@end
