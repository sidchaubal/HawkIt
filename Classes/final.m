//
//  final.m
//  Memo
//
//  Created by Siddharth Chaubal on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "final.h"
#import <MapKit/MKAnnotation.h>
@implementation AddressAnnotation

@synthesize coordinate;

- (NSString *)title{
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *plac=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	return [plac valueForKey:@"todo"];
}
- (NSString *)subtitle{
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *plac=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	NSString *select=[plac valueForKey:@"selection"];
	if([select isEqualToString:@"-1"])
	{
	return @"Tagged Location";
	}
	else
	{ 
		NSDictionary *tem=[[plac valueForKey:@"place"] objectAtIndex:[select intValue]];
		NSString *add=[NSString stringWithFormat:@"%@ %@",[[tem valueForKey:@"addressLines"] objectAtIndex:0],[[tem valueForKey:@"addressLines"] objectAtIndex:1]];
	return add;
	}
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"AddressAnnotation %f,%f",c.latitude,c.longitude);
	return self;
}

@end

@implementation final

@synthesize todo,mydel,sliderlabel;
@synthesize picker,segcontrol,done,mywebmap,notes;
NSMutableArray *pl;
NSString *slidervalue;
NSDate *selected;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    id<MKAnnotation> myAnnotation = [mapView.annotations objectAtIndex:0];
			[mapView selectAnnotation:myAnnotation animated:YES];
	
	
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	
    MKPinAnnotationView *aView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
															   reuseIdentifier:@"currentloc"];
	aView.pinColor = MKPinAnnotationColorGreen;
	aView.animatesDrop=TRUE;
	aView.canShowCallout = YES;
	aView.calloutOffset = CGPointMake(-5, 5);
	return aView;
}

-(IBAction)canceltodo {

	NSArray *t2=[[NSArray alloc] initWithObjects:@"CancelF",[self view],nil];
	
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"hi"
	 object:t2];
	
	

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"in final view");
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *plac=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	NSString *select=[plac valueForKey:@"selection"];
	mywebmap.hidden=YES;
	selected=[NSDate date];
	if([select isEqualToString:@"-1"])
	{   
		NSArray *locc=[[plac valueForKey:@"location"] componentsSeparatedByString:@","];
		NSLog(@"coordinates:%@,%@",[locc objectAtIndex:0],[locc objectAtIndex:1]);
		pl=[[NSMutableArray alloc] initWithObjects:@"",@"Tagged Location",[plac valueForKey:@"locationstr"],selected,[locc objectAtIndex:0],[locc objectAtIndex:1],@"car",@"",@"",nil];
		picker.hidden=YES;
		MKCoordinateRegion theRegion;
		MKCoordinateSpan theSpan;
		theSpan.latitudeDelta = 0.005;
		theSpan.longitudeDelta = 0.005;
		CLLocationCoordinate2D coords;
		coords.latitude=[[locc objectAtIndex:0] doubleValue];
		coords.longitude=[[locc objectAtIndex:1] doubleValue];
		theRegion.center = coords;
		theRegion.span = theSpan;
		
		AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:coords];
		[mywebmap addAnnotation: addAnnotation];
		[mywebmap showsUserLocation];
		mywebmap.scrollEnabled = NO; 
		mywebmap.zoomEnabled = NO; 
		
		[mywebmap setRegion:theRegion];		
		
		mywebmap.hidden=NO;
		

	}	
	else if([select isEqualToString:@"-2"])
	{
		pl=[[NSMutableArray alloc] initWithObjects:@"",@"No Location",@"",selected,@"",@"",@"",@"",@"",nil];
		picker.hidden=NO;
        segcontrol.enabled=NO;
		segcontrol.hidden=YES;
		done.enabled=NO;
		remindlabel.text=@"Set Alarm:";
		remindlabel.frame=CGRectMake(5,230,127,21); 
		remindlabel.font = [UIFont fontWithName:@"Zapfino" size: 14.0];

		sliderlabel.hidden=YES;
		theslider.hidden=YES;
		themthing.hidden=YES;
	}
	
	
	else {
		NSLog(@"about to get tem");
		
		NSDictionary *tem=[[plac valueForKey:@"place"] objectAtIndex:[select intValue]];
	pl=[[NSMutableArray alloc] initWithObjects:[tem valueForKey:@"url"],[tem valueForKey:@"titleNoFormatting"],[tem valueForKey:@"streetAddress"],selected,[tem valueForKey:@"lat"],[tem valueForKey:@"lng"],@"car",@"",@"",nil];
		picker.hidden=YES;
		NSLog(@"we have reached here");
		MKCoordinateRegion theRegion;
		MKCoordinateSpan theSpan;
		theSpan.latitudeDelta = 0.005;
		theSpan.longitudeDelta = 0.005;
		CLLocationCoordinate2D coords;
		coords.latitude=[[tem valueForKey:@"lat"] doubleValue];
		coords.longitude=[[tem valueForKey:@"lng"] doubleValue];
		theRegion.center = coords;
		theRegion.span = theSpan;

		AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:coords];
		[mywebmap addAnnotation: addAnnotation];
		[mywebmap viewForAnnotation:addAnnotation];
		mywebmap.scrollEnabled = NO; 
		mywebmap.zoomEnabled = NO; 
		
		[mywebmap setRegion:theRegion];		
		
		mywebmap.hidden=NO;
	}
	
	
	
	sliderlabel.text=@"310";
