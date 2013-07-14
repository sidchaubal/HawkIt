//
//  MemoAppDelegate.m
//  Memo
//
//  Created by Siddharth Chaubal on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemoAppDelegate.h"
#import "MemoViewController.h"
#import "Home Page.h"
#import "final.h"
#import "loge.h"
#import "CoreLocation/CLLocationManagerDelegate.h"
#import "QuartzCore/QuartzCore.h"
@implementation MemoAppDelegate

@synthesize window,mytabbarcontroller;
@synthesize viewController,mymann,hmepageviewcontroller;

int actualgps,sigloc;

  

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	
	NSString *pathd=[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
	NSMutableDictionary *tds=[[NSMutableDictionary alloc] init];
	actualgps=0;
	self.mymann = [[CLLocationManager alloc] init];
	mymann.delegate = self; 
	mymann.distanceFilter = kCLLocationAccuracyBest;
	mymann.distanceFilter = 50;
	
	NSLog(@"path is %@",pathd);
	
	BOOL xfile2Exists = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@xtodos.plist",pathd]];
	if(!xfile2Exists)
	{		
		[tds writeToFile:[NSString stringWithFormat:@"%@xtodos.plist",pathd] atomically:YES];

	}
	
	BOOL file2Exists = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@todos.plist",pathd]];
	if(!file2Exists)
	{
		[tds writeToFile:[NSString stringWithFormat:@"%@todos.plist",pathd] atomically:YES];
		NSSet *regs=[mymann monitoredRegions];
		NSArray *easy=[regs allObjects];
		for(int i=0;i<[easy count];i++)
		{
			[mymann stopMonitoringForRegion:[easy objectAtIndex:i]];
			//[tds removeObjectForKey:[[easy objectAtIndex:i] identifier] ];
		}
		
	}
		else {
		tds=[NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@todos.plist",pathd]];
		NSArray *tdkeys=[tds allKeys];
		for (int i=0; i<[tds count]; i++) {
			NSArray *currtd=[tds valueForKey:[tdkeys objectAtIndex:i]];
			NSString *stat=[currtd objectAtIndex:1];
			if([stat isEqualToString:@"No Location"])
			{ NSDate *tddate=[currtd objectAtIndex:3];
				NSComparisonResult result = [[NSDate date] compare:tddate];
				if(result == NSOrderedDescending)
					[tds removeObjectForKey:[tdkeys objectAtIndex:i]];
			}
			
		}
		[tds writeToFile:[NSString stringWithFormat:@"%@todos.plist",pathd] atomically:YES];
	
		 }

	
	sigloc=0;
	
	
	/*NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[dateFormatter setLocale:usLocale];
	NSDate *date = [NSDate date];
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	NSString *phonetype=[[NSString alloc] initWithString:@"iPhone 3GS"];
	if([CLLocationManager regionMonitoringEnabled])
	{
	  phonetype=@"iPhone 4";
	}
	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	BOOL logfile2Exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	if(!logfile2Exists)
	{   	NSString *astdate2=[[NSString alloc] initWithFormat:@"Phone Type: %@ \n App Started on date %@: %@",phonetype,[[dateFormatter locale] localeIdentifier], formattedDateString];
		[astdate2 writeToFile:path atomically:YES];
			}
	else {
		
		NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
		NSString *astdate=[[NSString alloc] initWithFormat:@"\n\n%@ \n Phone Type: %@ \nApp Started on date %@: %@",aStr,phonetype,[[dateFormatter locale] localeIdentifier], formattedDateString];
		[astdate writeToFile:path atomically:YES];
		NSDate *thed=[[NSUserDefaults standardUserDefaults] valueForKey:@"FirstLoadTime"];
		if(thed!=nil)
		{		NSLog(@"FTL loop date is %@",[thed description]);

			NSTimeInterval inter=[thed timeIntervalSinceNow];
			NSLog(@"FTL interval is %f",(inter/3600));
			if(inter<0)
				inter=inter*(-1);
			if((inter/3600)>=24)
			{   [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"FirstLoadTime"];
				NSString *URL3=[[NSString alloc] initWithFormat:@"http://sid-is-here.appspot.com/submitlog"];
				NSLog(@"URL2:%@",URL3);
				NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL3] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
				[request setHTTPMethod:@"POST"];
				NSString *postString = [NSString stringWithFormat:@"log=%@&user=%@",astdate,[[UIDevice currentDevice] name]];
				[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
				[[NSURLConnection alloc] initWithRequest:request delegate:self] ; 
				NSLog(@"request is initiated");
			}
		}

	}
	
	*/
	
				 if([[mymann monitoredRegions] count]>0)
		 [mymann startUpdatingLocation];
		 
		 
		
	
			
	
	if([[launchOptions valueForKey:@"UIApplicationLaunchOptionsLocationKey"] boolValue])
	{
		//NSLog(@"app launched due to location activity");
		
	//	NSString* aStr2 = [[NSString alloc] initWithContentsOfFile:path];
//		NSString* strr=[[NSString alloc] initWithFormat:@"%@ App launched due to location activity",aStr2];
//		[strr writeToFile:path atomically:YES];
		if(mymann==nil)
		{
			self.mymann = [[CLLocationManager alloc] init];
			mymann.delegate = self; 
			mymann.distanceFilter = kCLLocationAccuracyBest;
			mymann.distanceFilter = 50;
		}
		NSSet *regs=[mymann monitoredRegions];
		 NSArray *easy=[regs allObjects];
		 NSLog(@"count of monitored regions %d",[easy count]);
		 for(int i=0;i<[easy count];i++)
		 {
		 [mymann startMonitoringForRegion:[easy objectAtIndex:i] desiredAccuracy:1 ];
		 }
		 
		
		
	}
	
	
	// Override point for customization after application launch.
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(handleNotification:)
	 name:@"hi"
	 object:nil];    
    // Add the view controller's view to the window and display.
    [window addSubview:mytabbarcontroller.view];
    [window makeKeyAndVisible];

    return YES;
}


