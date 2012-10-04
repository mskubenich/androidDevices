//
//  NewDeviceController.h
//  Android
//
//  Created by Lion User on 01/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDeviceController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UITextField *dev_name;
    IBOutlet UITextView *dev_description;
    IBOutlet UIImageView *imageView;
    UIImage *image;
    IBOutlet UITextField *storage;
    IBOutlet UITextField *os;
    IBOutlet UITextField *ram;
    IBOutlet UITextField *bluetooth;
    IBOutlet UITextField *wifi;
    IBOutlet UITextField *gps;
    IBOutlet UITextField *camera;
    //IBOutlet NSManagedObject *newDevice;
    
    IBOutlet UIScrollView *originalScroll;
    
}

@property(nonatomic, retain) UITextField *dev_name;
@property(nonatomic, retain) UITextView *dev_description;
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) UITextField *storage;
@property(nonatomic, retain) UITextField *os;
@property(nonatomic, retain) UITextField *ram;
@property(nonatomic, retain) UITextField *bluetooth;
@property(nonatomic, retain) UITextField *wifi;
@property(nonatomic, retain) UITextField *gps;
@property(nonatomic, retain) UITextField *camera;
//@property(nonatomic, retain) NSManagedObject *newDevice;
@property(nonatomic, retain) UIScrollView *originalScroll;


-(void)save:(id)sender;
-(IBAction)hideKeybord:(id)sender;
-(IBAction)selectImage;
-(IBAction)removeImage;

@end
