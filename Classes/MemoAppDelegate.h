//
//  MemoAppDelegate.h
//  Memo
//
//  Created by Siddharth Chaubal on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class MemoViewController,Home_Page;

@interface MemoAppDelegate : NSObject <UIApplicationDelegate,CLLocationManagerDelegate> {
    UIWindow *window;
    MemoViewController *addmemoviewController;
	Home_Page *hmepageviewcontroller;
	NSNotificationCenter * myNotficationCenter;
	CLLocationManager *mymann;
	UITabBarController *mytabbarcontroller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MemoViewController *viewController;
@property (nonatomic,retain) 	CLLocationManager *mymann;
@property (nonatomic,retain) 	Home_Page *hmepageviewcontroller;
@property (nonatomic,retain) IBOutlet	UITabBarController *mytabbarcontroller;

-(CLLocationManager*) LocManager;

@end

