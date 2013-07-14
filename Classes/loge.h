//
//  log.h
//  ToDo
//
//  Created by Siddharth Chaubal on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface loge : UIViewController {

	UITextView *mytextview;
	
}

@property(nonatomic,retain) IBOutlet UITextView *mytextview;

-(IBAction) goback;
-(IBAction) clearlog;
@end
