//
//  MemoViewController.m
//  Memo
//
//  Created by Siddharth Chaubal on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemoViewController.h"
#import "MemoAppDelegate.h"
@implementation MemoViewController

@synthesize todo,locationManager,startingPoint,mytaby,texty;
@synthesize arrowpull,mytable,mysearchbar;
NSString *desilocation;
NSString *latlng;
NSString *locationstr;
CLLocationCoordinate2D coord;
UITextField *textfieldName;
int flag;
int flagv;
int ftl;
NSMutableArray *buttons;
NSMutableArray *layers;
NSMutableArray *xbuttons;
UIScrollView *chview;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//NSString *path=@"/Users/Sid/Documents/Memo/places.plist";
	//Next create the dictionary from the contents of the file.
	//NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
	NSString *path=[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
	NSArray *temp=[[NSArray alloc] initWithObjects:@"",nil];
	NSDate *d=[NSDate date];
	NSMutableDictionary *locations=[[NSMutableDictionary alloc] init];
	NSArray *oknow=[[NSArray alloc] init];
	[locations setValue:oknow forKey:@"new"];
	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"",@"location",temp,@"place",@"",@"query",@"",@"selection",@"",@"todo",d,@"alarm",@"310",@"radius",@"car",@"type",@"",@"locationstr",locations,@"locations",@"0",@"justlaunched",nil];
	flag=4;
	buttons=[[NSMutableArray alloc] init ];
	xbuttons=[[NSMutableArray alloc] init ];

	layers=[[NSMutableArray alloc] init ];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *image=[UIImage imageNamed: @"location-arrow.png"];
	[button setBackgroundImage: [image stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	button.frame= CGRectMake(0.0, 5.0, image.size.width-7, image.size.height-7);
	
	[button addTarget:self action:@selector(ChangeLocation)    forControlEvents:UIControlEventTouchUpInside];
	
	UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height) ];
	
	[v addSubview:button];
    flagv=0;
	ftl=0;
	UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *image2=[UIImage imageNamed: @"kill.png"];
	[button2 setBackgroundImage: [image2 stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	button2.frame= CGRectMake(0.0, 0.0, image2.size.width, image2.size.height);
	
	[button2 addTarget:self action:@selector(Killpressed)    forControlEvents:UIControlEventTouchUpInside];
	
	UIView *v2=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image2.size.width, image2.size.height) ];
	
	[v2 addSubview:button2];
	
	UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithCustomView:v];
	UIBarButtonItem *forward2 = [[UIBarButtonItem alloc] initWithCustomView:v2];

	UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	NSArray *buts=[[NSArray alloc] initWithObjects:forward2,flexible,forward,nil];
	[mytaby setItems:buts animated:YES];
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@places.plist",path]];
	if(!fileExists)
		[dict writeToFile:[NSString stringWithFormat:@"%@places.plist",path] atomically:YES];
	else 
		dict=[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@places.plist",path]];

	self.locationManager = [[CLLocationManager alloc] init]; 
	locationManager.delegate = self; 
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;

	
	NSString *location=[dict valueForKey:@"location"];
	
	if([location isEqualToString:@""])
	{  
		UIAlertView *firsttimerun=[[UIAlertView alloc] initWithTitle:@"First Time Load" message:@"To add location based ToDos use 'from' in your ToDo string. 'from safeway' will search Safeways near your current locations. Choose desired location and save! \n You can also save ToDos with your current location. Use Tag Me! For non location based ToDos ignore 'from' in your string." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[firsttimerun show];
		[firsttimerun release];
		[[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"FirstLoadTime"];
		ftl=1;
	}
    [locationManager startUpdatingLocation];

    locationstr=[[NSString alloc] initWithString:[dict valueForKey:@"locationstr"]];
	texty.text=[NSString stringWithFormat:@"Currently at: %@",locationstr];	
	mysearchbar.delegate=self;
	mysearchbar.placeholder=[NSString stringWithFormat:@"Search Near %@",locationstr];
	

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [mysearchbar resignFirstResponder];

	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	//Next create the dictionary from the contents of the file.
	NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
	NSArray *emptyarr=[[NSArray alloc] initWithObjects:nil];
	[dict setValue:emptyarr forKey:@"place"];
	[dict writeToFile:path atomically:YES];
	NSString *loc=[dict valueForKey:@"location"];
	NSString *passed=mysearchbar.text;
	responseData = [[NSMutableData data] retain];
	NSString *URL3=[[NSString alloc] initWithFormat:@"https://ajax.googleapis.com/ajax/services/search/local?v=1.0&key=ABQIAAAAVe9Z8kNHjtexqa8vojF3iRTx65eoQoQWSwF1E81tC_cezCN52xQ5h6QMOvNvKsNm57sQ5pMK20_MGQ&sll=%@&q=%@&mrt=localonly",loc,passed];
	NSLog(@"URL2:%@",URL3);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL3] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	[[NSURLConnection alloc] initWithRequest:request delegate:self] ; 
	NSLog(@"request is initiated");
	
	
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[mysearchbar setShowsCancelButton:YES animated:YES];
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [mysearchbar resignFirstResponder];
	mysearchbar.showsCancelButton=NO;

}

-(IBAction)Killpressed {

	UIAlertView *nolocation=[[UIAlertView alloc] initWithTitle:@"Kill all ToDos" message:@"Are You Sure you want to delete ALL ToDos?" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[nolocation addButtonWithTitle:@"Yes"];
	[nolocation addButtonWithTitle:@"Cancel"];
	[nolocation show];
	
	
	

}

-(IBAction) taguserslocation:(id)sender {

	NSLog(@"Updating location");
	if(locationManager==nil)
	{NSLog(@"creating location manager");
		self.locationManager = [[CLLocationManager alloc] init]; 
		locationManager.delegate = self; 
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;}
	flag=1;
	[locationManager startUpdatingLocation];
	
	

}

-(IBAction) showlog
{
	NSArray *t=[[NSArray alloc] initWithObjects:@"logshow",@"",nil];
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"hi"
	 object:t];
}

-(void)doWiggle:(UIView *)touchView {
	
	// grabbing the layer of the tocuhed view.
	CALayer *touchedLayer = [touchView layer];
	
	NSLog(@"in do wiggle");
	// here is an example wiggle
	CABasicAnimation *wiggle = [CABasicAnimation animationWithKeyPath:@"transform"];
	wiggle.duration = 0.1;
	wiggle.repeatCount = 1e100f;
	wiggle.autoreverses = YES;
	wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(touchedLayer.transform,0.1, 0.0 ,1.0 ,2.0)];
	
	// doing the wiggle
	[touchedLayer addAnimation:wiggle forKey:@"wiggle"];
	[layers addObject:touchedLayer];
	// setting a timer to remove the layer
	//NSTimer *wiggleTimer = [NSTimer scheduledTimerWithTimeInterval:(2) target:self selector:@selector(endWiggle:) userInfo:touchedLayer repeats:NO];
}


