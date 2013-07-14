//
//  MemoViewController.h
//  Memo
//
//  Created by Siddharth Chaubal on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JSON/JSON.h"


@interface MemoViewController : UIViewController <UISearchBarDelegate, CLLocationManagerDelegate,MKReverseGeocoderDelegate, UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITextField *todo;
	CLLocationManager	*locationManager;
	CLLocation	*startingPoint;
	UITextView *texty;
	UIToolbar *mytaby;
	UITableView *mytable;
	NSData *responseData;
	UIButton *arrowpull;
	UISearchBar *mysearchbar;
}

@property (nonatomic,retain) IBOutlet UITextField *todo;
@property (retain, nonatomic) CLLocationManager *locationManager; 
@property (retain, nonatomic) CLLocation *startingPoint; 
@property (nonatomic,retain) IBOutlet 	UITextView *texty;
@property (retain,nonatomic)  IBOutlet			UIToolbar *mytaby;
@property (nonatomic,retain) IBOutlet	UITableView *mytable;
@property (nonatomic,retain) IBOutlet	UISearchBar *mysearchbar;

@property (retain,nonatomic) IBOutlet 	UIButton *arrowpull;


-(IBAction)AnalyzePressed;
-(IBAction)ChangeLocationM;
-(IBAction)Killpressed;
-(IBAction) taguserslocation:(id)sender;
-(IBAction) showlog;
@end

