//
//  scheduleViewController.m
//  Somfy
//
//  Created by Sempercon on 4/24/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "scheduleViewController.h"
#import "AppDelegate_iPhone.h"
#import "ScheduleListings.h"
#import "TimerService.h"
#import "EventsService.h"
#import "UserService.h"
#import "DBAccess.h"
#import "addScheduleView.h"
#import "ScheduleCustomCell.h"



extern BOOL  _isLOGOUT;

@implementation scheduleViewController

@synthesize tableView;
@synthesize scrollView;
@synthesize addScheduleSubView;
@synthesize addScheduleTextField;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
	addScheduleTextField.leftView = paddingView;
	addScheduleTextField.leftViewMode = UITextFieldViewModeAlways;
	addScheduleTextField.placeholder=@"New Schedule Name";
	[paddingView release];
	self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	int height = [[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList count] * 50;
	[self.tableView setFrame:CGRectMake(10, 72, 300, height)];
	[scrollView setContentSize:CGSizeMake(320, height+72)];
	[self.tableView	 reloadData];
}
- (void)viewDidAppear:(BOOL)animated
{
}
- (void)viewWillDisappear:(BOOL)animated
{
}
- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.view = nil;
}

#pragma mark -
#pragma mark INITIAL LOAD

-(void)FormatSchedulesListArray
{
	NSMutableArray *eventArray;
	int condTypeInt,trigReasonIDInt;
	
	
	if([[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList count]>0)
		[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList removeAllObjects];
	
	for(int i=0;i<[[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray count];i++)
	{
		NSMutableDictionary *dict = [[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray objectAtIndex:i];
		[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList addObject:dict];
	}
	for(int i=0;i<[[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray count];i++)
	{
		NSMutableDictionary *dict = [[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray objectAtIndex:i];
		
		eventArray = [[AppDelegate_iPhone sharedAppDelegate].g_getEventsInfoArray objectAtIndex:i];
		
		if([eventArray count]>[eventArray count]-2)
		{
			condTypeInt = [[[eventArray objectAtIndex:[eventArray count]-2]objectForKey:@"condType"] intValue];
			if ( condTypeInt == DEVICE )
			{
				trigReasonIDInt = [[[eventArray objectAtIndex:[eventArray count]-2]objectForKey:@"trigReasonID"] intValue];
				if ( trigReasonIDInt == SUNRISE || trigReasonIDInt == SUNSET )
				{
					[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList addObject:dict];
				}
			}
		}
	}
	//Sorting Schedule Event array
	NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
	[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
	[lastNameSorter1 release];
}



#pragma mark -
#pragma mark GET SCHEDULE TIMER INFO 

-(void)getScheduleTimerInfo
{
	scheduleTimerInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0
															  target:self 
															selector:@selector(scheduleTimerInfoTask) 
															userInfo:nil 
															 repeats:YES];
	scheduleTimerInfoEnum = NONE;
	g_objectIndex = 0;
	
	
}

-(void)scheduleTimerInfoTask
{
	switch(scheduleTimerInfoEnum)
	{
		case NONE:
		{
			scheduleTimerInfoEnum = TIMER_GET_INFO;
			break;
		}
		case TIMER_GET_INFO:
		{
			if([[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray count] > g_objectIndex)
			{
				[[TimerService getSharedInstance]timerGetInfo:[[[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
				scheduleTimerInfoEnum = PROCESSING;
			}
			else 
			{
				scheduleTimerInfoEnum = DONE;
			}
			
			break;
		}
		case TIMER_GET_INFO_DONE:
		{
			if(g_objectIndex<[[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray count]-1)
			{
				g_objectIndex++;
				scheduleTimerInfoEnum = TIMER_GET_INFO;
			}
			else
				scheduleTimerInfoEnum = DONE;
			break;
		}
		case DONE:
		{
			[scheduleTimerInfoTimer invalidate];
			scheduleTimerInfoTimer=nil;
			scheduleEnum = TIMER_GET_INFO_DONE;
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark GET SCHEDULE EVENT INFO 

-(void)getScheduleEventInfo
{
	scheduleEventInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0
															  target:self 
															selector:@selector(scheduleEventInfoTask) 
															userInfo:nil 
															 repeats:YES];
	scheduleEventInfoEnum = NONE;
	g_objectIndex = 0;
	
	
}

-(void)scheduleEventInfoTask
{
	switch(scheduleEventInfoEnum)
	{
		case NONE:
		{
			scheduleEventInfoEnum = EVENT_INFO;
			break;
		}
		case EVENT_INFO:
		{
			if([[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray count] > g_objectIndex)
			{
				[[EventsService getSharedInstance]getInfo:[[[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
				scheduleEventInfoEnum = PROCESSING;
			}
			else 
			{
				scheduleEventInfoEnum = DONE;
			}
			
			break;
		}
		case EVENT_INFO_DONE:
		{
			if(g_objectIndex<[[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray count]-1)
			{
				g_objectIndex++;
				scheduleEventInfoEnum = EVENT_INFO;
			}
			else
				scheduleEventInfoEnum = DONE;
			break;
		}
		case DONE:
		{
			[scheduleEventInfoTimer invalidate];
			scheduleEventInfoTimer=nil;
			scheduleEnum = EVENT_INFO_DONE;
			break;
		}
		default:
			break;
	}
}



-(void)initialLoad
{
	[[AppDelegate_iPhone sharedAppDelegate]showCustomLoadingView];
	ProcessTimer = [NSTimer scheduledTimerWithTimeInterval:0 
													target:self 
												  selector:@selector(intialTask) 
												  userInfo:nil 
												   repeats:YES];
	scheduleEnum = NONE;
}

-(void)intialTask
{
	switch(scheduleEnum)
	{
		case NONE:
		{
			scheduleEnum = GET_TIMER;
			break;
		}
		case GET_TIMER:
		{
			[[TimerService getSharedInstance]getTimers:self];
			scheduleEnum = PROCESSING;
			break;
		}
		case GET_TIMER_DONE:
		{
			//Sorting Schedule Event array
			NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
			[[AppDelegate_iPhone  sharedAppDelegate].g_getTimersArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
			[lastNameSorter1 release];
			scheduleEnum = TIMER_GET_INFO;
			break;
		}
		case TIMER_GET_INFO:
		{
			scheduleEnum = PROCESSING;
			[self getScheduleTimerInfo];
			break;
		}
		case TIMER_GET_INFO_DONE:
		{
			scheduleEnum = GET_EVENT;
			break;
		}
		case GET_EVENT:
		{
			[[EventsService getSharedInstance]getEvents:self];
			scheduleEnum = PROCESSING;
			break;
		}
		case GET_EVENT_DONE:
		{
			//Sorting Schedule Event array
			NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
			[[AppDelegate_iPhone  sharedAppDelegate].g_getEventsArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
			[lastNameSorter1 release];
			
			scheduleEnum = EVENT_INFO;
			break;
		}
		case EVENT_INFO:
		{
			scheduleEnum = PROCESSING;
			[self getScheduleEventInfo];
			break;
		}
		case EVENT_INFO_DONE:
		{
			[self FormatSchedulesListArray];
			//Sorting Schedule Event array
			NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
			[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
			[lastNameSorter1 release];
			scheduleEnum = DONE;
			break;
		}
		case DONE:
		{
			[ProcessTimer invalidate];
			ProcessTimer=nil;
			[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
			[self.tableView reloadData];
			break;
		}
		default:
			break;
	}
}



#pragma mark -
#pragma mark TABLE VIEW DELEGATES

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList count];
}

- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return 50;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"ScheduleCustomCell";
    ScheduleCustomCell *cell = (ScheduleCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) 
    {
        CGRect rect = CGRectMake(0.0, 0.0, 300, 45);
        cell = [[[ScheduleCustomCell alloc] initWithFrame:rect reuseIdentifier:identifier] retain];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.delegate = self;
    } 
	
	if([[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList count]==1)
		cell.backgroundImg.image = [UIImage imageNamed:@"single_bg.png"];
	else
	{
		if(indexPath.row == 0)
			cell.backgroundImg.image = [UIImage imageNamed:@"top_bg.png"];
		else if(indexPath.row == [[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList count]-1)
			cell.backgroundImg.image = [UIImage imageNamed:@"bottom-bg.png"];
		else
			cell.backgroundImg.image = [UIImage imageNamed:@"top2_bg.png"];
	}
	
	cell.lblScheduleName.text = [[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList objectAtIndex:indexPath.row] objectForKey:@"name"];
	cell.img.image = [UIImage imageNamed:@"iP_Sch-Icon-Layer.png"];
	
	if([[[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList objectAtIndex:indexPath.row]objectForKey:@"enabled"] isEqualToString:@""])
	{	cell.lblScheduleEnable.text = @"Disabled";
		cell.lblScheduleEnable.textColor=[UIColor colorWithRed:(float)157/255 green:(float)195/255 blue:(float)207/255 alpha:1.0 ];
	}
	else
	{
		cell.lblScheduleEnable.text = @"Enabled";
		cell.lblScheduleEnable.textColor=[UIColor colorWithRed:(float)214/255 green:(float)121/255 blue:(float)10/255 alpha:1.0 ];
	}

	return cell;
}

#pragma mark -
#pragma mark ENABLE/DISABLE SCHEDULE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	enableorDisableIndex = indexPath.row;
	
	strInfoType = [[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex]objectForKey:@"ScheduleInfoType"];
	if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
	{
		if([[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex]objectForKey:@"enabled"] isEqualToString:@""])
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex]objectForKey:@"id"] forKey:@"id"];
			[commandDictionary setObject:@"true" forKey:@"enabled"];
			[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
			[commandDictionary setObject:@"false" forKey:@"randomized"];
			[commandDictionary setObject:@"0" forKey:@"startTime"];
			[[TimerService getSharedInstance]enableTimer:commandDictionary :self];
			[commandDictionary release];
		}
		else
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex]objectForKey:@"id"] forKey:@"id"];
			[commandDictionary setObject:@"false" forKey:@"enabled"];
			[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
			[commandDictionary setObject:@"false" forKey:@"randomized"];
			[commandDictionary setObject:@"0" forKey:@"startTime"];
			[[TimerService getSharedInstance]enableTimer:commandDictionary :self];
			[commandDictionary release];
		}
	}
	else
	{
		if([[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex]objectForKey:@"enabled"] isEqualToString:@""])
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex]objectForKey:@"id"] forKey:@"id"];
			[commandDictionary setObject:@"true" forKey:@"enabled"];
			[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
			[commandDictionary setObject:@"false" forKey:@"randomized"];
			[commandDictionary setObject:@"0" forKey:@"startTime"];
			[[EventsService getSharedInstance]enable:commandDictionary :self];
			[commandDictionary release];
		}
		else
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex]objectForKey:@"id"] forKey:@"id"];
			[commandDictionary setObject:@"false" forKey:@"enabled"];
			[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
			[commandDictionary setObject:@"false" forKey:@"randomized"];
			[commandDictionary setObject:@"0" forKey:@"startTime"];
			[[EventsService getSharedInstance]enable:commandDictionary :self];
			[commandDictionary release];
		}
	}
	
	[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];

}


#pragma mark -
#pragma mark PUSHING TO DETAILVIEW

-(void)ScheduleSelected:(ScheduleCustomCell*)cell
{
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	ScheduleListings *scheduleListings = [[ScheduleListings alloc]initWithNibName:@"ScheduleListings" bundle:nil];
	scheduleListings.selectedIndex = [NSString stringWithFormat:@"%d",indexPath.row];
	[self.navigationController pushViewController:scheduleListings animated:YES];
	[scheduleListings release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	ScheduleListings *scheduleListings = [[ScheduleListings alloc]initWithNibName:@"ScheduleListings" bundle:nil];
	scheduleListings.selectedIndex = [NSString stringWithFormat:@"%d",indexPath.row];
	[self.navigationController pushViewController:scheduleListings animated:YES];
	[scheduleListings release];
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)ADD:(id)sender
{
	//[self.view addSubview:addScheduleSubView];
	
	addScheduleView *addscheduleView = [[addScheduleView alloc]initWithNibName:@"addScheduleView" bundle:nil];
	[self.navigationController pushViewController:addscheduleView animated:YES];
	[addscheduleView release];
}

-(IBAction)ADDScheduleCreate:(id)sender
{
	if(addScheduleTextField.text!=nil&&![addScheduleTextField.text isEqualToString:@""])
	{
		[[AppDelegate_iPhone sharedAppDelegate]showCustomLoadingView];
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:addScheduleTextField.text forKey:@"name"];
		[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
		[commandDictionary setObject:@"false" forKey:@"randomized"];
		[commandDictionary setObject:@"0" forKey:@"startTime"];
		[commandDictionary setObject:@"false" forKey:@"enabled"];
		[[TimerService getSharedInstance]addTimer:commandDictionary :self];
		[commandDictionary release];
		[addScheduleSubView removeFromSuperview];
	}
}

-(IBAction)ADDScheduleCancel:(id)sender
{
	[addScheduleSubView removeFromSuperview];
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
	if(strCommand==GET_TIMERS)
	{
		scheduleEnum = GET_TIMER_DONE;
		//Copy the g_scheduleList result
		[AppDelegate_iPhone  sharedAppDelegate].g_getTimersArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_INFO)
	{
		scheduleTimerInfoEnum = TIMER_GET_INFO_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[[AppDelegate_iPhone  sharedAppDelegate].g_getTimersInfoArray addObject:[resultArray mutableCopy]];
	}
	else if(strCommand==GET_EVENTS)
	{
		scheduleEnum = GET_EVENT_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[AppDelegate_iPhone  sharedAppDelegate].g_getEventsArray = [resultArray mutableCopy];
	}
	else if(strCommand==EVENT_GET_INFO)
	{
		scheduleEventInfoEnum = EVENT_INFO_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[[AppDelegate_iPhone  sharedAppDelegate].g_getEventsInfoArray addObject:[resultArray mutableCopy]];
	}
	else if(strCommand == ADD_TIMER)
	{
		[self initialLoad];
	}
	else if(strCommand == ENABLE)
	{
		// When we sent an schedule timer enable return a true case we manually update the array as enable/disable and refresh the drawing view
		
		NSMutableDictionary *dictionary = [[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex];
		if([[dictionary objectForKey:@"enabled"] isEqualToString:@""])
		{
			[dictionary setObject:@"1" forKey:@"enabled"];
			[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:enableorDisableIndex withObject:dictionary];
		}
		else
		{
			[dictionary setObject:@"" forKey:@"enabled"];
			[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:enableorDisableIndex withObject:dictionary];
		}
		[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
		[self.tableView reloadData];
	}
	else if(strCommand == EVENT_ENABLE)
	{
		// When we sent an schedule event enable return a true case we manually update the array as enable/disable and refresh the drawing view
		
		NSMutableDictionary *dictionary = [[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex];
		if([[dictionary objectForKey:@"enabled"] isEqualToString:@""])
		{
			[dictionary setObject:@"1" forKey:@"enabled"];
			[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:enableorDisableIndex withObject:dictionary];
		}
		else
		{
			[dictionary setObject:@"" forKey:@"enabled"];
			[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:enableorDisableIndex withObject:dictionary];
		}
		[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
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
		[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
	}
	
}

-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription
{
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
    [Logout release];
	[scrollView release];
	[addScheduleTextField release];
	[addScheduleSubView release];
	[tableView release];
    [super dealloc];
}


@end
