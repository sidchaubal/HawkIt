//
//  log.m
//  ToDo
//
//  Created by Siddharth Chaubal on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "loge.h"


@implementation loge
@synthesize mytextview;


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
	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];

	NSString *thestr=[[NSString alloc] initWithContentsOfFile:path];
	mytextview.text=thestr;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(IBAction) clearlog {
	NSLog(@"in clear log");
	NSString *path=[NSString stringWithFormat:@"%@/Documents/log.txt",NSHomeDirectory()];
	NSString *bl=@"";
	[bl writeToFile:path atomically:YES];
	NSString *thestr=[[NSString alloc] initWithContentsOfFile:path];
	mytextview.text=thestr;

}

-(IBAction) goback {
	NSArray *cust=[[NSArray alloc] initWithObjects:@"log",[self view],nil];
	NSLog(@"in go back to app");
 	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"hi"
	 object:cust];
}

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
