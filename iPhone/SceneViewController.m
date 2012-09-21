//
//  SceneViewController.m
//  Somfy
//
//  Created by Sempercon on 4/22/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "SceneViewController.h"
#import "AppDelegate_iPhone.h"
#import "DashboardService.h"
#import "UserService.h"
#import "DBAccess.h"

extern BOOL  _isLOGOUT;

@implementation SceneViewController

@synthesize tableView;
@synthesize scrollView;
@synthesize Logout;

#pragma mark -
#pragma mark VIEW CALLBACKS
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)viewDidUnload {
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.view = nil;
 }


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    isSceneEdit = NO;
	//self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iP_bg.png"]];
	[super viewDidLoad];
	self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	int height = [[AppDelegate_iPhone  sharedAppDelegate].g_ScenesArray count] * 45;
	[self.tableView setFrame:CGRectMake(10, 72, 300, height)];
	[scrollView setContentSize:CGSizeMake(320, height+72)];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark -
#pragma mark TABLE VIEW DELEGATES

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   	return [[AppDelegate_iPhone  sharedAppDelegate].g_ScenesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return 45;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SceneCustomCell";
    SceneCustomCell *cell = (SceneCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) 
    {
        CGRect rect = CGRectMake(0.0, 0.0, 304, 45);
        cell = [[[SceneCustomCell alloc] initWithFrame:rect reuseIdentifier:identifier] retain];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.delegate = self;
    }
	
	if([[AppDelegate_iPhone  sharedAppDelegate].g_ScenesArray count]==1)
		cell.imgBg.image = [UIImage imageNamed:@"single_bg.png"];
	else
	{
		if(indexPath.row == 0)
			cell.imgBg.image = [UIImage imageNamed:@"top_bg.png"];
		else if(indexPath.row == [[AppDelegate_iPhone  sharedAppDelegate].g_ScenesArray count]-1)
			cell.imgBg.image = [UIImage imageNamed:@"bottom-bg.png"];
		else 
			cell.imgBg.image = [UIImage imageNamed:@"top2_bg.png"];
	}
		
	cell.btnActivated.hidden = YES;
	[cell.btnScene setBackgroundImage:[UIImage imageNamed:@"iP_Scene.png"] forState:UIControlStateNormal];
	cell.lblSceneName.text =[[[AppDelegate_iPhone  sharedAppDelegate].g_ScenesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
	cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SceneCustomCell *cell = (SceneCustomCell*)[self.tableView cellForRowAtIndexPath:indexPath];
	cell.btnActivated.hidden = NO;
	[[DashboardService getSharedInstance]ActivateScenes:[[[AppDelegate_iPhone  sharedAppDelegate].g_ScenesArray objectAtIndex:indexPath.row]objectForKey:@"id"] :self];
}

-(void)ScenesSelected:(SceneCustomCell*)cell
{
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	cell.btnActivated.hidden = NO;
	[[DashboardService getSharedInstance]ActivateScenes:[[[AppDelegate_iPhone  sharedAppDelegate].g_ScenesArray objectAtIndex:indexPath.row]objectForKey:@"id"] :self];
}

-(IBAction)LOGOUT:(id)sender
{
	//[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	//[[UserService getSharedInstance]Logout:self];
	
	// Hint
	UIAlertView *alertLOGOUT = [[UIAlertView alloc]initWithTitle:@"Logout Confirmation" 
														 message:@"Do you really want to logout of TaHomA?" 
														delegate:self 
											   cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [alertLOGOUT setTag: 325];
	[alertLOGOUT show];
	[alertLOGOUT release];
}

#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	if(strCommand==ACTIVATE_SCENES)
	{
		[self.tableView reloadData];
	}
	else if(strCommand == LOGOUT)
	{
		[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		
		NSString *query;
		BOOL success;
		DBAccess *dbobj = [[DBAccess alloc]init];
		NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
		query=@"SELECT * FROM Somfy";
		loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
		[Arr release];
		if([loginArray count]>0)
		{
			query=@"DELETE FROM Somfy";
			success = [dbobj DeleteFromDB:query];
		}
		[dbobj release];
		
		_isLOGOUT = YES;
		[[AppDelegate_iPhone sharedAppDelegate].tabBarController.view removeFromSuperview];
		[[AppDelegate_iPhone sharedAppDelegate]WindowShuoldAppear];
	}
	else if(strCommand == AUTHENTICATE_USER)
	{
		[AppDelegate_iPhone sharedAppDelegate].g_SessionArray = [resultArray mutableCopy];
		/*if ([[[[AppDelegate_iPhone sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 4)
		{
			UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Authorization Error" message:@"Not an authorized user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			
			[self.tableView reloadData];
			[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		}
		else 
		{
			[self.tableView reloadData];
			[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		}*/
		[self.tableView reloadData];
		[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
	}
}

-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription
{
    [self.tableView reloadData];
	[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
	
	if([errorMsg isEqualToString:@"SESSION EXPIRED"])
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert setTag:255];
		[errorAlert show];
		[errorAlert release];
		
		/*[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray removeAllObjects];
		[[AppDelegate_iPhone sharedAppDelegate].tabBarController.view removeFromSuperview];
		[[AppDelegate_iPhone sharedAppDelegate]WindowShuoldAppear];*/
	}
	else
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 255)
	{
		/*[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray removeAllObjects];
		[[AppDelegate_iPhone sharedAppDelegate].tabBarController.view removeFromSuperview];
		[[AppDelegate_iPhone sharedAppDelegate]WindowShuoldAppear];*/
		
		//Check if rememberme button is selected while login
		NSString *query;
		DBAccess *dbobj = [[DBAccess alloc]init];
		NSArray *Arr=[[NSArray alloc]initWithObjects:@"username",@"password",@"userrole",nil];
		query=@"SELECT * FROM Somfy";
		loginArray = [dbobj selectAllValueFromDatabase:query :Arr];
		[Arr release];
		[dbobj release];
		if([loginArray count]>0)
		{
			//Remove previous session from sessionArray
			[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray removeAllObjects];
			//Send authenticate command 
			[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"username"] forKey:@"username"];
			[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"password"] forKey:@"password"];
			[[UserService getSharedInstance]authenticate:commandDictionary:self];
			[commandDictionary release];
			
		}
		else
		{
			[[AppDelegate_iPhone  sharedAppDelegate].g_SessionArray removeAllObjects];
			[[AppDelegate_iPhone sharedAppDelegate].tabBarController.view removeFromSuperview];
			[[AppDelegate_iPhone sharedAppDelegate]WindowShuoldAppear];
		}
	}
	// Hint
	else if(alertView.tag == 325)
	{
		if(buttonIndex==1)
		{
			[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
			[[UserService getSharedInstance]Logout:self];
		}
	}
}

#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
    [Logout release];
	[scrollView release];
	[tableView release];
	[super dealloc];
}


@end