-(IBAction)ChangeLocationM {

	if([layers count]!=0)
	{
		for (int i=0; i<[layers count]; i++) {
			CALayer *tlayer=[layers objectAtIndex:i];
			[tlayer removeAllAnimations];
			[[xbuttons objectAtIndex:i] removeFromSuperview];
			
		}
		[layers removeAllObjects];
	}
	CATransition *transition = [CATransition animation];
	
	// Animate over 3/4 of a second
	transition.duration=1.00;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	
	
	transition.type=kCATransitionPush;
	
	transition.delegate=self;
	
	
	[buttons removeAllObjects];
	
	if(flagv==0)
	{NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSDictionary *placesdic=[[NSDictionary alloc] initWithContentsOfFile:path];
	NSDictionary *locs=[placesdic valueForKey:@"locations"];
	NSArray *locskey=[locs allKeys];
		int scroll=[locs count];
		if(scroll<4) scroll=4;
		CGRect frame=CGRectMake(0,40, 80*scroll, 40);
		chview.contentSize=CGSizeMake(80*scroll, 40);
		//myscrollview.clipsToBounds=YES;
		chview.delegate=self;
		chview.showsVerticalScrollIndicator=NO;
		chview.showsHorizontalScrollIndicator=NO;
		
		chview=[[UIScrollView alloc] initWithFrame:frame];
		[chview setBackgroundColor:[UIColor lightTextColor]];
		
		UIButton *arrw=[UIButton buttonWithType:UIButtonTypeCustom];
		arrw.frame=CGRectMake(0, 15, 15, 15);
		[arrw setImage:[UIImage imageNamed:@"PullRightArrow.gif"] forState:UIControlStateNormal];
		[arrw addTarget:self action:@selector(ChangeLocationM) forControlEvents:UIControlEventTouchUpInside];
		[chview addSubview:arrw];
		
		for (int i=0; i<[locs count]; i++) {
		
		CGRect fr;
		if(i==0)
		fr=CGRectMake(40, 0, 30, 30);
		else 
			fr=CGRectMake(50*(i+1), 0, 30, 30);
		UIButton *locbut=[UIButton buttonWithType:UIButtonTypeCustom];
		locbut.frame=fr;
		locbut.tag=i;
		//UIImage *butimg=[UIImage imageNamed:@"mapper.jpeg"];
		//[butimg setBackgroundColor:[UIColor clearColor]];
		[locbut setImage:[UIImage imageNamed:@"53-house.png"] forState:UIControlStateNormal];
		[locbut setBackgroundColor:[UIColor clearColor]];
		[locbut addTarget:self action:@selector(ChangeLocationN:) forControlEvents:UIControlEventTouchUpInside];
		if(![[locskey objectAtIndex:i] isEqualToString:@"new"])
		[locbut addTarget:self action:@selector(wiggle) forControlEvents:UIControlEventTouchDownRepeat];
		[buttons addObject:locbut];
		[chview addSubview:locbut];
		
		if(i==0)
			fr=CGRectMake(40, 22, 60, 20);
		else 
			fr=CGRectMake(50*(i+1), 22, 60, 20);
		
		UILabel *locla=[[UILabel alloc] initWithFrame:fr];
		locla.text=[locskey objectAtIndex:i];
		[locla setFont:[UIFont fontWithName:@"calibri" size:1]];
		[locla setBackgroundColor:[UIColor clearColor]];
		locla.textColor=[UIColor blackColor];
		NSLog(@"label %@",locla.text);
		[chview addSubview:locla];
	}
		flagv=1;
		transition.subtype=kCATransitionFromRight;
		[chview.layer addAnimation:transition forKey:nil];

	[self.view addSubview:chview];
		arrowpull.hidden=YES;
		mysearchbar.hidden=YES;

	}
	else 
	{
		transition.subtype=kCATransitionFromLeft;
		[chview.layer addAnimation:transition forKey:nil];

	[chview removeFromSuperview];
		arrowpull.hidden=NO;
		mysearchbar.hidden=NO;

	flagv=0;}
}

