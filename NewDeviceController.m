//
//  NewDeviceController.m
//  Android
//
//  Created by Lion User on 01/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewDeviceController.h"
#import "AppDelegate.h"
#import "HomeController.h"

@interface NewDeviceController ()

@end

@implementation NewDeviceController

@synthesize dev_name;
@synthesize dev_description;
@synthesize imageView;
@synthesize image;
@synthesize storage;
@synthesize os;
@synthesize ram;
@synthesize bluetooth;
@synthesize wifi;
@synthesize gps;
@synthesize camera;

@synthesize originalScroll;
//@synthesize newDevice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //create save button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" 
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self 
                                                                  action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
  //  self.customScroll = self.originalScroll;
    self.originalScroll.contentSize = CGSizeMake(320, 1024);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    dev_name = nil;
    dev_description = nil;
    image = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [dev_name release];
    [dev_description release];
    [image release];
    [super dealloc];
}

#pragma mark -

-(void)save:(id)sender{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Device"
                                                  inManagedObjectContext:context];
    
    NSManagedObject *newDevice = [[NSManagedObject alloc] initWithEntity:entityDesc
                                          insertIntoManagedObjectContext:context];
    [newDevice setValue:dev_name.text forKey:@"name"];
    [newDevice setValue:dev_description.text forKey:@"devDescription"];
    NSData *data = UIImagePNGRepresentation(image);
    [newDevice setValue:data forKey:@"image"];
    [newDevice setValue:storage.text forKey:@"storage"];
    [newDevice setValue:os.text forKey:@"os"];
    [newDevice setValue:ram.text forKey:@"ram"];
    [newDevice setValue:bluetooth.text forKey:@"bluetooth"];
    [newDevice setValue:wifi.text forKey:@"wifi"];
    [newDevice setValue:gps.text forKey:@"gps"];
    [newDevice setValue:camera.text forKey:@"camera"];
    
    NSError *error;
    if(![context save:&error]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Error" 
                                                        message:[error description] 
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [newDevice release];
    NSArray *arrayOfControllers = self.navigationController.viewControllers;
    [[arrayOfControllers objectAtIndex:[arrayOfControllers count]-2] reloadTable];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideKeybord:(id)sender{
    [dev_name resignFirstResponder];
    [dev_description resignFirstResponder];
    [storage resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)selectImage{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  
    [picker dismissModalViewControllerAnimated:YES];  
    self.image = selectedImage; 
    [self.imageView setImage:self.image];

}

-(void)removeImage{
    self.image = nil;
    self.imageView.image = nil;
}

@end
