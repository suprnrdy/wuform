//
//  ListViewController2.m
//  WuForm
//
//  Created by hack intosh on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ListViewController2.h"
#import "EventStore.h"

@implementation ListViewController2
{
  UIBarButtonItem *rightButton;
}
@synthesize managedObjectContext;
@synthesize listMasterViewController;
@synthesize listDetailViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
  // Setup datasource
  EventStore *eventStore = [EventStore defaultStore];
  
  if(managedObjectContext)
  {
    [eventStore setManagedObjectContext:managedObjectContext];
  }
  else
  {
    NSLog(@"Error... need to set managedObjectContext before loading view of ListViewController instance");
    abort();
  }

  
  // Do any additional setup after loading the view from its nib.
  listDetailViewController = [[ListDetailViewController alloc] init];
  listMasterViewController = [[ListMasterViewController alloc] init];
  [listMasterViewController setListDetailViewController:listDetailViewController];
  
  UIInterfaceOrientation theOrientation = UIInterfaceOrientationPortrait;
	CGSize fullSize = [self splitViewSizeForOrientation:theOrientation];
	float width = fullSize.width;
	float height = fullSize.height;
  float _splitPosition = 200.0;
  float _splitWidth = 1.0;
    
	// Layout the master, divider and detail views.
	CGRect newFrame = CGRectMake(0, 0, width, height);
	UIViewController *controller;
	UIView *theView;
  CGRect masterRect, dividerRect, detailRect;
  
  newFrame.size.width = _splitPosition;
  masterRect = newFrame;
  
  newFrame.origin.x += newFrame.size.width;
  newFrame.size.width = _splitWidth;
  dividerRect = newFrame;
  
  newFrame.origin.x += newFrame.size.width;
  newFrame.size.width = width - newFrame.origin.x;
  detailRect = newFrame;
  
  // Position master.
  controller = self.listMasterViewController;
  if (controller && [controller isKindOfClass:[UIViewController class]])  {
    theView = controller.view;
    if (theView) {
      theView.frame = masterRect;
      if (!theView.superview) {
        [controller viewWillAppear:NO];
        [self.view addSubview:theView];
        [controller viewDidAppear:NO];
      }
    }
  }
  
  // Position detail.
  controller = self.listDetailViewController;
  if (controller && [controller isKindOfClass:[UIViewController class]])  {
    theView = controller.view;
    if (theView) {
      theView.frame = detailRect;
      if (!theView.superview) {
        [self.view insertSubview:theView aboveSubview:self.listMasterViewController.view];
      } else {
        [self.view bringSubviewToFront:theView];
      }
    }
  }
  
  // Set Navigation Bar style
  [self.navigationController setNavigationBarHidden:NO animated:NO];  
  
  rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Export"
                                                 style:UIBarButtonItemStyleDone 
                                                target:self 
                                                action:@selector(syncList:)];
  self.navigationItem.rightBarButtonItem = rightButton;
    
  
  // Select first row by default
  [self.listMasterViewController selectFirstRow];
  
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
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait || 
          interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (CGSize)splitViewSizeForOrientation:(UIInterfaceOrientation)theOrientation
{
	UIScreen *screen = [UIScreen mainScreen];
	CGRect fullScreenRect = screen.bounds; // always implicitly in Portrait orientation.
	CGRect appFrame = screen.applicationFrame;
	
	// Find status bar height by checking which dimension of the applicationFrame is narrower than screen bounds.
	// Little bit ugly looking, but it'll still work even if they change the status bar height in future.
	float statusBarHeight = MAX((fullScreenRect.size.width - appFrame.size.width), (fullScreenRect.size.height - appFrame.size.height));
	
	// Initially assume portrait orientation.
	float width = fullScreenRect.size.width;
	float height = fullScreenRect.size.height;
	
	// Correct for orientation.
//	if (UIInterfaceOrientationIsLandscape(theOrientation)) {
  if(NO){
		width = height;
		height = fullScreenRect.size.width;
	}
	
	// Account for status bar, which always subtracts from the height (since it's always at the top of the screen).
	height -= statusBarHeight;
	
	return CGSizeMake(width, height);
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSLog(@"Clicked Button %d", buttonIndex);

  switch (buttonIndex) {
    case 0:
      // Synch with Wufoo
      if(![listMasterViewController syncList])
      {
        NSLog(@"ERROR: UNABLE to SYNC LIST");
      }
      break;
      
    case 1:
      // Export to .csv
      if(![listMasterViewController exportListToCSV])
      {
        NSLog(@"ERROR: UNABLE to Export LIST");
      }
      break;
      
    default:
      break;
  }
}

- (IBAction)syncList:(id)sender
{
  // Start sync here
  // NSError *error = nil;
  
//  if(![listMasterViewController syncList])
//  {
//    NSLog(@"ERROR: UNABLE to SYNC LIST");
//  } 
  
  NSLog(@"Show Export Options Popup");

  UIActionSheet *exportActionSheet = [[UIActionSheet alloc] initWithTitle:@"Export Entries" 
                                                                delegate:self 
                                                       cancelButtonTitle:@"OK" 
                                                  destructiveButtonTitle:nil 
                                                       otherButtonTitles:@"Synch with Wufoo", @"Mail as .csv", nil];
  [exportActionSheet showFromBarButtonItem:rightButton animated:YES];
}
@end