-(CLLocationManager*) LocManager {

	return self.mymann;

}


-(void)handleNotification:(NSNotification *)pNotification
{
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	
	NSMutableDictionary *tds=[NSMutableDictionary dictionaryWithContentsOfFile:pathx];

		NSArray *obja=(NSArray*) [pNotification object];
	NSString *obj=[obja objectAtIndex:0];
	loge *logview=[[loge alloc] initWithNibName:@"loge" bundle:nil];

	final *fview=[[final alloc] initWithNibName:@"final" bundle:nil];
	[fview wantsFullScreenLayout];
	CATransition *transition2 = [CATransition animation];
	
	// Animate over 3/4 of a second
	transition2.duration=1.00;
	// using the ease in/out timing function
	transition2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	
	
	transition2.type=kCATransitionPush;
	transition2.subtype=kCATransitionFromTop;
	
	transition2.delegate=self;
	
	if([obj isEqualToString:@"CancelF"]) {

		[[obja objectAtIndex:1] removeFromSuperview];	
		[window addSubview:mytabbarcontroller.view];

	}
	else if([obj isEqualToString:@"Home"]) {
	
		[[obja objectAtIndex:1] removeFromSuperview];
		if(mytabbarcontroller==nil)
		{
			mytabbarcontroller=[[MemoViewController alloc] initWithNibName:@"MemoViewController" bundle:nil];
			
		}
		[window addSubview:mytabbarcontroller.view];
	
	}
		else if([obj isEqualToString:@"logshow"]) {
			// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
			transition2.subtype=kCATransitionFromBottom;
			[logview.view.layer addAnimation:transition2 forKey:nil];

		[window addSubview:logview.view];	
	}
	else if([obj isEqualToString:@"log"]) {
		NSLog(@"in app delegate");
		// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
		transition2.subtype=kCATransitionFromTop;
		UIView *objview=(UIView*)[obja objectAtIndex:1];
		[objview.layer addAnimation:transition2 forKey:nil];

		[[obja objectAtIndex:1] removeFromSuperview];	
	}
	
	
	else if([obj isEqualToString:@"Kill"]) {
	
//		NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
		NSString *patht=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
		
		
//		NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
//		NSString *dat=[[NSString alloc] initWithFormat:@"%@\nApp deleting all regions and stopping Location services",aStr];
//		[dat writeToFile:path atomically:YES];	
		NSSet *regs=[mymann monitoredRegions];
		NSArray *easy=[regs allObjects];
		for(int i=0;i<[easy count];i++)
		{
			[mymann stopMonitoringForRegion:[easy objectAtIndex:i]];
			//[tds removeObjectForKey:[[easy objectAtIndex:i] identifier] ];
		}
		[tds removeAllObjects];
		[tds writeToFile:patht atomically:YES];
		[mymann stopMonitoringSignificantLocationChanges];
		[mymann stopUpdatingLocation];
		
	
	}
	else if([obj isEqualToString:@"Final"]) {
		
		NSLog(@"in app delegate");
		NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
		NSDictionary *tem=[NSDictionary dictionaryWithContentsOfFile:path];
		if([[tem valueForKey:@"selection"] isEqualToString:@"-2"]||[[tem valueForKey:@"selection"] isEqualToString:@"-1"])
		{			[mytabbarcontroller.view.layer addAnimation:transition2 forKey:nil];
			[mytabbarcontroller.view removeFromSuperview];
		}
		else 
		[[obja objectAtIndex:1] removeFromSuperview];
		
		[window addSubview:[fview view]];
	}
	else if([obj isEqualToString:@"Done_Alarm"]) {
		[[obja objectAtIndex:1] removeFromSuperview];
		[window addSubview:mytabbarcontroller.view];
	}
	else if([obj isEqualToString:@"Done"]) {
		
		NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
		NSDictionary *tem=[NSDictionary dictionaryWithContentsOfFile:path];
		int rad=[[tem valueForKey:@"radius"] intValue];
		NSString *select=[tem valueForKey:@"selection"];
		NSDictionary *tpl;
		NSArray *tpl1;
		CLLocationCoordinate2D co;

		if([select isEqualToString:@"-1"])
		{
			NSArray *locc=[[tem valueForKey:@"location"] componentsSeparatedByString:@","];
			tpl1=[[NSArray alloc] initWithObjects:@"",@"Tagged Location",[tem valueForKey:@"location"],@"",[locc objectAtIndex:0],[locc objectAtIndex:1],nil];
			co.latitude=[[tpl1 objectAtIndex:4] doubleValue];
			co.longitude=[[tpl1 objectAtIndex:5] doubleValue];
		}
		else {
			
		tpl=[[NSDictionary alloc] initWithDictionary:[[tem objectForKey:@"place"] objectAtIndex:[select intValue]]];
			co.latitude=[[tpl valueForKey:@"lat"] doubleValue];
			co.longitude=[[tpl valueForKey:@"lng"] doubleValue];
			
		}
		if([CLLocationManager regionMonitoringEnabled])
		{
		CLRegion *reg=[[CLRegion alloc] initCircularRegionWithCenter:co radius:rad identifier:[tem valueForKey:@"todo"]];
		[mymann startMonitoringForRegion:reg desiredAccuracy:2];
		}
		

		if([[tem valueForKey:@"type"] isEqualToString:@"Foot"])
		{	
			//[mymann startMonitoringSignificantLocationChanges];
			sigloc=1;
			
		}
		NSLog(@"monitored regions %d",[[mymann monitoredRegions] count]);
//		NSString *path2=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
//		NSLog(@"path is %@",path);
		
		//	NSData *fdata=[[NSData alloc] init];
//		NSString* aStr = [[NSString alloc] initWithContentsOfFile:path2];
		//NSLog(@"Data:%@",aStr);
//		NSString *dat=[[NSString alloc] initWithFormat:@"%@\nNew Todo added for %@",aStr,[tem valueForKey:@"todo"]];
//		NSLog(@"New Todo added for %@",[tem valueForKey:@"todo"]);
//		[dat writeToFile:path2 atomically:YES];
		[[obja objectAtIndex:1] removeFromSuperview];
		[window addSubview:mytabbarcontroller.view];
		if(actualgps!=1)
		{
			actualgps=1;
			mymann.distanceFilter = kCLLocationAccuracyBest;
			[mymann startUpdatingLocation];
			
		}
	}
	


}
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */	
	//CLLocationCoordinate2D thecoord3={38.904935,-77.034652};
	mytabbarcontroller.selectedViewController=[[mytabbarcontroller viewControllers] objectAtIndex:0];

	if(mymann == nil)
	{	mymann=[[CLLocationManager alloc] init];
	mymann.delegate=self;
		mymann.distanceFilter = kCLLocationAccuracyBest;
		mymann.distanceFilter = 10;
	}
	[mymann stopMonitoringSignificantLocationChanges];

	[mymann stopUpdatingLocation];
		NSString *status=@"No Background Monitoring";
