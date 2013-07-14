//
//  Home Page.m
//  ToDo
//
//  Created by Siddharth Chaubal on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Home Page.h"
#import <QuartzCore/QuartzCore.h>
#import "disclosureview.h"
@implementation AddressAnnotationH

@synthesize coordinate;

- (NSString *)subtitle{
		return mSubTitle;
}
- (NSString *)title{
	return mTitle; 
}
					
- (void)settitle:(NSString*)thetitle{
	mTitle=thetitle;
}
- (void)setsubtitle:(NSString*)thesubtitle{
	
	mSubTitle=thesubtitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	mTitle=@"";
	NSLog(@"AddressAnnotation %f,%f",c.latitude,c.longitude);
	return self;
}

@end

@implementation Home_Page

@synthesize myappdelegate,mylocman,mytool,tableview,td,xtd,mapview1,mapview,flipview,noteimage,noteview,notetext;

#pragma mark -
#pragma mark View lifecycle

int flipped=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	NSString *pathd=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];
	
	mapview1.hidden=YES;
	td=[[NSMutableDictionary alloc] initWithContentsOfFile:pathd];
	xtd=[[NSMutableDictionary alloc] initWithContentsOfFile:pathx];

	myappdelegate=(MemoAppDelegate*)[UIApplication sharedApplication].delegate ;
	mylocman=[myappdelegate LocManager];
	noteview.hidden=YES;
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(handleNotification:)
	 name:@"hometable"
	 object:nil];   

}



- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	
	NSMutableDictionary *plac=[[NSMutableDictionary alloc] initWithContentsOfFile:pathx];
	
	NSArray *loccc=[[plac valueForKey:@"location"] componentsSeparatedByString:@","];
	CLLocationCoordinate2D coords;
	coords.latitude=[[loccc objectAtIndex:0] doubleValue];
	coords.longitude=[[loccc objectAtIndex:1] doubleValue];
	
    MKPinAnnotationView *aView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
															   reuseIdentifier:@"currentloc"];
	if((annotation.coordinate.latitude ==coords.latitude)&&(annotation.coordinate.longitude ==coords.longitude))
	{aView.pinColor = MKPinAnnotationColorGreen;

	}
	else 
	aView.pinColor = MKPinAnnotationColorRed;


	aView.animatesDrop=TRUE;
	aView.canShowCallout = YES;
	aView.calloutOffset = CGPointMake(-5, 5);
	return aView;
}
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
	MKCircleView* circleView = [[[MKCircleView alloc] initWithOverlay:overlay] autorelease];
	circleView.strokeColor = [UIColor lightGrayColor];
	circleView.lineWidth = 1.0;
	//Uncomment below to fill in the circle
	circleView.fillColor = [UIColor lightTextColor];
	return circleView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for(int i=0;i<[[mapView annotations] count];i++)
	{id<MKAnnotation> myAnnotation = [mapView.annotations objectAtIndex:i];
		if([myAnnotation.title isEqualToString:@"Current Location"])
	[mapView selectAnnotation:myAnnotation animated:YES];
	}
	
}