-(IBAction)wiggle {
	

    [xbuttons removeAllObjects];
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSDictionary *placesdic=[[NSDictionary alloc] initWithContentsOfFile:path];
	NSDictionary *locs=[placesdic valueForKey:@"locations"];
	NSArray *locskey=[locs allKeys];
	for (int i=0; i<[locs count]; i++) {
		
		CGRect fr;
		if(i==0)
			fr=CGRectMake(30, 45, 13, 13);
		else 
			fr=CGRectMake(40*(i+1), 45, 13, 13);
		
		UIButton *cross=[UIButton buttonWithType:UIButtonTypeCustom];
		cross.frame=fr;
		[cross setImage:[UIImage imageNamed:@"black_cross.gif"] forState:UIControlStateNormal];
		[cross addTarget:self action:@selector(endwiggle:) forControlEvents:UIControlEventTouchUpInside];
		[cross setTag:i];
		cross.contentVerticalAlignment=UIControlContentVerticalAlignmentFill;
		cross.contentHorizontalAlignment=UIControlContentHorizontalAlignmentFill;
		if(![[locskey objectAtIndex:i] isEqualToString:@"new"])
		{[xbuttons addObject:cross];
		[self doWiggle:[buttons objectAtIndex:i]];
		[self.view addSubview:cross];
		}
	}	

}