//	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSDictionary *tdd=[[NSDictionary alloc] initWithContentsOfFile:pathx];
	NSArray *tddkeys=[tdd allKeys];
	int fg=0;
	int gs=0;
	for (int i=0; i<[tdd count]; i++) {
		NSString *typ=[[tdd valueForKey:[tddkeys objectAtIndex:i]] objectAtIndex:6];
		NSString *tst=[[tdd valueForKey:[tddkeys objectAtIndex:i]] objectAtIndex:1];
		if(!([CLLocationManager regionMonitoringEnabled]))
		{if(!([tst isEqualToString:@"No Location"]))
			gs=1;}
		if([typ isEqualToString:@"Foot"])
			fg=1;
	}
	if(fg==1)
	{  sigloc=0;
		[mymann startUpdatingLocation];
	status=@"Background Monitoring Active!";
		NSLog(@"starting to monitor significant location changes");

	}
	
	if (gs==1) 
	{[mymann startMonitoringSignificantLocationChanges];
		status=@"Background Monitoring Active!";
		NSLog(@"starting to monitor significant location changes");
	}
//	NSData *fdata=[[NSData alloc] init];
//	NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
//	NSLog(@"Data:%@",aStr);
//	NSString *dat=[[NSString alloc] initWithFormat:@"%@\nApp Entered Background with %@",aStr,status];
	
