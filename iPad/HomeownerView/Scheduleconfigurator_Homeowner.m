//
//  Scheduleconfigurator_Homeowner.m
//  Somfy
//
//  Created by Sempercon on 5/3/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "LiveviewDashboard.h"
#import "Scheduleconfigurator_Homeowner.h"
#import "SceneConfigurator_Homeowner.h"
#import "AppDelegate_iPad.h"
#import "RoomSelector_ipad.h"
#import "DeviceConfigurator_iPad.h"
#import "SceneConfigurator_iPad.h"
#import "EventConfigurator_iPad.h"
#import "ScheduleConfigurator_iPad.h"
#import "TimerService.h"
#import "EventsService.h"
#import "TimeConverterUtil.h"
#import "ConfigurationService.h"
#import "ConfigurationService.h"
#include <QuartzCore/QuartzCore.h>
#import "LoginScreen_iPad.h"
#import "DBAccess.h"
#import "UserService.h"
#import "MJPEGViewer_iPad.h"


@interface Scheduleconfigurator_Homeowner (Private)
-(void)InitializeDefaultScheduleValues;
-(void)initialLoad;
-(void)getScheduleTimerInfo;
-(void)initialTaskComplete;
-(void)LoadAllSchedules:(NSMutableArray*)scheduleArr;
-(void)showLoadingView;
-(void)hideLoadingView;
-(void) alignLabelWithTop:(UILabel *)label;
-(void)saveScheduleTaskComplete;
-(void)saveScheduleOneByOne;
-(void)OpenWindow;
@end

extern BOOL  isLOGOUT;


@implementation Scheduleconfigurator_Homeowner

@synthesize Logout;
@synthesize DashboardBtn,SceneConfigBtn,ScheduleConfigBtn,InstallerViewBtn;
@synthesize scheduleScrollView;
@synthesize TimeLbl1,TimeLbl2,DateLbl,ActivatedLabel;
@synthesize g_scheduleList,g_scheduleInfoList,g_timerInfoList,g_eventInfoList;

@synthesize scenesPicker;
@synthesize datePicker,timePicker,TodatePicker;

@synthesize addScheduleView;
@synthesize addScheduleTextField;

@synthesize editScheduleView;
@synthesize editScheduleTextField;

@synthesize	imgView;
@synthesize animationScrollView;
@synthesize label1,label2;

//Custom classes schedule subscrollview class files
@synthesize subcontainerView,pickerPopupView,pickerPopupsubView;

@synthesize pickerOkBtn,pickerCancelBtn;

//Animation
@synthesize animateImageView;
@synthesize animationTitle;

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

//Set custom image for button selected weekday selector
-(void)setCustomImage:(NSString*)dictKey:(UIButton*)btnType:(int)index
{
	if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
		[btnType setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
	else
		[btnType setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    if (isLocal == 1)
        self.Logout.hidden = YES;
    
	//test case
	animationScrollView.hidden = YES;
	isSaveSchedule = NO;
	saveScheduleEnum = NONE;
	_cachedDays = 0;
	maintenanceArray = [[NSMutableArray alloc]init];
	maintenanceDictionary = [[NSMutableDictionary alloc]init];
	
	isAnimation = YES;
	isLoadingSchedule = NO;
	//Animation
	animationScrollView.hidden = YES;
	animationTitle = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 350, 70)];
	animationTitle.lineBreakMode = UILineBreakModeWordWrap;
	animationTitle.numberOfLines = 0;
	animationTitle.textAlignment = UITextAlignmentCenter;
	animationTitle.font = [UIFont systemFontOfSize:13];
	animationTitle.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle];
	
	
	isWeekdaySelector = NO;
	isDatePicker= NO;isTimerPicker= NO;isScenePicker= NO;
	isTimeofday = YES;
	
	selectedSchedulesArray = [[NSMutableArray alloc]init];
	g_scheduleInfoList = [[NSMutableArray alloc]init];
	
	DateTimeDisplayTimer = [NSTimer scheduledTimerWithTimeInterval:1 
															target:self 
														  selector:@selector(DateTimeDisplayTask) 
														  userInfo:nil 
														   repeats:YES];
	[self InitializeDefaultScheduleValues];
	//[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	
	
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 20)];
	addScheduleTextField.leftView = paddingView;
	addScheduleTextField.leftViewMode = UITextFieldViewModeAlways;
	addScheduleTextField.placeholder= @"New Schedule Name";
	[paddingView release];
	
	UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 20)];
	editScheduleTextField.leftView = paddingView1;
	editScheduleTextField.leftViewMode = UITextFieldViewModeAlways;
	[paddingView1 release];
	
	
	[super viewDidLoad];
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
	xposition=0;
	self.view = nil;

}

