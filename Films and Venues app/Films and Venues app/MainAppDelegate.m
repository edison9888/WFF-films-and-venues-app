//
//  MainAppDelegate.m
//  Films and Venues app
//
//  Created by Jordan Carney on 1/15/13.
//  Copyright (c) 2013 Jordan Carney. All rights reserved.
//

#import "MainAppDelegate.h"
#import "HomeViewController.h"
#import "MFSideMenu.h"
#import "SideMenuViewController.h"

/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-TRACKING-ID";

@implementation MainAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].debug = YES;
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    /* sets the nav bar to custom text everywhere */
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor whiteColor],
                          UITextAttributeTextShadowColor: [UIColor grayColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                     UITextAttributeFont: [UIFont fontWithName:@"KeeponTruckin" size:24.0f]
     }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [self sideMenu].navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (HomeViewController *)demoController {
    return [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self demoController]];
}

-(MFSideMenu *)sideMenu {
    SideMenuViewController *leftSideMenuController = [[SideMenuViewController alloc] init];
    UINavigationController *navigationController = [self navigationController];
    
    MFSideMenu *sideMenu = [MFSideMenu menuWithNavigationController:navigationController
                                             leftSideMenuController:leftSideMenuController
                                            rightSideMenuController:nil];
    
    leftSideMenuController.sideMenu = sideMenu;
    
    return sideMenu;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