//	[dat writeToFile:path   atomically:YES];	//CLRegion *mynewregion3=[[CLRegion alloc] initCircularRegionWithCenter:thecoord3 radius:50 identifier:@"Magic Gourd" ];
	
	//[mymann startMonitoringForRegion:mynewregion3 desiredAccuracy:1];
	//NSLog(@"set and done!");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	
//	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	sigloc=0;
	int gpsflag=0;
	//	NSData *fdata=[[NSData alloc] init];
//	NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
//	NSString *da=[[NSString alloc] initWithFormat:@"%@\nApp Entered Foreground",aStr];
//	[da writeToFile:path atomically:YES];
	
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSMutableDictionary *tdss=[[NSMutableDictionary alloc] initWithContentsOfFile:pathx];
	NSArray *tdkeys=[tdss allKeys];
	for (int i=0; i<[tdss count]; i++) {
		NSArray *currtd=[tdss valueForKey:[tdkeys objectAtIndex:i]];
		NSString *stat=[currtd objectAtIndex:1];
		if([stat isEqualToString:@"No Location"])
		{ NSDate *tddate=[currtd objectAtIndex:3];
			NSComparisonResult result = [[NSDate date] compare:tddate];
			if(result == NSOrderedDescending)
				[tdss removeObjectForKey:[tdkeys objectAtIndex:i]];
		}
		else 
			gpsflag=1;
		
	}
	[tdss writeToFile:pathx atomically:YES];
	
	
	if(mymann == nil)
	{	mymann=[[CLLocationManager alloc] init];
		mymann.delegate=self;
		mymann.distanceFilter = kCLLocationAccuracyBest;
		mymann.distanceFilter = 50;
	}
	//[mymann stopMonitoringSignificantLocationChanges];
	if(gpsflag==1)
	[mymann startUpdatingLocation];
	
	if([application applicationIconBadgeNumber]>0)
	{
		application.applicationIconBadgeNumber=0;
	}
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
//	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	//NSString *patht=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	//NSMutableDictionary *tds=[[NSMutableDictionary alloc] initWithContentsOfFile:patht];
	
	
//	NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
//	NSString *dat=[[NSString alloc] initWithFormat:@"%@\nApp about to terminate",aStr];
//	[dat writeToFile:path atomically:YES];	
	
	/*NSSet *regs=[mymann monitoredRegions];
	NSArray *easy=[regs allObjects];
	NSLog(@"about to exit: regions currently: %d",[easy count]);
	for(int i=0;i<[easy count];i++)
	{
		[mymann stopMonitoringForRegion:[easy objectAtIndex:i]];
		[tds removeObjectForKey:[[easy objectAtIndex:i] identifier ]];
	}*/
	//[tds writeToFile:patht atomically:YES];
	[mymann stopMonitoringSignificantLocationChanges];
	[mymann stopUpdatingLocation];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	
	NSDictionary *temp=[notification userInfo];
	NSString *t;
	NSString *pathp=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];

	t=[[NSString alloc] initWithFormat:NSLocalizedString(@"%@", nil),
			   [temp valueForKey:@"ToDoItemKey"]];
	
	NSLog(@"in app local noti for %@",[temp valueForKey:@"ToDoItemKey"]);
	if([[temp valueForKey:@"type"] isEqualToString:@"alarm"])
	{
		NSString *pathx=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
		NSString *patht=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];

		NSMutableDictionary *xtempdic=[NSMutableDictionary dictionaryWithContentsOfFile:patht];

		NSMutableDictionary *tempdic=[NSMutableDictionary dictionaryWithContentsOfFile:pathx];
		[xtempdic setValue:[tempdic valueForKey:[temp valueForKey:@"ToDoItemKey"]] forKey:[temp valueForKey:@"ToDoItemKey"]];
		[xtempdic writeToFile:patht atomically:YES];
		
		[tempdic removeObjectForKey:[temp valueForKey:@"ToDoItemKey"]];
		[tempdic writeToFile:pathx atomically:YES];
		
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
		
		NSArray *keys=[tempdic allKeys];
		for(int i=0;i<[tempdic count];i++)
		{
		  if([[[tempdic valueForKey:[keys objectAtIndex:i]] objectAtIndex:1] isEqualToString:@"No Location"])
		  {
			  
			  NSLog(@" active alarms in for %@",[keys objectAtIndex:i]);
		 UILocalNotification *localNotif = [[UILocalNotification alloc] init];

			  if(localNotif)
			  {
				  NSArray *currtd=[tempdic valueForKey:[keys objectAtIndex:i]];
				  NSString *alert;
				  NSString *note=[currtd objectAtIndex:7];
				  if(!([note isEqualToString:@"Insert Notes Here"]||[note isEqualToString:@""]))
					  alert=[NSString stringWithFormat:NSLocalizedString(@"%@ \n Notes:%@", nil),
							 [keys objectAtIndex:i],note];
				  else 
					  alert=[NSString stringWithFormat:NSLocalizedString(@"%@", nil),
							 [keys objectAtIndex:i]];
				  localNotif.alertBody = alert;
				  localNotif.alertAction = NSLocalizedString(@"Thanks!", nil);
				  localNotif.timeZone=[NSTimeZone localTimeZone];
				  localNotif.fireDate=[currtd objectAtIndex:3];
				  
				  localNotif.soundName = @"sub.caf";
				  localNotif.applicationIconBadgeNumber = [application applicationIconBadgeNumber]+1;
				  
				  NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",alert],@"ToDoItemKey",@"type",@"alarm",@"notes",note,nil];
				  localNotif.userInfo = infoDict;
				  [application scheduleLocalNotification:localNotif];
				  
				  localNotif.fireDate=[[currtd objectAtIndex:3] dateByAddingTimeInterval:360];
				  [application scheduleLocalNotification:localNotif];
				  
				  localNotif.fireDate=[[currtd objectAtIndex:3] dateByAddingTimeInterval:600];
				  [application scheduleLocalNotification:localNotif];
				  
				  //[application scheduleLocalNotification:localNotif];
				  [localNotif release];
				  
			  
			  
			  
			  }
		  
		  }
		}
		
	}
	NSMutableDictionary *plac=[NSMutableDictionary dictionaryWithContentsOfFile:pathp];

	[plac setValue:[temp valueForKey:@"ToDoItemKey"] forKey:@"justlaunched"];
	[plac writeToFile:pathp atomically:YES];
	mytabbarcontroller.selectedViewController=[[mytabbarcontroller viewControllers] objectAtIndex:1];
	
		
}


