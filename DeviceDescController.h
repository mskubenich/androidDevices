//
//  DeviceDescController.h
//  Android
//
//  Created by Lion User on 01/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceDescController : UIViewController{
    IBOutlet UILabel *name;
    IBOutlet UILabel *description;
    IBOutlet UILabel *storage;
    IBOutlet UIImageView *image;
    
    NSManagedObjectID *currentDeviceId;
}

@property(nonatomic, retain)UILabel *name;
@property(nonatomic, retain)UILabel *description;
@property(nonatomic, retain)UILabel *storage;
@property(nonatomic, retain)UIImageView *image;
@property(nonatomic, retain)NSManagedObjectID *currentDeviceId;

@end
