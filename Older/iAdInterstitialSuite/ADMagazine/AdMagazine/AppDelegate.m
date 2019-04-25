/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application delegate class used for setting up our application.
 */

#import "AppDelegate.h"
@import iAd;

@implementation AppDelegate

// The app delegate must implement the window @property
// from UIApplicationDelegate @protocol to use a main storyboard file.
//
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* Ads involve network requests, so if an application needs to use interstitial
        ads and wants to ensure early availability, this method can be called to trigger
        a prefetch.
    */
    [UIViewController prepareInterstitialAds];
    
    return YES;
}

@end