-(IBAction) endwiggle:(id)sender {

	UIButton *sent=(UIButton*)sender;
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSDictionary *placesdic=[[NSDictionary alloc] initWithContentsOfFile:path];
	NSMutableDictionary *locs=[placesdic valueForKey:@"locations"];
	NSArray *locskeys=[locs allKeys];
	NSLog(@"deleted %d",[sent tag]);
	
	[locs removeObjectForKey:[locskeys objectAtIndex:[sent tag]]];
	[placesdic setValue:locs forKey:@"locations"];
	[placesdic writeToFile:path atomically:YES];
	
	for (int i=0; i<[layers count]; i++) {
		CALayer *tlayer=[layers objectAtIndex:i];
		[tlayer removeAllAnimations];
		[[xbuttons objectAtIndex:i] removeFromSuperview];
		
	}
	[layers removeAllObjects];
	
	
	[self ChangeLocationM];
	[self ChangeLocationM];

}


-(IBAction)ChangeLocationN:(id)sender {

	UIButton *sbutton=(UIButton*)sender;
	//NSLog(@"button tag is %d",[sbutton tag]);
	if([sbutton tag]==0&&[buttons count]==1)
	{[self ChangeLocation];
		flag=0;
	}
	else if([buttons count]>1&&[sbutton tag]==[buttons count]-1)
	{[self ChangeLocation];
		flag=0;
	}
		else {
		NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
		NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:path];
		NSDictionary *thelocdic=[dict valueForKey:@"locations"];
		NSArray *thekeys=[thelocdic allKeys];
		NSArray *thearr=[thelocdic valueForKey:[thekeys objectAtIndex:sbutton.tag]];
		[dict setValue:[thearr objectAtIndex:0] forKey:@"locationstr"];
		[dict setValue:[thearr objectAtIndex:1] forKey:@"location"];
		[dict writeToFile:path atomically:YES];
		locationstr=[thearr objectAtIndex:0];
		texty.text=[NSString stringWithFormat:@"Search Location: %@",locationstr];	
			//mysearchbar.placeholder=[NSString stringWithFormat:@"Search Near %@",locationstr];

	}

}

-(IBAction)ChangeLocation {

	NSLog(@"Updating location");
	if(locationManager==nil)
	{NSLog(@"creating location manager");
		self.locationManager = [[CLLocationManager alloc] init]; 
	locationManager.delegate = self; 
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;}
	if(flag!=0 && flag!=1)
	flag=3;

	[locationManager startUpdatingLocation];
	//[self ChangeLocationM];


}

-(IBAction)AnalyzePressed {
	

	desilocation=mysearchbar.text;
		NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
		//Next create the dictionary from the contents of the file.
		NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:path];
		[dict setValue:desilocation forKey:@"query"];
		//[dict setValue:todolocal forKey:@"todo"];
		//write changes back to file.
	[dict setValue:@"-2" forKey:@"selection"];
		[dict writeToFile:path atomically:YES];
	//write changes back to file.
	
	NSArray *t2=[[NSArray alloc] initWithObjects:@"Final",@"",nil];
	
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"hi"
	 object:t2];	
	
	
	
}