#pragma mark - #pragma mark CLLocationManagerDelegate Methods 
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation {


	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	UIApplication *application=[UIApplication sharedApplication];

	CLLocationCoordinate2D crds=[newLocation coordinate];
	CLLocationDegrees la=crds.latitude;
	CLLocationDegrees lo=crds.longitude;
	
	NSLog(@"in location manager method for %f %f",la,lo);	
//	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	
	NSMutableDictionary *tds=[[NSMutableDictionary alloc] initWithContentsOfFile:pathx];
	
	
	/*NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
	NSString *dat=[[NSString alloc] initWithFormat:@"%@\nLocation Manager delegate called: for location %f %f",aStr,la,lo];
	[dat retain];
	[dat writeToFile:path atomically:YES];	
	*/
/*	NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) > 5.0)
    {	/*NSString* aStr2 = [[NSString alloc] initWithContentsOfFile:path];
		NSString *dat2=[[NSString alloc] initWithFormat:@"%@\nLocation Rejected",aStr2];
		[dat2 writeToFile:path atomically:YES];	
 return;
 }

	*/
	int flag=100;
	NSArray *easy;
	if([CLLocationManager regionMonitoringEnabled])
	{
	NSSet *regs=[mymann monitoredRegions];
	easy=[regs allObjects];
	NSTimeInterval interval=3601;
		//services.text=[NSString stringWithFormat:@"Region monitored currently:%d",[easy count]];
	////CLLocationCoordinate2D thecoord1={38.899583,-77.04823};
	//CLLocationCoordinate2D thecoord3={38.903053,-77.046671};
	for(int i=0;i<[easy count];i++)
	{if([[easy objectAtIndex:i] containsCoordinate:crds])
	{	
		NSString *regionidentifier=[[easy objectAtIndex:i] identifier];
		NSString *com=[[tds valueForKey:regionidentifier] objectAtIndex:1];
		NSLog(@"for %@",com);
		if([com isEqualToString:@"Tagged Location"])
		{NSDate *currtddate=[[tds valueForKey:regionidentifier] objectAtIndex:3];
			interval=[currtddate timeIntervalSinceNow];
			interval=interval*(-1);
		}
		NSLog(@"interval %f",interval);

		if(interval>3600)
		{	//NSString* aStr2 = [[NSString alloc] initWithContentsOfFile:path];
			//NSString *nwdat=[[NSString alloc] initWithFormat:@"%@\nSignificant location change/did update location....Entered region %@",aStr2,regionidentifier];
			//[nwdat writeToFile:path atomically:YES];			
			
			flag=i;		
		}
		}
	}	
	}
	//If region monitoring is not enabled
	else {
		NSArray *tdarrays=[tds allKeys];
		NSTimeInterval interval2=3601;
		for (int i=0; i<[tds count]; i++) {
			NSArray *currt=[tds valueForKey:[tdarrays objectAtIndex:i]];
			NSString *cim=[currt objectAtIndex:1]; 
			if(!([cim isEqualToString:@"No Location"]))
			{
				if([cim isEqualToString:@"Tagged Location"])
				{NSDate *currtddate=[currt objectAtIndex:3];
					interval2=[currtddate timeIntervalSinceNow];
					interval2=interval2*(-1);
				}
				NSLog(@"interval %f",interval2);
				
				CLLocationCoordinate2D c;
				c.latitude=[[currt objectAtIndex:4] doubleValue];
				c.longitude=[[currt objectAtIndex:5] doubleValue];
				CLRegion *reg3gs=[[CLRegion alloc] initCircularRegionWithCenter:c radius:310 identifier:[tdarrays objectAtIndex:i]];
				
				if([reg3gs containsCoordinate:[newLocation coordinate]])
				{
					//NSString* aStr2 = [[NSString alloc] initWithContentsOfFile:path];
					//NSString *nwdat=[[NSString alloc] initWithFormat:@"%@\nSignificant location change/did update location....Entered region %@",aStr2,[tdarrays objectAtIndex:i]];
					//[nwdat writeToFile:path atomically:YES];			
					
					flag=i;		
					
				}
			
			}
		}
	}

	NSLog(@"flag is %d",flag);
	if(flag!=100)
	{
		if(localNotif) {
			
			NSArray *tdarrays=[tds allKeys];
			NSString *m=[tdarrays objectAtIndex:flag];
			NSString *note=[[tds valueForKey:m] objectAtIndex:7];
			NSString *alert;
			if(!(([note isEqualToString:@"Insert Notes Here"]||[note isEqualToString:@""])))
				alert=[NSString stringWithFormat:NSLocalizedString(@"%@ \n Notes:%@", nil),
					   m,note];
			else 
				alert=[NSString stringWithFormat:NSLocalizedString(@"%@", nil),
					   m];
			
			
			localNotif.alertBody = alert;				
			localNotif.alertAction = NSLocalizedString(@"Remove ToDo", nil);
			
			localNotif.soundName = @"beep.caf";
			localNotif.applicationIconBadgeNumber = [application applicationIconBadgeNumber]+1;
			
				NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:alert,@"ToDoItemKey",@"type",@"location",nil];
				localNotif.userInfo = infoDict;

						if([CLLocationManager regionMonitoringEnabled])		
			[mymann stopMonitoringForRegion:[easy objectAtIndex:flag]];
			
			NSString *pathh=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];
			NSMutableDictionary *xtempdic=[NSMutableDictionary dictionaryWithContentsOfFile:pathh];
			
			if([CLLocationManager regionMonitoringEnabled])		
			[xtempdic setObject:[tds valueForKey:[[easy objectAtIndex:flag] identifier]] forKey:[[easy objectAtIndex:flag] identifier]];
			else 
			[xtempdic setObject:[tds valueForKey:m] forKey:m];

			[xtempdic writeToFile:pathh atomically:YES];
			
			if([CLLocationManager regionMonitoringEnabled])		
			[tds removeObjectForKey:[[easy objectAtIndex:flag] identifier]];
			else 
			[tds removeObjectForKey:m];

			[tds writeToFile:pathx atomically:YES];
			[application presentLocalNotificationNow:localNotif];
			
			//[application scheduleLocalNotification:localNotif];
			[localNotif release];
			
			//[tem removeObjectForKey:td];
			//[tem writeToFile:path atomically:YES];
		}
		
	}
	else if(actualgps==1) {
		
		NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
		NSDictionary *tem=[NSDictionary dictionaryWithContentsOfFile:path];
		NSString *select=[tem valueForKey:@"selection"];
		NSArray *tpl1;
		NSDictionary *tpl;
		if([select isEqualToString:@"-1"])
		{
			NSArray *locc=[[tem valueForKey:@"location"] componentsSeparatedByString:@","];
			tpl1=[[NSArray alloc] initWithObjects:@"",@"Tagged Location",[tem valueForKey:@"location"],@"",[locc objectAtIndex:0],[locc objectAtIndex:1],nil];
			
		}
		else {
			
		tpl=[[NSDictionary alloc] initWithDictionary:[[tem objectForKey:@"place"] objectAtIndex:[select intValue]]];
			CLLocation *lll=[[CLLocation alloc] initWithLatitude:[[tpl valueForKey:@"lat"] doubleValue] longitude:[[tpl valueForKey:@"lng"] doubleValue]];
			CLLocationDistance ddd=[newLocation distanceFromLocation:lll];
			NSString *str=[[NSString alloc] initWithFormat:@"You are %f meters from your todo: %@",ddd,[tem valueForKey:@"todo"]];
			
			UIAlertView *infoview=[[UIAlertView alloc] initWithTitle:@"Sit Tight!" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[infoview show];
			[infoview release];
			//[mymann stopUpdatingLocation];

		}
			
		}

	actualgps=0;
	
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	//NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];

	
	//NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
	//NSString *dat=[[NSString alloc] initWithFormat:@"%@\nError Location manager failed for %@",aStr,[error localizedDescription]];
	//[dat writeToFile:path atomically:YES];
		
	if([[error localizedDescription] isEqualToString:@"The operation couldn’t be completed. (kCLErrorDomain error 0.)"])
	{	
		if(mymann == nil)
		{	mymann=[[CLLocationManager alloc] init];
			mymann.delegate=self;
			mymann.distanceFilter = kCLLocationAccuracyBest;
			mymann.distanceFilter = 50;
		}
	[mymann stopUpdatingLocation];
	[mymann stopMonitoringSignificantLocationChanges];
	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	UIApplication *application=[UIApplication sharedApplication];
	
		if(localNotif) {
		
		localNotif.alertBody = NSLocalizedString(@"We have failed to track your location as WiFi/3G is turned off or not available. Please Launch App again to continue tracking your ToDos",nil);
		localNotif.alertAction = NSLocalizedString(@"OK", nil);
		
		localNotif.soundName = UILocalNotificationDefaultSoundName;
		localNotif.applicationIconBadgeNumber = [application applicationIconBadgeNumber]+1;
		
		[application presentLocalNotificationNow:localNotif];
		
		//[application scheduleLocalNotification:localNotif];
		[localNotif release];
		
		//[tem removeObjectForKey:td];
		//[tem writeToFile:path atomically:YES];
	}
	}
 }