-(void)viewWillAppear:(BOOL)animated
{
	if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
	{
		if([[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] == 4)
			InstallerViewBtn.hidden = YES;
		else {
			InstallerViewBtn.hidden = NO;
		}
	}
	
	
	[[AppDelegate_iPad sharedAppDelegate]SetHomeownerViewIndex:2];
	[ScheduleConfigBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
}

-(void)FormatSchedulesListArray
{
	NSMutableArray *eventArray;
	int condTypeInt,trigReasonIDInt;
	
	
	if([[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList count]>0)
		[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList removeAllObjects];
	
	for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_getTimersArray count];i++)
	{
		NSMutableDictionary *dict = [[AppDelegate_iPad sharedAppDelegate].g_getTimersArray objectAtIndex:i];
		[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList addObject:dict];
	}
	for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count];i++)
	{
		NSMutableDictionary *dict = [[AppDelegate_iPad sharedAppDelegate].g_getEventsArray objectAtIndex:i];
		
		eventArray = [[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray objectAtIndex:i];
		
		if([eventArray count]>[eventArray count]-2)
		{
			condTypeInt = [[[eventArray objectAtIndex:[eventArray count]-2]objectForKey:@"condType"] intValue];
			if ( condTypeInt == DEVICE )
			{
				trigReasonIDInt = [[[eventArray objectAtIndex:[eventArray count]-2]objectForKey:@"trigReasonID"] intValue];
				if ( trigReasonIDInt == SUNRISE || trigReasonIDInt == SUNSET )
				{
					[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList addObject:dict];
				}
			}
		}
	}
	//Sorting Schedule Event array
	NSSortDescriptor *lastNameSorter1 =[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
	[[AppDelegate_iPad  sharedAppDelegate].g_formatScheduleList sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
	[lastNameSorter1 release];
	
	if(isSaveSchedule)
	{
		for (int i=0; i<[[AppDelegate_iPad  sharedAppDelegate].g_formatScheduleList count]; i++) {
			int ID = [[[[AppDelegate_iPad  sharedAppDelegate].g_formatScheduleList objectAtIndex:i] objectForKey:@"id"] intValue];
			if( ID == newScheduleId)
			{
				saveScheduleIndex = i;
				break;
			}
		}
	}
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
			[[AppDelegate_iPad sharedAppDelegate].g_getTimersInfoArray removeAllObjects];
			scheduleTimerInfoEnum = TIMER_GET_INFO;
			break;
		}
		case TIMER_GET_INFO:
		{
			if([[AppDelegate_iPad sharedAppDelegate].g_getTimersArray count] > g_objectIndex)
			{
				[[TimerService getSharedInstance]timerGetInfo:[[[AppDelegate_iPad sharedAppDelegate].g_getTimersArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
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
			if(g_objectIndex<[[AppDelegate_iPad sharedAppDelegate].g_getTimersArray count]-1)
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
			[[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray removeAllObjects];
			scheduleEventInfoEnum = EVENT_INFO;
			break;
		}
		case EVENT_INFO:
		{
			if([[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count] > g_objectIndex)
			{
				[[EventsService getSharedInstance]getInfo:[[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray objectAtIndex:g_objectIndex]objectForKey:@"id"] :self];
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
			if(g_objectIndex<[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count]-1)
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



#pragma mark -
#pragma mark INITIAL LOAD 

-(void)initialLoad
{
	[self showLoadingView];
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
			
			if(isSaveSchedule)
			{
				if(isTimerorEventChange)
				{
					if([[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"ScheduleInfoType"] isEqualToString:@"ScheduleEventInfo"])
						scheduleEnum = GET_EVENT;
					else
						scheduleEnum = GET_TIMER;
				}
				else
				{
					if(isTimerToEvent)
						scheduleEnum = GET_EVENT;
					else
						scheduleEnum = GET_TIMER;
				}
			}
			else
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
			[[AppDelegate_iPad  sharedAppDelegate].g_getTimersArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
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
			if(isSaveSchedule)
			{
				if(isTimerorEventChange)
				{
					if([[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"ScheduleInfoType"] isEqualToString:@"ScheduleTimerInfo"])
						scheduleEnum = EVENT_INFO_DONE;
				}
				else
				{
					if(!isTimerToEvent)
						scheduleEnum = EVENT_INFO_DONE;
				}
			}
			else
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
			[[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter1]];
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
			scheduleEnum = DONE;
			break;
		}
		case DONE:
		{
			[self initialTaskComplete];
			[self InitializeDefaultScheduleValues];
			
			if(!isSaveSchedule)
			{
				[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
			}
			else
				isSaveSchedule = NO;
			[self OpenWindow];
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}

-(void)initialTaskComplete
{
	[ProcessTimer invalidate];
	ProcessTimer=nil;
}


-(void)setMetaData:(NSString*)strMetaData
{
	NSString *strDateString;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
	
	if ([strMetaData rangeOfString:@"sDate."].location == NSNotFound) {
		[maintenanceDictionary setObject:@"" forKey:@"dateTextField"];
	} else {
        
        //Find current year
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *currYear = [dateFormatter stringFromDate:[NSDate date]];
        
        
		NSString *subString = [strMetaData substringWithRange:NSMakeRange([strMetaData rangeOfString:@"sDate."].location, 10)];
		subString = [subString stringByReplacingOccurrencesOfString:@"sDate." withString:@""];
		NSString *month = [subString substringToIndex:2];
		NSString *date = [subString substringFromIndex:2];
		NSString *format = [month stringByAppendingString:@"-"];
		format = [format stringByAppendingString:date];
		format = [format stringByAppendingString:@"-"];
		format = [format stringByAppendingString:currYear];
		
		//To display as date string label
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		NSDate *newDate = [dateFormatter dateFromString:format];
		[dateFormatter setDateFormat:@"MMM dd,yyy"];
		strDateString = [dateFormatter stringFromDate:newDate];
		
		
		[maintenanceDictionary setObject:format forKey:@"dateTextField"];
		
		
		//Separator between two dates
		strDateString = [strDateString stringByAppendingString:@"  -  "];
		
		
		subString = [strMetaData substringWithRange:NSMakeRange([strMetaData rangeOfString:@"eDate."].location, 10)];
		subString = [subString stringByReplacingOccurrencesOfString:@"eDate." withString:@""];
		month = [subString substringToIndex:2];
		date = [subString substringFromIndex:2];
		format = [month stringByAppendingString:@"-"];
		format = [format stringByAppendingString:date];
		format = [format stringByAppendingString:@"-"];
		format = [format stringByAppendingString:currYear];
		
		//To display as date string label
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		newDate = [dateFormatter dateFromString:format];
		[dateFormatter setDateFormat:@"MMM dd,yyy"];
		strDateString = [strDateString stringByAppendingString:[dateFormatter stringFromDate:newDate]];
		
		
		[maintenanceDictionary setObject:format forKey:@"TodateTextField"];
		[maintenanceDictionary setObject:strDateString forKey:@"DateString"];
	}
	[dateFormatter release];
}

-(void)setActivationTime:(NSString*)strTime
{
	NSString *typoString = @"";
	[[TimeConverterUtil getSharedInstance]convertTimeFromMinutesAfterMidnight:[strTime intValue]];
	int hours =[[TimeConverterUtil getSharedInstance]getHours];
	int mins	=[[TimeConverterUtil getSharedInstance]getMinutes];
	//Determine the values for the ampm group
	if ( hours >= 12 )
		typoString = @"PM";
	else
		typoString = @"AM";
	
	//Determin the value for the hours property
	if ( hours > 13 )
	{
		hours = hours - 12;
	}
	//Last check..if the get hours is equivalant to 0 then we are 
	//going to just store the hours as 12
	if ( hours == 0 )
		hours = 12;
	
	NSString *minutes = [NSString stringWithFormat:@"%d",mins];
	if([minutes length]==1)
		minutes = [@"0" stringByAppendingString:minutes];
	
	NSString *strFormat = [[NSString stringWithFormat:@"%d",hours] stringByAppendingString:@":"];
	strFormat = [strFormat stringByAppendingString:minutes];
	strFormat = [strFormat stringByAppendingString:@" "];
	strFormat = [strFormat stringByAppendingString:typoString];
	[maintenanceDictionary setObject:strFormat forKey:@"timerTextField"];
	[maintenanceDictionary setObject:strTime forKey:@"startTime"];
}

//Set sunrise or sunset based on trigreason ID
-(void)setSunriseOrSunset:(NSString*)trigReasonID
{
	if(trigReasonID!=nil)
	{
		if([trigReasonID intValue]==1)
		{
			[maintenanceDictionary setObject:@"YES" forKey:@"issunriseBool"];
		}
		else
		{
			[maintenanceDictionary setObject:@"NO" forKey:@"issunriseBool"];
		}
	}
}

//Set weekday button selected state
-(void)setWeekdayButtonSelectedState:(int)_currentDays
{
	if(_currentDays & SUNDAY )
		[maintenanceDictionary setObject:@"YES" forKey:@"sunbtnselected"];
	else
		[maintenanceDictionary setObject:@"NO" forKey:@"sunbtnselected"];
	
	if(_currentDays & MONDAY )
		[maintenanceDictionary setObject:@"YES" forKey:@"monbtnselected"];
	else
		[maintenanceDictionary setObject:@"NO" forKey:@"monbtnselected"];
	
	if(_currentDays & TUESDAY )
		[maintenanceDictionary setObject:@"YES" forKey:@"tuebtnselected"];
	else
		[maintenanceDictionary setObject:@"NO" forKey:@"tuebtnselected"];
	
	if(_currentDays & WEDNESDAY )
		[maintenanceDictionary setObject:@"YES" forKey:@"wedbtnselected"];
	else
		[maintenanceDictionary setObject:@"NO" forKey:@"wedbtnselected"];
	
	if(_currentDays & THURSDAY )
		[maintenanceDictionary setObject:@"YES" forKey:@"thubtnselected"];
	else
		[maintenanceDictionary setObject:@"NO" forKey:@"thubtnselected"];
	
	if(_currentDays & FRIDAY )
		[maintenanceDictionary setObject:@"YES" forKey:@"fribtnselected"];
	else
		[maintenanceDictionary setObject:@"NO" forKey:@"fribtnselected"];
	
	if(_currentDays & SATURDAY )
		[maintenanceDictionary setObject:@"YES" forKey:@"satbtnselected"];
	else
		[maintenanceDictionary setObject:@"NO" forKey:@"satbtnselected"];
	
	if ( _currentDays == 127 )
		[maintenanceDictionary setObject:@"YES" forKey:@"allbtnselected"];
	else
		[maintenanceDictionary setObject:@"NO" forKey:@"allbtnselected"];
}


-(void)InitializeDefaultScheduleValues
{
	NSString *strTimerInfoId;
	int TimerIndex,EventIndex;
	NSMutableArray *timerArray,*eventArray;
	timerArray = [[NSMutableArray alloc]init];
	eventArray = [[NSMutableArray alloc]init];
	
	if([maintenanceArray count]>0)
		[maintenanceArray removeAllObjects];
	
	for(int i=0;i<[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList count];i++)
	{
		
		[timerArray removeAllObjects];
		[eventArray removeAllObjects];
		
		if([maintenanceDictionary count]>0)
			[maintenanceDictionary removeAllObjects];
		
		//Load timerarray from timerInfoList
		strInfoType = [[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"ScheduleInfoType"];
		if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
		{
			strTimerInfoId = [[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"id"];
			for(int j=0;j<[[AppDelegate_iPad sharedAppDelegate].g_getTimersArray count];j++)
			{
				if([strTimerInfoId isEqualToString:[[[AppDelegate_iPad sharedAppDelegate].g_getTimersArray objectAtIndex:j]objectForKey:@"id"]])
				{
					TimerIndex = j;
					timerArray = [[[AppDelegate_iPad sharedAppDelegate].g_getTimersInfoArray objectAtIndex:j] mutableCopy];
					break;
				}
			}
		}
		else
		{
			strTimerInfoId = [[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"id"];
			for(int j=0;j<[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray count];j++)
			{
				if([strTimerInfoId isEqualToString:[[[AppDelegate_iPad sharedAppDelegate].g_getEventsArray objectAtIndex:j]objectForKey:@"id"]])
				{
					EventIndex = j;
					eventArray = [[[AppDelegate_iPad sharedAppDelegate].g_getEventsInfoArray objectAtIndex:j] mutableCopy];
					break;
				}
			}
			
		}
		
		//Default initialize values
		[maintenanceDictionary setObject:@"NO" forKey:@"sunbtnselected"];
		[maintenanceDictionary setObject:@"NO" forKey:@"monbtnselected"];
		[maintenanceDictionary setObject:@"NO" forKey:@"tuebtnselected"];
		[maintenanceDictionary setObject:@"NO" forKey:@"wedbtnselected"];
		[maintenanceDictionary setObject:@"NO" forKey:@"thubtnselected"];
		[maintenanceDictionary setObject:@"NO" forKey:@"fribtnselected"];
		[maintenanceDictionary setObject:@"NO" forKey:@"satbtnselected"];
		[maintenanceDictionary setObject:@"NO" forKey:@"allbtnselected"];
		[maintenanceDictionary setObject:@"YES" forKey:@"issunriseBool"];
		[maintenanceDictionary setObject:@"NO" forKey:@"isWeekdaySelector"];
		[maintenanceDictionary setObject:@"" forKey:@"startTime"];
		[maintenanceDictionary setObject:@"" forKey:@"_currentDays"];
		[maintenanceDictionary setObject:@"" forKey:@"sliderValue"];
		[maintenanceDictionary setObject:@"" forKey:@"DateString"];
		
		
		//Check whether it should be weekday or yearly selector
		if([timerArray count]>0)
		{
			if([[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"] length]>0)
			{
				//Check if date. present in the meta data
				if([[TimeConverterUtil getSharedInstance]containsDate:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"]])
				{
					[maintenanceDictionary setObject:@"NO" forKey:@"isWeekdaySelector"];
					[self setMetaData:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"]];
				}
				else
				{
					[maintenanceDictionary setObject:@"YES" forKey:@"isWeekdaySelector"];
					//Get  daysActiveMask from Timer_get_info 
					//NSMutableArray *timerArray = [[g_scheduleInfoList objectAtIndex:i]objectForKey:@"TimerInfo"];
					[maintenanceDictionary setObject:[[timerArray objectAtIndex:0]objectForKey:@"daysActiveMask"] forKey:@"_currentDays"];
					[self setWeekdayButtonSelectedState:[[[timerArray objectAtIndex:0]objectForKey:@"daysActiveMask"]intValue]];
					[maintenanceDictionary setObject:@"" forKey:@"dateTextField"];
				}
			}
			else
			{
				[maintenanceDictionary setObject:@"YES" forKey:@"isWeekdaySelector"];
				//NSMutableArray *timerArray = [[g_scheduleInfoList objectAtIndex:i]objectForKey:@"TimerInfo"];
				[maintenanceDictionary setObject:[[timerArray objectAtIndex:0]objectForKey:@"daysActiveMask"] forKey:@"_currentDays"];
				[self setWeekdayButtonSelectedState:[[[timerArray objectAtIndex:0]objectForKey:@"daysActiveMask"]intValue]];
				[maintenanceDictionary setObject:@"" forKey:@"dateTextField"];
			}
		}
		else if([eventArray count]>0)
		{
			if([[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"] length]>0)
			{
				//Check if date. present in the meta data
				if([[TimeConverterUtil getSharedInstance]containsDate:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"]])
				{
					[maintenanceDictionary setObject:@"NO" forKey:@"isWeekdaySelector"];
					[self setMetaData:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"]];
				}
				else
				{
					[maintenanceDictionary setObject:@"YES" forKey:@"isWeekdaySelector"];
					//Get  daysActiveMask from Timer_get_info 
					//NSMutableArray *timerArray = [[g_scheduleInfoList objectAtIndex:i]objectForKey:@"TimerInfo"];
					[maintenanceDictionary setObject:[[eventArray objectAtIndex:0]objectForKey:@"daysActiveMask"] forKey:@"_currentDays"];
					[self setWeekdayButtonSelectedState:[[[eventArray objectAtIndex:0]objectForKey:@"daysActiveMask"]intValue]];
					[maintenanceDictionary setObject:@"" forKey:@"dateTextField"];
				}
			}
			else
			{
				[maintenanceDictionary setObject:@"YES" forKey:@"isWeekdaySelector"];
				//NSMutableArray *timerArray = [[g_scheduleInfoList objectAtIndex:i]objectForKey:@"TimerInfo"];
				[maintenanceDictionary setObject:[[eventArray objectAtIndex:0]objectForKey:@"daysActiveMask"] forKey:@"_currentDays"];
				[self setWeekdayButtonSelectedState:[[[eventArray objectAtIndex:0]objectForKey:@"daysActiveMask"]intValue]];
				[maintenanceDictionary setObject:@"" forKey:@"dateTextField"];
			}
			
		}
		
		//Check whether it should be sunset , sunrise or Time 
		//NSMutableArray *eventArray = [[g_scheduleInfoList objectAtIndex:i]objectForKey:@"EventInfo"];
		if([eventArray count]>0)
		{
			//if([[[eventArray objectAtIndex:0]objectForKey:@"enabled"] length]>0)
			{
				[maintenanceDictionary setObject:@"NO" forKey:@"isTimeofday"];
				[maintenanceDictionary setObject:@"NO" forKey:@"PreviousisTimeofday"];
				//Check whether it should be sunrise or sunset
				if([eventArray count]>[eventArray count]-2)
					[self setSunriseOrSunset:[[eventArray objectAtIndex:[eventArray count]-2]objectForKey:@"trigReasonID"]];
				if([eventArray count]>[eventArray count]-1)
					[maintenanceDictionary setObject:[[eventArray objectAtIndex:[eventArray count]-1]objectForKey:@"modifiable"] forKey:@"sliderValue"];
				
				if([[[eventArray objectAtIndex:1]objectForKey:@"name"] length]>0)
				{
					[maintenanceDictionary setObject:[[eventArray objectAtIndex:1]objectForKey:@"name"] forKey:@"scenesTextField"];
					[maintenanceDictionary setObject:[[eventArray objectAtIndex:1]objectForKey:@"id"] forKey:@"scenesTextFieldID"];
					[maintenanceDictionary setObject:[[eventArray objectAtIndex:1]objectForKey:@"name"] forKey:@"PreviousscenesTextField"];
					[maintenanceDictionary setObject:[[eventArray objectAtIndex:1]objectForKey:@"id"] forKey:@"PreviousscenesTextFieldID"];
				}
				else
					[maintenanceDictionary setObject:@"" forKey:@"scenesTextField"];
				
			}
		}
		else
		{
            if([timerArray count]>0)
            {
                [maintenanceDictionary setObject:@"YES" forKey:@"PreviousisTimeofday"];
                [maintenanceDictionary setObject:@"YES" forKey:@"isTimeofday"];
                NSString *timerString = [[timerArray objectAtIndex:0]objectForKey:@"startTime"];
                [self setActivationTime:timerString];
            }
		}
		//Check whether it should randomized
		//NSMutableArray *timerArray = [[g_scheduleInfoList objectAtIndex:i]objectForKey:@"TimerInfo"];
		if([timerArray count]>0)
		{
			if([[[timerArray objectAtIndex:0]objectForKey:@"randomized"] isEqualToString:@"0"] || [[[timerArray objectAtIndex:0]objectForKey:@"randomized"] isEqualToString:@""])
				[maintenanceDictionary setObject:@"NO" forKey:@"isRandomize"];
			else
				[maintenanceDictionary setObject:@"YES" forKey:@"isRandomize"];
			
			
		}
		//Check whether the scene should be configured for that schedule
		//timerArray = [[g_scheduleInfoList objectAtIndex:i]objectForKey:@"TimerInfo"];
		if([timerArray count]>1)
		{
			if([[[timerArray objectAtIndex:1]objectForKey:@"name"] length]>0)
			{
				[maintenanceDictionary setObject:[[timerArray objectAtIndex:1]objectForKey:@"name"] forKey:@"scenesTextField"];
				[maintenanceDictionary setObject:[[timerArray objectAtIndex:1]objectForKey:@"id"] forKey:@"scenesTextFieldID"];
				[maintenanceDictionary setObject:[[timerArray objectAtIndex:1]objectForKey:@"name"] forKey:@"PreviousscenesTextField"];
				[maintenanceDictionary setObject:[[timerArray objectAtIndex:1]objectForKey:@"id"] forKey:@"PreviousscenesTextFieldID"];
			}
			else
				[maintenanceDictionary setObject:@"" forKey:@"scenesTextField"];
		}
		
		strInfoType = [[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"ScheduleInfoType"];
		
		[maintenanceDictionary setObject:strInfoType forKey:@"ScheduleInfoType"];
		[maintenanceDictionary setObject:@"0" forKey:@"_changeMask"];
		
		[maintenanceArray addObject:[maintenanceDictionary mutableCopy]];
		
	}
	[timerArray release];
	[eventArray release];
}

-(void)DateTimeDisplayTask
{
	NSDate *date = [NSDate date];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hh:mm"];
	TimeLbl1.text = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"a"];
	TimeLbl2.text = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"MM/dd/yy"];
	DateLbl.text = [dateFormatter stringFromDate:date];
	[dateFormatter release];
}

//Load all schedules 
-(void)LoadAllSchedules:(NSMutableArray*)scheduleArr
{	
	//Remove all subviews from scrollview for load a new subviews
	NSArray *subviewArr = [scheduleScrollView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	BOOL isSelected = NO;
	int x=0,y=0;
	int subx=0,suby=40,Newy=100;
	isLoadingSchedule = YES;
	for(int i=0;i<[scheduleArr count];i++)
	{
		
		UIImageView *bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, 165, 480)];
		bg_image.image = [UIImage imageNamed:@"scene_editBackground.png"];
		bg_image.alpha = 0.5;
		bg_image.contentMode = UIViewContentModeScaleToFill;
		[scheduleScrollView addSubview:bg_image];
		[bg_image release];
		
		
		UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(x+10, y, 140, 30)];
		lbl1.textColor = [UIColor colorWithRed:0.250 green:0.498 blue:0.631 alpha:1];
		lbl1.backgroundColor = [UIColor clearColor];
		lbl1.textAlignment = UITextAlignmentCenter;
		lbl1.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
		lbl1.text = @"SCHEDULE";
		[scheduleScrollView addSubview:lbl1];
		[lbl1 release];
		
		y =y+30;
		
		UILabel *scheduleName = [[UILabel alloc] initWithFrame:CGRectMake(x+2, y, 160, 60)];
		scheduleName.textAlignment =UITextAlignmentCenter;
		scheduleName.textColor = [UIColor whiteColor];
		scheduleName.backgroundColor = [UIColor clearColor];
		scheduleName.lineBreakMode = UILineBreakModeWordWrap;
		scheduleName.numberOfLines =5;
		scheduleName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		scheduleName.text=[[scheduleArr objectAtIndex:i]objectForKey:@"name"];
		[scheduleName setTag:i];
		[self alignLabelWithTop:scheduleName];
		[scheduleScrollView addSubview:scheduleName];
		[scheduleName release];
		
		UIButton *customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		customBtn.frame = CGRectMake(x+2, y, 160, 60);
		customBtn.titleLabel.textAlignment =UITextAlignmentCenter;
		customBtn.titleLabel.textColor = [UIColor clearColor];
		customBtn.titleLabel.backgroundColor = [UIColor clearColor];
		customBtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		customBtn.titleLabel.numberOfLines = 5;
		customBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
		[customBtn setTag:i];
		[customBtn addTarget:self action:@selector(ScheduleNameEdit:) forControlEvents:UIControlEventTouchUpInside];
		[scheduleScrollView addSubview:customBtn];
		[customBtn release];
		
		for(int j=0;j<[selectedSchedulesArray count];j++)
		{
			if(i==[[selectedSchedulesArray objectAtIndex:j] intValue])
			{
				UIScrollView *scrollsubView = [[UIScrollView alloc]initWithFrame:CGRectMake(x+170, 0, 340, 480)];
				scrollsubView.backgroundColor = [UIColor clearColor];
				[scrollsubView setTag:i];
				[scrollsubView setBounces:YES];
				//[scheduleScrollView addSubview:scrollsubView];
				if(currentSceneEditIndex == [[selectedSchedulesArray objectAtIndex:j]intValue])
				{
					[scrollsubView setFrame:CGRectMake( x-25, 0.0f, 340.0f, 400.0f)]; //notice this is OFF screen!
					[UIView beginAnimations:@"animateTableView" context:nil];
					[UIView setAnimationDuration:0.07];
					[scrollsubView setFrame:CGRectMake( x+172, 0.0f, 340.0f, 400.0f)]; //notice this is ON screen!
					[UIView commitAnimations];
				}
				[scheduleScrollView  addSubview:scrollsubView];
				
				
				UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 340,750)];
				containerView.backgroundColor = [UIColor clearColor];
				
				
				UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(19, 0, 160, 30)];
				lbl1.textColor = [UIColor whiteColor];
				lbl1.backgroundColor = [UIColor clearColor];
				lbl1.textAlignment = UITextAlignmentLeft;
				lbl1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lbl1.text = @"ACTIVATION DAY";
				[containerView addSubview:lbl1];
				[lbl1 release];

				
				UIButton *dayofWeekBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				dayofWeekBtn.frame = CGRectMake(27, 30, 141, 51);
				[dayofWeekBtn setTag:i];
				[dayofWeekBtn setBackgroundImage:[UIImage imageNamed:@"day_of_week_up.png"] forState:UIControlStateNormal];
				[dayofWeekBtn addTarget:self action:@selector(dayofWeekBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:dayofWeekBtn];
				
				UIButton *calendarDateBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				calendarDateBtn.frame = CGRectMake(168, 30, 141, 51);
				[calendarDateBtn setTag:i];
				[calendarDateBtn setBackgroundImage:[UIImage imageNamed:@"calender_date_selected.png"] forState:UIControlStateNormal];
				[calendarDateBtn addTarget:self action:@selector(calendarDateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:calendarDateBtn];
				
				
				UILabel *lblWeekorYear = [[UILabel alloc]initWithFrame:CGRectMake(18, 75, 160, 27)];
				lblWeekorYear.textColor = [UIColor whiteColor];
				lblWeekorYear.backgroundColor = [UIColor clearColor];
				lblWeekorYear.textAlignment = UITextAlignmentLeft;
				lblWeekorYear.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lblWeekorYear.text = @"SCHEDULE";
				[containerView addSubview:lblWeekorYear];
				
				
				UILabel *lblYearlySelector = [[UILabel alloc]initWithFrame:CGRectMake(29, 100, 300, 27)];
				lblYearlySelector.textColor = [UIColor blackColor];
				lblYearlySelector.numberOfLines = 0;
				lblYearlySelector.lineBreakMode = UILineBreakModeWordWrap;
				lblYearlySelector.backgroundColor = [UIColor clearColor];
				lblYearlySelector.textAlignment = UITextAlignmentCenter;
				lblYearlySelector.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lblYearlySelector.text = @"Day schedule To Run";
				[containerView addSubview:lblYearlySelector];
				
				UILabel *lblDateString = [[UILabel alloc]initWithFrame:CGRectMake(35, 123, 300, 27)];
				lblDateString.textColor = [UIColor blackColor];
				lblDateString.numberOfLines = 0;
				lblDateString.text = @"";
				lblDateString.lineBreakMode = UILineBreakModeWordWrap;
				lblDateString.backgroundColor = [UIColor clearColor];
				lblDateString.textAlignment = UITextAlignmentCenter;
				lblDateString.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				[containerView addSubview:lblDateString];
				
				UIButton *sunBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				g_sunBtn = sunBtn;
				sunBtn.frame = CGRectMake(27, 126, 37, 37);
				[sunBtn setTag:i];
				sunBtn.titleLabel.font = [UIFont systemFontOfSize:13];
				[sunBtn setTitle:@"Su" forState:UIControlStateNormal];
				[sunBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[sunBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
				[sunBtn addTarget:self action:@selector(sunBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:sunBtn];
				
				UIButton *monBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				g_monBtn = monBtn;
				monBtn.frame = CGRectMake(112, 126, 37, 37);
				[monBtn setTag:i];
				monBtn.titleLabel.font = [UIFont systemFontOfSize:13];
				[monBtn setTitle:@"M" forState:UIControlStateNormal];
				[monBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[monBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
				[monBtn addTarget:self action:@selector(monBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:monBtn];
				
				UIButton *tueBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				g_tueBtn = tueBtn;
				tueBtn.frame = CGRectMake(196, 126, 37, 37);
				[tueBtn setTag:i];
				tueBtn.titleLabel.font = [UIFont systemFontOfSize:13];
				[tueBtn setTitle:@"Tu" forState:UIControlStateNormal];
				[tueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[tueBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
				[tueBtn addTarget:self action:@selector(tueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:tueBtn];
				
				UIButton *wedBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				g_wedBtn = wedBtn;
				wedBtn.frame = CGRectMake(276, 126, 37, 37);
				[wedBtn setTag:i];
				wedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
				[wedBtn setTitle:@"W" forState:UIControlStateNormal];
				[wedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[wedBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
				[wedBtn addTarget:self action:@selector(wedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:wedBtn];
				
				UIButton *thuBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				g_thuBtn = thuBtn;
				thuBtn.frame = CGRectMake(27, 201, 37, 37);
				[thuBtn setTag:i];
				thuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
				[thuBtn setTitle:@"Th" forState:UIControlStateNormal];
				[thuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[thuBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
				[thuBtn addTarget:self action:@selector(thuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:thuBtn];
				
				UIButton *friBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				g_friBtn = friBtn;
				friBtn.frame = CGRectMake(112, 201, 37, 37);
				[friBtn setTag:i];
				friBtn.titleLabel.font = [UIFont systemFontOfSize:13];
				[friBtn setTitle:@"F" forState:UIControlStateNormal];
				[friBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[friBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
				[friBtn addTarget:self action:@selector(friBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:friBtn];
				
				UIButton *satBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				g_satBtn = satBtn;
				satBtn.frame = CGRectMake(196, 201, 37, 37);
				[satBtn setTag:i];
				satBtn.titleLabel.font = [UIFont systemFontOfSize:13];
				[satBtn setTitle:@"Sa" forState:UIControlStateNormal];
				[satBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[satBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
				[satBtn addTarget:self action:@selector(satBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:satBtn];
				
				UIButton *allBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				allBtn.frame = CGRectMake(276, 201, 37, 37);
				[allBtn setTag:i];
				allBtn.titleLabel.font = [UIFont systemFontOfSize:13];
				[allBtn setTitle:@"All" forState:UIControlStateNormal];
				[allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
				[allBtn addTarget:self action:@selector(allBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:allBtn];
				
				UILabel *fromLbl = [[UILabel alloc]initWithFrame:CGRectMake(23, 163, 57, 27)];
				fromLbl.textColor = [UIColor whiteColor];
				fromLbl.backgroundColor = [UIColor clearColor];
				fromLbl.textAlignment = UITextAlignmentLeft;
				fromLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
				fromLbl.text = @"From";
				[containerView addSubview:fromLbl];
				
				
				UITextField *dateTextField = [[UITextField alloc]initWithFrame:CGRectMake(97, 154, 135, 45)];
				dateTextField.borderStyle = UITextBorderStyleNone;
				dateTextField.userInteractionEnabled = NO;
				dateTextField.backgroundColor = [UIColor clearColor];
				dateTextField.background = [UIImage imageNamed:@"DropDown.png"];
				dateTextField.textAlignment = UITextAlignmentCenter;
				dateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
				[containerView addSubview:dateTextField];
				
				UIButton *datePickerBtn  = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
				datePickerBtn.frame = CGRectMake(251, 158, 72, 37);
				[datePickerBtn setTag:i];
				[datePickerBtn setTitle:@"Pick" forState:UIControlStateNormal];
				[datePickerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				[datePickerBtn addTarget:self action:@selector(datePickerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:datePickerBtn];
				
				UILabel *toLbl = [[UILabel alloc]initWithFrame:CGRectMake(23, 218, 43, 27)];
				toLbl.textColor = [UIColor whiteColor];
				toLbl.backgroundColor = [UIColor clearColor];
				toLbl.textAlignment = UITextAlignmentLeft;
				toLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
				toLbl.text = @"To";
				[containerView addSubview:toLbl];
				
				
				UITextField *TodateTextField = [[UITextField alloc]initWithFrame:CGRectMake(96, 209, 135, 45)];
				TodateTextField.borderStyle = UITextBorderStyleNone;
				TodateTextField.userInteractionEnabled = NO;
				TodateTextField.backgroundColor = [UIColor clearColor];
				TodateTextField.background = [UIImage imageNamed:@"DropDown.png"];
				TodateTextField.textAlignment = UITextAlignmentCenter;
				TodateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
				[containerView addSubview:TodateTextField];
				
				
				UIButton *TodatePickerBtn  = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
				TodatePickerBtn.frame = CGRectMake(251, 214, 72, 37);
				[TodatePickerBtn setTag:i];
				[TodatePickerBtn setTitle:@"Pick" forState:UIControlStateNormal];
				[TodatePickerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				[TodatePickerBtn addTarget:self action:@selector(TodatePickerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:TodatePickerBtn];
				
                // Hint
				//lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(18, 269, 160, 35)];
                lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(19, 277, 160, 35)];
				lbl1.textColor = [UIColor whiteColor];
				lbl1.backgroundColor = [UIColor clearColor];
				lbl1.textAlignment = UITextAlignmentLeft;
				lbl1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lbl1.text = @"ACTIVATION TIME";
				[containerView addSubview:lbl1];
				[lbl1 release];
				
				/*UISegmentedControl *activationTimeSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Time",@"Sunrise Sunset",nil]];
				activationTimeSegment.segmentedControlStyle = UISegmentedControlStyleBar;
				activationTimeSegment.momentary = NO;
				[activationTimeSegment setTag:i];
				activationTimeSegment.frame = CGRectMake(18, 311, 191, 37);
				[activationTimeSegment addTarget:self action:@selector(activationTimeSegmentAction:) forControlEvents:UIControlEventValueChanged];
				[containerView addSubview:activationTimeSegment];*/
				
				UIButton *timeofDayBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				timeofDayBtn.frame = CGRectMake(27, 308, 141, 51);
				[timeofDayBtn setTag:i];
				[timeofDayBtn setBackgroundImage:[UIImage imageNamed:@"time_of_day_up.png"] forState:UIControlStateNormal];
				[timeofDayBtn addTarget:self action:@selector(timeofDayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:timeofDayBtn];
				
				UIButton *sunrise_sunset_Btn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				sunrise_sunset_Btn.frame = CGRectMake(168, 308, 141, 51);
				[sunrise_sunset_Btn setTag:i];
				[sunrise_sunset_Btn setBackgroundImage:[UIImage imageNamed:@"sunrise_sunset_selected.png"] forState:UIControlStateNormal];
				[sunrise_sunset_Btn addTarget:self action:@selector(sunrise_sunset_BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:sunrise_sunset_Btn];
				
				
				UIButton * sunriseBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				sunriseBtn.frame = CGRectMake(35, 372, 37, 37);
				[sunriseBtn setTag:i];
				[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"not_selected_up.png"] forState:UIControlStateNormal];
				[sunriseBtn addTarget:self action:@selector(sunriseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:sunriseBtn];
				
				UIButton * sunsetBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				sunsetBtn.frame = CGRectMake(181, 372, 37, 37);
				[sunsetBtn setTag:i];
				[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"not_selected_up.png"] forState:UIControlStateNormal];
				[sunsetBtn addTarget:self action:@selector(sunsetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:sunsetBtn];
			
				UILabel *lblsunrise = [[UILabel alloc]initWithFrame:CGRectMake(83, 373, 65, 28)];
				lblsunrise.textColor = [UIColor whiteColor];
				lblsunrise.backgroundColor = [UIColor clearColor];
				lblsunrise.textAlignment = UITextAlignmentLeft;
				lblsunrise.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lblsunrise.text = @"Sunrise";
				[containerView addSubview:lblsunrise];
				
				UILabel *lblsunset = [[UILabel alloc]initWithFrame:CGRectMake(230, 373, 65, 28)];
				lblsunset.textColor = [UIColor whiteColor];
				lblsunset.backgroundColor = [UIColor clearColor];
				lblsunset.textAlignment = UITextAlignmentLeft;
				lblsunset.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lblsunset.text = @"Sunset";
				[containerView addSubview:lblsunset];
				
				UILabel *lblEventSliderValue = [[UILabel alloc]initWithFrame:CGRectMake(107, 414, 128, 28)];
				//[lblEventSliderValue setTag:i];
				[lblEventSliderValue setTag:1999];
				lblEventSliderValue.textColor = [UIColor whiteColor];
				lblEventSliderValue.backgroundColor = [UIColor clearColor];
				lblEventSliderValue.textAlignment = UITextAlignmentCenter;
				lblEventSliderValue.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lblEventSliderValue.text = @"";
				[containerView addSubview:lblEventSliderValue];
				
				UILabel *lblSliderValue1 = [[UILabel alloc]initWithFrame:CGRectMake(6, 414, 36, 28)];
				lblSliderValue1.textColor = [UIColor whiteColor];
				lblSliderValue1.backgroundColor = [UIColor clearColor];
				lblSliderValue1.textAlignment = UITextAlignmentCenter;
				lblSliderValue1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lblSliderValue1.text = @"-60";
				[containerView addSubview:lblSliderValue1];
				
				UILabel *lblSliderValue2 = [[UILabel alloc]initWithFrame:CGRectMake(299, 414, 36, 28)];
				lblSliderValue2.textColor = [UIColor whiteColor];
				lblSliderValue2.backgroundColor = [UIColor clearColor];
				lblSliderValue2.textAlignment = UITextAlignmentCenter;
				lblSliderValue2.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lblSliderValue2.text = @"60";
				[containerView addSubview:lblSliderValue2];
				
                // Hint
                
				/*UISlider *eventSlider = [[UISlider alloc]initWithFrame:CGRectMake(21, 450, 300, 23)];
				[eventSlider setTag:i];
				eventSlider.minimumValue = -60;
				eventSlider.maximumValue = 60;
				[eventSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
				[containerView addSubview:eventSlider];*/
                
                UISlider *eventSlider = [[UISlider alloc]initWithFrame:CGRectMake(21, 415, 300, 100)];
				[eventSlider setThumbImage:[UIImage imageNamed:@"customthumb.png"] forState:UIControlStateNormal];
				[eventSlider thumbRectForBounds:CGRectMake(21, 450, 200, 100) trackRect:CGRectMake(21, 450, 200, 100)  value: eventSlider.value];
				[eventSlider setTag:i];
				eventSlider.minimumValue = -60;
				eventSlider.maximumValue = 60;
				[eventSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
				[containerView addSubview:eventSlider];
				
				UITextField *timerTextField = [[UITextField alloc]initWithFrame:CGRectMake(49, 400, 135, 45)];
				timerTextField.borderStyle = UITextBorderStyleNone;
				timerTextField.userInteractionEnabled = NO;
				timerTextField.background = [UIImage imageNamed:@"DropDown.png"];
				timerTextField.textAlignment = UITextAlignmentCenter;
				timerTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
				timerTextField.backgroundColor = [UIColor clearColor];
				[containerView addSubview:timerTextField];
				
				UIButton *timePickerBtn  = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
				timePickerBtn.frame = CGRectMake(219, 405, 72, 37);
				[timePickerBtn setTag:i];
				[timePickerBtn setTitle:@"Pick" forState:UIControlStateNormal];
				[timePickerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				[timePickerBtn addTarget:self action:@selector(timePickerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:timePickerBtn];
				
				lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(18, 491, 160, 35)];
				lbl1.textColor = [UIColor whiteColor];
				lbl1.backgroundColor = [UIColor clearColor];
				lbl1.textAlignment = UITextAlignmentLeft;
				lbl1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				lbl1.text = @"SELECTED SCENE";
				[containerView addSubview:lbl1];
				[lbl1 release];
				
				/*UITextField *scenesTextField = [[UITextField alloc]initWithFrame:CGRectMake(19, 551, 224, 51)];
				scenesTextField.borderStyle = UITextBorderStyleNone;
				scenesTextField.backgroundColor = [UIColor whiteColor];
				scenesTextField.textAlignment = UITextAlignmentCenter;
				[containerView addSubview:scenesTextField];*/
				
				UIButton *scenesPickerBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				scenesPickerBtn.frame = CGRectMake(29, 551, 280, 31);
				[scenesPickerBtn setTag:i];
				[scenesPickerBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Shape-13.png"] forState:UIControlStateNormal];
				[scenesPickerBtn addTarget:self action:@selector(scenesPickerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[containerView addSubview:scenesPickerBtn];
				
				UILabel *scenesTextField = [[UILabel alloc]initWithFrame:CGRectMake(37, 555, 224, 22)];
				scenesTextField.textColor = [UIColor blackColor];
				scenesTextField.backgroundColor = [UIColor clearColor];
				scenesTextField.textAlignment = UITextAlignmentLeft;
				scenesTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
				scenesTextField.text = @"";
				[containerView addSubview:scenesTextField];
				
				
				if([[[maintenanceArray objectAtIndex:i]objectForKey:@"isTimeofday"] isEqualToString:@"YES"])
				{
					lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 649, 111, 40)];
					lbl1.textColor = [UIColor whiteColor];
					lbl1.backgroundColor = [UIColor clearColor];
					lbl1.textAlignment = UITextAlignmentLeft;
					lbl1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
					lbl1.text = @"RANDOMIZE";
					[containerView addSubview:lbl1];
					[lbl1 release];
					
					UIButton *randomizeBtn  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
					randomizeBtn.frame = CGRectMake(251, 644, 50, 50);
					[randomizeBtn setTag:i];
					[randomizeBtn addTarget:self action:@selector(RandomizeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
					[containerView addSubview:randomizeBtn];
					//Check if randmoize enabled or not
					if([maintenanceArray count]>i)
					{
						if([[[maintenanceArray objectAtIndex:i]objectForKey:@"isRandomize"] isEqualToString:@"YES"])
							[randomizeBtn setBackgroundImage:[UIImage imageNamed:@"Randomize_selected.png"] forState:UIControlStateNormal];
						else
							[randomizeBtn setBackgroundImage:[UIImage imageNamed:@"Randomize.png"] forState:UIControlStateNormal];
					}
					[randomizeBtn release];
				}
				
				if([maintenanceArray count]>i)
				{
					if([[[maintenanceArray objectAtIndex:i]objectForKey:@"isWeekdaySelector"] isEqualToString:@"YES"])
						isWeekdaySelector = YES;
					else
						isWeekdaySelector = NO;
					
					if([[[maintenanceArray objectAtIndex:i]objectForKey:@"isTimeofday"] isEqualToString:@"YES"])
						isTimeofday = YES;
					else
						isTimeofday = NO;
				}
				
				
				//Check if its in weeekdayselector or yearly selector
				if(isWeekdaySelector)
				{
					//[activationDayBtn setTitle:@"Yearly Run Selector" forState:UIControlStateNormal];
					
					//[activationDaySegment setSelectedSegmentIndex:0];
					
					[dayofWeekBtn setBackgroundImage:[UIImage imageNamed:@"day_of_week_down_selected.png"] forState:UIControlStateNormal];
					[calendarDateBtn setBackgroundImage:[UIImage imageNamed:@"calender_date_up.png"] forState:UIControlStateNormal];
					
					
					lblWeekorYear.text = @"Days";
					lblYearlySelector.hidden = YES;
					lblDateString.hidden = YES;
					
					//Set week day button selected state
					sunBtn.hidden=NO;monBtn.hidden=NO;tueBtn.hidden=NO;wedBtn.hidden=NO;thuBtn.hidden=NO;friBtn.hidden=NO;satBtn.hidden=NO;allBtn.hidden=NO;
					[self setCustomImage:@"sunbtnselected" :sunBtn :i];
					[self setCustomImage:@"monbtnselected" :monBtn :i];
					[self setCustomImage:@"tuebtnselected" :tueBtn :i];
					[self setCustomImage:@"wedbtnselected" :wedBtn :i];
					[self setCustomImage:@"thubtnselected" :thuBtn :i];
					[self setCustomImage:@"fribtnselected" :friBtn :i];
					[self setCustomImage:@"satbtnselected" :satBtn :i];
					[self setCustomImage:@"allbtnselected" :allBtn :i];
							
					dateTextField.hidden = YES;datePickerBtn.hidden = YES;TodatePickerBtn.hidden = YES;TodateTextField.hidden= YES;
					fromLbl.hidden = YES;toLbl.hidden = YES;
					
					if(isTimeofday)
					{
						lblSliderValue1.hidden = YES;
						lblSliderValue2.hidden = YES;
						
						[timeofDayBtn setBackgroundImage:[UIImage imageNamed:@"time_of_day_down_selected.png"] forState:UIControlStateNormal];
						[sunrise_sunset_Btn setBackgroundImage:[UIImage imageNamed:@"sunrise_sunset_up.png"] forState:UIControlStateNormal];
						
						sunriseBtn.hidden=YES;lblsunrise.hidden=YES;
						sunsetBtn.hidden=YES;lblsunset.hidden=YES;
						lblEventSliderValue.hidden=YES;eventSlider.hidden=YES;
						timerTextField.hidden = NO;timePickerBtn.hidden = NO;
						//Set timertextfield text
						timerTextField.text = [[maintenanceArray objectAtIndex:i]objectForKey:@"timerTextField"];
					}
					else
					{
						lblSliderValue1.hidden = NO;
						lblSliderValue2.hidden = NO;
						
						[timeofDayBtn setBackgroundImage:[UIImage imageNamed:@"time_of_day_up.png"] forState:UIControlStateNormal];
						[sunrise_sunset_Btn setBackgroundImage:[UIImage imageNamed:@"sunrise_sunset_selected.png"] forState:UIControlStateNormal];
						
						sunriseBtn.hidden=NO;lblsunrise.hidden=NO;
						sunsetBtn.hidden=NO;lblsunset.hidden=NO;
						lblEventSliderValue.hidden=NO;eventSlider.hidden=NO;
						timerTextField.hidden = YES;timePickerBtn.hidden = YES;
						
						//Set sunrise or sunset
						//[maintenanceDictionary setObject:@"YES" forKey:@"issunriseBool"];
						
						if([[[maintenanceArray objectAtIndex:i]objectForKey:@"issunriseBool"] isEqualToString:@"YES"])
						{
							[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"selected_up.png"] forState:UIControlStateNormal];
							[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"not_selected_up.png"] forState:UIControlStateNormal];
						}
						else
						{
							[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"not_selected_up.png"] forState:UIControlStateNormal];
							[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"selected_up.png"] forState:UIControlStateNormal];
						}
						//set modifiable values for uislider
						
						if([[[maintenanceArray objectAtIndex:i]objectForKey:@"sliderValue"] isEqualToString:@""])
						{
							eventSlider.value = 0;
							lblEventSliderValue.text = @"0";
							lblEventSliderValue.text = [lblEventSliderValue.text stringByAppendingString:@" minute(s)"];
						}
						else
						{
							eventSlider.value = [[[maintenanceArray objectAtIndex:i]objectForKey:@"sliderValue"] intValue];
							lblEventSliderValue.text = [[maintenanceArray objectAtIndex:i]objectForKey:@"sliderValue"];
							lblEventSliderValue.text = [lblEventSliderValue.text stringByAppendingString:@" minute(s)"];
						}
					}
				}
				else
				{
					[dayofWeekBtn setBackgroundImage:[UIImage imageNamed:@"day_of_week_up.png"] forState:UIControlStateNormal];
					[calendarDateBtn setBackgroundImage:[UIImage imageNamed:@"calender_date_selected.png"] forState:UIControlStateNormal];
					
					lblWeekorYear.text = @"Yearly Selector";
					lblYearlySelector.hidden = NO;
					lblDateString.hidden = NO;
					sunBtn.hidden=YES;monBtn.hidden=YES;tueBtn.hidden=YES;wedBtn.hidden=YES;thuBtn.hidden=YES;friBtn.hidden=YES;satBtn.hidden=YES;allBtn.hidden=YES;
					
					dateTextField.hidden = NO;datePickerBtn.hidden = NO;TodatePickerBtn.hidden = NO;TodateTextField.hidden= NO;
					fromLbl.hidden = NO;toLbl.hidden = NO;
					
					//Set datetextfield value
					lblDateString.text = [[maintenanceArray objectAtIndex:i]objectForKey:@"DateString"];
					dateTextField.text = [[maintenanceArray objectAtIndex:i]objectForKey:@"dateTextField"];
					TodateTextField.text = [[maintenanceArray objectAtIndex:i]objectForKey:@"TodateTextField"];
					if(isTimeofday)
					{
						lblSliderValue1.hidden = YES;
						lblSliderValue2.hidden = YES;
						
						[timeofDayBtn setBackgroundImage:[UIImage imageNamed:@"time_of_day_down_selected.png"] forState:UIControlStateNormal];
						[sunrise_sunset_Btn setBackgroundImage:[UIImage imageNamed:@"sunrise_sunset_up.png"] forState:UIControlStateNormal];
						
						sunriseBtn.hidden=YES;lblsunrise.hidden=YES;
						sunsetBtn.hidden=YES;lblsunset.hidden=YES;
						lblEventSliderValue.hidden=YES;eventSlider.hidden=YES;
						timerTextField.hidden = NO;timePickerBtn.hidden = NO;
						//Set timertextfield text
						timerTextField.text = [[maintenanceArray objectAtIndex:i]objectForKey:@"timerTextField"];
					}
					else
					{
						lblSliderValue1.hidden = NO;
						lblSliderValue2.hidden = NO;
						
						[timeofDayBtn setBackgroundImage:[UIImage imageNamed:@"time_of_day_up.png"] forState:UIControlStateNormal];
						[sunrise_sunset_Btn setBackgroundImage:[UIImage imageNamed:@"sunrise_sunset_selected.png"] forState:UIControlStateNormal];
						
						sunriseBtn.hidden=NO;lblsunrise.hidden=NO;
						sunsetBtn.hidden=NO;lblsunset.hidden=NO;
						lblEventSliderValue.hidden=NO;eventSlider.hidden=NO;
						timerTextField.hidden = YES;timePickerBtn.hidden = YES;
						
						//Set sunrise or sunset
						if([[[maintenanceArray objectAtIndex:i]objectForKey:@"issunriseBool"] isEqualToString:@"YES"])
						{
							[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"selected_up.png"] forState:UIControlStateNormal];
							[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"not_selected_up.png"] forState:UIControlStateNormal];
						}
						else
						{
							[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"not_selected_up.png"] forState:UIControlStateNormal];
							[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"selected_up.png"] forState:UIControlStateNormal];
						}
						if([[[maintenanceArray objectAtIndex:i]objectForKey:@"sliderValue"] isEqualToString:@""])
						{
							eventSlider.value = 0;
							lblEventSliderValue.text = @"0";
							lblEventSliderValue.text = [lblEventSliderValue.text stringByAppendingString:@" minute(s)"];
						}
						else
						{
							eventSlider.value = [[[maintenanceArray objectAtIndex:i]objectForKey:@"sliderValue"] intValue];
							lblEventSliderValue.text = [[maintenanceArray objectAtIndex:i]objectForKey:@"sliderValue"];
							lblEventSliderValue.text = [lblEventSliderValue.text stringByAppendingString:@" minute(s)"];
						}
					}
				}
				
				//Set scenes textfield value for that schedule
				scenesTextField.text = [[maintenanceArray objectAtIndex:i]objectForKey:@"scenesTextField"];
				
				//Add containerview to scrollview
				[scrollsubView addSubview:containerView];
				[scrollsubView setContentSize:CGSizeMake(340, 750)];
				
				[lblSliderValue1,lblSliderValue2 release];
				
				[dayofWeekBtn,calendarDateBtn release];
				[timeofDayBtn,sunrise_sunset_Btn release];
				
				[sunriseBtn,sunsetBtn release];
				[eventSlider release];
				[lblEventSliderValue,lblsunrise,lblsunset,lblWeekorYear,lblYearlySelector,lblDateString release];
				[sunBtn,monBtn,tueBtn,wedBtn,thuBtn,friBtn,satBtn,allBtn release];
				
				[dateTextField,timerTextField,scenesTextField release];
				[datePickerBtn,timePickerBtn,TodatePickerBtn,scenesPickerBtn release];
				//[activationDaySegment release];
				//[activationTimeSegment release];
				[fromLbl release];
				[toLbl release];
				[TodateTextField release];
				[containerView release];
				[scrollsubView release];
			}
		}
		
		y =y+60+20;
		isSelected = NO;
		
		for(int j=0;j<[selectedSchedulesArray count];j++)
		{
			if(i==[[selectedSchedulesArray objectAtIndex:j] intValue])
			{
				UIButton * customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				customBtn.frame = CGRectMake(x+20, y, 110, 110);
				[customBtn setTag:i];
				if([[[scheduleArr objectAtIndex:i]objectForKey:@"enabled"] isEqualToString:@""]|| [[[scheduleArr objectAtIndex:i]objectForKey:@"enabled"] isEqualToString:@"0"])
					[customBtn setBackgroundImage:[UIImage imageNamed:@"schedule_icon_gray.png"] forState:UIControlStateNormal];
				else
					[customBtn setBackgroundImage:[UIImage imageNamed:@"schedule_icon.png"] forState:UIControlStateNormal];
				[customBtn addTarget:self action:@selector(ScheduleSelect:) forControlEvents:UIControlEventTouchUpInside];
				[scheduleScrollView addSubview:customBtn];
				[customBtn release];
				
				y = y+100+10;
				
				UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 160, 40)];
				lbl3.textColor = [UIColor whiteColor];
				lbl3.backgroundColor = [UIColor clearColor];
				lbl3.textAlignment = UITextAlignmentCenter;
				lbl3.lineBreakMode = UILineBreakModeWordWrap;
				lbl3.numberOfLines = 0;
				lbl3.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
				if([[[scheduleArr objectAtIndex:i]objectForKey:@"enabled"] isEqualToString:@""]|| [[[scheduleArr objectAtIndex:i]objectForKey:@"enabled"] isEqualToString:@"0"])
					lbl3.text = @"SCHEDULE DISABLED";
				else
					lbl3.text = @"SCHEDULE ENABLED";;
				[scheduleScrollView addSubview:lbl3];
				[lbl3 release];
				
				UIImageView *bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(x+10, y+50, 145, 200)];
				bg_image.image = [UIImage imageNamed:@"device_tools_background.png"];
				bg_image.alpha = 1.0;
				bg_image.contentMode = UIViewContentModeScaleToFill;
				[scheduleScrollView addSubview:bg_image];
				[bg_image release];
				
				y = y+40+20;
				
				UIButton * customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				customBtn1.frame = CGRectMake(x+30, y, 100, 30);
				[customBtn1 setTag:i];
				//[customBtn1 setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
				
				[customBtn1 setTitle:@"Save" forState:UIControlStateNormal];
				[customBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				//[customBtn1 setFont:[UIFont systemFontOfSize:12]];
				customBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
				[customBtn1 setBackgroundImage:[UIImage imageNamed:@"btnCommonSave.png"] forState:UIControlStateNormal];
				
				[customBtn1 addTarget:self action:@selector(ScheduleSave:) forControlEvents:UIControlEventTouchUpInside];
				[scheduleScrollView addSubview:customBtn1];
				[customBtn1 release];
				y = y+30+20;
				customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				customBtn1.frame = CGRectMake(x+30, y, 100, 30);
				[customBtn1 setTag:i];
				//[customBtn1 setBackgroundImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateNormal];
				[customBtn1 setTitle:@"Reset" forState:UIControlStateNormal];
				[customBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				//[customBtn1 setFont:[UIFont systemFontOfSize:12]];
				customBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
				[customBtn1 setBackgroundImage:[UIImage imageNamed:@"btnCommonSave.png"] forState:UIControlStateNormal];
				
				
				[customBtn1 addTarget:self action:@selector(ScheduleReset:) forControlEvents:UIControlEventTouchUpInside];
				[scheduleScrollView addSubview:customBtn1];
				[customBtn1 release];
				y = y+30+20;
				customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				customBtn1.frame = CGRectMake(x+30, y, 100, 30);
				[customBtn1 setTag:i];
				//[customBtn1 setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
				[customBtn1 setTitle:@"Delete" forState:UIControlStateNormal];
				[customBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				//[customBtn1 setFont:[UIFont systemFontOfSize:12]];
				customBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
				[customBtn1 setBackgroundImage:[UIImage imageNamed:@"btnCommonSave.png"] forState:UIControlStateNormal];
				
				[customBtn1 addTarget:self action:@selector(ScheduleDelete:) forControlEvents:UIControlEventTouchUpInside];
				[scheduleScrollView addSubview:customBtn1];
				[customBtn1 release];
				y = y+30+20;
				
				customBtn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
				customBtn1.frame = CGRectMake(x+30, y, 100, 30);
				[customBtn1 setTag:i];
				//[customBtn1 setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
				[customBtn1 setTitle:@"Close" forState:UIControlStateNormal];
				[customBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				//[customBtn1 setFont:[UIFont systemFontOfSize:12]];
				customBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
				[customBtn1 setBackgroundImage:[UIImage imageNamed:@"btnCommonSave.png"] forState:UIControlStateNormal];
				
				[customBtn1 addTarget:self action:@selector(ScheduleClose:) forControlEvents:UIControlEventTouchUpInside];
				[scheduleScrollView addSubview:customBtn1];
				[customBtn1 release];
				
				y = y+30+20;
				
				x = x + 180+340;
				
				isSelected = YES;
			}
		}
		
		 
		if(!isSelected)
		{
			UIButton * customBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			customBtn.frame = CGRectMake(x+20, y, 110, 110);
			[customBtn setTag:i];
			if([[[scheduleArr objectAtIndex:i]objectForKey:@"enabled"] isEqualToString:@""]|| [[[scheduleArr objectAtIndex:i]objectForKey:@"enabled"] isEqualToString:@"0"])
				[customBtn setBackgroundImage:[UIImage imageNamed:@"schedule_icon_gray.png"] forState:UIControlStateNormal];
			else
				[customBtn setBackgroundImage:[UIImage imageNamed:@"schedule_icon.png"] forState:UIControlStateNormal];
			[customBtn addTarget:self action:@selector(ScheduleSelect:) forControlEvents:UIControlEventTouchUpInside];
			[scheduleScrollView addSubview:customBtn];
			[customBtn release];
			
			y = y+100+10;
			
			UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 160, 40)];
			lbl3.textColor = [UIColor whiteColor];
			lbl3.backgroundColor = [UIColor clearColor];
			lbl3.textAlignment = UITextAlignmentCenter;
			lbl3.lineBreakMode = UILineBreakModeWordWrap;
			lbl3.numberOfLines = 0;
			lbl3.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
			if([[[scheduleArr objectAtIndex:i]objectForKey:@"enabled"] isEqualToString:@""]|| [[[scheduleArr objectAtIndex:i]objectForKey:@"enabled"] isEqualToString:@"0"])
				lbl3.text = @"SCHEDULE DISABLED";
			else
				lbl3.text = @"SCHEDULE ENABLED";
			[scheduleScrollView addSubview:lbl3];
			[lbl3 release];
			
			y = y+40+170;
			UIButton * editcustomBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			editcustomBtn.frame = CGRectMake(x+30, y, 100, 30);
			[editcustomBtn setTag:i];
			//[editcustomBtn setBackgroundImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
			[editcustomBtn setTitle:@"Edit" forState:UIControlStateNormal];
			[editcustomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			//[customBtn1 setFont:[UIFont systemFontOfSize:12]];
			editcustomBtn.titleLabel.font = [UIFont systemFontOfSize:12];
			[editcustomBtn setBackgroundImage:[UIImage imageNamed:@"btnCommonSave.png"] forState:UIControlStateNormal];
			
			[editcustomBtn addTarget:self action:@selector(ScheduleEdit:) forControlEvents:UIControlEventTouchUpInside];
			[scheduleScrollView addSubview:editcustomBtn];
			[editcustomBtn release];
			
			y = y+30+20;
			
			x= x + 170;
		}
		
		y=0;
		subx=0;suby=40;Newy=100;
		[scheduleScrollView setContentSize:CGSizeMake(x, 460)];
		
	}
	
	isLoadingSchedule = NO;
	[scheduleScrollView setContentOffset:LastOffsetPointScenes animated:NO];
}

- (void) alignLabelWithTop:(UILabel *)label {
	CGSize maxSize = CGSizeMake(label.frame.size.width, 999);
	label.adjustsFontSizeToFitWidth = NO;
	
	// get actual height
	CGSize actualSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
	CGRect rect = label.frame;
	rect.size.height = actualSize.height;
	label.frame = rect;
}

#pragma mark -
#pragma mark ADD SCHEDULE

-(IBAction)addScheduleClicked:(id)sender
{
	addScheduleTextField.text=@"";
	[self.view addSubview:addScheduleView];
}


-(IBAction)addScheduleCreateClicked:(id)sender
{
	//Send add schedule command to server and refresh all data after gettting success result
	if(![addScheduleTextField.text isEqualToString:@""]&&addScheduleTextField.text!=nil)
	{
		NSString *temp;
		temp= @"Created schedule named ";
		animationTitle.text = [temp stringByAppendingString:addScheduleTextField.text];
		[self showLoadingView];
		NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
		[commandDictionary setObject:addScheduleTextField.text forKey:@"name"];
		[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
		[commandDictionary setObject:@"false" forKey:@"randomized"];
		[commandDictionary setObject:@"0" forKey:@"startTime"];
		[commandDictionary setObject:@"false" forKey:@"enabled"];
		[[TimerService getSharedInstance]addTimer:commandDictionary :self];
		[commandDictionary release];
		[addScheduleView removeFromSuperview];
		LastOffsetPointScenes =  [scheduleScrollView contentOffset];
	}
	
}

-(IBAction)addScheduleCancelClicked:(id)sender
{
	[addScheduleView removeFromSuperview];
}

-(NSString*) FillLeadingZeros : (NSString *) eventId
{
	NSString *sResult;
	sResult=@"";
	if([eventId length] == 0 )
		sResult=@"0000";
	else if([eventId length] == 1 )
		sResult=@"000";
	else if([eventId length] == 2 )
		sResult=@"00";
	else if([eventId length] == 3 )
		sResult=@"0";
	
	sResult = [sResult stringByAppendingString:eventId];
	return sResult;
}


#pragma mark -
#pragma mark EDIT SCHEDULE NAME

-(void)ScheduleNameEdit:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	saveScheduleIndex = btn.tag;
	currScheduleId = [[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"id"]intValue ];
	editScheduleTextField.text	= [[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"name"];
	[self.view addSubview:editScheduleView];
}

//EDIT SCHEDULE
-(IBAction)editScheduleSaveClicked:(id)sender
{
	if(![editScheduleTextField.text isEqualToString:@""])
	{
		strInfoType = [[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"ScheduleInfoType"];
		if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[NSString stringWithFormat:@"%d",currScheduleId] forKey:@"id"];
			[commandDictionary setObject:editScheduleTextField.text forKey:@"name"];
			[[TimerService getSharedInstance]changeName:commandDictionary :self];
			[commandDictionary release];
			[editScheduleView removeFromSuperview];
		}
		else
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[NSString stringWithFormat:@"%d",currScheduleId] forKey:@"id"];
			[commandDictionary setObject:editScheduleTextField.text forKey:@"name"];
			[[EventsService getSharedInstance]changeName:commandDictionary :self];
			[commandDictionary release];
			[editScheduleView removeFromSuperview];
		}
		LastOffsetPointScenes =  [scheduleScrollView contentOffset];
		[self showLoadingView];
		animationTitle.text = @"Successfully changed the name of a schedule";
	}
}

-(IBAction)editScheduleCancelClicked:(id)sender
{
	[editScheduleView removeFromSuperview];
}

#pragma mark -
#pragma mark ENABLE/DISABLE SCHEDULE

-(void)ScheduleSelect:(id)sender
{
	//Send enable / disable schedule command based on schedule info type
	
	UIButton *btn = (UIButton*)sender;
	enableorDisableIndex = btn.tag;
	strInfoType = [[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"ScheduleInfoType"];
	if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
	{
		if([[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"enabled"] isEqualToString:@""]||[[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"enabled"] isEqualToString:@"0"])
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"id"] forKey:@"id"];
			[commandDictionary setObject:@"true" forKey:@"enabled"];
			[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
			[commandDictionary setObject:@"false" forKey:@"randomized"];
			[commandDictionary setObject:@"0" forKey:@"startTime"];
			[[TimerService getSharedInstance]enableTimer:commandDictionary :self];
			[commandDictionary release];
			animationTitle.text = [[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"name"] stringByAppendingString:@" was successfully enabled"];
		}
		else
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"id"] forKey:@"id"];
			[commandDictionary setObject:@"false" forKey:@"enabled"];
			[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
			[commandDictionary setObject:@"false" forKey:@"randomized"];
			[commandDictionary setObject:@"0" forKey:@"startTime"];
			[[TimerService getSharedInstance]enableTimer:commandDictionary :self];
			[commandDictionary release];
			animationTitle.text =[[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"name"] stringByAppendingString:@" was successfully disabled"]; 
		}
		
	}
	else
	{
		if([[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"enabled"] isEqualToString:@""]||[[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"enabled"] isEqualToString:@"0"])
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"id"] forKey:@"id"];
			[commandDictionary setObject:@"true" forKey:@"enabled"];
			[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
			[commandDictionary setObject:@"false" forKey:@"randomized"];
			[commandDictionary setObject:@"0" forKey:@"startTime"];
			[[EventsService getSharedInstance]enable:commandDictionary :self];
			[commandDictionary release];
			animationTitle.text = [[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"name"] stringByAppendingString:@" was successfully enabled"];
		}
		else
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"id"] forKey:@"id"];
			[commandDictionary setObject:@"false" forKey:@"enabled"];
			[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
			[commandDictionary setObject:@"false" forKey:@"randomized"];
			[commandDictionary setObject:@"0" forKey:@"startTime"];
			[[EventsService getSharedInstance]enable:commandDictionary :self];
			[commandDictionary release];
			animationTitle.text = [[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag]objectForKey:@"name"] stringByAppendingString:@" was successfully disabled"];
		}
		
	}
	LastOffsetPointScenes =  [scheduleScrollView contentOffset];
	[self showLoadingView];
	
	
}

#pragma mark -
#pragma mark SAVE SCHEDULE CHANGES

-(void)ScheduleSave:(id)sender
{
	[self showLoadingView];
	animationTitle.text = @"Saved schedule successfully";
	UIButton *button = (UIButton*)sender;
	saveScheduleIndex = button.tag;
	[self saveScheduleOneByOne];
}

-(void)saveScheduleOneByOne
{
	isTimerToEvent = NO;
	isSaveSchedule = YES;
	saveScheduleTimer = [NSTimer scheduledTimerWithTimeInterval:0 
													target:self 
													selector:@selector(saveScheduleTask) 
												  userInfo:nil 
												   repeats:YES];
	saveScheduleEnum = NONE;
}

-(void)saveScheduleTask
{
	switch(saveScheduleEnum)
	{
		case NONE:
		{
			
			//Load change mask for corresponding schedule
			_changeMask = [[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"_changeMask"] intValue];
			strInfoType = [[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"ScheduleInfoType"];
			saveScheduleEnum = SCH_CHECK_TIMER_EVENT_CHANGE;
			break;
			
		}
		case SCH_CHECK_TIMER_EVENT_CHANGE:
		{
			if([[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"PreviousisTimeofday"] isEqualToString:@"YES"]&&[[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"isTimeofday"] isEqualToString:@"NO"])//Time to Event
			{	isTimerToEvent = YES;
				isTimerorEventChange = NO;
				saveScheduleEnum = SCH_CHECK_SCENE_CHANGE;
				strInfoType = @"ScheduleEventInfo";
			}
			else if([[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"PreviousisTimeofday"] isEqualToString:@"NO"]&&[[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"isTimeofday"] isEqualToString:@"YES"])//Event to Time
			{	isTimerToEvent = NO;
				isTimerorEventChange = NO;
				saveScheduleEnum = SCH_CHECK_SCENE_CHANGE;
				strInfoType = @"ScheduleTimerInfo";
			}
			else 
			{
				saveScheduleEnum = SCH_SET_DAYS_MASK;
				isTimerorEventChange = YES;
			}
			break;
		}
		case SCH_CHECK_SCENE_CHANGE:
		{
			if ((_changeMask & ASSOCIATED_SCENE_CHANGE )&&!([[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"scenesTextField"] isEqualToString:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"PreviousscenesTextField"]]))
			{
				if(isTimerorEventChange == NO)
				{
					if([[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"ScheduleInfoType"] isEqualToString:@"ScheduleTimerInfo"])
					{
						//INCLUDE_SCENE command
						NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"intoID"];
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"PreviousscenesTextFieldID"] forKey:@"scene"];
						[commandDictionary setObject:@"0" forKey:@"include"];
						[[TimerService getSharedInstance]includeScene:commandDictionary :self];
						[commandDictionary release];
						saveScheduleEnum = PROCESSING_SCH_CHECK_SCENE_CHANGE;
					}
					else
					{
						//EVENT_SCENE_INCLUDE command
						NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"intoID"];
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"PreviousscenesTextFieldID"] forKey:@"scene"];
						[commandDictionary setObject:@"0" forKey:@"include"];
						[[EventsService getSharedInstance]sceneInclude:commandDictionary :self];
						[commandDictionary release];
						saveScheduleEnum = PROCESSING_SCH_CHECK_SCENE_CHANGE;
					}
				}
				else {
					saveScheduleEnum = SCH_REMOVE_SCHUDLE;
				}
			}
			else {
				saveScheduleEnum = SCH_REMOVE_SCHUDLE;
			}
			break;
		}
		case SCH_REMOVE_SCHUDLE:
		{
			if(isTimerToEvent)//Change from time to event REMOVE command
			{
				//REMOVE command
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"id"];	
				[commandDictionary setObject:@"false" forKey:@"getList"];
				[[TimerService getSharedInstance]removeTimerFromController:commandDictionary :self];
				[commandDictionary release];
			}
			else //Change from event to time EVENT_REMOVE command
			{
				//EVENT_REMOVE command
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"id"];	
				[commandDictionary setObject:@"false" forKey:@"getList"];
				[[EventsService getSharedInstance]eventRemove:commandDictionary :self];
				[commandDictionary release];
			}
			saveScheduleEnum = PROCESSING;
			break;
			
		}
		case SCH_ADD_SCHUDLE:
		{
			if(isTimerToEvent)//Add a Event Schedule
			{
				//EVENT_ADD command
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"name"] forKey:@"name"];
				if([[maintenanceArray objectAtIndex:saveScheduleIndex]objectForKey:@"_currentDays"]!=nil)
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex]objectForKey:@"_currentDays"] forKey:@"daysActiveMask"];
				else
					[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
				[commandDictionary setObject:@"false" forKey:@"enabled"];
				[[EventsService getSharedInstance]add:commandDictionary :self];
				[commandDictionary release];
			}
			else //Add a Timer Schedule
			{
				//ADD_TIMER send add timer command to server
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				if([[maintenanceArray objectAtIndex:saveScheduleIndex]objectForKey:@"startTime"]!=nil)
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex]objectForKey:@"startTime"] forKey:@"startTime"];
				else
					[commandDictionary setObject:@"0" forKey:@"startTime"];
				if([[maintenanceArray objectAtIndex:saveScheduleIndex]objectForKey:@"_currentDays"]!=nil)
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex]objectForKey:@"_currentDays"] forKey:@"daysActiveMask"];
				else
					[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
				[commandDictionary setObject:@"false" forKey:@"enabled"];
				[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"name"] forKey:@"name"];
				[commandDictionary setObject:@"false" forKey:@"randomized"];
				[[TimerService getSharedInstance]addTimer:commandDictionary :self];
				[commandDictionary release];
			}
			saveScheduleEnum = PROCESSING;
			break;
			
		}
		case SCH_EVENT_TRIG_DEVICE:
		{
			//EVENT_SET_TRIGGER_DEVICE send command to server
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:@"1" forKey:@"deviceID"];
			[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"eventID"];
			[[EventsService getSharedInstance]setTriggerDevice:commandDictionary :self];
			[commandDictionary release];
			saveScheduleEnum = PROCESSING;
			break;
		}
		case SCH_SET_DAYS_MASK:
		{
			
			//Need to set up the tasks for the save based on the change mask
			//if (_changeMask & DAY_MASK_CHANGE || isTimerorEventChange == YES)
			if (_changeMask & DAY_MASK_CHANGE || isTimerorEventChange == NO)
			{
				if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
				{
					//SET_DAYS_MASK command
					NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"id"];	
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"id"];
					[commandDictionary setObject:@"0" forKey:@"startTime"];
					[commandDictionary setObject:@"false" forKey:@"enabled"];
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"_currentDays"] forKey:@"daysActiveMask"];
					[commandDictionary setObject:@"false" forKey:@"randomized"];
					[[TimerService getSharedInstance]setDaysMask:commandDictionary :self];
					[commandDictionary release];
					saveScheduleEnum = PROCESSING;
				}
				else
				{
					//EVENT_SET_DAYS_MASK command
					NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
					[commandDictionary setObject:@"0" forKey:@"numCondsInEvent"];
					[commandDictionary setObject:@"false" forKey:@"enabled"];
					[commandDictionary setObject:@"0" forKey:@"sunriseSunsetOffset"];
					[commandDictionary setObject:@"" forKey:@"associatedConditions"];
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"_currentDays"] forKey:@"daysActiveMask"];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"id"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"id"];
					[commandDictionary setObject:@"0" forKey:@"numScenesInEvent"];
					[commandDictionary setObject:@"0" forKey:@"sunriseOrSunset"];
					[[EventsService getSharedInstance]setDaysMask:commandDictionary :self];
					[commandDictionary release];
					saveScheduleEnum = PROCESSING;
				}
				
				//_taskGroup.addTask( new ScheduleSaveDayMaskTask ( timerService, info ) );
				//_taskGroup.addTask( new SetEventTriggerDayMaskTask ( eventsService, info.daysActiveMask, eventId ) );
			}
			else
				saveScheduleEnum = SCH_SET_METADATA;
			
			break;
		}
			
		case SCH_SET_METADATA:
		{
			//Add the task to change the meta data
			if (_changeMask & METADATA_CHANGE|| isTimerorEventChange == NO)
			{
				NSString *strMetaData = @"";
				NSString *startDate = [[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"dateTextField"];
				NSString *endDate = [[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"TodateTextField"];
				NSArray *array = [startDate componentsSeparatedByString:@"-"];
				if([array count]>2)
				{
					strMetaData = [@"sDate." stringByAppendingString:[array objectAtIndex:0]];
					strMetaData = [strMetaData stringByAppendingString:[array objectAtIndex:1]];
				}
				array = [endDate componentsSeparatedByString:@"-"];
				if([array count]>2)
				{
					strMetaData = [strMetaData stringByAppendingString:@"eDate."];
					strMetaData = [strMetaData stringByAppendingString:[array objectAtIndex:0]];
					strMetaData = [strMetaData stringByAppendingString:[array objectAtIndex:1]];
				}
				
				//SET_METADATA command
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				
				if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
					[commandDictionary setObject:@"3" forKey:@"metaDataType"];
				else
					[commandDictionary setObject:@"2" forKey:@"metaDataType"];
				
				if(	startDate!= nil && ![startDate isEqualToString:@""])
					[commandDictionary setObject:strMetaData forKey:@"metaData"];
				
				if(isTimerorEventChange)
					[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"relatedID"];
				else
					[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"relatedID"];
				[[ConfigurationService getSharedInstance]setMetaData:commandDictionary :self];
				[commandDictionary release];
				saveScheduleEnum = PROCESSING;
			}
			else 
				saveScheduleEnum = SCH_TIMER_RANDOMIZE;
			break;
		}
		case SCH_TIMER_RANDOMIZE:
		{
			//Add the task to change the randomize setting of the schedule
			if (_changeMask & RANDOMIZE_CHANGE)
			{
				if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
				{
					//TIMER_RANDOMIZE command
					NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"id"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"id"];
					[commandDictionary setObject:@"0" forKey:@"startTime"];
					[commandDictionary setObject:@"false" forKey:@"enabled"];
					[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
					if([[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"isRandomize"] isEqualToString:@"YES"])
						[commandDictionary setObject:@"true" forKey:@"randomized"];
					else
						[commandDictionary setObject:@"false" forKey:@"randomized"];
					[[TimerService getSharedInstance]randomizeTimer:commandDictionary :self];
					[commandDictionary release];
					saveScheduleEnum = PROCESSING;
				}
				else
					saveScheduleEnum =SCH_START_CHANGE;
			}
			else 
				saveScheduleEnum = SCH_START_CHANGE;
			break;
		}
		case SCH_START_CHANGE:
		{
			//Add the start change 
			if (_changeMask & START_CHANGE || isTimerorEventChange == NO)
			{
				//_taskGroup.addTask( new ScheduleSaveStartTimeTask ( timerService, info ) );
				
				if([strInfoType isEqualToString:@"ScheduleTimerInfo"]&&isTimerToEvent==NO)
				{
					//SET_TIME command
					NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
					[commandDictionary setObject:@"false" forKey:@"enabled"];
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"startTime"] forKey:@"startTime"];
					[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"id"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"id"];
					[commandDictionary setObject:@"false" forKey:@"randomized"];
					[[TimerService getSharedInstance]setTime:commandDictionary :self];
					[commandDictionary release];
					saveScheduleEnum = PROCESSING;
				}
				
				else 
					saveScheduleEnum = SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE;
				
			}
			else {
				saveScheduleEnum = SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE;
			}
			break;
			
		}
		case SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE:
		{
			//Add the task to add an associated scene
			
			if(isTimerorEventChange==NO)
			{
				saveScheduleEnum = SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE;
			}
			else
			{
				if ((_changeMask & ASSOCIATED_SCENE_CHANGE )&&!([[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"scenesTextField"] isEqualToString:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"PreviousscenesTextField"]]))
				{
					if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
					{
						//INCLUDE_SCENE command
						NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
						if(isTimerorEventChange)
							[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"intoID"];
						else
							[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"intoID"];
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"PreviousscenesTextFieldID"] forKey:@"scene"];
						[commandDictionary setObject:@"0" forKey:@"include"];
						[[TimerService getSharedInstance]includeScene:commandDictionary :self];
						[commandDictionary release];
						saveScheduleEnum = PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE;
					}
					else
					{
						//EVENT_SCENE_INCLUDE command
						NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
						if(isTimerorEventChange)
							[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"intoID"];
						else
							[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"intoID"];
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"PreviousscenesTextFieldID"] forKey:@"scene"];
						[commandDictionary setObject:@"0" forKey:@"include"];
						[[EventsService getSharedInstance]sceneInclude:commandDictionary :self];
						[commandDictionary release];
						saveScheduleEnum = PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE;
					}
				}
				else {
					saveScheduleEnum = SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE;
				}
			}
			break;
		}
		case SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE:
		{
			//Add the task to add an associated scene
			if (_changeMask & ASSOCIATED_SCENE_CHANGE)
			{
				if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
				{
					//INCLUDE_SCENE command
					NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"intoID"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"intoID"];
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"scenesTextFieldID"] forKey:@"scene"];
					[commandDictionary setObject:@"1" forKey:@"include"];
					[[TimerService getSharedInstance]includeScene:commandDictionary :self];
					[commandDictionary release];
					saveScheduleEnum = PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE;
				}
				else
				{
					//EVENT_SCENE_INCLUDE command
					NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"intoID"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"intoID"];
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"scenesTextFieldID"] forKey:@"scene"];
					[commandDictionary setObject:@"1" forKey:@"include"];
					[[EventsService getSharedInstance]sceneInclude:commandDictionary :self];
					[commandDictionary release];
					saveScheduleEnum = PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE;
				}
			}
			else {
				saveScheduleEnum = SCH_SUNRISE_SUNSET_OFFSET_CHANGE;
			}
			break;
		}
		case SCH_SUNRISE_SUNSET_OFFSET_CHANGE:
		{
			//Add the task to set the offset for the sunrise and sunset
			if (_changeMask & SUNRISE_SUNSET_OFFSET_CHANGE || isTimerorEventChange == NO)
			{
				if([strInfoType isEqualToString:@"ScheduleEventInfo"]||isTimerToEvent==YES)
				{
					//EVENT_SET_TIME command
					NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
					[commandDictionary setObject:@"0" forKey:@"trigDeviceID"];
					[commandDictionary setObject:@"0" forKey:@"condType"];
					[commandDictionary setObject:@"0" forKey:@"timeStart"];
					if([[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"sliderValue"] != nil)
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"sliderValue"] forKey:@"modifiable"];
					else
						[commandDictionary setObject:@"0" forKey:@"modifiable"];
					[commandDictionary setObject:@"0" forKey:@"trigReasonID"];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"eventID"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"eventID"];
					[commandDictionary setObject:@"0" forKey:@"timeEnd"];
					[commandDictionary setObject:@"0" forKey:@"id"];
					[[EventsService getSharedInstance]setTime:commandDictionary :self];
					[commandDictionary release];
					saveScheduleEnum = PROCESSING;
				}
				else {
					saveScheduleEnum = SCH_SUNRISE_SUNSET_TIME_CHANGE;
				}
			}
			else {
				saveScheduleEnum = SCH_SUNRISE_SUNSET_TIME_CHANGE;
			}
			break;
		}
		case SCH_SUNRISE_SUNSET_TIME_CHANGE:
		{
			//Add the task to set the time change on the sunrise and sunset
			if (_changeMask & SUNRISE_SUNSET_TIME_CHANGE || isTimerorEventChange == NO)
			{
				if([strInfoType isEqualToString:@"ScheduleEventInfo"]||isTimerToEvent==YES)
				{
					//EVENT_SET_TRIGGER_REASON command
					NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
					if([[[maintenanceArray objectAtIndex:saveScheduleIndex] objectForKey:@"issunriseBool"] isEqualToString:@"YES"])
						[commandDictionary setObject:@"1" forKey:@"reasonID"];
					else
						[commandDictionary setObject:@"2" forKey:@"reasonID"];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] forKey:@"eventID"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"eventID"];
					[[EventsService getSharedInstance]setTriggerDeviceReason:commandDictionary :self];
					[commandDictionary release];
					saveScheduleEnum = PROCESSING;
				}
				else
					saveScheduleEnum = DONE;
			}
			else
				saveScheduleEnum = DONE;
			break;
		}
			
		case DONE:
		{
			[self saveScheduleTaskComplete];
			[self initialLoad];
			//[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}

-(void)saveScheduleTaskComplete
{
	[saveScheduleTimer invalidate];
	saveScheduleTimer=nil;
}



-(void)changeDaysActiveMask:(int)mask :(NSMutableDictionary*)dictionary
{
	//Need to change the value stored for the change mask in 
	//presentation model
	int newMaskValue = mask;
	
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	//ScheduleChangeMaskEnum
	if ( !( _changeMask & DAY_MASK_CHANGE ) )
		_changeMask = _changeMask ^ DAY_MASK_CHANGE;
	
	if ( ( [[dictionary objectForKey:@"_currentDays"] intValue] == newMaskValue ) && ( _changeMask & DAY_MASK_CHANGE ) )
	{
		_changeMask = _changeMask ^ DAY_MASK_CHANGE;
	}
	
	[dictionary setObject:[NSString stringWithFormat:@"%d",newMaskValue] forKey:@"_currentDays"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
}

-(void)changeDateRange:(NSString*)strDate :(NSMutableDictionary*)dictionary
{
	NSString *strDateString;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
	
	//TODO:Need to check to see if 
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	
	if ( ! ( _changeMask & METADATA_CHANGE ) )
		_changeMask = _changeMask ^ METADATA_CHANGE;
	
	//Need to check to see if it is the same start and end date in the 
	//memento
	
	if ( ( [[dictionary objectForKey:@"dateTextField"] isEqualToString:strDate]) && ( _changeMask & METADATA_CHANGE ) )
		_changeMask = _changeMask ^ METADATA_CHANGE;

	[dictionary setObject:strDate forKey:@"dateTextField"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	//dispatchEvent ( new Event (Event.CHANGE ) );
	
	
	//To display as date string label
	if([[dictionary objectForKey:@"dateTextField"] isEqualToString:@""]||[dictionary objectForKey:@"dateTextField"]==nil)
	{
		[dictionary setObject:[dictionary objectForKey:@"TodateTextField"] forKey:@"dateTextField"];
	}
	[dateFormatter setDateFormat:@"MM-dd-yyyy"];
	NSDate *newDate = [dateFormatter dateFromString:[dictionary objectForKey:@"dateTextField"]];
	[dateFormatter setDateFormat:@"MMM dd,yyy"];
	strDateString = [dateFormatter stringFromDate:newDate];
	
	//Separator between two dates
	strDateString = [strDateString stringByAppendingString:@"  -  "];
	
	//To display as date string label
	if([[dictionary objectForKey:@"TodateTextField"] isEqualToString:@""]||[dictionary objectForKey:@"TodateTextField"]==nil)
	{
		[dictionary setObject:[dictionary objectForKey:@"dateTextField"] forKey:@"TodateTextField"];
	}
	[dateFormatter setDateFormat:@"MM-dd-yyyy"];
	newDate = [dateFormatter dateFromString:[dictionary objectForKey:@"TodateTextField"]];
	[dateFormatter setDateFormat:@"MMM dd,yyy"];
	strDateString = [strDateString stringByAppendingString:[dateFormatter stringFromDate:newDate]];
	[dictionary setObject:strDateString forKey:@"DateString"];
	
	
	
	[dateFormatter release];
}

-(void)changeToDateRange:(NSString*)strDate :(NSMutableDictionary*)dictionary
{
	NSString *strDateString;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
	
	//TODO:Need to check to see if 
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	
	if ( ! ( _changeMask & METADATA_CHANGE ) )
		_changeMask = _changeMask ^ METADATA_CHANGE;
	
	//Need to check to see if it is the same start and end date in the 
	//memento
	
	if ( ( [[dictionary objectForKey:@"TodateTextField"] isEqualToString:strDate]) && ( _changeMask & METADATA_CHANGE ) )
		_changeMask = _changeMask ^ METADATA_CHANGE;
	
	[dictionary setObject:strDate forKey:@"TodateTextField"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	//dispatchEvent ( new Event (Event.CHANGE ) );
	
	
	//To display as date string label
	if([[dictionary objectForKey:@"dateTextField"] isEqualToString:@""]||[dictionary objectForKey:@"dateTextField"]==nil)
	{
		[dictionary setObject:[dictionary objectForKey:@"TodateTextField"] forKey:@"dateTextField"];
	}
	[dateFormatter setDateFormat:@"MM-dd-yyyy"];
	NSDate *newDate = [dateFormatter dateFromString:[dictionary objectForKey:@"dateTextField"]];
	[dateFormatter setDateFormat:@"MMM dd,yyy"];
	strDateString = [dateFormatter stringFromDate:newDate];
	
	//Separator between two dates
	strDateString = [strDateString stringByAppendingString:@"  -  "];
	
	//To display as date string label
	if([[dictionary objectForKey:@"TodateTextField"] isEqualToString:@""]||[dictionary objectForKey:@"TodateTextField"]==nil)
	{
		[dictionary setObject:[dictionary objectForKey:@"dateTextField"] forKey:@"TodateTextField"];
	}
	[dateFormatter setDateFormat:@"MM-dd-yyyy"];
	newDate = [dateFormatter dateFromString:[dictionary objectForKey:@"TodateTextField"]];
	[dateFormatter setDateFormat:@"MMM dd,yyy"];
	strDateString = [strDateString stringByAppendingString:[dateFormatter stringFromDate:newDate]];
	[dictionary setObject:strDateString forKey:@"DateString"];
	
	

	[dateFormatter release];
}


-(void)changeActivateTime:(NSMutableDictionary*)dictionary
{
	//Now that we are changing the activate time, we are 
	//going to need to pass in the information to the
	
	int currentTimeinSec=0,hours;
	NSString *currentTimeString = [dictionary objectForKey:@"timerTextField"];
	
	if ([currentTimeString rangeOfString:@"AM"].location == NSNotFound) 
	{
		hours = 12;
	}
	else
	{
		hours = 0;
	}
	
	currentTimeString = [currentTimeString stringByReplacingOccurrencesOfString:@"AM" withString:@""];
	currentTimeString = [currentTimeString stringByReplacingOccurrencesOfString:@"PM" withString:@""];
	currentTimeString = [currentTimeString stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	NSArray *HousMins = [currentTimeString componentsSeparatedByString:@":"];
	if([HousMins count]>1)
	{
		hours+= [[HousMins objectAtIndex:0]intValue];
		currentTimeinSec = [[TimeConverterUtil getSharedInstance]convertTimeToMinutesAfterMidnight:hours :[[HousMins objectAtIndex:1]intValue]];
	}

	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	//Set the change mask if it is not currently set
	if ( !( _changeMask & START_CHANGE ) )
		_changeMask = _changeMask ^ START_CHANGE;
	
	//Need to check the memento to see if it is the same if it is set the bit mask back
	//off
	if ( ( [[dictionary objectForKey:@"startTime"] intValue] == currentTimeinSec ) && ( _changeMask & START_CHANGE ) )
		_changeMask = _changeMask ^ START_CHANGE;
	
	//Store the new value
	[dictionary setObject:[NSString stringWithFormat:@"%d",currentTimeinSec] forKey:@"startTime"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	//Need to dispatch an event that the info changedNS
	//dispatchEvent ( new Event ( Event.CHANGE ) );
	
	
}

-(void)changeSelectedScene:(NSString*)strSceneName :(NSString*)strSceneId :(NSMutableDictionary*)dictionary
{
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	//Set up everything to change the scene
	if ( ! ( _changeMask & ASSOCIATED_SCENE_CHANGE ) )
		_changeMask = _changeMask ^ ASSOCIATED_SCENE_CHANGE;
	
	if ( ( [[dictionary objectForKey:@"scenesTextField"] isEqualToString:strSceneName]) && ( _changeMask & ASSOCIATED_SCENE_CHANGE ) )
		_changeMask = _changeMask ^ ASSOCIATED_SCENE_CHANGE;	
	
	if([dictionary objectForKey:@"PreviousscenesTextField"]==nil&&[dictionary objectForKey:@"scenesTextField"]==nil)
	{
		//Store the new scene values
		[dictionary setObject:strSceneName forKey:@"scenesTextField"];
		[dictionary setObject:strSceneId forKey:@"scenesTextFieldID"];
		[dictionary setObject:strSceneName forKey:@"PreviousscenesTextField"];
		[dictionary setObject:strSceneId forKey:@"PreviousscenesTextFieldID"];
		[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	}
	else
	{
		if([dictionary objectForKey:@"PreviousscenesTextField"]!=nil)
		{
			//Store previous scene name and id
			[dictionary setObject:[dictionary objectForKey:@"scenesTextField"] forKey:@"PreviousscenesTextField"];
			[dictionary setObject:[dictionary objectForKey:@"scenesTextFieldID"] forKey:@"PreviousscenesTextFieldID"];
			//Store the new scene values
			[dictionary setObject:strSceneName forKey:@"scenesTextField"];
			[dictionary setObject:strSceneId forKey:@"scenesTextFieldID"];
			[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
		}
	}
}

-(void)changeSunriseSunset:(NSString*)state :(NSMutableDictionary*)dictionary
{
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	//Set the change mask if it is not currently set
	if ( !( _changeMask & SUNRISE_SUNSET_TIME_CHANGE ) )
		_changeMask = _changeMask ^ SUNRISE_SUNSET_TIME_CHANGE;
	
	//Need to check the memento to see if it is the same if it is set the bit mask back
	//off
	if ( ( [[dictionary objectForKey:@"issunriseBool"] isEqualToString:state] ) && ( _changeMask & SUNRISE_SUNSET_TIME_CHANGE ) )
		_changeMask = _changeMask ^ SUNRISE_SUNSET_TIME_CHANGE;
	
	//Store the new value
	[dictionary setObject:state forKey:@"issunriseBool"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	
	//dispatchEvent ( new Event ( Event.CHANGE ) );			
}

-(void)changeSunriseSunsetOffset:(int)offsetValue :(NSMutableDictionary*)dictionary
{
	int newSunriseSunsetOffset = offsetValue;
	
	//Load change mask for corresponding schedule
	_changeMask = [[dictionary objectForKey:@"_changeMask"] intValue];
	
	//Set the change mask if it is not currently set
	if ( !( _changeMask & SUNRISE_SUNSET_OFFSET_CHANGE ) )
		_changeMask = _changeMask ^ SUNRISE_SUNSET_OFFSET_CHANGE;
	
	//Need to check the memento to see if it is the same if it is set the bit mask back
	//off
	if ( ( [[dictionary objectForKey:@"sliderValue"] intValue] == newSunriseSunsetOffset ) && ( _changeMask & SUNRISE_SUNSET_OFFSET_CHANGE ) )
		_changeMask = _changeMask ^ SUNRISE_SUNSET_OFFSET_CHANGE;
	
	//Store the new value	
	[dictionary setObject:[NSString stringWithFormat:@"%d",newSunriseSunsetOffset] forKey:@"sliderValue"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	
	//dispatchEvent ( new Event ( Event.CHANGE ) );			
}

-(void)toggleRandomized:(NSString*)boolValue:(NSMutableDictionary*)dictionary
{
	//Set the change mask if it is not currently set
	if ( !( _changeMask & RANDOMIZE_CHANGE ) )
		_changeMask = _changeMask ^ RANDOMIZE_CHANGE;
	
	//Need to check the memento to see if it is the same if it is set the bit mask back
	//off
	if ( ( [[dictionary objectForKey:@"isRandomize"] isEqualToString:boolValue] ) && ( _changeMask & RANDOMIZE_CHANGE ) )
		_changeMask = _changeMask ^ RANDOMIZE_CHANGE;
	
	//Store the new value
	[dictionary setObject:boolValue forKey:@"isRandomize"];
	[dictionary setObject:[NSString stringWithFormat:@"%d",_changeMask] forKey:@"_changeMask"];
	
	//dispatchEvent ( new Event ( Event.CHANGE ) );		
}


#pragma mark -
#pragma mark RESET SCHEDULE

-(void)ScheduleReset:(id)sender
{
	LastOffsetPointScenes =  [scheduleScrollView contentOffset];
	[self InitializeDefaultScheduleValues];
	[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
}

#pragma mark -
#pragma mark DELETE SCHEDULE

-(void)ScheduleDelete:(id)sender
{
	
	UIButton *btn = (UIButton*)sender;
	deleteScheduleIndex = btn.tag;
	LastOffsetPointScenes =  [scheduleScrollView contentOffset];
	animationTitle.text = @"Successfully deleted a schedule";
	//Set current g_formatScheduleList id as currScheduleId
	currScheduleId = [[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:btn.tag] objectForKey:@"id"] intValue];
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" 
												   message:@"Do you really want to delete this schedule ?" 
												  delegate:self 
										 cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
}



#pragma mark -
#pragma mark EDIT SCHEDULE OPEN WINDOW

-(void)ScheduleEdit:(id)sender
{
	_changeMask = 0;
	isScheduleScrollSelect = YES;
	BOOL isExists = NO;
	int ExistIndex,selCount=0;
	UIButton *btn = (UIButton*)sender;
	int TagVal =  btn.tag;
	for(int i=0;i<[selectedSchedulesArray count];i++)
	{
		if(TagVal==[[selectedSchedulesArray objectAtIndex:i] intValue])
		{
			isExists = YES;
			ExistIndex = i;
			break;
		}
	}
	currentSceneEditIndex = TagVal;

	if(isExists)
		[selectedSchedulesArray removeObjectAtIndex:ExistIndex];
	else
		[selectedSchedulesArray addObject:[NSString stringWithFormat:@"%d",TagVal]];
	
	
	
    //Hint
    for(int m=0;m<[selectedSchedulesArray count];m++)
    {
        if([[selectedSchedulesArray objectAtIndex:m]intValue] <=TagVal)
            selCount++;
    }
    if((xposition+350)>((TagVal*172)+((selCount-1)*340)))
    {
        int Currpos = xposition;//TagVal*165;
        LastOffsetPointSchedule = CGPointMake(Currpos,0);
    }
    else if(((xposition+350)<((TagVal*172)+((selCount-1)*340))) && ((xposition+500)>((TagVal*172)+((selCount-1)*340))))
    {
        int Currpos = xposition+150;//TagVal*165;
        LastOffsetPointSchedule = CGPointMake(Currpos,0);
    }
    else
    {
		int currentSceneEditWidth = (TagVal * 168) + 168 +((selCount-1) * 340);//142 width of one scene bg + gap
		int curWidth = currentSceneEditWidth - xposition;
		int widthToAdd = (curWidth+340)-940;
		int Currpos = xposition + widthToAdd;
		LastOffsetPointSchedule = CGPointMake(Currpos,0);
    }
    selCount=0;
    [self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
}

#pragma mark -
#pragma mark EDIT SCHEDULE CLOSE WINDOW

-(void)ScheduleClose:(id)sender
{
	isScheduleScrollSelect = YES;
	BOOL isExists = NO;
	int ExistIndex;
	UIButton *btn = (UIButton*)sender;
	int TagVal =  btn.tag;
	for(int i=0;i<[selectedSchedulesArray count];i++)
	{
		if(TagVal==[[selectedSchedulesArray objectAtIndex:i] intValue])
		{
			isExists = YES;
			ExistIndex = i;
			break;
		}
	}
	if(isExists)
		[selectedSchedulesArray removeObjectAtIndex:ExistIndex];
	else
		[selectedSchedulesArray addObject:[NSString stringWithFormat:@"%d",TagVal]];
	
	[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	if(LastOffsetPointSchedule.x < 100 || scheduleScrollView.contentSize.width<940)
	{
		LastOffsetPointSchedule.x = 0;
		LastOffsetPointSchedule.y =0;
		[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	else {
		[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	
	//[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	if(scrollView==scheduleScrollView)
	{
		if(!isScheduleScrollSelect)
		{
			LastOffsetPointSchedule =  [scheduleScrollView contentOffset];
		}
	}
    xposition =scrollView.contentOffset.x;
}

#pragma mark -
#pragma mark PICKER DELEGATES

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	// This method needs to be used. It asks how many columns will be used in the UIPickerView
	return 1; // We only need one column so we will return 1.
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	return [[[AppDelegate_iPad sharedAppDelegate] g_ScenesArray] count]; // We will need the amount of rows that we used in the pickerViewArray, so we will return the count of the array.
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	return [[[[AppDelegate_iPad sharedAppDelegate] g_ScenesArray] objectAtIndex:row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { 
	scenePickerRowIndex = row;
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

/*-(void)activationDaySegmentAction:(id)sender
{
	if(!isLoadingSchedule)
	{
		isScheduleScrollSelect = YES;
		UISegmentedControl *segControl = (UISegmentedControl*)sender;
		switch ([sender selectedSegmentIndex]) {
			case 0:
			{
				NSMutableDictionary *dict = [maintenanceArray objectAtIndex:segControl.tag];
				[dict setObject:@"YES" forKey:@"isWeekdaySelector"];
				[maintenanceArray replaceObjectAtIndex:segControl.tag withObject:dict];
				break;
			}
			case 1:
			{
				NSMutableDictionary *dict = [maintenanceArray objectAtIndex:segControl.tag];
				[dict setObject:@"NO" forKey:@"isWeekdaySelector"];
				[maintenanceArray replaceObjectAtIndex:segControl.tag withObject:dict];
				break;
			}
			default:
				break;
		}
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
		[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
		isScheduleScrollSelect = NO;
	}
}*/

-(void)dayofWeekBtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	isScheduleScrollSelect = YES;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:btn.tag];
	[dict setObject:@"YES" forKey:@"isWeekdaySelector"];
	[maintenanceArray replaceObjectAtIndex:btn.tag withObject:dict];
	[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
}

-(void)calendarDateBtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	isScheduleScrollSelect = YES;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:btn.tag];
	[dict setObject:@"NO" forKey:@"isWeekdaySelector"];
	[maintenanceArray replaceObjectAtIndex:btn.tag withObject:dict];
	[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
}





/*-(void)activationTimeSegmentAction:(id)sender
{
	if(!isLoadingSchedule)
	{
		isScheduleScrollSelect = YES;
		UISegmentedControl *segControl = (UISegmentedControl*)sender;
		switch ([sender selectedSegmentIndex]) {
			case 0:
			{
				NSMutableDictionary *dict = [maintenanceArray objectAtIndex:segControl.tag];
				[dict setObject:[dict objectForKey:@"isTimeofday"] forKey:@"PreviousisTimeofday"];
				[dict setObject:@"YES" forKey:@"isTimeofday"];
				[maintenanceArray replaceObjectAtIndex:segControl.tag withObject:dict];
				break;
			}
			case 1:
			{
				NSMutableDictionary *dict = [maintenanceArray objectAtIndex:segControl.tag];
				[dict setObject:[dict objectForKey:@"isTimeofday"] forKey:@"PreviousisTimeofday"];
				[dict setObject:@"NO" forKey:@"isTimeofday"];
				[maintenanceArray replaceObjectAtIndex:segControl.tag withObject:dict];
				break;
			}
			default:
				break;
		}
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
		[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
		isScheduleScrollSelect = NO;
	}
}*/

-(void)timeofDayBtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	isScheduleScrollSelect = YES;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:btn.tag];
	[dict setObject:[dict objectForKey:@"isTimeofday"] forKey:@"PreviousisTimeofday"];
	[dict setObject:@"YES" forKey:@"isTimeofday"];
	[maintenanceArray replaceObjectAtIndex:btn.tag withObject:dict];
	[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
}

-(void)sunrise_sunset_BtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	isScheduleScrollSelect = YES;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:btn.tag];
	[dict setObject:[dict objectForKey:@"isTimeofday"] forKey:@"PreviousisTimeofday"];
	[dict setObject:@"NO" forKey:@"isTimeofday"];
	[maintenanceArray replaceObjectAtIndex:btn.tag withObject:dict];
	[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
}


 
-(IBAction)RandomizeBtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	if([[[maintenanceArray objectAtIndex:btn.tag]objectForKey:@"isRandomize"] isEqualToString:@"YES"])
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:btn.tag];
		//[dict setObject:@"NO" forKey:@"isRandomize"];
		
		//Set change toggle randomized button in maintenance array
		[self toggleRandomized:@"NO" :dict];
		
		[maintenanceArray replaceObjectAtIndex:btn.tag withObject:dict];
		[btn setBackgroundImage:[UIImage imageNamed:@"Randomize.png"] forState:UIControlStateNormal];
	}
	else
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:btn.tag];
		//[dict setObject:@"YES" forKey:@"isRandomize"];
		
		//Set change toggle randomized button in maintenance array
		[self toggleRandomized:@"YES" :dict];
		
		[maintenanceArray replaceObjectAtIndex:btn.tag withObject:dict];
		[btn setBackgroundImage:[UIImage imageNamed:@"Randomize_selected.png"] forState:UIControlStateNormal];
	}
}
-(IBAction)sunriseBtnClicked:(id)sender
{
	issunriseBool = YES;
	
	isScheduleScrollSelect = YES;
	UIButton *btn = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:btn.tag];
	//[dict setObject:@"YES" forKey:@"issunriseBool"];
	
	//set sunrise or sunest bool in maintenance array
	[self changeSunriseSunset:@"YES" :dict];
	
	[maintenanceArray replaceObjectAtIndex:btn.tag withObject:dict];
	//[btn setBackgroundImage:[UIImage imageNamed:@"CheckBox.png"] forState:UIControlStateNormal];
	[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
	
	/*issunriseBool = YES;
	[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"CheckBox.png"] forState:UIControlStateNormal];
	[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"EmptyBox.png"] forState:UIControlStateNormal];*/
}
-(IBAction)sunsetBtnClicked:(id)sender
{
	issunriseBool = NO;
	
	isScheduleScrollSelect = YES;
	UIButton *btn = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:btn.tag];
	//[dict setObject:@"NO" forKey:@"issunriseBool"];

	//set sunrise or sunest bool in maintenance array
	[self changeSunriseSunset:@"NO" :dict];
	
	[maintenanceArray replaceObjectAtIndex:btn.tag withObject:dict];
	//[btn setBackgroundImage:[UIImage imageNamed:@"CheckBox.png"] forState:UIControlStateNormal];
	[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
	
	/*issunriseBool = NO;
	[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"CheckBox.png"] forState:UIControlStateNormal];
	[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"EmptyBox.png"] forState:UIControlStateNormal];*/
}

-(void)sliderValueChanged:(id)sender
{
	NSString *sliderVal;
	UISlider *slider = (UISlider *)sender;
	UILabel *sliderLabel;
	
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:slider.tag];
	
	for (UIView *subview in [scheduleScrollView subviews])
	{
		if ([subview isKindOfClass:[UIScrollView class]])
		{
			UIScrollView *scrollView = (UIScrollView*)subview;
			if(scrollView.tag==slider.tag)
			{
				for (UIView *subview in [scrollView subviews])
				{
					if ([subview isKindOfClass:[UIView class]])
					{
						UIView *containerView = (UIView*)subview;
						for (UIView *subview in [containerView subviews])
						{
							if ([subview isKindOfClass:[UILabel class]]){
								UILabel *label = (UILabel*)subview;
								
								if(label.tag == 1999)
								{
									sliderLabel = label;
									break;
								}
							}
						}
					}
					break;
				}
			}
		}
	}
	
	
	/*sliderVal= [NSString stringWithFormat:@"%d",(int)[slider value]];
	//Set sunrise or sunset offset value changed in maintenance array
	[self changeSunriseSunsetOffset:(int)[slider value] :dict];
	
	//[dict setObject:sliderVal forKey:@"sliderValue"];
	[maintenanceArray replaceObjectAtIndex:slider.tag withObject:dict];
	sliderLabel.text = sliderVal;*/
	
	
	if([[dict objectForKey:@"sliderValue"] intValue]!=(int)[slider value])
	{
		sliderVal= [NSString stringWithFormat:@"%d",(int)[slider value]];
		//Set sunrise or sunset offset value changed in maintenance array
		[self changeSunriseSunsetOffset:(int)[slider value] :dict];
		
		//[dict setObject:sliderVal forKey:@"sliderValue"];
		[maintenanceArray replaceObjectAtIndex:slider.tag withObject:dict];
		sliderLabel.text = sliderVal;
		sliderLabel.text = [sliderLabel.text stringByAppendingString:@" minute(s)"];
	}
}

-(void)setAllGlobalWeekdaysButtonState:(int)tag
{
	for (UIView *subview in [scheduleScrollView subviews])
	{
		if ([subview isKindOfClass:[UIScrollView class]])
		{
			UIScrollView *scrollView = (UIScrollView*)subview;
			if(scrollView.tag==tag)
			{
				for (UIView *subview in [scrollView subviews])
				{
					if ([subview isKindOfClass:[UIView class]])
					{
						UIView *containerView = (UIView*)subview;
						for (UIView *subview in [containerView subviews])
						{
							if ([subview isKindOfClass:[UIButton class]])
							{
								UIButton *button = (UIButton*)subview;
								if([button.currentTitle isEqualToString:@"Su"])
									g_sunBtn = button;
								else if([button.currentTitle isEqualToString:@"M"])
									g_monBtn = button;
								else if([button.currentTitle isEqualToString:@"Tu"])
									g_tueBtn = button;
								else if([button.currentTitle isEqualToString:@"W"])
									g_wedBtn = button;
								else if([button.currentTitle isEqualToString:@"Th"])
									g_thuBtn = button;
								else if([button.currentTitle isEqualToString:@"F"])
									g_friBtn = button;
								else if([button.currentTitle isEqualToString:@"Sa"])
									g_satBtn = button;
								else if([button.currentTitle isEqualToString:@"All"])
									g_allBtn = button;
							}
						}
					}
					break;
				}
			}
		}
	}
}

-(void)handleDayClick :(int)_currentDays :(int)DayNoofWeek :(NSMutableDictionary*)dict
{
	switch ( DayNoofWeek )
	{
		case 1:
			_currentDays=_currentDays ^ SUNDAY;
			break;
		case 2:
			_currentDays=_currentDays ^ MONDAY;
			break;
		case 3:
			_currentDays=_currentDays ^ TUESDAY;
			break;
		case 4:
			_currentDays=_currentDays ^ WEDNESDAY;
			break;
		case 5:
			_currentDays=_currentDays ^ THURSDAY;
			break;
		case 6:
			_currentDays=_currentDays ^ FRIDAY;
			break;
		case 7:
			_currentDays=_currentDays ^ SATURDAY;
			break;
		case 8:
			if ( _currentDays == ALL )
				_currentDays=_cachedDays;
			else
			{
				_cachedDays=_currentDays;
				_currentDays=ALL;
			}
			break;
	}
	
	[self changeDaysActiveMask:_currentDays :dict];
}


-(IBAction)sunBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	[self setAllGlobalWeekdaysButtonState:button.tag];
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:button.tag];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :1 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"sunbtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"sunbtnselected"];
	}
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
	{
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:button.tag withObject:dict];
}
-(IBAction)monBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	[self setAllGlobalWeekdaysButtonState:button.tag];
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:button.tag];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :2 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"monbtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"monbtnselected"];
	}
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
	{
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:button.tag withObject:dict];
}
-(IBAction)tueBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	[self setAllGlobalWeekdaysButtonState:button.tag];
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:button.tag];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :3 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"tuebtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"tuebtnselected"];
	}
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
	{
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:button.tag withObject:dict];
}
-(IBAction)wedBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	[self setAllGlobalWeekdaysButtonState:button.tag];
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:button.tag];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :4 :dict];
	
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"wedbtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"wedbtnselected"];
	}
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
	{
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:button.tag withObject:dict];
}
-(IBAction)thuBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	[self setAllGlobalWeekdaysButtonState:button.tag];
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:button.tag];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :5 :dict];
	
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"thubtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"thubtnselected"];
	}
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
	{
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:button.tag withObject:dict];
}
-(IBAction)friBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	[self setAllGlobalWeekdaysButtonState:button.tag];
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:button.tag];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :6 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"fribtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"fribtnselected"];
	}
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
	{
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:button.tag withObject:dict];
}
-(IBAction)satBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	[self setAllGlobalWeekdaysButtonState:button.tag];
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:button.tag];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :7 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"satbtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"satbtnselected"];
	}
	
	if([g_allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
	{
		[g_allBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:button.tag withObject:dict];
}
-(IBAction)allBtnClicked:(id)sender
{	
	UIButton *button = (UIButton*)sender;
	[self setAllGlobalWeekdaysButtonState:button.tag];
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:button.tag];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :8 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day-up.png"])
	{
		[dict setObject:@"NO" forKey:@"sunbtnselected"];
		[dict setObject:@"NO" forKey:@"monbtnselected"];
		[dict setObject:@"NO" forKey:@"tuebtnselected"];
		[dict setObject:@"NO" forKey:@"wedbtnselected"];
		[dict setObject:@"NO" forKey:@"thubtnselected"];
		[dict setObject:@"NO" forKey:@"fribtnselected"];
		[dict setObject:@"NO" forKey:@"satbtnselected"];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
		
		[button setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		
		if([g_sunBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
		{
			[dict setObject:@"YES" forKey:@"sunbtnselected"];
		}
		else
			[g_sunBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		
		if([g_monBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
		{
			[dict setObject:@"YES" forKey:@"monbtnselected"];
		}
		else
			[g_monBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		
		if([g_tueBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
		{
			[dict setObject:@"YES" forKey:@"tuebtnselected"];
		}
		else
			[g_tueBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		
		if([g_wedBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
		{
			[dict setObject:@"YES" forKey:@"wedbtnselected"];
		}
		else
			[g_wedBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		
		if([g_thuBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
		{
			[dict setObject:@"YES" forKey:@"thubtnselected"];
		}
		else
			[g_thuBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		
		if([g_friBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
		{
			[dict setObject:@"YES" forKey:@"fribtnselected"];
		}
		else
			[g_friBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		
		if([g_satBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"day_selected.png"])
		{
			[dict setObject:@"YES" forKey:@"satbtnselected"];
		}
		else
			[g_satBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"sunbtnselected"] isEqualToString:@"YES"])
		{
			[g_sunBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_sunBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"monbtnselected"] isEqualToString:@"YES"])
		{
			[g_monBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_monBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"tuebtnselected"] isEqualToString:@"YES"])
		{
			[g_tueBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_tueBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"wedbtnselected"] isEqualToString:@"YES"])
		{
			[g_wedBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_wedBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"thubtnselected"] isEqualToString:@"YES"])
		{
			[g_thuBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_thuBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"fribtnselected"] isEqualToString:@"YES"])
		{
			[g_friBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_friBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"satbtnselected"] isEqualToString:@"YES"])
		{
			[g_satBtn setBackgroundImage:[UIImage imageNamed:@"day_selected.png"] forState:UIControlStateNormal];
		}
		else
			[g_satBtn setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
	}
}

//picker popup ok and cancel
-(IBAction)pickerOkClicked:(id)sender
{
	[pickerPopupView removeFromSuperview];
	isScheduleScrollSelect = YES;
	if(isDatePicker)
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedPickerIndex];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		//[dict setObject:[dateFormatter stringFromDate:datePicker.date] forKey:@"dateTextField"];
		
		//set changeDateRange based on maintenance array
		[self changeDateRange:[dateFormatter stringFromDate:datePicker.date] :dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedPickerIndex withObject:dict];
		[dateFormatter release];
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
		[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	else if(isToDatePicker)
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedPickerIndex];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		//[dict setObject:[dateFormatter stringFromDate:datePicker.date] forKey:@"dateTextField"];
		
		//set changeDateRange based on maintenance array
		[self changeToDateRange:[dateFormatter stringFromDate:TodatePicker.date] :dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedPickerIndex withObject:dict];
		[dateFormatter release];
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
		[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	else if(isTimerPicker)
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedPickerIndex];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"hh:mm a"];
		[dict setObject:[dateFormatter stringFromDate:timePicker.date] forKey:@"timerTextField"];
		
		//Set changed current time in maintenance dict
		[self changeActivateTime:dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedPickerIndex withObject:dict];
		[dateFormatter release];
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
		[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	else if(isScenePicker)
	{
		//scenesTextField.text = [[[[AppDelegate_iPad sharedAppDelegate] g_ScenesArray] objectAtIndex:scenePickerRowIndex] objectForKey:@"name"];
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedPickerIndex];
		//[dict setObject:[[[[AppDelegate_iPad sharedAppDelegate] g_ScenesArray] objectAtIndex:scenePickerRowIndex] objectForKey:@"name"] forKey:@"scenesTextField"];
		
		//set change selected scene in maintenacne dict
		[self changeSelectedScene:[[[[AppDelegate_iPad sharedAppDelegate] g_ScenesArray] objectAtIndex:scenePickerRowIndex] objectForKey:@"name"] :[[[[AppDelegate_iPad sharedAppDelegate] g_ScenesArray] objectAtIndex:scenePickerRowIndex] objectForKey:@"id"] :dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedPickerIndex withObject:dict];
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
		[scheduleScrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	isScheduleScrollSelect = NO;
}
-(IBAction)pickerCancelClicked:(id)sender
{
	[pickerPopupView removeFromSuperview];
}

-(IBAction)datePickerBtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	selectedPickerIndex = btn.tag;
	NSString *strDate = [[maintenanceArray objectAtIndex:btn.tag]objectForKey:@"dateTextField"];
	if(![strDate isEqualToString:@""]&&strDate!=nil)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		datePicker.date = [dateFormatter dateFromString:strDate];
		[dateFormatter release];
	}
	
	isDatePicker= YES;isTimerPicker= NO;isScenePicker= NO;isToDatePicker=NO;
	//Remove all subviews from popview for load a new subviews
	NSArray *subviewArr = [pickerPopupsubView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	[self.view addSubview:pickerPopupView];
	pickerOkBtn.frame = CGRectMake(228, 288, 74, 37);
	pickerCancelBtn.frame = CGRectMake(340, 288, 74, 37);
	datePicker.frame = CGRectMake(42, 42, 400, 216);
	[pickerPopupsubView addSubview:datePicker];
	[pickerPopupsubView addSubview:pickerOkBtn];
	[pickerPopupsubView addSubview:pickerCancelBtn];
	
}

-(IBAction)TodatePickerBtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	selectedPickerIndex = btn.tag;
	NSString *strDate = [[maintenanceArray objectAtIndex:btn.tag]objectForKey:@"TodateTextField"];
	if(![strDate isEqualToString:@""]&&strDate!=nil)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		TodatePicker.date = [dateFormatter dateFromString:strDate];
		[dateFormatter release];
	}
	
	isDatePicker= NO;isTimerPicker= NO;isScenePicker= NO;isToDatePicker=YES;
	//Remove all subviews from popview for load a new subviews
	NSArray *subviewArr = [pickerPopupsubView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	[self.view addSubview:pickerPopupView];
	pickerOkBtn.frame = CGRectMake(228, 288, 74, 37);
	pickerCancelBtn.frame = CGRectMake(340, 288, 74, 37);
	TodatePicker.frame = CGRectMake(42, 42, 400, 216);
	[pickerPopupsubView addSubview:TodatePicker];
	[pickerPopupsubView addSubview:pickerOkBtn];
	[pickerPopupsubView addSubview:pickerCancelBtn];
}




-(IBAction)timePickerBtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	selectedPickerIndex = btn.tag;
	NSString *strDate = [[maintenanceArray objectAtIndex:btn.tag]objectForKey:@"timerTextField"];
	if(![strDate isEqualToString:@""]&&strDate!=nil)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"hh:mm a"];
		timePicker.date = [dateFormatter dateFromString:strDate];
		[dateFormatter release];
	}
	
	isDatePicker= NO;isTimerPicker= YES;isScenePicker= NO;isToDatePicker=NO;
	
	//Remove all subviews from popview for load a new subviews
	NSArray *subviewArr = [pickerPopupsubView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	[self.view addSubview:pickerPopupView];
	pickerOkBtn.frame = CGRectMake(228, 288, 74, 37);
	pickerCancelBtn.frame = CGRectMake(340, 288, 74, 37);
	timePicker.frame = CGRectMake(42, 42, 400, 216);
	[pickerPopupsubView addSubview:timePicker];
	[pickerPopupsubView addSubview:pickerOkBtn];
	[pickerPopupsubView addSubview:pickerCancelBtn];
}
-(IBAction)scenesPickerBtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	selectedPickerIndex = btn.tag;
	NSString *sceneName = [[maintenanceArray objectAtIndex:btn.tag]objectForKey:@"scenesTextField"];
	
	//Check index of scene name in scenelist array
	for(int i=0;i<[[[AppDelegate_iPad sharedAppDelegate] g_ScenesArray] count];i++)
	{
		NSString *scene = [[[[AppDelegate_iPad sharedAppDelegate] g_ScenesArray] objectAtIndex:i] objectForKey:@"name"];
		if([scene isEqualToString:sceneName])
		{
			[scenesPicker selectRow:i inComponent:0 animated:NO];
			break;
		}
	}
	
	
	isDatePicker= NO;isTimerPicker= NO;isScenePicker= YES;isToDatePicker=NO;
	//Remove all subviews from popview for load a new subviews
	NSArray *subviewArr = [pickerPopupsubView subviews];
	for(int i=0;i<[subviewArr count];i++)
		[[subviewArr objectAtIndex:i] removeFromSuperview];
	
	[self.view addSubview:pickerPopupView];
	pickerOkBtn.frame = CGRectMake(228, 288, 74, 37);
	pickerCancelBtn.frame = CGRectMake(340, 288, 74, 37);
	scenesPicker.frame = CGRectMake(42, 42, 400, 216);
	[pickerPopupsubView addSubview:scenesPicker];
	[pickerPopupsubView addSubview:pickerOkBtn];
	[pickerPopupsubView addSubview:pickerCancelBtn];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
	if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) 
	{ 
		return YES; 
	} 
	return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark LOADING VIEW

- (void)showLoadingView
{
    if (loadingView == nil)
    { 
		loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,1024,768)];
        loadingView.opaque = NO;
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.alpha = 0.5;
		
		//ActivityIndicator shows in the middle of loadingView
		UILabel *loadingTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, 1024, 100)];
		loadingTitle.text = @"";
		loadingTitle.textAlignment=UITextAlignmentCenter;
		loadingTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
		loadingTitle.textColor = [UIColor lightGrayColor];
        loadingTitle.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:loadingTitle];
		[loadingTitle release];
		
		UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(494, 402, 37.0, 37.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [loadingView addSubview:spinningWheel];
        [spinningWheel release];
    }
    [self.view addSubview:loadingView];
}

- (void)hideLoadingView
{
    [loadingView removeFromSuperview];
	[loadingView release];
	loadingView=nil;
}


#pragma mark -
#pragma mark ANIMATION BLOCKS

-(void)OpenWindow
{
	//Kill all previous timer
	[openTimer invalidate];
    openTimer = nil;
    [closeTimer invalidate];
    closeTimer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(CloseWindow) object:nil];
	
	animationScrollView.hidden = NO;
	animateImageView.frame = CGRectMake(38, 210, 455, 289);
	yPosition = 210;
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
	animateImageView.frame = CGRectMake(38, yPosition, 455, 289);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition<=25)
	{
		yPosition = 25;
		[openTimer invalidate];
		openTimer = nil;
		[self performSelector:@selector(CloseWindow) withObject:nil afterDelay:2];
	}
}

-(void)CloseDisplayTask
{
	//Kill open timer
	[openTimer invalidate];
    openTimer = nil;
	
	yPosition+=3;
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.02];
	[UIView setAnimationBeginsFromCurrentState:YES];
	animateImageView.frame = CGRectMake(38, yPosition, 455, 289);
	// Commit the changes
	[UIView commitAnimations];
	
	if(yPosition>=210)
	{
		yPosition = 210;
		[closeTimer invalidate];
		closeTimer = nil;
		animationScrollView.hidden = YES;
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



#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	
	if(strCommand==GET_TIMERS)
	{
		scheduleEnum = GET_TIMER_DONE;
		//Copy the g_scheduleList result
		[AppDelegate_iPad  sharedAppDelegate].g_getTimersArray = [resultArray mutableCopy];
	}
	else if(strCommand==GET_INFO)
	{
		scheduleTimerInfoEnum = TIMER_GET_INFO_DONE;
		//Copy the timer info array in g_getTimersInfoArray
		[[AppDelegate_iPad  sharedAppDelegate].g_getTimersInfoArray addObject:[resultArray mutableCopy]];
	}
	else if(strCommand==GET_EVENTS)
	{
		scheduleEnum = GET_EVENT_DONE;
		//Copy the timer info array in g_getEventsArray
		[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray = [resultArray mutableCopy];
	}
	else if(strCommand==EVENT_GET_INFO)
	{
		scheduleEventInfoEnum = EVENT_INFO_DONE;
		//Copy the timer info array in g_getEventsInfoArray
		[[AppDelegate_iPad  sharedAppDelegate].g_getEventsInfoArray addObject:[resultArray mutableCopy]];
	}
	else if(strCommand == ADD_TIMER)
	{
		if (saveScheduleEnum == PROCESSING)
		{
			newScheduleId =[[[resultArray objectAtIndex:0] objectForKey:@"id"] intValue];
			saveScheduleEnum = SCH_SET_DAYS_MASK;
		}
		else 
			[self initialLoad];
	}
	else if(strCommand == ENABLE)
	{
		// When we sent an schedule timer enable return a true case we manually update the array as enable/disable and refresh the drawing view
		
		NSMutableDictionary *dictionary = [[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex];
		if([[dictionary objectForKey:@"enabled"] isEqualToString:@""] || [[dictionary objectForKey:@"enabled"] isEqualToString:@"0"] )
		{
			[dictionary setObject:@"1" forKey:@"enabled"];
			[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:enableorDisableIndex withObject:dictionary];
		}
		else
		{
			[dictionary setObject:@"" forKey:@"enabled"];
			[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:enableorDisableIndex withObject:dictionary];
		}
		[self hideLoadingView];
		[self OpenWindow];
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
		
	}
	else if(strCommand == EVENT_ENABLE)
	{
		// When we sent an schedule event enable return a true case we manually update the array as enable/disable and refresh the drawing view
		
		NSMutableDictionary *dictionary = [[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:enableorDisableIndex];
		if([[dictionary objectForKey:@"enabled"] isEqualToString:@""] || [[dictionary objectForKey:@"enabled"] isEqualToString:@"0"] )
		{
			[dictionary setObject:@"1" forKey:@"enabled"];
			[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:enableorDisableIndex withObject:dictionary];
		}
		else
		{
			[dictionary setObject:@"" forKey:@"enabled"];
			[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:enableorDisableIndex withObject:dictionary];
		}
		[self hideLoadingView];
		[self OpenWindow];
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	}
	else if(strCommand == TIMER_CHANGE_NAME)
	{
		//When we sent an timer change name command in the result we should get timer get name command and replace in the array and refresh the drawing view
		
		[[TimerService getSharedInstance]getName:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] :self];
		
	}
	else if(strCommand == EVENT_CHANGE_NAME)
	{
		//When we sent an event change name command in the result we should get event get name command and replace in the array and refresh the drawing view
		[[EventsService getSharedInstance]getName:[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"id"] :self];
	}
	else if(strCommand == GET_NAME)
	{
		//Update the array based on the schedule timer get name return
		[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"name"];
		NSMutableDictionary *dictionary = [[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex];
		if([resultArray count]>0)
			[dictionary setObject:[[resultArray objectAtIndex:0]objectForKey:@"name"] forKey:@"name"];
		[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:saveScheduleIndex withObject:dictionary];
		[self hideLoadingView];
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
		[self OpenWindow];
	}
	else if(strCommand == EVENT_GET_NAME)
	{
		//Update the array based on the schedule event get name return
		[[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex]objectForKey:@"name"];
		NSMutableDictionary *dictionary = [[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex];
		if([resultArray count]>0)
			[dictionary setObject:[[resultArray objectAtIndex:0]objectForKey:@"name"] forKey:@"name"];
		[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:saveScheduleIndex withObject:dictionary];
		[self hideLoadingView];
		[self LoadAllSchedules:[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList];
	}
	else if (strCommand == REMOVE)
	{
		if (saveScheduleEnum == PROCESSING)
		{
			//REMOVE TIMER AND TIMER INFO ARRAY
			for (int i=0; i<[[AppDelegate_iPad  sharedAppDelegate].g_getTimersArray count]; i++) {
				int ID = [[[[AppDelegate_iPad  sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex] objectForKey:@"id"] intValue];
				int TIMERID = [[[[AppDelegate_iPad  sharedAppDelegate].g_getTimersArray objectAtIndex:i] objectForKey:@"id"] intValue];
				if( ID == TIMERID)
				{
					[[AppDelegate_iPad  sharedAppDelegate].g_getTimersArray removeObjectAtIndex:i];
					[[AppDelegate_iPad  sharedAppDelegate].g_getTimersInfoArray removeObjectAtIndex:i];
					break;
				}
			}
			
			saveScheduleEnum = SCH_ADD_SCHUDLE;
		}
		else
		{
			BOOL isExists = NO;
			int ExistIndex;
			for(int i=0;i<[selectedSchedulesArray count];i++)
			{
				if(deleteScheduleIndex==[[selectedSchedulesArray objectAtIndex:i] intValue])
				{
					isExists = YES;
					ExistIndex = i;
					break;
				}
			}
			if(isExists)
				[selectedSchedulesArray removeObjectAtIndex:ExistIndex];
			else
				[selectedSchedulesArray addObject:[NSString stringWithFormat:@"%d",deleteScheduleIndex]];
			
			[self initialLoad];
		}
	}
	else if (strCommand == EVENT_REMOVE)
	{
		if (saveScheduleEnum == PROCESSING)
		{
			//REMOVE TIMER AND TIMER INFO ARRAY
			for (int i=0; i<[[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray count]; i++) {
				int ID = [[[[AppDelegate_iPad  sharedAppDelegate].g_formatScheduleList objectAtIndex:saveScheduleIndex] objectForKey:@"id"] intValue];
				int TIMERID = [[[[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray objectAtIndex:i] objectForKey:@"id"] intValue];
				if( ID == TIMERID)
				{
					[[AppDelegate_iPad  sharedAppDelegate].g_getEventsArray removeObjectAtIndex:i];
					[[AppDelegate_iPad  sharedAppDelegate].g_getEventsInfoArray removeObjectAtIndex:i];
					break;
				}
			}
			
			
			saveScheduleEnum = SCH_ADD_SCHUDLE;
		}
		else
		{
			BOOL isExists = NO;
			int ExistIndex;
			for(int i=0;i<[selectedSchedulesArray count];i++)
			{
				if(deleteScheduleIndex==[[selectedSchedulesArray objectAtIndex:i] intValue])
				{
					isExists = YES;
					ExistIndex = i;
					break;
				}
			}
			if(isExists)
				[selectedSchedulesArray removeObjectAtIndex:ExistIndex];
			else
				[selectedSchedulesArray addObject:[NSString stringWithFormat:@"%d",deleteScheduleIndex]];
			
			[self initialLoad];
		}
	}
	else if(strCommand == EVENT_ADD)
	{
		newScheduleId =[[[resultArray objectAtIndex:0] objectForKey:@"id"] intValue];
		//saveScheduleEnum = SCH_EXCLUDE_SCHUDLE_FROM_SCENE;
		saveScheduleEnum = SCH_EVENT_TRIG_DEVICE;
	}
	else if(strCommand == EVENT_SET_TRIGGER_DEVICE)
	{
		//saveScheduleEnum = SCH_EXCLUDE_SCHUDLE_FROM_SCENE;
		saveScheduleEnum = SCH_SET_DAYS_MASK;
	}
	else if(strCommand == INCLUDE_SCENE)
	{
		if(saveScheduleEnum == PROCESSING_SCH_CHECK_SCENE_CHANGE)
			saveScheduleEnum = SCH_REMOVE_SCHUDLE;
		else if (saveScheduleEnum == PROCESSING_SCH_INCLUDE_SCHUDLE_TO_SCENE)
			saveScheduleEnum = SCH_SET_DAYS_MASK;
		else if (saveScheduleEnum == PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE)
			saveScheduleEnum = SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE;
		else if (saveScheduleEnum == PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE)
			saveScheduleEnum = SCH_SUNRISE_SUNSET_OFFSET_CHANGE;
	}
	else if(strCommand == EVENT_SCENE_INCLUDE)
	{
		if(saveScheduleEnum == PROCESSING_SCH_CHECK_SCENE_CHANGE)
			saveScheduleEnum = SCH_REMOVE_SCHUDLE;
		else if (saveScheduleEnum == PROCESSING_SCH_INCLUDE_SCHUDLE_TO_SCENE)
			saveScheduleEnum = SCH_SET_DAYS_MASK;
		else if (saveScheduleEnum == PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE)
			saveScheduleEnum = SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE;
		else if (saveScheduleEnum == PROCESSING_SCH_ASSOCIATED_SCENE_CHANGE_INCLUDE)
			saveScheduleEnum = SCH_SUNRISE_SUNSET_OFFSET_CHANGE;
	}
	else if (strCommand == EVENT_SET_DAYS_MASK)
	{
		saveScheduleEnum = SCH_SET_METADATA;
	}
	else if(strCommand == SET_DAYS_MASK)
	{
		saveScheduleEnum = SCH_SET_METADATA;
	}
	else if (strCommand == SET_METADATA)
	{
		saveScheduleEnum = SCH_TIMER_RANDOMIZE;
	}
	else if (strCommand == TIMER_RANDOMIZE)
	{
		saveScheduleEnum = SCH_START_CHANGE;
	}
	else if(strCommand == SET_TIME)
	{
		//if Timer service set time 
		saveScheduleEnum = SCH_ASSOCIATED_SCENE_CHANGE_EXCLUDE;
	}
	else if(strCommand == EVENT_SET_TIME)
	{
		saveScheduleEnum = SCH_SUNRISE_SUNSET_TIME_CHANGE;
	}
	else if(strCommand == EVENT_SET_TRIGGER_REASON)
	{
		saveScheduleEnum = DONE;
	}
	else if(strCommand == LOGOUT)
	{
		[self hideLoadingView];
		
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
		
		isLOGOUT = YES;
		NSArray *array = [[AppDelegate_iPad sharedAppDelegate].window subviews];
		for (int i=0; i<[array count]; i++) {
			[[array objectAtIndex:i] removeFromSuperview];
		}
		[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view];
		
	}
	else if(strCommand == AUTHENTICATE_USER)
	{
		[AppDelegate_iPad sharedAppDelegate].g_SessionArray = [resultArray mutableCopy];
		if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
		{
			if ([[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 4 && [[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"userRole"]intValue ] != 2)
			{
				UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Authorization Error" message:@"Not an authorized user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[errorAlert show];
				[errorAlert release];
				
				[self hideLoadingView];
			}
			else 
			{
				[self hideLoadingView];
			}
		}
	}
}

-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription
{
	[self hideLoadingView];
	
	if(isSaveSchedule)
	{
		//[self saveScheduleTaskComplete];
		//[self initialTaskComplete];
		isSaveSchedule = NO;
	}
	
	if([errorMsg isEqualToString:@"SESSION EXPIRED"])
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert setTag:255];
		[errorAlert show];
		[errorAlert release];
		
		
		/*[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray removeAllObjects];
		NSArray *array = [[AppDelegate_iPad sharedAppDelegate].window subviews];
		for (int i=0; i<[array count]; i++) {
			[[array objectAtIndex:i] removeFromSuperview];
		}
		[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view];*/
	}
	else
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	[ProcessTimer invalidate];
	ProcessTimer = nil;
	
	[QueueTimer invalidate];
	QueueTimer = nil;
	
	[deleteScheduleTimer invalidate];
	deleteScheduleTimer = nil;
	
	[saveScheduleTimer invalidate];
	saveScheduleTimer = nil;
	
	[scheduleTimerInfoTimer invalidate];
	scheduleTimerInfoTimer = nil;
	
	[scheduleEventInfoTimer invalidate];
	scheduleEventInfoTimer = nil;
	
	[addSchTimer invalidate];
	addSchTimer = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 255)
	{
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
			[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray removeAllObjects];
			//Send authenticate command 
			[self showLoadingView];
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"username"] forKey:@"username"];
			[commandDictionary setObject:[[loginArray objectAtIndex:0]objectForKey:@"password"] forKey:@"password"];
			[[UserService getSharedInstance]authenticate:commandDictionary:self];
			[commandDictionary release];
			
		}
		else
		{
			[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray removeAllObjects];
			NSArray *array = [[AppDelegate_iPad sharedAppDelegate].window subviews];
			for (int i=0; i<[array count]; i++) {
				[[array objectAtIndex:i] removeFromSuperview];
			}
            
 /*           id subView = [[DeviceSkinChooser getSharedInstance]getDeviceSkinBasedOnDeviceType:110];
            if(subView!=nil)
            {
                //popupView =  subView;
                [subView SetMainDelegate:self];
                //		[subView setDeviceDict:selectedDeviceDict];
                //Filter with each devices in the same roomID
                //		[subView setSelectedRoomDevicesArray:[self filterRoomForDevices:selectedDeviceDict]];
                [self.view addSubview:subView];
                //		popupView.alpha = 0;
                //		[self performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:.3];
            }
           */ 
 //           [[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].MJPEGViewer_iPadController.view];

			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view];
		}
	}
	// Hint
	else if(alertView.tag == 325)
	{
		if(buttonIndex==1)
		{
			[self showLoadingView];
			[[UserService getSharedInstance]Logout:self];
		}
	}
	else if(buttonIndex==1)
	{
		[self showLoadingView];
		strInfoType = [[[AppDelegate_iPad sharedAppDelegate].g_formatScheduleList objectAtIndex:deleteScheduleIndex]objectForKey:@"ScheduleInfoType"];
		if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[NSString stringWithFormat:@"%d",currScheduleId] forKey:@"id"];
			[commandDictionary setObject:@"false" forKey:@"getList"];
			[[TimerService getSharedInstance]removeTimerFromController :commandDictionary :self];
			[commandDictionary release];
			
		}
		else
		{
			NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
			[commandDictionary setObject:[NSString stringWithFormat:@"%d",currScheduleId] forKey:@"id"];	
			[commandDictionary setObject:@"false" forKey:@"getList"];
			[[EventsService getSharedInstance]eventRemove:commandDictionary :self];
			[commandDictionary release];
		}
	}
}


#pragma mark -
#pragma mark BOTTOM TABS

-(IBAction)LOGOUT:(id)sender
{
	//[self showLoadingView];
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

-(IBAction)LiveViewDashboard:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DashboardviewController.view];
}
-(IBAction)SceneConfigurator:(id)sender
{
	[[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigHomeviewController.view];
}
-(IBAction)ScheduleConfigurator:(id)sender
{
}
-(IBAction)InstallerView:(id)sender
{
	switch ([[AppDelegate_iPad sharedAppDelegate]GetInstallerViewIndex]) {
			
		case 1:
		{
			[[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].viewController.view];
			break;
		}
		case 2:
		{
			[[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].DeviceConfigviewController.view];
			break;
		}
		case 3:
		{
			[[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].SceneConfigviewController.view];
			break;
		}
		case 4:
		{
			[[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].EventConfigviewController.view];
			break;
		}
		case 5:
		{
			[[AppDelegate_iPad sharedAppDelegate].ScheduleConfigHomeviewController.view removeFromSuperview];
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].ScheduleConfigviewController.view];
			break;
		}
		default:
			break;
	}
}

-(void)InstallerView
{
	[self.tabBarController.view removeFromSuperview];
	[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].tabBarController.view];
}


#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
    [Logout release];
	[g_scheduleList,g_scheduleInfoList,g_timerInfoList,g_eventInfoList release];
	[DateTimeDisplayTimer invalidate];
	DateTimeDisplayTimer = nil;
	[TimeLbl1,TimeLbl2,DateLbl,ActivatedLabel release];
	[selectedSchedulesArray release];
	[scheduleScrollView release];
	[DashboardBtn,SceneConfigBtn,ScheduleConfigBtn,InstallerViewBtn release];
	
	[scenesPicker release];
	[datePicker,timePicker,TodatePicker release];
	
	[editScheduleView release];
	[editScheduleTextField release];
	
	//Custom classes schedule subscrollview class files
	[subcontainerView,pickerPopupView,pickerPopupsubView release];
	[pickerOkBtn,pickerCancelBtn release];
	
	[addScheduleView release];
	[addScheduleTextField release];
	
	[imgView release];
	[animationScrollView release];
	[label1,label2 release];
	[animateImageView release];
	[animationTitle release];
    [super dealloc];
}


@end
