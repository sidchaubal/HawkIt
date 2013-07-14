//
//  final.h
//  Memo
//
//  Created by Siddharth Chaubal on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MemoAppDelegate.h"
@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *mTitle;
	NSString *mSubTitle;
}

@end

@interface final : UIViewController <MKMapViewDelegate>  {

	UITextView *todo;
	UITextField *notes;
	MemoAppDelegate *mydel;
	NSNotificationCenter * myNotficationCenter;
	UILabel *sliderlabel;
	UIDatePicker *picker;
	UISegmentedControl *segcontrol;
	UIBarButtonItem *done;
	MKMapView *mywebmap;
	IBOutlet UISlider *theslider;
	IBOutlet UILabel *remindlabel;
	IBOutlet UILabel *themthing;
}
@property (nonatomic,retain) IBOutlet UITextView *todo;

@property (nonatomic,retain) 	MemoAppDelegate *mydel;
@property (nonatomic,retain) IBOutlet 	UILabel *sliderlabel;
@property (nonatomic,retain) IBOutlet UIDatePicker *picker;
@property (nonatomic,retain) IBOutlet 	UISegmentedControl *segcontrol;
@property (nonatomic,retain) IBOutlet 	UIBarButtonItem *done;
@property (nonatomic,retain) IBOutlet MKMapView *mywebmap;
@property (nonatomic,retain) IBOutlet 	UITextField *notes;

-(void)donepressed:(id)sender;
-(IBAction)displayDate:(id)sender;
-(IBAction) segcontrolvaluechanged:(id)sender;
-(IBAction)slidervaluechanged:(id)sender;
-(IBAction)canceltodo;

@end
