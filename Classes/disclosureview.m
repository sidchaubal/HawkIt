//
//  disclosureview.m
//  ToDo
//
//  Created by Siddharth Chaubal on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "disclosureview.h"
#import <QuartzCore/QuartzCore.h>


@implementation disclosureview
@synthesize myweby,mytoly,chakardu;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(handleNotification:)
	 name:@"disclosure"
	 object:nil];   
	mytoly.hidden=YES;
	[chakardu startAnimating];
}

-(void)handleNotification:(NSNotification *)pNotification
{
	NSURL *ur=(NSURL*)[pNotification object];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:ur];
	
	//Load the request in the UIWebView.
	[myweby loadRequest:requestObj];
	[chakardu stopAnimating];
	chakardu.hidden=YES;
	CATransition *transition2 = [CATransition animation];
	
	// Animate over 3/4 of a second
	transition2.duration=1.50;
	// using the ease in/out timing function
	transition2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	
	
	transition2.type=kCATransitionPush;
	transition2.subtype=kCATransitionFromBottom;

	transition2.delegate=self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[mytoly.layer addAnimation:transition2 forKey:nil];
	mytoly.hidden=NO;
	

}

-(IBAction) goback {

	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"hometable"
	 object:[self view]];
	

}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
