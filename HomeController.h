//
//  HomeController.h
//  Android
//
//  Created by Lion User on 01/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceDescController;

@interface HomeController : UITableViewController<UIAlertViewDelegate>{
    NSMutableArray *devices;
}

@property(nonatomic, retain) NSMutableArray *devices;

-(void)goToNew:(id)sender;
-(void)reloadTable;
-(void)editTable;

@end
