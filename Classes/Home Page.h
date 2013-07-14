//
//  Home Page.h
//  ToDo
//
//  Created by Siddharth Chaubal on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoAppDelegate.h"
#import <Mapkit/MKAnnotation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotationH : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	
	NSString *mTitle;
	NSString *mSubTitle;
}
@end

@interface Home_Page : UIViewController <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate> {

	
	MemoAppDelegate *myappdelegate;
	CLLocationManager *mylocman;
	UIBarButtonItem *mytool;
	UITableView *tableview;
	NSMutableDictionary *td;
	NSMutableDictionary *xtd;

	MKMapView *mapview1;
	UIBarButtonItem *mapview;
	UIView *flipview;
	UIImageView *noteimage;
	UIView *noteview;
	UITextView *notetext;
}

@property (nonatomic,retain) MemoAppDelegate *myappdelegate;
@property (nonatomic,retain) 	CLLocationManager *mylocman;
@property (nonatomic,retain) IBOutlet	UIBarButtonItem *mytool;
@property (nonatomic,retain) IBOutlet 	UITableView *tableview;
@property (nonatomic,retain)	NSMutableDictionary *td;
@property (nonatomic,retain)	NSMutableDictionary *xtd;

@property (nonatomic,retain) IBOutlet 	MKMapView *mapview1;
@property (nonatomic,retain) IBOutlet 	UIBarButtonItem *mapview;
@property (nonatomic,retain) IBOutlet UIView *flipview;
@property (nonatomic,retain) IBOutlet 	UIImageView *noteimage;
@property (nonatomic,retain) IBOutlet UIView *noteview;
@property (nonatomic,retain) IBOutlet 	UITextView *notetext;

- (IBAction) EditTable:(id)sender;
-(IBAction) MapViewaction;
-(IBAction) closenote;

@end
