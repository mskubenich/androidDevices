//
//  EditController.m
//  Android
//
//  Created by Lion User on 02/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditController.h"
#import "AppDelegate.h"

@interface EditController ()

@end

@implementation EditController

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

@synthesize currentObjectId;
@synthesize device;

#pragma mark - 
#pragma mark View methods

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
    [super viewDidLoad];
    NSString *message = [[NSString alloc] initWithFormat:@"%@", currentObjectId];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Error" 
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" 
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self 
                                                                  action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    //self.navigationItem.leftBarButtonItem.title = @"Cancel";
    self.originalScroll.contentSize = CGSizeMake(320, 1024);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Device"
                                                  inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self = %@", self.currentObjectId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    [request setPredicate:predicate];
    NSError *error;
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[context executeFetchRequest:request
                                                                                        error:&error] ];
    if(array == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Error" 
                                                        message:[error description] 
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [error release];
    }else{
        self.device = [array objectAtIndex:0];
    }
    [array release];
    
    dev_name.text = [device valueForKey:@"name"];
    dev_description.text = [device valueForKey:@"devDescription"];
    UIImage *img = [[UIImage alloc] initWithData:[device valueForKey:@"image"]];
    image = img;
    imageView.image = img;
    [img release];
    storage.text = [device valueForKey:@"storage"];
    os.text = [device valueForKey:@"os"];
    ram.text = [device valueForKey:@"ram"];
    bluetooth.text = [device valueForKey:@"bluetooth"];
    wifi.text = [device valueForKey:@"wifi"];
    gps.text = [device valueForKey:@"gps"];
    camera.text = [device valueForKey:@"camera"];
}

- (void)viewDidUnload
{
    dev_name = nil;
    dev_description = nil;
    image = nil;
    imageView = nil;
    storage = nil;
    os = nil;
    ram = nil;
    bluetooth = nil;
    wifi = nil;
    gps = nil;
    camera = nil;
    currentObjectId = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [dev_name release];
    [dev_description release];
    [image release];
    [imageView release];
    [storage release];
    [os release];
    [ram release];
    [bluetooth release];
    [wifi release];
    [gps release];
    [camera release];
    [currentObjectId release];
    [super dealloc];
}

#pragma mark my methods

-(void)save:(id)sender{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];    
    
    [device setValue:dev_name.text forKey:@"name"];
    [device setValue:dev_description.text forKey:@"devDescription"];
    NSData *data = UIImagePNGRepresentation(image);
    [device setValue:data forKey:@"image"];
    [device setValue:storage.text forKey:@"storage"];
    [device setValue:os.text forKey:@"os"];
    [device setValue:ram.text forKey:@"ram"];
    [device setValue:bluetooth.text forKey:@"bluetooth"];
    [device setValue:wifi.text forKey:@"wifi"];
    [device setValue:gps.text forKey:@"gps"];
    [device setValue:camera.text forKey:@"camera"];
    
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
    NSArray *arrayOfControllers = self.navigationController.viewControllers;
    //[[arrayOfControllers objectAtIndex:[arrayOfControllers count]-2] reloadTable];
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark text field delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
