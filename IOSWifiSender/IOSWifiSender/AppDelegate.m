//
//  AppDelegate.m
//  x
//
//  Created by Aaron Liu on 3/17/16.
//  Copyright © 2016 Aaron Liu. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()
{
    //@property (nonatomic, strong) NSString *userName;
}
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    [Parse setApplicationId:@"2cgtN37k2k6hylSkqZeBmREGrYSwAjiKG7AIZY3v" clientKey:@"Ad9u7dApDtgOLUJgEe0cm18CjpwzTZDB2gjNrpWt"];
    [PFUser logInWithUsernameInBackground:@"root" password:@"root"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            PFQuery *query = [PFQuery queryWithClassName:@"info"];
                                            [query getObjectInBackgroundWithId:@"GNoVk3Re5d" block:^(PFObject *deviceInfo, NSError *error) {
                                                
                                                // Do stuff after successful login.
                                               // PFObject *deviceInfo;
                                               // deviceInfo = [PFObject objectWithClassName:@"info"];
                                               /* deviceInfo[@"v1"] = user[@"v1"];
                                                deviceInfo[@"v2"] = user[@"v2"];
                                                deviceInfo[@"Off"] = user[@"Off"];
                                                deviceInfo[@"1D"] = user[@"1D"];
                                                deviceInfo[@"2D"] = user[@"2D"];
                                                deviceInfo[@"3D"] = user[@"3D"];
                                                deviceInfo[@"4D"] = user[@"4D"];
                                                deviceInfo[@"5D"] = user[@"5D"];
                                                deviceInfo[@"6D"] = user[@"6D"];
                                                deviceInfo[@"7D"] = user[@"7D"];
                                                
                                                deviceInfo[@"1T"] = user[@"1T"];
                                                deviceInfo[@"2T"] = user[@"2T"];
                                                deviceInfo[@"3T"] = user[@"3T"];
                                                deviceInfo[@"4T"] = user[@"4T"];
                                                deviceInfo[@"5T"] = user[@"5T"];
                                                deviceInfo[@"6T"] = user[@"6T"];
                                                deviceInfo[@"7T"] = user[@"7T"];*/
                                                [deviceInfo saveInBackground];
                             
                                            }];
                                            // T
                                           

                                            
                                        } else {
                                            NSLog(@"%@", error);
                                            // The login failed. Check error to see why.
                                        }
                                    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
