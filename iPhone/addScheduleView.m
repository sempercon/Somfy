//
//  addScheduleView.m
//  Somfy
//
//  Created by Karuppiah Annamalai on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "addScheduleView.h"
#import "TimerService.h"
#import "AppDelegate_iPhone.h"
#import "EventsService.h"
#import "ScheduleListings.h"
#import "DBAccess.h"
#import "UserService.h"

@implementation addScheduleView

@synthesize scheduleNameTextField;
@synthesize animateImageView;
@synthesize animationScrollView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	addedScheduleId = -1;
	scheduleIndex = -1;
    [super viewDidLoad];
	
	animationTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, 300, 24)];
	animationTitle1.text = @"myTaHomA Message";
	animationTitle1.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	animationTitle1.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle1];
	
	animationTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(14, 44, 300, 30)];
	animationTitle2.text = @"";
	animationTitle2.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
	animationTitle2.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle2];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
			[[AppDelegate_iPhone sharedAppDelegate].g_getTimersInfoArray removeAllObjects];
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
			[[AppDelegate_iPhone sharedAppDelegate].g_getEventsInfoArray removeAllObjects];
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
			//[self MoveToEditSchedule];
			[self OpenWindow];
			break;
		}
		default:
			break;
	}
}

-(void)MoveToEditSchedule
{
	BOOL isExists = NO;
	for(int i=0;i<[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList count];i++)
	{
		int schdID = [[[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList objectAtIndex:i] objectForKey:@"id"] intValue];
		if(schdID == addedScheduleId)
		{
			isExists = YES;
			scheduleIndex = i;
			break;
		}
	}
	
	if(isExists)
	{
		ScheduleListings *scheduleListings = [[ScheduleListings alloc]initWithNibName:@"ScheduleListings" bundle:nil];
		scheduleListings.selectedIndex = [NSString stringWithFormat:@"%d",scheduleIndex];
		[self.navigationController pushViewController:scheduleListings animated:YES];
		[scheduleListings release];
	}
}


-(IBAction)Cancel:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)Next:(id)sender
{
	if(scheduleNameTextField.text!=nil&&![scheduleNameTextField.text isEqualToString:@""])
	{
		[[AppDelegate_iPhone sharedAppDelegate]showCustomLoadingView];
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:scheduleNameTextField.text forKey:@"name"];
		[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
		[commandDictionary setObject:@"false" forKey:@"randomized"];
		[commandDictionary setObject:@"0" forKey:@"startTime"];
		[commandDictionary setObject:@"false" forKey:@"enabled"];
		[[TimerService getSharedInstance]addTimer:commandDictionary :self];
		[commandDictionary release];
		[scheduleNameTextField resignFirstResponder];
		animationTitle2.text = [scheduleNameTextField.text stringByAppendingString:@" added successfully"];
	}
	else
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter schedule name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
}

#pragma mark -
#pragma mark ANIMATION 

-(void)OpenWindow
{
	animationScrollView.hidden = NO;
	animateImageView.frame = CGRectMake(0, 85, 320, 100);
	yPosition = 85;
	openTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 
												 target:self 
											   selector:@selector(OpenDisplayTask) 
											   userInfo:nil 
												repeats:YES];
}

-(void)OpenDisplayTask
{
	yPosition-=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.02];
	[UIView setAnimationBeginsFromCurrentState:YES];
	animateImageView.frame = CGRectMake(0, yPosition, 320, 100);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition<=0)
	{
		yPosition = 0;
		[openTimer invalidate];
		openTimer = nil;
		[self performSelector:@selector(CloseWindow) withObject:nil afterDelay:2];
	}
}

-(void)CloseDisplayTask
{
	yPosition+=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.02];
	[UIView setAnimationBeginsFromCurrentState:YES];
	animateImageView.frame = CGRectMake(0, yPosition, 320, 100);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition>=85)
	{
		yPosition = 85;
		[closeTimer invalidate];
		closeTimer = nil;
		animationScrollView.hidden = YES;
		[self MoveToEditSchedule];
	}
}

-(void)CloseWindow
{
	closeTimer = [NSTimer scheduledTimerWithTimeInterval:0.02  
												  target:self 
												selector:@selector(CloseDisplayTask) 
												userInfo:nil 
												 repeats:YES];
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
		addedScheduleId = [[[resultArray objectAtIndex:0]objectForKey:@"id"] intValue];
		[self initialLoad];
	}
	else if(strCommand == AUTHENTICATE_USER)
	{
		[AppDelegate_iPhone sharedAppDelegate].g_SessionArray = [resultArray mutableCopy];
		/*if ([[[[AppDelegate_iPhone sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 4)
		{
			UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Authorization Error" message:@"Not an authorized user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			
			[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		}
		else 
		{
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)dealloc {
	[animateImageView release];
	[animationScrollView release];
	[animationTitle1,animationTitle2 release];
	[scheduleNameTextField release];
    [super dealloc];
}


@end
