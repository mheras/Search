//
//  MLAppDelegate.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/22/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLAppDelegate.h"
#import "MLUtils.h"

@implementation MLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    //Search Navigation
    MLSearchViewController * searchViewController= [[MLSearchViewController alloc]initWithNibName:nil bundle:nil];
    MLFavouritesViewController * favouritesViewController = [[MLFavouritesViewController alloc] initWithNibName:nil bundle:nil];
    
    UINavigationController * navigationControllerSearch = [[UINavigationController alloc]initWithRootViewController: searchViewController];
    UINavigationController * navigationControllerFavourites = [[UINavigationController alloc]initWithRootViewController: favouritesViewController];
    
    UITabBarController * tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    
    //Tab bar items
    UITabBarItem* searchProductTabBarItem=[[UITabBarItem alloc] initWithTitle:@"Buscar"  image:[UIImage imageNamed:@"searchTabBar.png"] tag:0];
    UITabBarItem* favouritesProductsTabBarItem=[[UITabBarItem alloc] initWithTitle:@"Favoritos"  image:[UIImage imageNamed:@"bookmarksTabBar.png"] tag:1];
    
    //Seleccionado en amarillo
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor yellowColor]];
    // Dark appearence
    //tabBarController.tabBar.barTintColor = [self colorWith255Red:84 withGreen:84 withBlue:84];
    
    if([MLUtils isRunningIos7]){
        tabBarController.tabBar.barTintColor=[UIColor blackColor];}
    else{
        [[UITabBar appearance] setBackgroundColor:[UIColor blackColor]];
    }

    navigationControllerSearch.tabBarItem=searchProductTabBarItem;
    navigationControllerFavourites.tabBarItem=favouritesProductsTabBarItem;
    
    [tabBarController setViewControllers:@[navigationControllerSearch,navigationControllerFavourites]];
    
    self.window.rootViewController= tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
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
