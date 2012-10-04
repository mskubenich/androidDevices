//
//  HomeController.m
//  Android
//
//  Created by Lion User on 01/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeController.h"
#import "DeviceDescController.h"
#import "NewDeviceController.h"
#import "AppDelegate.h"
#import "EditController.h"

@interface HomeController ()

@end

@implementation HomeController

@synthesize devices;

-(void)goToNew:(id)sender{
    NewDeviceController *newController = [[NewDeviceController alloc] init];
    newController.title = @"New Device";
    [self.navigationController pushViewController:newController animated:YES];
    [newController release];
}

-(void)reloadTable{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Device"
                                                  inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
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
    }
    self.devices = array;
    [array release];
    [request release];
    [self.tableView reloadData];
}

-(void)editTable{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if(self.tableView.editing){
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    }else{
        [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
    }
}

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
   
    [self reloadTable];
    
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New" 
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self 
                                                                 action:@selector(goToNew:)];
    self.navigationItem.leftBarButtonItem = newButton;
    [newButton release];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" 
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self 
                                                                 action:@selector(editTable)];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.devices = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [self.devices release];
    [super dealloc];
}

#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [devices count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *devicesTableIdentifier = @"devicesTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:devicesTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:devicesTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    NSManagedObject *device = [devices objectAtIndex:[indexPath row]];
    cell.textLabel.text = [device valueForKey:@"name"];
    cell.detailTextLabel.text = [device valueForKey:@"devDescription"];
    UIImage *dev_img = [[UIImage alloc] initWithData: [device valueForKey:@"image"]];
    [cell.imageView setImage:dev_img];
    [dev_img release];
    return cell;

}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceDescController *descController = [[DeviceDescController alloc] init];
    NSManagedObject *device = [devices objectAtIndex:[indexPath row]];
    descController.title = [device valueForKey:@"name"];
    NSManagedObjectID *id = [device objectID];
    [descController setCurrentDeviceId:id];
    [self.navigationController pushViewController:descController animated:YES];
    [descController release];
    return nil;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    EditController *editController = [[EditController alloc] init];
    editController.title = @"Edit";
    [self.navigationController pushViewController:editController animated:YES];
    [editController release];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

		AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        [context deleteObject:[self.devices objectAtIndex:[indexPath row]]];

        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  
            
        }else{
            [self.devices removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                             withRowAnimation:UITableViewRowAnimationNone];
        }
}

@end
