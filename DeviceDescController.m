//
//  DeviceDescController.m
//  Android
//
//  Created by Lion User on 01/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeviceDescController.h"
#import "AppDelegate.h"

@interface DeviceDescController ()

@end

@implementation DeviceDescController

@synthesize name;
@synthesize description;
@synthesize storage;
@synthesize image;
@synthesize currentDeviceId;

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Device"
                                                  inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self = %@", self.currentDeviceId];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *myarray = [[NSMutableArray alloc]initWithArray:[context executeFetchRequest:request
                                                                                        error:&error] ];
    if(myarray == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Error" 
                                                        message:[error description] 
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        NSManagedObject *device = [myarray objectAtIndex:0];
        self.name.text = [device valueForKey:@"name"];
        self.description.text = [device valueForKey:@"devDescription"];
        self.storage.text = [device valueForKey:@"storage"];
        
        UIImage *img = [[UIImage alloc] initWithData:[device valueForKey:@"image"]];
        self.image.image = img;
        [img release];
    }
    
    [myarray release];// WTF ???
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.name = nil;
    self.description = nil;
    self.image = nil;
    self.storage = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [self.name release];
    [self.description release];
    [self.image release];
    [self.storage release];
    [super dealloc];
}

@end