-(IBAction) MapViewaction
{
	NSSet *myannotations=[mapview1 annotationsInMapRect:[mapview1 visibleMapRect]];
	[mapview1 removeAnnotations:[myannotations allObjects]];
	[mapview1 removeOverlays:[mapview1 overlays]];
	NSString *pathd=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSString *pathxx=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];

	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];

	NSMutableDictionary *mapdict=[[NSMutableDictionary alloc] initWithContentsOfFile:pathd];
	NSMutableDictionary *plac=[[NSMutableDictionary alloc] initWithContentsOfFile:pathx];
	NSMutableDictionary *xtds=[[NSMutableDictionary alloc] initWithContentsOfFile:pathxx];
	
		
		//Load the request in the UIWebView.
	
	UIViewAnimationTransition mytrans=UIViewAnimationTransitionFlipFromRight;
	if (flipped==0) {
		flipped=1;
		[mapview setTitle:@"Table View"];

		mytrans=UIViewAnimationTransitionFlipFromRight;
		[UIView beginAnimations:@"View Flip" context:nil];
		[UIView setAnimationDuration:1.00];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		
		[UIView setAnimationTransition:mytrans forView:self.flipview cache:YES];
		[UIView commitAnimations];
		tableview.hidden=YES;
		noteimage.hidden=YES;
		mytool.enabled=NO;
		
		MKCoordinateRegion theRegion;
		MKCoordinateSpan theSpan;
		theSpan.latitudeDelta = 0.015;
		theSpan.longitudeDelta = 0.015;
		CLLocationCoordinate2D coords;
		NSArray *loccc=[[plac valueForKey:@"location"] componentsSeparatedByString:@","];
		coords.latitude=[[loccc objectAtIndex:0] doubleValue];
		coords.longitude=[[loccc objectAtIndex:1] doubleValue];
		theRegion.center = coords;
		theRegion.span = theSpan;
		mapview1.scrollEnabled = YES; 
		mapview1.zoomEnabled = YES; 
		AddressAnnotationH *addAnnotation = [[AddressAnnotationH alloc] initWithCoordinate:coords];
		[addAnnotation settitle:@"Current Location"];
		[addAnnotation setsubtitle:[plac valueForKey:@"locationstr"]];
		
		[mapview1 addAnnotation: addAnnotation];
		//[mapview1 showsUserLocation];
		[mapview1 setRegion:theRegion];		
		
		mapview1.hidden=NO;
				for (int i=0; i<[mapdict count]; i++) {
			NSString *desc=[[mapdict allKeys] objectAtIndex:i];
			if(!([[[mapdict valueForKey:desc] objectAtIndex:1] isEqualToString:@"No Location"]))
			{	
				coords.latitude=[[[mapdict valueForKey:desc] objectAtIndex:4] doubleValue];
				coords.longitude=[[[mapdict valueForKey:desc] objectAtIndex:5] doubleValue];
				int rad=[[[mapdict valueForKey:desc] objectAtIndex:8] intValue];
				AddressAnnotationH *addAnnotation = [[AddressAnnotationH alloc] initWithCoordinate:coords];
				[addAnnotation settitle:desc];
				[addAnnotation setsubtitle:[[mapdict valueForKey:desc] objectAtIndex:2] ];
				MKCircle* circle = [MKCircle circleWithCenterCoordinate:coords radius:rad];
				[mapview1 addOverlay:circle];
				[mapview1 addAnnotation: addAnnotation];
			}}
					

	}
	else {
		flipped=0;
		[mapview setTitle:@"Map View"];
		mytrans=UIViewAnimationTransitionFlipFromLeft;
		
		[UIView beginAnimations:@"View Flip" context:nil];
		[UIView setAnimationDuration:1.00];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		
		[UIView setAnimationTransition:mytrans forView:self.flipview cache:YES];
		[UIView commitAnimations];
		mapview1.hidden=YES;
		noteimage.hidden=NO;
if([mapdict count]>0||[xtds count]>0)
	mytool.enabled=YES;
		tableview.hidden=NO;
	}
	
	
	
	
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSString *path=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];

	NSMutableDictionary *plac=[[NSMutableDictionary alloc] initWithContentsOfFile:pathx];
	NSMutableDictionary *xtds=[[NSMutableDictionary alloc] initWithContentsOfFile:path];
	NSArray *keys=[xtds allKeys];
	
	NSLog(@"in view will appear");
	mapview1.hidden=YES;
	tableview.hidden=NO;
	[tableview reloadData];

	
	//NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:1];

	
	if(![[plac valueForKey:@"justlaunched"] isEqualToString:@"0"])
	{
		int ind=-1;
		ind=[keys indexOfObject:[plac valueForKey:@"justlaunched"]];
		if(ind!=-1)
		{NSIndexPath *indexi=[NSIndexPath indexPathForRow:ind inSection:1];

		
		
		//[tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
		//[tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:indexi] withRowAnimation:UITableViewRowAnimationTop];
			//[[tableview cellForRowAtIndexPath:indexi] setBackgroundColor:[UIColor whiteColor]];
			UITableViewCell *cell=[tableview cellForRowAtIndexPath:indexi];
			if(![[[xtds valueForKey:[plac valueForKey:@"justlaunched"]] objectAtIndex:7] isEqualToString:@""])
				cell.detailTextLabel.text=[[xtds valueForKey:[plac valueForKey:@"justlaunched"]] objectAtIndex:7];
			cell.detailTextLabel.textColor=[UIColor blackColor];
		[cell setBackgroundColor:[UIColor yellowColor]];
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		}

	
	}

	[plac setObject:@"0" forKey:@"justlaunched"];
	[plac writeToFile:pathx atomically:YES];


}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSString *pathd=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];

	td=[NSMutableDictionary dictionaryWithContentsOfFile:pathd];
	xtd=[NSMutableDictionary dictionaryWithContentsOfFile:pathx];

	if(section==0)
	{int sec=[td count];
	if(sec==0)
		sec=1;
	
	
	return sec;
	}
	
	else {
		int sec=[xtd count];
		if(sec==0)
			sec=1;
		
		
		return sec;
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *pathd=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];
	td=[NSMutableDictionary dictionaryWithContentsOfFile:pathd];
	xtd=[NSMutableDictionary dictionaryWithContentsOfFile:pathx];
    static NSString *CellIdentifier = @"Cell";
	//td=[NSMutableDictionary dictionaryWithContentsOfFile:pathd];

	NSArray *easy=[td allKeys];
	
	NSUInteger row = [indexPath row];
	//NSUInteger section = [indexPath section]; 
	
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    //}
    
	
	//section 1
	if([indexPath section]==0)
	{
	
	//No Active Todos
	if([td count]==0)
	{
	mytool.enabled=NO;
	cell.textLabel.text=@"No Active ToDos";
	cell.detailTextLabel.text=@"Add new Todos";
	cell.accessoryType = UITableViewCellAccessoryNone;
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	}
	else
	{	mytool.enabled=YES;
		NSLog(@"probloem is heere");
		cell.textLabel.text=[easy objectAtIndex:row];
		if([[[td valueForKey:cell.textLabel.text] objectAtIndex:1] isEqualToString:@"No Location"])
			cell.detailTextLabel.text=[[ [td valueForKey:cell.textLabel.text] objectAtIndex:3] description];
		else 
			cell.detailTextLabel.text=[[td valueForKey:cell.textLabel.text] objectAtIndex:2];
		
		
		NSLog(@"%@",[[td valueForKey:cell.textLabel.text] objectAtIndex:0]);
		if(!([[[td valueForKey:cell.textLabel.text] objectAtIndex:0] isEqualToString:@""]))
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		if([[[td valueForKey:cell.textLabel.text] objectAtIndex:7] isEqualToString:@""])
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];


	}
   		[cell setBackgroundColor:[UIColor clearColor]];

	}
	
	
	//section 2
	else 
	{    //No Inactive Todos
		
		if([xtd count]==0)
			
		{
			cell.textLabel.text=@"No Inactive ToDo";
			cell.detailTextLabel.text=@"Deleting active ToDos will put them here";
			cell.accessoryType = UITableViewCellAccessoryNone;
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

		}
		else
		{	NSArray *easyx=[xtd allKeys];
			mytool.enabled=YES;
			cell.textLabel.text=[easyx objectAtIndex:row];
			if([[[xtd valueForKey:cell.textLabel.text] objectAtIndex:1] isEqualToString:@"No Location"])
			cell.detailTextLabel.text=[[ [xtd valueForKey:cell.textLabel.text] objectAtIndex:3] description];
			else 
				cell.detailTextLabel.text=[[xtd valueForKey:cell.textLabel.text] objectAtIndex:2];

			cell.textLabel.textColor=[UIColor grayColor];
			NSLog(@"%@",[[xtd valueForKey:cell.textLabel.text] objectAtIndex:0]);
			if(!([[[xtd valueForKey:cell.textLabel.text] objectAtIndex:0] isEqualToString:@""]))
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			CGRect nameLabelRect = CGRectMake(2, 10, 25, 25);
			UIButton *reactivate =[UIButton buttonWithType:UIButtonTypeCustom];
			[reactivate setImage:[UIImage imageNamed:@"lightbulb.png"] forState:UIControlStateNormal];
			reactivate.frame=nameLabelRect;
			[reactivate setTag:indexPath.row];
			[reactivate addTarget:self action:@selector(Reactivate_todo:) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:reactivate];
			if([[[xtd valueForKey:cell.textLabel.text] objectAtIndex:7] isEqualToString:@""])
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
		}
		[cell setBackgroundColor:[UIColor clearColor]];
	}
	
	
		
	//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[cell setFont:[UIFont fontWithName:@"Calibri" size:10]];
	return cell;
}

