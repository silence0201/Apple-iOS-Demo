/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Application delegate
 */


#import "AppDelegate.h"
#import "Statistics.h"


@implementation AppDelegate

@synthesize window;

- (void)applicationWillTerminate:(UIApplication *)application {
    CloseStatisticsDatabase();
}

@end