-(void) locationManager:(CLLocationManager*) manager didEnterRegion:(CLRegion*)region {
	
	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	UIApplication *application=[UIApplication sharedApplication];
	
	//NSString *path=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	//NSMutableDictionary *tem=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	NSString *tddd=[region identifier];
	//NSString *tt=[[[tem valueForKey:td] valueForKey:@"place"] objectAtIndex:1];
	NSLog(@"did enter region of %@",tddd);
//	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	NSString *patht=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSMutableDictionary *tem=[[NSMutableDictionary alloc] dictionaryWithContentsOfFile:patht];

	NSDate *currtddate=[[tem valueForKey:tddd] objectAtIndex:3];
	NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:currtddate];		
	if(interval>360)
	{	
//	NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
//	NSString *dat=[[NSString alloc] initWithFormat:@"%@\nDelegate method entered region %@",aStr,tddd];
//	[dat writeToFile:path atomically:YES];
	
	if(localNotif) {
		
		NSString *alert;
		NSString *note=[[tem valueForKey:tddd] objectAtIndex:7];
		if(!(([note isEqualToString:@"Insert Notes Here"]||[note isEqualToString:@""])))
			alert=[NSString stringWithFormat:NSLocalizedString(@"%@ \n Notes:%@", nil),
				   tddd,note];
		else 
			alert=[NSString stringWithFormat:NSLocalizedString(@"%@", nil),
				   tddd];
		
		localNotif.alertBody = alert;
		localNotif.alertAction = NSLocalizedString(@"Remove ToDo", nil);
		
		localNotif.soundName = @"beep.caf";
		localNotif.applicationIconBadgeNumber = [application applicationIconBadgeNumber]+1;
		
		NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:alert,@"ToDoItemKey",@"type",@"location",nil];
		localNotif.userInfo = infoDict;
		[mymann stopMonitoringForRegion:region];
		
		NSString *pathh=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];
		NSMutableDictionary *xtempdic=[NSMutableDictionary dictionaryWithContentsOfFile:pathh];
		
		[xtempdic setObject:[tem valueForKey:tddd] forKey:tddd];
		 [xtempdic writeToFile:pathh atomically:YES];
		 
		
		[tem removeObjectForKey:tddd];
		[tem writeToFile:patht atomically:YES];
		[application presentLocalNotificationNow:localNotif];
		
		//[application scheduleLocalNotification:localNotif];
		[localNotif release];
		
		//[tem removeObjectForKey:td];
		//[tem writeToFile:path atomically:YES];
	}
	}
}