-(IBAction) Reactivate_todo:(id) sender {

	UIButton *sentby=(UIButton*)sender;
	
	NSLog(@"sent by %d",[sentby tag]);
	NSString *pathd=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];
	td=[NSMutableDictionary dictionaryWithContentsOfFile:pathd];
	xtd=[NSMutableDictionary dictionaryWithContentsOfFile:pathx];
	
	NSArray *xtdkeys=[xtd allKeys];
	NSArray *currtd=[NSArray arrayWithArray:[xtd valueForKey:[xtdkeys objectAtIndex:[sentby tag]]]];
	[td setObject:currtd forKey:[xtdkeys objectAtIndex:[sentby tag]]];
	[td writeToFile:pathd atomically:YES];
	
	[xtd removeObjectForKey:[xtdkeys objectAtIndex:[sentby tag]]];
	[xtd writeToFile:pathx atomically:YES];
	
	if(!([[currtd objectAtIndex:1] isEqualToString:@"No Location"]))
	{CLLocationCoordinate2D co;
	co.latitude=[[currtd objectAtIndex:4] doubleValue];
	co.longitude=[[currtd objectAtIndex:5] doubleValue];
	NSString *how=[currtd objectAtIndex:6];
	int rad=310;
	if([how isEqualToString:@"car"])
		rad=500;
	CLRegion *addingreg=[[CLRegion alloc] initCircularRegionWithCenter:co radius:rad identifier:[xtdkeys objectAtIndex:[sentby tag]] ];
	[mylocman startMonitoringForRegion:addingreg desiredAccuracy:2];
	
	if([how isEqualToString:@"Foot"])
		[mylocman startUpdatingLocation];
	}
		
	[tableview reloadData];
	
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	if(section==0)
		return @"Active";
	
	else 
		return @"Inactive";
}