-(void)alertView:(UIAlertView *)myalert willDismissWithButtonIndex:(NSInteger)buttonIndex
{	NSLog(@"Alertview button index: %d",buttonIndex);
	
	
if([[myalert title] isEqualToString:@"Kill all ToDos"]) {
	
		if (buttonIndex==0) {
			NSLog(@"in kill all todos");
			NSArray *t=[[NSArray alloc] initWithObjects:@"Kill",@"",nil];
			[[NSNotificationCenter defaultCenter] 
			 postNotificationName:@"hi"
			 object:t];
			
		}
	}
	else if ((buttonIndex==0)&&([myalert.title isEqualToString:@"Please Enter"])) {
		
		
			NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
			NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:path];
			NSMutableDictionary *another=[dict valueForKey:@"locations"];
		NSArray *tempoknow=[[NSArray alloc] initWithObjects:[dict valueForKey:@"locationstr"],[dict valueForKey:@"location"],nil];
			[another setValue:tempoknow forKey:textfieldName.text];
			[dict setValue:another forKey:@"locations"];
			[dict writeToFile:path atomically:YES];
		
		}
	else if([[myalert title] isEqualToString:@"Your Location"]) {
	if(buttonIndex==0)
	{
		
		NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
		//Next create the dictionary from the contents of the file.
		NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:path];
		[dict setValue:latlng  forKey:@"location"];
		[dict setValue:locationstr forKey:@"locationstr"];
		//write changes back to file.
	   [dict writeToFile:path atomically:YES];
		
		if(ftl!=1)
		{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter" message:@"" delegate:self cancelButtonTitle:nil  otherButtonTitles:nil];
		[alert addButtonWithTitle:@"Submit"];
		[alert addButtonWithTitle:@"Cancel"];
 		//	[alert addButtonWithTitle:@"Same"];
		[alert addTextFieldWithValue:@"" label:@"Location NickName"];
		textfieldName = [alert textFieldAtIndex:0];
		textfieldName.keyboardType = UIKeyboardTypeAlphabet;
		textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
		textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
		[alert show];
		}
		else 
			ftl=0;
		
	}
	if(buttonIndex==1)
	{
		
	}
	}
	else if([[myalert title] isEqualToString:@"Tagged Location"]) {
		if(buttonIndex==0)
		{

		NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
		//Next create the dictionary from the contents of the file.
		NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:path];
		[dict setValue:latlng  forKey:@"location"];
		[dict setValue:locationstr forKey:@"locationstr"];
		[dict setValue:@"-1" forKey:@"selection"];
		[dict setValue:todo.text forKey:@"todo"];
		[dict writeToFile:path atomically:YES];
		NSArray *t2=[[NSArray alloc] initWithObjects:@"Final",@"",nil];
		
		[[NSNotificationCenter defaultCenter] 
		 postNotificationName:@"hi"
		 object:t2];
		}
		if(buttonIndex==1)
		{
					}
	}
	}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark - #pragma mark CLLocationManagerDelegate Methods 
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation {
	
	[locationManager stopUpdatingLocation];
	if (startingPoint == nil) self.startingPoint = newLocation;
	NSString *latitudeString = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
		
	NSString *longitudeString = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
	
	
	coord.latitude = newLocation.coordinate.latitude;  
	coord.longitude = newLocation.coordinate.longitude;
	
			   
	latlng=[[NSString alloc] initWithFormat:@"%@,%@",latitudeString,longitudeString];
	NSLog(@"new location is %@ %@",latitudeString,longitudeString);
	NSLog(@"starting reverse geocoding");
	MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coord];
	[geocoder setDelegate:self];
	[geocoder start];
			   
	
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	
	NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Location." message:errorType delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
	[alert show]; 
	[alert release];
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	NSLog(@"Geocoding failed with error %@",error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Location" message:@"Try Again. If problem persists restart Application/Location Services." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
	[alert show]; 
	[alert release];
}
		
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	NSString *st=[[NSString alloc] initWithFormat:@"We have obtained your location as %@ %@ %@",[placemark subThoroughfare],[placemark thoroughfare],[placemark locality]];
	locationstr=[NSString stringWithFormat:@"%@ %@ %@",[placemark subThoroughfare],[placemark thoroughfare],[placemark locality]];
	texty.text=[NSString stringWithFormat:@"Search Location: %@",locationstr];
	[locationstr retain];
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSDictionary *dic=[[NSDictionary alloc] initWithContentsOfFile:path];

	UIAlertView *locationalert;///=[[UIAlertView alloc] initWithTitle:@"Your Location" message:st delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	if((flag==3)||([[dic valueForKey:@"locationstr"] isEqualToString:@""]))
	{				[dic setValue:locationstr forKey:@"locationstr"];
		[dic setValue:[NSString stringWithFormat:@"%g,%g",coord.latitude,coord.longitude] forKey:@"location"];
		[dic writeToFile:path atomically:YES];
		texty.text=[NSString stringWithFormat:@"Search Location: %@",locationstr];
		mysearchbar.placeholder=[NSString stringWithFormat:@"Search Near: %@",locationstr];
	}
	else if(flag==0)
	{locationalert=[[UIAlertView alloc] initWithTitle:@"Your Location" message:st delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		[locationalert addButtonWithTitle:@"Save this"];
		[locationalert addButtonWithTitle:@"Cancel"];
		[locationalert show];
	}
	else if(flag==1)
	{	locationalert=[[UIAlertView alloc] initWithTitle:@"Tagged Location" message:st delegate:self cancelButtonTitle:nil otherButtonTitles:nil];

		[locationalert addButtonWithTitle:@"Use this"];
		[locationalert addButtonWithTitle:@"Cancel"];
		[locationalert show];
	}
	
	//NSLog(@"The geocoder has returned: %@", [placemark addressDictionary]);
}
		
		
#pragma mark - 
#pragma mark Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section { 
	
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSDictionary *tem=[NSDictionary dictionaryWithContentsOfFile:path];
	int retvalue=[[tem valueForKey:@"place"] count];
	if(retvalue==0)
		return 1;
	else 
		return retvalue;
	
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSDictionary *tem=[NSDictionary dictionaryWithContentsOfFile:path];
	NSArray *place=[tem valueForKey:@"place"];
	
	NSUInteger row = [indexPath row];
	//NSUInteger section = [indexPath section]; 
	
	
	static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SectionsTableIdentifier];
	
	if (cell == nil) { 
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SectionsTableIdentifier] autorelease];
	}
	
	if(ftl==1)
	{	cell.textLabel.text=@"";
	cell.detailTextLabel.text=@"";
		ftl=0;}
	else if([place count]==0)
	{
		if(flag==1)
			cell.textLabel.text=[NSString stringWithFormat:@"No %@ Found Near You.",[tem valueForKey:@"query"]];
		else 
			cell.textLabel.text=[NSString stringWithFormat:@"Getting %@ Near You.....",[tem valueForKey:@"query"]];
		
	}
	else {
		cell.textLabel.text=[[place objectAtIndex:row] valueForKey:@"titleNoFormatting"];
		cell.detailTextLabel.text=[[place objectAtIndex:row] valueForKey:@"streetAddress"];
	}
	
	
	cell.textLabel.font=[UIFont fontWithName:@"Georgia-Bold" size:14];
	
	
	return cell;
	
	
	
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *tem=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	return [NSString stringWithFormat:@"Near %@",[tem valueForKey:@"locationstr"]];
	
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	//NSString *key = [keys objectAtIndex:section]; 
	return @"Choose your place";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *tem=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	[tem setObject:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"selection"];
	
	[tem writeToFile:path atomically:YES];
	NSArray *t=[[NSArray alloc] initWithObjects:@"Final",[self view],nil];
	
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"hi"
	 object:t];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	NSLog(@"object failed with error");
	UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"No Internet Connection Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[al show];
	[al release];
	NSArray *t=[[NSArray alloc] initWithObjects:@"Home",[self view],nil];
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"hi"
	 object:t];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSLog(@"connection finished loading");
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release]; 
	
	//NSLog(@"Response: %@",responseString);
	//NSLog(@"response:%@",responseString);
	
	
	SBJSON *json = [SBJSON new];
	NSDictionary *luckyNumbers = [json objectWithString:responseString];
	NSString *path=[NSString stringWithFormat:@"%@/Documents/places.plist",NSHomeDirectory()];
	NSMutableDictionary *tem=[NSMutableDictionary dictionaryWithContentsOfFile:path];
	NSLog(@"path is %@",path);
	NSArray *filewrite=[[NSArray alloc] initWithArray:[[luckyNumbers valueForKey:@"responseData"] valueForKey:@"results"]];
	[tem setValue:filewrite forKey:@"place"];
	[tem writeToFile:path atomically:YES];
	flag++;
	[mytable reloadData];
	
	
	
}




/*
-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	if(theTextField==NULL)
		theTextField=todo;
	
	[theTextField resignFirstResponder];
	
	return YES;
	
}
*/
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