/*
-(void) locationManager:(CLLocationManager*) manager didExitRegion:(CLRegion*)region {
	
	
	NSString *td=[region identifier];
	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	UIApplication *application=[UIApplication sharedApplication];
	NSLog(@"did exit region of %@",td);
	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	NSString *patht=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];

	NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
	NSString *dat=[[NSString alloc] initWithFormat:@"%@\nDelegate method exited region %@",aStr,td];
	[dat writeToFile:path atomically:YES];
	if(localNotif) {
		
		localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"You are exiting ToDo: %@", nil),
								td];
		localNotif.alertAction = NSLocalizedString(@"Thanks! Remove ToDo", nil);
		
		localNotif.soundName = UILocalNotificationDefaultSoundName;
		localNotif.applicationIconBadgeNumber = [application applicationIconBadgeNumber]+1;
		
		NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Exiting: %@",td],@"ToDoItemKey",@"type",@"location",nil];
		localNotif.userInfo = infoDict;
		[mymann stopMonitoringForRegion:region];
		[tds removeObjectForKey:td];
		[tds writeToFile:patht atomically:YES];
		
		[application presentLocalNotificationNow:localNotif];
		
		//[application scheduleLocalNotification:localNotif];
		[localNotif release];
		
		//[tem removeObjectForKey:td];
		//[tem writeToFile:path atomically:YES];
	}
 
}
*/

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
	
	NSLog(@"monitoring failed for region %@ with error %@",[region identifier],[error localizedDescription]);
	//NSString *err=[[NSString alloc] initWithFormat:@"monitoring failed for region %@ with error %@",[region identifier],[error localizedDescription]];