//	[NSTimeZone setDefaultTimeZone:[NSTimeZone localTimeZone]];
	NSDate *now = [NSDate date];
	[pl retain];
	selected=now;
	[picker setDate:now animated:YES];	//[myman startUpdatingLocation];
	if(selected!=nil)
	NSLog(@"picker date is %@",[selected description]);
}

-(IBAction)displayDate:(id)sender {
	[picker setTimeZone:[NSTimeZone systemTimeZone]];
	
	selected = [picker date];

	NSLog(@"new picker date: %@",[selected description]);
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *plac=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	[plac setValue:selected forKey:@"alarm"];
	[plac writeToFile:path atomically:YES];
	done.enabled=YES;

}


-(IBAction)slidervaluechanged:(id)sender
{
    NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *plac=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	UISlider *slider = (UISlider *)sender; 
	int progressAsInt = (int)(slider.value + 0.5f);
	slidervalue= [[NSString alloc] initWithFormat:@"%d", progressAsInt];
	sliderlabel.text = slidervalue;
	[plac setValue:slidervalue forKey:@"radius"];
	[plac writeToFile:path atomically:YES];
	
	
	//NSLog(@"new value of slider is %@",slidervalue);
}
-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	
	[theTextField resignFirstResponder];
	
	return YES;
	
}


-(void) donepressed:(id)sender {
	NSLog(@"todo is %@",todo.text);

	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	UIApplication *application=[UIApplication sharedApplication];
	NSString *pathplace=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *plac=[NSMutableDictionary dictionaryWithContentsOfFile:pathplace];
	
	NSString *path=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSMutableDictionary *tem=[[NSMutableDictionary alloc] initWithContentsOfFile:path];

	if(!([notes.text isEqualToString:@"Insert Notes Here"]||[notes.text isEqualToString:@""]))
	{
		[pl replaceObjectAtIndex:7 withObject:notes.text];
	}	
	if([[plac valueForKey:@"selection"] isEqualToString:@"-2"])
	{
		[pl replaceObjectAtIndex:3 withObject:[plac valueForKey:@"alarm"]];
		
				
	if(localNotif) {
		
		NSString *alert;
		if(!([notes.text isEqualToString:@"Insert Notes Here"]||[notes.text isEqualToString:@""]))
		alert=[NSString stringWithFormat:NSLocalizedString(@"%@ \n Notes:%@", nil),
				   todo.text,notes.text];
		else 
		alert=[NSString stringWithFormat:NSLocalizedString(@"%@", nil),
						 todo.text];
		localNotif.alertBody = alert;
		localNotif.alertAction = NSLocalizedString(@"Thanks!", nil);
		localNotif.timeZone=[NSTimeZone localTimeZone];
		localNotif.fireDate=selected;
		
		localNotif.soundName = @"sub.caf";
		localNotif.applicationIconBadgeNumber = [application applicationIconBadgeNumber]+1;
		
		NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",todo.text],@"ToDoItemKey",@"type",@"alarm",@"notes",notes.text,nil];
		localNotif.userInfo = infoDict;
		[application scheduleLocalNotification:localNotif];
		
		localNotif.fireDate=[selected dateByAddingTimeInterval:360];
		[application scheduleLocalNotification:localNotif];

		localNotif.fireDate=[selected dateByAddingTimeInterval:600];
		[application scheduleLocalNotification:localNotif];

		//[application scheduleLocalNotification:localNotif];
		[localNotif release];
		
		//[tem removeObjectForKey:td];
		//[tem writeToFile:path atomically:YES];
	}
		[tem setValue:pl forKey:todo.text];
		[tem writeToFile:path atomically:YES];
		
		
		NSArray *t=[[NSArray alloc] initWithObjects:@"Done_Alarm",[self view],nil];
		UIAlertView *myalert=[[UIAlertView alloc] initWithTitle:@"Saved!" message:@"ToDo saved! Now Relaxx..." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[myalert show];
		[myalert release];
		
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"hi"
	 object:t];
	
	}
	else {
		[pl replaceObjectAtIndex:8 withObject:sliderlabel.text];
		[tem setValue:pl forKey:todo.text];
		[tem writeToFile:path atomically:YES];

		NSArray *t2=[[NSArray alloc] initWithObjects:@"Done",[self view],nil];
		UIAlertView *myalert=[[UIAlertView alloc] initWithTitle:@"Saved!" message:@"ToDo saved! Now Relaxx..." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[myalert show];
		[myalert release];
		
		[[NSNotificationCenter defaultCenter] 
		 postNotificationName:@"hi"
		 object:t2];
		
		
	}

	
	}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(IBAction) segcontrolvaluechanged:(id)sender {

	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *plac=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	NSString *selectedtype=[segcontrol titleForSegmentAtIndex: [segcontrol selectedSegmentIndex]];
	NSLog(@"Selected:%@",selectedtype);
	if ([selectedtype isEqualToString:@"Foot"]) {
		//picker.hidden=NO;
		UIAlertView *footalert=[[UIAlertView alloc] initWithTitle:@"By Foot" message:@"WARNING: Tracking you on foot requires a lot of battery power. Your GPS Radio will run for the entire time till u reach this location. If your battery is getting low we suggest you delete this Todo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[footalert show];
		[footalert release];
		
		[plac setValue:@"Foot" forKey:@"type"];
		[pl replaceObjectAtIndex:6 withObject:@"Foot"];
		[plac writeToFile:path atomically:YES];
	}
	


}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	todo=nil;
	}


- (void)dealloc {
    [super dealloc];
	[todo release];
	
}


@end
