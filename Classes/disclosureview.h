//
//  disclosureview.h
//  ToDo
//
//  Created by Siddharth Chaubal on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface disclosureview : UIViewController {

	UIWebView *myweby;
	UIToolbar *mytoly;
	IBOutlet UIActivityIndicatorView *chakardu;
}
@property (nonatomic,retain) IBOutlet UIWebView *myweby;
@property (nonatomic,retain) IBOutlet UIToolbar *mytoly;
@property (nonatomic,retain) 	IBOutlet UIActivityIndicatorView *chakardu;

-(IBAction) goback;
@end