/*	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	
	NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
	
	NSString *dat=[[NSString alloc] initWithFormat:@"%@\nmonitoring failed for region %@ with error %@",aStr,[region identifier],[error localizedDescription]];
	[dat writeToFile:path atomically:YES];
*/	
}

#pragma mark -
#pragma mark Submit Log

/*

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	NSLog(@"object failed with error");
	UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sending Log Data to Sid failed. Will try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[al show];
	[al release];
	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	NSString *dat;
	NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
	dat=[[NSString alloc] initWithFormat:@"%@\nError in Sending data to Sid at %@",aStr,[[NSDate date] description]];
	
	[dat writeToFile:path atomically:YES];

	
	
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSLog(@"connection finished loading");
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release]; 
/*	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	NSString *dat;
	NSString* aStr = [[NSString alloc] initWithContentsOfFile:path];
	
	NSLog(@"Response: %@",responseString);	//NSLog(@"response:%@",responseString);
	if([responseString isEqualToString:@"Success"])
	dat=[[NSString alloc] initWithFormat:@"%@\nSent data to Sid successfuly at %@",aStr,[[NSDate date] description]];
	else 
	dat=[[NSString alloc] initWithFormat:@"%@\nError in Sending data to Sid at %@",aStr,[[NSDate date] description]];
		
	[dat writeToFile:path atomically:YES];

		
	
	
}

*/

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	viewController=nil;
	window=nil;
	mymann=nil;
	
}


- (void)dealloc {
    [viewController release];
    [window release];
	[mymann release];
    [super dealloc];
}


@end