-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {


	if(section==1)
		return @"Press the BULB to Re-Activate an Inactive Todo";
	else 
	    return @"Press Edit to shift ACTIVE Todos into InActive or DELETE any unused InActive ToDos";

}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {

	if(indexPath.section==1)
	return 2;
	else 
		return 0;

}
-(void)handleNotification:(NSNotification *)pNotification
{

	UIView *recobj=(UIView*)[pNotification object];
	CATransition *transition2 = [CATransition animation];
	
	// Animate over 3/4 of a second
	transition2.duration=0.50;
	// using the ease in/out timing function
	transition2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	
	
	transition2.type=kCATransitionReveal;
	transition2.subtype=kCATransitionFromLeft;
	
	transition2.delegate=self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[self.view.layer addAnimation:transition2 forKey:nil];
	[recobj removeFromSuperview];
	

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	

	NSString *pathd=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];

	//NSString *pathc=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];

	td=[NSMutableDictionary dictionaryWithContentsOfFile:pathd];
	xtd=[NSMutableDictionary dictionaryWithContentsOfFile:pathx];
	NSURL *myURL;
	NSArray *arr;
	disclosureview *mydis;
	//NSDictionary *dc=[[NSDictionary alloc] initWithContentsOfFile:pathc];
	
	if(indexPath.section==0) {
	arr=[td allKeys];
	myURL = [NSURL URLWithString:[[td objectForKey:[arr objectAtIndex:indexPath.row] ] objectAtIndex:0]];
	
	mydis=[[disclosureview alloc] initWithNibName:@"disclosureview" bundle:nil];
		}
	
	else {
		
		arr=[xtd allKeys];
		myURL = [NSURL URLWithString:[[xtd objectForKey:[arr objectAtIndex:indexPath.row] ] objectAtIndex:0]];
		
		mydis=[[disclosureview alloc] initWithNibName:@"disclosureview" bundle:nil];
		
	}
	CATransition *transition2 = [CATransition animation];
	
	// Animate over 3/4 of a second
	transition2.duration=0.50;
	// using the ease in/out timing function
	transition2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	
	
	transition2.type=kCATransitionPush;
	transition2.subtype=kCATransitionFromRight;
	
	transition2.delegate=self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[mydis.view.layer addAnimation:transition2 forKey:nil];
	
	[self.view addSubview:mydis.view];
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"disclosure"
	 object:myURL];
	
}																																																						


- (IBAction) EditTable:(id)sender

