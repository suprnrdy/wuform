//
//  ListDetailViewController.m
//  WuForm
//
//  Created by hack intosh on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ListDetailViewController.h"
#import "EventSyncher.h"

@implementation ListDetailViewController
@synthesize event;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize emailTextField;
@synthesize weddingDateTextField;
@synthesize syncLabel;
@synthesize syncButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      // Custom initialization
      sync = [[EventSyncher alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-1.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)syncEvent:(id)sender
{
  // Start sync here
  // NSError *error = nil;
  if(![sync startSync:event])
  {
    NSLog(@"ERROR: UNABLE to SYNC");
  } 
}

- (void)showEvent
{
  // Set listDetailViewController 
  firstNameTextField.text = event.firstName;  
  lastNameTextField.text = event.lastName;  
  emailTextField.text = event.emailAddress;  
  
  if (![event.synched boolValue]) {
    syncLabel.text = @"NOT SYNCHED";  
    NSLog(@"Not Synched");
  }
  else{
    syncLabel.text = @"SYNCHED";      
  }
  
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  weddingDateTextField.text = [dateFormatter stringFromDate:event.weddingDate]; 
  
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  NSLog(@"%@ %@ %@ %@ %@ %@", 
        event.firstName, 
        event.lastName,
        event.emailAddress,
        [dateFormatter stringFromDate:event.weddingDate],
        [numberFormatter stringFromNumber:event.synched],
        event.uuid);
  
  
}

- (void)hideDisplay
{
  [[self firstNameTextField] setHidden:YES];
  [[self lastNameTextField] setHidden:YES];
  [[self emailTextField] setHidden:YES];
  [[self weddingDateTextField] setHidden:YES];
  [[self syncLabel] setHidden:YES];
  [[self syncButton] setHidden:YES];
}

- (void)showDisplay
{
  [[self firstNameTextField] setHidden:NO];
  [[self lastNameTextField] setHidden:NO];
  [[self emailTextField] setHidden:NO];
  [[self weddingDateTextField] setHidden:NO];
  [[self syncLabel] setHidden:NO];
  [[self syncButton] setHidden:NO];
}

@end