{
	
	
    if(self.editing)
		
    {
		
		[super setEditing:NO animated:NO];
		
		[self.tableview setEditing:NO animated:NO];
		
		[tableview reloadData];
		
        [mytool setTitle:@"Edit"];
		
        [mytool setStyle:UIBarButtonItemStyleBordered];
		
    }
	
    else
		
    {
		
		[super setEditing:YES animated:YES];
		
		[self.tableview setEditing:YES animated:YES];
		
	//	[tableview reloadData];
		
        [mytool setTitle:@"Done"];
		
        [mytool setStyle:UIBarButtonItemStyleDone];
		
    }
	
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		NSString *pathd=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
		NSString *pathx=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];
		
		td=[NSMutableDictionary dictionaryWithContentsOfFile:pathd];
		xtd=[NSMutableDictionary dictionaryWithContentsOfFile:pathx];
	
		
		if(indexPath.section==1)
        {NSLog(@"about to get keys");
			NSArray *tarr=[xtd allKeys];	

		if([xtd count]!=0)
		{
						[xtd removeObjectForKey:[tarr objectAtIndex:indexPath.row]];
		[xtd writeToFile:pathx atomically:YES];
			/*if(indexPath.row!=0)
			{[tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];}
			*/
			if([td count]!=0)
				[tableview reloadData];
		}
		}   
	
	else if(indexPath.section==0)
	{int i=-1;
		NSLog(@"in delete active todos");
		NSArray *tarr=[td allKeys];	
		xtd=[NSMutableDictionary dictionaryWithContentsOfFile:pathx];
		if(!([[[td valueForKey:[tarr objectAtIndex:indexPath.row]] objectAtIndex:1] isEqualToString:@"No Location"]))
		{
			
			NSSet *rset=[mylocman monitoredRegions];			
			NSArray *rarr=[rset allObjects];
			
			//NSLog(@"RARR COUNT %d",[rarr count]);
			//NSLog(@"key 0: %@",[tarr objectAtIndex:indexPath.row]);
			if([rarr count]!=0)
			{	CLRegion *delreg;
				for(i=0;i<[rarr count];i++)
				{
				  if([[[rarr objectAtIndex:i] identifier] isEqualToString:[tarr objectAtIndex:indexPath.row]])
				  { delreg=[rarr objectAtIndex:i];
					  break;
				  }
				}
					
				[mylocman stopMonitoringForRegion:delreg];
			
			}
			
		}
		/*if([td count]!=0)
		{[tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		}
		 */
		i=indexPath.row;
		if(i!=-1) {
		[xtd setObject:[td valueForKey:[tarr objectAtIndex:i]] forKey:[tarr objectAtIndex:i]];
		[xtd writeToFile:pathx atomically:YES];
		[td removeObjectForKey:[tarr objectAtIndex:i]];

		[td writeToFile:pathd atomically:YES];
		}
		if([td count]!=0)
		[tableview reloadData];
	}
	}
	
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
	
	if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
		
	else 
		return UITableViewCellEditingStyleDelete;
		
    
	
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	CATransition *transition = [CATransition animation];
	
	// Animate over 3/4 of a second
	transition.duration=0.40;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	
	
	transition.type=kCATransitionFade;
	transition.subtype=kCATransitionFromLeft;
	transition.delegate=self;
	
	NSString *pathd=[NSString stringWithFormat:@"%@/Documents/todos.plist",NSHomeDirectory()];
	NSString *pathx=[NSString stringWithFormat:@"%@/Documents/xtodos.plist",NSHomeDirectory()];
	
	td=[NSMutableDictionary dictionaryWithContentsOfFile:pathd];
	xtd=[NSMutableDictionary dictionaryWithContentsOfFile:pathx];
	
	if(indexPath.section==0)
	{
		if([td count]>0&&(![[[td valueForKey:[[td allKeys] objectAtIndex:indexPath.row]] objectAtIndex:7] isEqualToString:@""]))
		{ 
			[noteview.layer addAnimation:transition forKey:nil];
			noteview.hidden=NO;
		notetext.text=[[td valueForKey:[[td allKeys] objectAtIndex:indexPath.row]] objectAtIndex:7];
		}
	}
	else 
	{
		if([xtd count]>0&&(![[[xtd valueForKey:[[xtd allKeys] objectAtIndex:indexPath.row]] objectAtIndex:7] isEqualToString:@""]))
		{			[noteview.layer addAnimation:transition forKey:nil];
			noteview.hidden=NO;
			notetext.text=[[xtd valueForKey:[[xtd allKeys] objectAtIndex:indexPath.row]] objectAtIndex:7];
		}
	}

}

-(IBAction) closenote {

	CATransition *transition = [CATransition animation];
	
	// Animate over 3/4 of a second
	transition.duration=0.35;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	
	
	transition.type=kCATransitionFade;
	transition.subtype=kCATransitionFromLeft;
	transition.delegate=self;
	[noteview.layer addAnimation:transition forKey:nil];
	noteview.hidden=YES;

}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	mylocman=nil;
	myappdelegate=nil;
	td=nil;
}


- (void)dealloc {
    [super dealloc];
	[mylocman release];
	[myappdelegate release];
	[td release];
}


@end

