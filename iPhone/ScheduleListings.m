//
//  ScheduleListings.m
//  Somfy
//
//  Created by Sempercon on 4/25/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "ScheduleListings.h"
#import "AppDelegate_iPhone.h"
#import "TimeConverterUtil.h"
#import "TimerService.h"
#import "EventsService.h"
#import "TimeConverterUtil.h"
#import "ConfigurationService.h"
#import "ConfigurationService.h"
#include <QuartzCore/QuartzCore.h>
#import "UserService.h"
#import "DBAccess.h"


@interface ScheduleListings (Private)
-(void)InitializeDefaultScheduleValues;
-(void)loadScheduleDetails;
-(void)OpenWindow;
-(void)saveScheduleOneByOne;
-(void)saveScheduleTaskComplete;
-(void)initialTaskComplete;
@end

extern BOOL  _isLOGOUT;

@implementation ScheduleListings

@synthesize scrollView;
@synthesize sceneNameLbl,scheduleNameLbl;
@synthesize selectedIndex;

@synthesize editScheduleView,editScheduleTextField;

//Custom classes schedule subscrollview class files
@synthesize subcontainerView,pickerPopupView,pickerPopupsubView;
@synthesize activationDayBtn,activationTimeBtn,sunriseBtn,sunsetBtn;
@synthesize scenesPicker;
@synthesize datePicker,TodatePicker,timePicker;
@synthesize eventSlider;
@synthesize lblEventSliderValue,lblsunrise,lblsunset,lblWeekorYear,lblYearlySelector;
@synthesize sunBtn,monBtn,tueBtn,wedBtn,thuBtn,friBtn,satBtn,allBtn;

@synthesize dateTextField,timerTextField,scenesTextField,TodateTextField;
@synthesize datePickerBtn,timePickerBtn,scenesPickerBtn,TodatePickerBtn;
@synthesize pickerOkBtn,pickerCancelBtn,randomizeBtn;
@synthesize fromLabel,toLabel,lblDateString,randomizeLbl;
@synthesize activationWeekdaySegment,activationTimeofdaySegment;
@synthesize runat,imgRandomize;
@synthesize sunRiseOffset,minutes,minus60,plus60;

//Animation
@synthesize animateImageView;
@synthesize animationScrollView;
@synthesize animationTitle1,animationTitle2;
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
	
	//Added for animation 
	isAnimation = YES;
	animationScrollView.hidden = YES;
	isSaveSchedule = NO;
	_cachedDays = 0;
	
	animationTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, 300, 24)];
	animationTitle1.text = @"myTaHomA Message";
	animationTitle1.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	animationTitle1.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle1];
	//[animationTitle1 release];
	
	NSString *temp=@"";
	animationTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(14, 44, 300, 30)];
	temp = [[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList objectAtIndex:[selectedIndex intValue]] objectForKey:@"name"];
	temp = [temp stringByAppendingString:@" was successfully saved."];
	animationTitle2.text = temp;
	animationTitle2.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
	animationTitle2.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle2];
	//[animationTitle2 release];
	
	maintenanceArray = [[NSMutableArray alloc]init];
	maintenanceDictionary = [[NSMutableDictionary alloc]init];

	self.navigationController.navigationBarHidden = YES;
	selectedIntIndex = [selectedIndex intValue];
	[self InitializeDefaultScheduleValues];
	[self loadScheduleDetails];
	[super viewDidLoad];
	isDeleteSchedule = NO;
	
	scheduleNameLbl.text = [[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex] objectForKey:@"name"];
	sceneNameLbl.text = @"";
	
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
	TodateTextField.leftView = paddingView;
	TodateTextField.leftViewMode = UITextFieldViewModeAlways;
	TodateTextField.placeholder=@"Date To End";
	[paddingView release];
	
	UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
	dateTextField.leftView = paddingView1;
	dateTextField.leftViewMode = UITextFieldViewModeAlways;
	dateTextField.placeholder=@"Date To Start";
	[paddingView1 release];
	
	UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
	timerTextField.leftView = paddingView2;
	timerTextField.leftViewMode = UITextFieldViewModeAlways;
	timerTextField.placeholder=@"Time To Run";
	[paddingView2 release];
	[scrollView setContentSize:CGSizeMake(320, 750)];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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

-(void)setMetaData:(NSString*)strMetaData
{
	NSString *strDateString;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
	
	if ([strMetaData rangeOfString:@"sDate."].location == NSNotFound) {
		[maintenanceDictionary setObject:@"" forKey:@"dateTextField"];
		//NSLog(@"string does not contain meta data");
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
	
	NSString *Strminutes = [NSString stringWithFormat:@"%d",mins];
	if([Strminutes length]==1)
		Strminutes = [@"0" stringByAppendingString:Strminutes];
	
	NSString *strFormat = [[NSString stringWithFormat:@"%d",hours] stringByAppendingString:@":"];
	strFormat = [strFormat stringByAppendingString:Strminutes];
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
	
	for(int i=0;i<[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList count];i++)
	{
		
		[timerArray removeAllObjects];
		[eventArray removeAllObjects];
		
		if([maintenanceDictionary count]>0)
			[maintenanceDictionary removeAllObjects];
		
		//Load timerarray from timerInfoList
		strInfoType = [[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"ScheduleInfoType"];
		if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
		{
			strTimerInfoId = [[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"id"];
			for(int j=0;j<[[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray count];j++)
			{
				if([strTimerInfoId isEqualToString:[[[AppDelegate_iPhone sharedAppDelegate].g_getTimersArray objectAtIndex:j]objectForKey:@"id"]])
				{
					TimerIndex = j;
					timerArray = [[[AppDelegate_iPhone sharedAppDelegate].g_getTimersInfoArray objectAtIndex:j] mutableCopy];
					break;
				}
			}
		}
		else
		{
			strTimerInfoId = [[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"id"];
			for(int j=0;j<[[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray count];j++)
			{
				if([strTimerInfoId isEqualToString:[[[AppDelegate_iPhone sharedAppDelegate].g_getEventsArray objectAtIndex:j]objectForKey:@"id"]])
				{
					EventIndex = j;
					eventArray = [[[AppDelegate_iPhone sharedAppDelegate].g_getEventsInfoArray objectAtIndex:j] mutableCopy];
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
		
		
		
		//Check whether it should be weekday or yearly selector
		if([timerArray count]>0)
		{
			if([[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"] length]>0)
			{
				//Check if date. present in the meta data
				if([[TimeConverterUtil getSharedInstance]containsDate:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"]])
				{
					[maintenanceDictionary setObject:@"NO" forKey:@"isWeekdaySelector"];
					[self setMetaData:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"]];
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
			if([[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"] length]>0)
			{
				//Check if date. present in the meta data
				if([[TimeConverterUtil getSharedInstance]containsDate:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"]])
				{
					[maintenanceDictionary setObject:@"NO" forKey:@"isWeekdaySelector"];
					[self setMetaData:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"metaData"]];
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
				//else
					//[maintenanceDictionary setObject:@"" forKey:@"scenesTextField"];
				
			}
		}
		else
		{
			[maintenanceDictionary setObject:@"YES" forKey:@"PreviousisTimeofday"];
			[maintenanceDictionary setObject:@"YES" forKey:@"isTimeofday"];
			NSString *timerString = [[timerArray objectAtIndex:0]objectForKey:@"startTime"];
			[self setActivationTime:timerString];
		}
		//Check whether it should randomized
		//NSMutableArray *timerArray = [[g_scheduleInfoList objectAtIndex:i]objectForKey:@"TimerInfo"];
		if([timerArray count]>0)
		{
			if([[[timerArray objectAtIndex:0]objectForKey:@"randomized"] length]>0)
				[maintenanceDictionary setObject:@"YES" forKey:@"isRandomize"];
			else
				[maintenanceDictionary setObject:@"NO" forKey:@"isRandomize"];
			
			
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
			//else
				//[maintenanceDictionary setObject:@"" forKey:@"scenesTextField"];
		}
		
		strInfoType = [[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:i]objectForKey:@"ScheduleInfoType"];
		
		[maintenanceDictionary setObject:strInfoType forKey:@"ScheduleInfoType"];
		[maintenanceDictionary setObject:@"0" forKey:@"_changeMask"];
		
		[maintenanceArray addObject:[maintenanceDictionary mutableCopy]];
		
	}
	[timerArray release];
	[eventArray release];
}
//Set custom image for button selected weekday selector
-(void)setCustomImage:(NSString*)dictKey:(UIButton*)btnType:(int)index
{
	if([dictKey isEqualToString:@"sunbtnselected"])
	{
		if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Su_sel.png"] forState:UIControlStateNormal];
		else
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Su.png"] forState:UIControlStateNormal];
		
	}
	else if([dictKey isEqualToString:@"monbtnselected"])
	{
		if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_M_sel.png"] forState:UIControlStateNormal];
		else
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_M.png"] forState:UIControlStateNormal];
		
	}
	else if([dictKey isEqualToString:@"tuebtnselected"])
	{
		if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Tu_sel.png"] forState:UIControlStateNormal];
		else
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Tu.png"] forState:UIControlStateNormal];
		
	}
	else if([dictKey isEqualToString:@"wedbtnselected"])
	{
		if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_W_sel.png"] forState:UIControlStateNormal];
		else
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_W.png"] forState:UIControlStateNormal];
		
	}
	else if([dictKey isEqualToString:@"thubtnselected"])
	{
		if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Th_sel.png"] forState:UIControlStateNormal];
		else
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Th.png"] forState:UIControlStateNormal];
		
	}
	else if([dictKey isEqualToString:@"fribtnselected"])
	{
		if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_F_sel.png"] forState:UIControlStateNormal];
		else
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_F.png"] forState:UIControlStateNormal];
		
	}
	else if([dictKey isEqualToString:@"satbtnselected"])
	{
		if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Sa_sel.png"] forState:UIControlStateNormal];
		else
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Sa.png"] forState:UIControlStateNormal];
		
	}
	else if([dictKey isEqualToString:@"allbtnselected"])
	{
		if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All_sel.png"] forState:UIControlStateNormal];
		else
			[btnType setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All.png"] forState:UIControlStateNormal];
		
	}
	/*if([[[maintenanceArray objectAtIndex:index]objectForKey:dictKey] isEqualToString:@"YES"])
		[btnType setBackgroundImage:[UIImage imageNamed:@"day-selected.png"] forState:UIControlStateNormal];
	else
		[btnType setBackgroundImage:[UIImage imageNamed:@"day-up.png"] forState:UIControlStateNormal];
*/
 }

-(void)loadScheduleDetails
{
	isLoadingSchedule = YES;
	
	randomizeLbl.hidden = YES;
	randomizeBtn.hidden = YES;
	imgRandomize.hidden = YES;
	
	if([[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"isTimeofday"] isEqualToString:@"YES"])
	{
		randomizeLbl.hidden = NO;
		randomizeBtn.hidden = NO;
		imgRandomize.hidden = NO;
		if([[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"isRandomize"] isEqualToString:@"YES"])
			[randomizeBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_Rand_sel.png"] forState:UIControlStateNormal];
		else
			[randomizeBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_Rand.png"] forState:UIControlStateNormal];
	}
	
	
	if([maintenanceArray count]>selectedIntIndex)
	{
		if([[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"isWeekdaySelector"] isEqualToString:@"YES"])
			isWeekdaySelector = YES;
		else
			isWeekdaySelector = NO;
		
		if([[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"isTimeofday"] isEqualToString:@"YES"])
			isTimeofday = YES;
		else
			isTimeofday = NO;
	}
	
	
	//Check if its in weeekdayselector or yearly selector
	if(isWeekdaySelector)
	{
		//[activationDayBtn setTitle:@"Yearly Run Selector" forState:UIControlStateNormal];
		[activationWeekdaySegment setSelectedSegmentIndex:0];
		lblWeekorYear.text = @"Days";
		lblYearlySelector.hidden = YES;
		lblDateString.hidden = YES;
		
		//Set week day button selected state
		sunBtn.hidden=NO;monBtn.hidden=NO;tueBtn.hidden=NO;wedBtn.hidden=NO;thuBtn.hidden=NO;friBtn.hidden=NO;satBtn.hidden=NO;allBtn.hidden=NO;
		
		
		[self setCustomImage:@"sunbtnselected" :sunBtn :selectedIntIndex];
		[self setCustomImage:@"monbtnselected" :monBtn :selectedIntIndex];
		[self setCustomImage:@"tuebtnselected" :tueBtn :selectedIntIndex];
		[self setCustomImage:@"wedbtnselected" :wedBtn :selectedIntIndex];
		[self setCustomImage:@"thubtnselected" :thuBtn :selectedIntIndex];
		[self setCustomImage:@"fribtnselected" :friBtn :selectedIntIndex];
		[self setCustomImage:@"satbtnselected" :satBtn :selectedIntIndex];
		[self setCustomImage:@"allbtnselected" :allBtn :selectedIntIndex];
		
		dateTextField.hidden = YES;datePickerBtn.hidden = YES;TodatePickerBtn.hidden = YES;TodateTextField.hidden= YES;
		fromLabel.hidden = YES;toLabel.hidden = YES;
		
		if(isTimeofday)
		{
			//[activationTimeBtn setTitle:@"Sunrise Sunset" forState:UIControlStateNormal];
			[activationTimeofdaySegment setSelectedSegmentIndex:0];
			sunriseBtn.hidden=YES;lblsunrise.hidden=YES;
			sunsetBtn.hidden=YES;lblsunset.hidden=YES;
			lblEventSliderValue.hidden=YES;eventSlider.hidden=YES;
			runat.hidden = YES;
			sunRiseOffset.hidden = YES;
			minutes.hidden = YES;
			minus60.hidden = YES;
			plus60.hidden = YES;
			
			timerTextField.hidden = NO;timePickerBtn.hidden = NO;
			//Set timertextfield text
			timerTextField.text = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"timerTextField"];
		}
		else
		{
			//[activationTimeBtn setTitle:@"Time of Day" forState:UIControlStateNormal];
			[activationTimeofdaySegment setSelectedSegmentIndex:1];
			sunriseBtn.hidden=NO;lblsunrise.hidden=NO;
			sunsetBtn.hidden=NO;lblsunset.hidden=NO;
			lblEventSliderValue.hidden=NO;eventSlider.hidden=NO;
			runat.hidden = NO;
			sunRiseOffset.hidden = NO;
			minutes.hidden = NO;
			minus60.hidden = NO;
			plus60.hidden = NO;
			timerTextField.hidden = YES;timePickerBtn.hidden = YES;
			
			//Set sunrise or sunset
			//[maintenanceDictionary setObject:@"YES" forKey:@"issunriseBool"];
			
			if([[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"issunriseBool"] isEqualToString:@"YES"])
			{
				[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Option_sel.png"] forState:UIControlStateNormal];
				[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Option_unsel.png"] forState:UIControlStateNormal];
			}
			else
			{
				[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Option_unsel.png"] forState:UIControlStateNormal];
				[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Option_sel.png"] forState:UIControlStateNormal];
			}
			
			//set modifiable values for uislider
			int sliderVal = 0;
			if(![[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"sliderValue"] isEqualToString:@""])
				sliderVal = [[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"sliderValue"] intValue];
			
			eventSlider.value = sliderVal;
			lblEventSliderValue.text = [NSString stringWithFormat:@"%d",sliderVal];
		}
	}
	else
	{
		//[activationDayBtn setTitle:@"WeekDay Selector" forState:UIControlStateNormal];
		[activationWeekdaySegment setSelectedSegmentIndex:1];
		lblWeekorYear.text = @"Yearly Selector";
		lblYearlySelector.hidden = NO;
		lblDateString.hidden = NO;
		sunBtn.hidden=YES;monBtn.hidden=YES;tueBtn.hidden=YES;wedBtn.hidden=YES;thuBtn.hidden=YES;friBtn.hidden=YES;satBtn.hidden=YES;allBtn.hidden=YES;
		
		dateTextField.hidden = NO;datePickerBtn.hidden = NO;TodatePickerBtn.hidden = NO;TodateTextField.hidden= NO;
		fromLabel.hidden = NO;toLabel.hidden = NO;
		
		//Set datetextfield value
		lblDateString.text = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"DateString"];
		dateTextField.text = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"dateTextField"];
		TodateTextField.text = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"TodateTextField"];
		if(isTimeofday)
		{
			//[activationTimeBtn setTitle:@"Sunrise Sunset" forState:UIControlStateNormal];
			[activationTimeofdaySegment setSelectedSegmentIndex:0];
			sunriseBtn.hidden=YES;lblsunrise.hidden=YES;
			sunsetBtn.hidden=YES;lblsunset.hidden=YES;
			lblEventSliderValue.hidden=YES;eventSlider.hidden=YES;
			runat.hidden = YES;
			sunRiseOffset.hidden = YES;
			minutes.hidden = YES;
			minus60.hidden = YES;
			plus60.hidden = YES;
			
			timerTextField.hidden = NO;timePickerBtn.hidden = NO;
			//Set timertextfield text
			timerTextField.text = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"timerTextField"];
		}
		else
		{
			//[activationTimeBtn setTitle:@"Time of Day" forState:UIControlStateNormal];
			[activationTimeofdaySegment setSelectedSegmentIndex:1];
			sunriseBtn.hidden=NO;lblsunrise.hidden=NO;
			sunsetBtn.hidden=NO;lblsunset.hidden=NO;
			lblEventSliderValue.hidden=NO;eventSlider.hidden=NO;
			timerTextField.hidden = YES;timePickerBtn.hidden = YES;
			runat.hidden = NO;
			sunRiseOffset.hidden = NO;
			minutes.hidden = NO;
			minus60.hidden = NO;
			plus60.hidden = NO;
			
			//Set sunrise or sunset
			if([[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"issunriseBool"] isEqualToString:@"YES"])
			{
				[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Option_sel.png"] forState:UIControlStateNormal];
				[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Option_unsel.png"] forState:UIControlStateNormal];
			}
			else
			{
				[sunriseBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Option_unsel.png"] forState:UIControlStateNormal];
				[sunsetBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Option_sel.png"] forState:UIControlStateNormal];
			}
			
			//set modifiable values for uislider
			int sliderVal = 0;
			if(![[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"sliderValue"] isEqualToString:@""])
				sliderVal = [[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"sliderValue"] intValue];
			
			eventSlider.value = sliderVal;
			lblEventSliderValue.text = [NSString stringWithFormat:@"%d",sliderVal];
		}
		
	}
	
	//Set scenes textfield value for that schedule
	scheduleNameLbl.text = [[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex] objectForKey:@"name"];
	scenesTextField.text = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"scenesTextField"];
	sceneNameLbl.text = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"scenesTextField"];
	[scrollView addSubview:subcontainerView];
	[scrollView setContentSize:CGSizeMake(320, 750)];
	
	isLoadingSchedule = NO;
}


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
	
	if(isSaveSchedule)
	{
		for (int i=0; i<[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList count]; i++) {
			int ID = [[[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList objectAtIndex:i] objectForKey:@"id"] intValue];
			if( ID == newScheduleId)
			{
				selectedIntIndex = i;
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


#pragma mark -
#pragma mark LOAD ALL VALUES 

-(void)initialLoad
{
	[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
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
					if([[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"ScheduleInfoType"] isEqualToString:@"ScheduleEventInfo"])
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
			if(isSaveSchedule)
			{
				if(isTimerorEventChange)
				{
					if([[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"ScheduleInfoType"] isEqualToString:@"ScheduleTimerInfo"])
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
			scheduleEnum = DONE;
			break;
		}
		case DONE:
		{
			[self initialTaskComplete];
			if(isDeleteSchedule)
			{
				isDeleteSchedule = NO;
				[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
				[self.navigationController popViewControllerAnimated:YES];
			}
			else if(isSaveSchedule)
			{
				[self InitializeDefaultScheduleValues];
				[self loadScheduleDetails];
				[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
				isSaveSchedule = NO;
				[self OpenWindow];
			}
			else
			{
				[self InitializeDefaultScheduleValues];
				[self loadScheduleDetails];
				[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
			}
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


#pragma mark -
#pragma mark PICKER DELEGATES

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	// This method needs to be used. It asks how many columns will be used in the UIPickerView
	return 1; // We only need one column so we will return 1.
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	return [[[AppDelegate_iPhone sharedAppDelegate] g_ScenesArray] count]; // We will need the amount of rows that we used in the pickerViewArray, so we will return the count of the array.
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	return [[[[AppDelegate_iPhone sharedAppDelegate] g_ScenesArray] objectAtIndex:row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { 
	scenePickerRowIndex = row;
}


#pragma mark -
#pragma mark HANDLERS FOR EDIT SCHEDULE NAME CLICK EVENT

-(IBAction)btnBackClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)EDITScheduleName:(id)sender
{
	[self.view addSubview:editScheduleView];
	
	currScheduleId = [[[[AppDelegate_iPhone	sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"]intValue ];
	editScheduleTextField.text	= [[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"name"];
}

-(IBAction)EDITScheduleNameSave:(id)sender
{
	if(![editScheduleTextField.text isEqualToString:@""])
	{
		strInfoType = [[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"ScheduleInfoType"];
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
		[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	}
}

-(IBAction)EDITScheduleNameSaveCancel:(id)sender
{
	[editScheduleView removeFromSuperview];
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
	{
		_changeMask = _changeMask ^ SUNRISE_SUNSET_OFFSET_CHANGE;
	}
	
	//Need to check the memento to see if it is the same if it is set the bit mask back
	//off
	if ( ( [[dictionary objectForKey:@"sliderValue"] intValue] == newSunriseSunsetOffset ) && ( _changeMask & SUNRISE_SUNSET_OFFSET_CHANGE ) )
	{
		_changeMask = _changeMask ^ SUNRISE_SUNSET_OFFSET_CHANGE;
	}
	
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 
{
	if(scrollView1==scrollView)
	{
		if(!isScheduleScrollSelect)
		{
			LastOffsetPointSchedule =  [scrollView contentOffset];
		}
	}
}

#pragma mark -
#pragma mark SAVE SCHEDULE CHANGES

-(IBAction)ScheduleSave:(id)sender
{
	[self saveScheduleOneByOne];
}

-(void)saveScheduleOneByOne
{
	isTimerToEvent = NO;
	//[self showLoadingView];
	isSaveSchedule = YES;
	[[AppDelegate_iPhone sharedAppDelegate]showCustomLoadingView];
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
			_changeMask = [[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"_changeMask"] intValue];
			strInfoType = [[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"ScheduleInfoType"];
			saveScheduleEnum = SCH_CHECK_TIMER_EVENT_CHANGE;
			break;
			
		}
		case SCH_CHECK_TIMER_EVENT_CHANGE:
		{
			if([[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"PreviousisTimeofday"] isEqualToString:@"YES"]&&[[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"isTimeofday"] isEqualToString:@"NO"])//Time to Event
			{	isTimerToEvent = YES;
				isTimerorEventChange = NO;
				saveScheduleEnum = SCH_CHECK_SCENE_CHANGE;
				strInfoType = @"ScheduleEventInfo";
			}
			else if([[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"PreviousisTimeofday"] isEqualToString:@"NO"]&&[[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"isTimeofday"] isEqualToString:@"YES"])//Event to Time
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
			if ((_changeMask & ASSOCIATED_SCENE_CHANGE )&&!([[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"scenesTextField"] isEqualToString:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"PreviousscenesTextField"]]))
			{
				if(isTimerorEventChange == NO)
				{
					if([[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"ScheduleInfoType"] isEqualToString:@"ScheduleTimerInfo"])
					{
						//INCLUDE_SCENE command
						NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"intoID"];
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"PreviousscenesTextFieldID"] forKey:@"scene"];
						[commandDictionary setObject:@"0" forKey:@"include"];
						[[TimerService getSharedInstance]includeScene:commandDictionary :self];
						[commandDictionary release];
						saveScheduleEnum = PROCESSING_SCH_CHECK_SCENE_CHANGE;
					}
					else
					{
						//EVENT_SCENE_INCLUDE command
						NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"intoID"];
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"PreviousscenesTextFieldID"] forKey:@"scene"];
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
				[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"id"];	
				[commandDictionary setObject:@"false" forKey:@"getList"];
				[[TimerService getSharedInstance]removeTimerFromController:commandDictionary :self];
				[commandDictionary release];
			}
			else //Change from event to time EVENT_REMOVE command
			{
				//EVENT_REMOVE command
				NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
				[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"id"];	
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
				[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"name"] forKey:@"name"];
				if([[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"_currentDays"]!=nil)
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"_currentDays"] forKey:@"daysActiveMask"];
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
				if([[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"startTime"]!=nil)
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"startTime"] forKey:@"startTime"];
				else
					[commandDictionary setObject:@"0" forKey:@"startTime"];
				if([[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"_currentDays"]!=nil)
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"_currentDays"] forKey:@"daysActiveMask"];
				else
					[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
				[commandDictionary setObject:@"false" forKey:@"enabled"];
				[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"name"] forKey:@"name"];
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
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"id"];	
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"id"];
					[commandDictionary setObject:@"0" forKey:@"startTime"];
					[commandDictionary setObject:@"false" forKey:@"enabled"];
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"_currentDays"] forKey:@"daysActiveMask"];
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
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"_currentDays"] forKey:@"daysActiveMask"];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"id"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"id"];
					[commandDictionary setObject:@"0" forKey:@"numScenesInEvent"];
					[commandDictionary setObject:@"0" forKey:@"sunriseOrSunset"];
					[[EventsService getSharedInstance]setDaysMask:commandDictionary :self];
					[commandDictionary release];
					saveScheduleEnum = PROCESSING;
				}
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
				NSString *startDate = [[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"dateTextField"];
				NSString *endDate = [[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"TodateTextField"];
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
					[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"relatedID"];
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
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"id"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"id"];
					[commandDictionary setObject:@"0" forKey:@"startTime"];
					[commandDictionary setObject:@"false" forKey:@"enabled"];
					[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
					if([[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"isRandomize"] isEqualToString:@"YES"])
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
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"startTime"] forKey:@"startTime"];
					[commandDictionary setObject:@"0" forKey:@"daysActiveMask"];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"id"];
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
				if ((_changeMask & ASSOCIATED_SCENE_CHANGE )&&!([[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"scenesTextField"] isEqualToString:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"PreviousscenesTextField"]]))
				{
					if([strInfoType isEqualToString:@"ScheduleTimerInfo"])
					{
						//INCLUDE_SCENE command
						NSMutableDictionary *commandDictionary = [[NSMutableDictionary alloc]init];
						if(isTimerorEventChange)
							[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"intoID"];
						else
							[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"intoID"];
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"PreviousscenesTextFieldID"] forKey:@"scene"];
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
							[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"intoID"];
						else
							[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"intoID"];
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"PreviousscenesTextFieldID"] forKey:@"scene"];
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
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"intoID"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"intoID"];
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"scenesTextFieldID"] forKey:@"scene"];
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
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"intoID"];
					else
						[commandDictionary setObject:[NSString stringWithFormat:@"%d",newScheduleId] forKey:@"intoID"];
					[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"scenesTextFieldID"] forKey:@"scene"];
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
					if([[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"sliderValue"] != nil)
						[commandDictionary setObject:[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"sliderValue"] forKey:@"modifiable"];
					else
						[commandDictionary setObject:@"0" forKey:@"modifiable"];
					[commandDictionary setObject:@"0" forKey:@"trigReasonID"];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"eventID"];
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
					if([[[maintenanceArray objectAtIndex:selectedIntIndex] objectForKey:@"issunriseBool"] isEqualToString:@"YES"])
						[commandDictionary setObject:@"1" forKey:@"reasonID"];
					else
						[commandDictionary setObject:@"2" forKey:@"reasonID"];
					if(isTimerorEventChange)
						[commandDictionary setObject:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] forKey:@"eventID"];
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
			//[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
			[self saveScheduleTaskComplete];
			[self initialLoad];
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
#pragma mark RESET SCHEDULE

-(IBAction)ScheduleReset:(id)sender
{
	[self InitializeDefaultScheduleValues];
	[self loadScheduleDetails];
}

#pragma mark -
#pragma mark DELETE SCHEDULE

-(IBAction)ScheduleDelete:(id)sender
{
	//Set current g_formatScheduleList id as currScheduleId
	currScheduleId = [[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex] objectForKey:@"id"] intValue];
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" 
												   message:@"Do you really want to delete this schedule ?" 
												  delegate:self 
										 cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
}



#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)activationWeekdaySegmentChanged:(id)sender
{
	if(!isLoadingSchedule)
	{
		isScheduleScrollSelect = YES;
		switch ([sender selectedSegmentIndex]) {
			case 0:
			{
				NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
				[dict setObject:@"YES" forKey:@"isWeekdaySelector"];
				[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
				break;
			}
			case 1:
			{
				NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
				[dict setObject:@"NO" forKey:@"isWeekdaySelector"];
				[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
				break;
			}
			default:
				break;
		}
		[self loadScheduleDetails];
		[scrollView setContentOffset:LastOffsetPointSchedule animated:NO];
		isScheduleScrollSelect = NO;
	}
}

-(IBAction)activationTimeofdaySegmentChanged:(id)sender
{
	if(!isLoadingSchedule)
	{
		isScheduleScrollSelect = YES;
		switch ([sender selectedSegmentIndex]) {
			case 0:
			{
				NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
				[dict setObject:[dict objectForKey:@"isTimeofday"] forKey:@"PreviousisTimeofday"];
				[dict setObject:@"YES" forKey:@"isTimeofday"];
				[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
				break;
			}
			case 1:
			{
				NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
				[dict setObject:[dict objectForKey:@"isTimeofday"] forKey:@"PreviousisTimeofday"];
				[dict setObject:@"NO" forKey:@"isTimeofday"];
				[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
				break;
			}
			default:
				break;
		}
		[self loadScheduleDetails];
		[scrollView setContentOffset:LastOffsetPointSchedule animated:NO];
		isScheduleScrollSelect = NO;
	}
}


-(IBAction)RandomizeBtnClicked:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	if([[[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"isRandomize"] isEqualToString:@"YES"])
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
		//[dict setObject:@"NO" forKey:@"isRandomize"];
		
		//Set change toggle randomized button in maintenance array
		[self toggleRandomized:@"NO" :dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
		[btn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_Rand.png"] forState:UIControlStateNormal];
	}
	else
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
		//[dict setObject:@"YES" forKey:@"isRandomize"];
		
		//Set change toggle randomized button in maintenance array
		[self toggleRandomized:@"YES" :dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
		[btn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_Rand_sel.png"] forState:UIControlStateNormal];
	}
}

-(IBAction)sunriseBtnClicked:(id)sender
{
	issunriseBool = YES;
	
	isScheduleScrollSelect = YES;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	//[dict setObject:@"YES" forKey:@"issunriseBool"];
	
	//set sunrise or sunest bool in maintenance array
	[self changeSunriseSunset:@"YES" :dict];
	
	[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
	//[btn setBackgroundImage:[UIImage imageNamed:@"CheckBox.png"] forState:UIControlStateNormal];
	[self loadScheduleDetails];
	[scrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
	
}
-(IBAction)sunsetBtnClicked:(id)sender
{
	issunriseBool = NO;
	
	isScheduleScrollSelect = YES;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	//[dict setObject:@"NO" forKey:@"issunriseBool"];
	
	//set sunrise or sunest bool in maintenance array
	[self changeSunriseSunset:@"NO" :dict];
	
	[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
	//[btn setBackgroundImage:[UIImage imageNamed:@"CheckBox.png"] forState:UIControlStateNormal];
	[self loadScheduleDetails];
	[scrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	isScheduleScrollSelect = NO;
}

-(IBAction)eventSliderValueChanged:(id)sender
{
	UISlider *slider = (UISlider *)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	lblEventSliderValue.text = [NSString stringWithFormat:@"%d",(int)[slider value]];
	//Set sunrise or sunset offset value changed in maintenance array
	if([[dict objectForKey:@"sliderValue"] intValue]!=(int)[slider value])
	{
		[self changeSunriseSunsetOffset:(int)[slider value] :dict];
		[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
	}
}

#pragma mark -
#pragma mark HANDLERS FOR WEEKDAY BUTTON CLICK EVENT

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
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :1 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_Su.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Su_sel.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"sunbtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Su.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"sunbtnselected"];
	}
	
	if([allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_All_sel.png"])
	{
		[allBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
}
-(IBAction)monBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :2 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_M.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_M_sel.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"monbtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_M.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"monbtnselected"];
	}
	
	if([allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_All_sel.png"])
	{
		[allBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
}
-(IBAction)tueBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :3 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_Tu.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Tu_sel.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"tuebtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Tu.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"tuebtnselected"];
	}
	
	if([allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_All_sel.png"])
	{
		[allBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
}
-(IBAction)wedBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :4 :dict];
	
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_W.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_W_sel.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"wedbtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_W.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"wedbtnselected"];
	}
	
	if([allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_All_sel.png"])
	{
		[allBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
}
-(IBAction)thuBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :5 :dict];
	
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_Th.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Th_sel.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"thubtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Th.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"thubtnselected"];
	}
	
	if([allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_All_sel.png"])
	{
		[allBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
}
-(IBAction)friBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :6 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_F.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_F_sel.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"fribtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_F.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"fribtnselected"];
	}
	
	if([allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_All_sel.png"])
	{
		[allBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
}
-(IBAction)satBtnClicked:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :7 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_Sa.png"])
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Sa_sel.png"] forState:UIControlStateNormal];
		[dict setObject:@"YES" forKey:@"satbtnselected"];
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Sa.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"satbtnselected"];
	}
	
	if([allBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_All_sel.png"])
	{
		[allBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All.png"] forState:UIControlStateNormal];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
	}
	
	[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
}
-(IBAction)allBtnClicked:(id)sender
{	
	UIButton *button = (UIButton*)sender;
	NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
	
	//Set current days as bit values and store as changemask
	[self handleDayClick:[[dict objectForKey:@"_currentDays"] intValue] :8 :dict];
	
	if([button backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_All.png"])
	{
		[dict setObject:@"NO" forKey:@"sunbtnselected"];
		[dict setObject:@"NO" forKey:@"monbtnselected"];
		[dict setObject:@"NO" forKey:@"tuebtnselected"];
		[dict setObject:@"NO" forKey:@"wedbtnselected"];
		[dict setObject:@"NO" forKey:@"thubtnselected"];
		[dict setObject:@"NO" forKey:@"fribtnselected"];
		[dict setObject:@"NO" forKey:@"satbtnselected"];
		[dict setObject:@"NO" forKey:@"allbtnselected"];
		
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All_sel.png"] forState:UIControlStateNormal];
		
		if([sunBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_Su_sel.png"])
		{
			[dict setObject:@"YES" forKey:@"sunbtnselected"];
		}
		else
			[sunBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Su_sel.png"] forState:UIControlStateNormal];
		
		if([monBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_M_sel.png"])
		{
			[dict setObject:@"YES" forKey:@"monbtnselected"];
		}
		else
			[monBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_M_sel.png"] forState:UIControlStateNormal];
		
		if([tueBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_Tu_sel.png"])
		{
			[dict setObject:@"YES" forKey:@"tuebtnselected"];
		}
		else
			[tueBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Tu_sel.png"] forState:UIControlStateNormal];
		
		if([wedBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_W_sel.png"])
		{
			[dict setObject:@"YES" forKey:@"wedbtnselected"];
		}
		else
			[wedBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_W_sel.png"] forState:UIControlStateNormal];
		
		if([thuBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_Th_sel.png"])
		{
			[dict setObject:@"YES" forKey:@"thubtnselected"];
		}
		else
			[thuBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Th_sel.png"] forState:UIControlStateNormal];
		
		if([friBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_F_sel.png"])
		{
			[dict setObject:@"YES" forKey:@"fribtnselected"];
		}
		else
			[friBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_F_sel.png"] forState:UIControlStateNormal];
		
		if([satBtn backgroundImageForState:UIControlStateNormal]==[UIImage imageNamed:@"iP_Sch_edit_Sa_sel.png"])
		{
			[dict setObject:@"YES" forKey:@"satbtnselected"];
		}
		else
			[satBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Sa_sel.png"] forState:UIControlStateNormal];
		
	}
	else
	{
		[button setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_All.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"sunbtnselected"] isEqualToString:@"YES"])
		{
			[sunBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Su_sel.png"] forState:UIControlStateNormal];
		}
		else
			[sunBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Su.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"monbtnselected"] isEqualToString:@"YES"])
		{
			[monBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_M_sel.png"] forState:UIControlStateNormal];
		}
		else
			[monBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_M.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"tuebtnselected"] isEqualToString:@"YES"])
		{
			[tueBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Tu_sel.png"] forState:UIControlStateNormal];
		}
		else
			[tueBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Tu.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"wedbtnselected"] isEqualToString:@"YES"])
		{
			[wedBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_W_sel.png"] forState:UIControlStateNormal];
		}
		else
			[wedBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_W.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"thubtnselected"] isEqualToString:@"YES"])
		{
			[thuBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Th_sel.png"] forState:UIControlStateNormal];
		}
		else
			[thuBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Th.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"fribtnselected"] isEqualToString:@"YES"])
		{
			[friBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_F_sel.png"] forState:UIControlStateNormal];
		}
		else
			[friBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_F.png"] forState:UIControlStateNormal];
		
		if([[dict  objectForKey:@"satbtnselected"] isEqualToString:@"YES"])
		{
			[satBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Sa_sel.png"] forState:UIControlStateNormal];
		}
		else
			[satBtn setBackgroundImage:[UIImage imageNamed:@"iP_Sch_edit_Sa.png"] forState:UIControlStateNormal];
	}
}

//picker popup ok and cancel
-(IBAction)pickerOkClicked:(id)sender
{
	[pickerPopupView removeFromSuperview];
	isScheduleScrollSelect = YES;
	if(isDatePicker)
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		//[dict setObject:[dateFormatter stringFromDate:datePicker.date] forKey:@"dateTextField"];
		
		//set changeDateRange based on maintenance array
		[self changeDateRange:[dateFormatter stringFromDate:datePicker.date] :dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
		[dateFormatter release];
		[self loadScheduleDetails];
		[scrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	else if(isToDatePicker)
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		//[dict setObject:[dateFormatter stringFromDate:datePicker.date] forKey:@"dateTextField"];
		
		//set changeDateRange based on maintenance array
		[self changeToDateRange:[dateFormatter stringFromDate:TodatePicker.date] :dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
		[dateFormatter release];
		[self loadScheduleDetails];
		[scrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	else if(isTimerPicker)
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"hh:mm a"];
		[dict setObject:[dateFormatter stringFromDate:timePicker.date] forKey:@"timerTextField"];
		
		//Set changed current time in maintenance dict
		[self changeActivateTime:dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
		[dateFormatter release];
		[self loadScheduleDetails];
		[scrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	else if(isScenePicker)
	{
		//scenesTextField.text = [[[[AppDelegate_iPhone sharedAppDelegate] g_ScenesArray] objectAtIndex:scenePickerRowIndex] objectForKey:@"name"];
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:selectedIntIndex];
		//[dict setObject:[[[[AppDelegate_iPhone sharedAppDelegate] g_ScenesArray] objectAtIndex:scenePickerRowIndex] objectForKey:@"name"] forKey:@"scenesTextField"];
		
		//set change selected scene in maintenacne dict
		[self changeSelectedScene:[[[[AppDelegate_iPhone sharedAppDelegate] g_ScenesArray] objectAtIndex:scenePickerRowIndex] objectForKey:@"name"] :[[[[AppDelegate_iPhone sharedAppDelegate] g_ScenesArray] objectAtIndex:scenePickerRowIndex] objectForKey:@"id"] :dict];
		
		[maintenanceArray replaceObjectAtIndex:selectedIntIndex withObject:dict];
		[self loadScheduleDetails];
		[scrollView setContentOffset:LastOffsetPointSchedule animated:NO];
	}
	isScheduleScrollSelect = NO;
}
-(IBAction)pickerCancelClicked:(id)sender
{
	[pickerPopupView removeFromSuperview];
}

-(IBAction)datePickerBtnClicked:(id)sender
{
	NSString *strDate = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"dateTextField"];
	if(![strDate isEqualToString:@""]&&strDate!=nil)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		datePicker.date = [dateFormatter dateFromString:strDate];
		[dateFormatter release];
	}
	
	isDatePicker= YES;isTimerPicker= NO;isScenePicker= NO;isToDatePicker=NO;
	
	//Remove all subviews from popview for load a new subviews
	[datePicker removeFromSuperview];
	[TodatePicker removeFromSuperview];
	[timePicker removeFromSuperview];
	[scenesPicker removeFromSuperview];
	
	datePicker.frame = CGRectMake(8, 100, 303, 216);
	[pickerPopupView addSubview:datePicker];
	[self.view addSubview:pickerPopupView];
	
}

-(IBAction)TodatePickerBtnClicked:(id)sender
{
	NSString *strDate = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"TodateTextField"];
	if(![strDate isEqualToString:@""]&&strDate!=nil)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"MM-dd-yyyy"];
		TodatePicker.date = [dateFormatter dateFromString:strDate];
		[dateFormatter release];
	}
	
	isDatePicker= NO;isTimerPicker= NO;isScenePicker= NO;isToDatePicker=YES;

	//Remove all subviews from popview for load a new subviews
	[datePicker removeFromSuperview];
	[TodatePicker removeFromSuperview];
	[timePicker removeFromSuperview];
	[scenesPicker removeFromSuperview];
	
	TodatePicker.frame = CGRectMake(8, 100, 303, 216);
	[pickerPopupView addSubview:TodatePicker];
	[self.view addSubview:pickerPopupView];
}




-(IBAction)timePickerBtnClicked:(id)sender
{
	NSString *strDate = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"timerTextField"];
	if(![strDate isEqualToString:@""]&&strDate!=nil)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
		[dateFormatter setDateFormat:@"hh:mm a"];
		timePicker.date = [dateFormatter dateFromString:strDate];
		[dateFormatter release];
	}
	
	isDatePicker= NO;isTimerPicker= YES;isScenePicker= NO;isToDatePicker=NO;
	
	//Remove all subviews from popview for load a new subviews
	[datePicker removeFromSuperview];
	[TodatePicker removeFromSuperview];
	[timePicker removeFromSuperview];
	[scenesPicker removeFromSuperview];
	
	timePicker.frame = CGRectMake(8, 100, 303, 216);
	[pickerPopupView addSubview:timePicker];
	[self.view addSubview:pickerPopupView];
}
-(IBAction)scenesPickerBtnClicked:(id)sender
{
	NSString *sceneName = [[maintenanceArray objectAtIndex:selectedIntIndex]objectForKey:@"scenesTextField"];
	
	//Check index of scene name in scenelist array
	for(int i=0;i<[[[AppDelegate_iPhone sharedAppDelegate] g_ScenesArray] count];i++)
	{
		NSString *scene = [[[[AppDelegate_iPhone sharedAppDelegate] g_ScenesArray] objectAtIndex:i] objectForKey:@"name"];
		if([scene isEqualToString:sceneName])
		{
			[scenesPicker selectRow:i inComponent:0 animated:NO];
			break;
		}
	}

	isDatePicker= NO;isTimerPicker= NO;isScenePicker= YES;isToDatePicker=NO;
	
	//Remove all subviews from popview for load a new subviews
	[datePicker removeFromSuperview];
	[TodatePicker removeFromSuperview];
	[timePicker removeFromSuperview];
	[scenesPicker removeFromSuperview];
	
	scenesPicker.frame = CGRectMake(8, 100, 303, 216);
	[pickerPopupView addSubview:scenesPicker];
	[self.view addSubview:pickerPopupView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
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
		//Copy the timer info array in g_getEventsArray
		[AppDelegate_iPhone  sharedAppDelegate].g_getEventsArray = [resultArray mutableCopy];
	}
	else if(strCommand==EVENT_GET_INFO)
	{
		scheduleEventInfoEnum = EVENT_INFO_DONE;
		//Copy the timer info array in g_getEventsInfoArray
		[[AppDelegate_iPhone  sharedAppDelegate].g_getEventsInfoArray addObject:[resultArray mutableCopy]];
	}
	else if(strCommand == TIMER_CHANGE_NAME)
	{
		//When we sent an timer change name command in the result we should get timer get name command and replace in the array and refresh the drawing view
		
		[[TimerService getSharedInstance]getName:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] :self];
		
	}
	else if(strCommand == EVENT_CHANGE_NAME)
	{
		//When we sent an event change name command in the result we should get event get name command and replace in the array and refresh the drawing view
		[[EventsService getSharedInstance]getName:[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"id"] :self];
	}
	else if(strCommand == GET_NAME)
	{
		//Update the array based on the schedule timer get name return
		[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"name"];
		NSMutableDictionary *dictionary = [[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex];
		if([resultArray count]>0)
			[dictionary setObject:[[resultArray objectAtIndex:0]objectForKey:@"name"] forKey:@"name"];
		[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:selectedIntIndex withObject:dictionary];
		[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
		[self loadScheduleDetails];
	}
	else if(strCommand == EVENT_GET_NAME)
	{
		//Update the array based on the schedule event get name return
		[[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"name"];
		NSMutableDictionary *dictionary = [[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex];
		if([resultArray count]>0)
			[dictionary setObject:[[resultArray objectAtIndex:0]objectForKey:@"name"] forKey:@"name"];
		[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList replaceObjectAtIndex:selectedIntIndex withObject:dictionary];
		[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
		[self loadScheduleDetails];
	}
	else if (strCommand == REMOVE)
	{
		if (saveScheduleEnum == PROCESSING)
		{
			//REMOVE TIMER AND TIMER INFO ARRAY
			for (int i=0; i<[[AppDelegate_iPhone  sharedAppDelegate].g_getTimersArray count]; i++) {
				int ID = [[[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex] objectForKey:@"id"] intValue];
				int TIMERID = [[[[AppDelegate_iPhone  sharedAppDelegate].g_getTimersArray objectAtIndex:i] objectForKey:@"id"] intValue];
				if( ID == TIMERID)
				{
					[[AppDelegate_iPhone  sharedAppDelegate].g_getTimersArray removeObjectAtIndex:i];
					[[AppDelegate_iPhone  sharedAppDelegate].g_getTimersInfoArray removeObjectAtIndex:i];
					break;
				}
			}
			saveScheduleEnum = SCH_ADD_SCHUDLE;
		}
		else
			[self initialLoad];
	}
	else if (strCommand == EVENT_REMOVE)
	{
		if(saveScheduleEnum == PROCESSING)
		{
			//REMOVE TIMER AND TIMER INFO ARRAY
			for (int i=0; i<[[AppDelegate_iPhone  sharedAppDelegate].g_getEventsArray count]; i++) {
				int ID = [[[[AppDelegate_iPhone  sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex] objectForKey:@"id"] intValue];
				int TIMERID = [[[[AppDelegate_iPhone  sharedAppDelegate].g_getEventsArray objectAtIndex:i] objectForKey:@"id"] intValue];
				if( ID == TIMERID)
				{
					[[AppDelegate_iPhone  sharedAppDelegate].g_getEventsArray removeObjectAtIndex:i];
					[[AppDelegate_iPhone  sharedAppDelegate].g_getEventsInfoArray removeObjectAtIndex:i];
					break;
				}
			}
			saveScheduleEnum = SCH_ADD_SCHUDLE;
		}
		else
			[self initialLoad];
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
	else if(strCommand == EVENT_ADD)
	{
		newScheduleId =[[[resultArray objectAtIndex:0] objectForKey:@"id"] intValue];
		saveScheduleEnum = SCH_EVENT_TRIG_DEVICE;
	}
	else if(strCommand == EVENT_SET_TRIGGER_DEVICE)
	{
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
		//saveScheduleEnum = SCH_SUNRISE_SUNSET_OFFSET_CHANGE;
		
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
		[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
		
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
	[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
	isDeleteSchedule = NO;
	if(isSaveSchedule)
	{
		[self saveScheduleTaskComplete];
		[self initialTaskComplete];
		isSaveSchedule = NO;
	}
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
	// Hint
	else if(alertView.tag == 325)
	{
		if(buttonIndex==1)
		{
			[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
			[[UserService getSharedInstance]Logout:self];
		}
	}
	else if(buttonIndex==1)
	{
		[[AppDelegate_iPhone sharedAppDelegate]showCustomLoadingView];
		isDeleteSchedule = YES;
		strInfoType = [[[AppDelegate_iPhone sharedAppDelegate].g_formatScheduleList objectAtIndex:selectedIntIndex]objectForKey:@"ScheduleInfoType"];
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
#pragma mark DEALLOC

- (void)dealloc {
	[Logout release];
	[animateImageView,animationScrollView,animationTitle1,animationTitle2 release];
	[scrollView release];
	[sceneNameLbl,scheduleNameLbl release];
	[activationWeekdaySegment,activationTimeofdaySegment release];
	[fromLabel,toLabel,lblDateString release];
	[selectedIndex release];
	[maintenanceArray,maintenanceDictionary release];
	
	[editScheduleView,editScheduleTextField release];
	
	//Custom classes schedule subscrollview class files
	[subcontainerView,pickerPopupView,pickerPopupsubView release];
	[activationDayBtn,activationTimeBtn,sunriseBtn,sunsetBtn release];
	[scenesPicker release];
	[datePicker,timePicker,TodatePicker release];
	[eventSlider,randomizeLbl release];
	[lblEventSliderValue,lblsunrise,lblsunset,lblWeekorYear,lblYearlySelector release];
	[sunBtn,monBtn,tueBtn,wedBtn,thuBtn,friBtn,satBtn,allBtn release];
	
	[dateTextField,timerTextField,scenesTextField,TodateTextField release];
	[datePickerBtn,timePickerBtn,scenesPickerBtn,TodatePickerBtn release];
	[pickerOkBtn,pickerCancelBtn,randomizeBtn release];
	[runat release];
	[sunRiseOffset,minutes,minus60,plus60,imgRandomize release];
    [super dealloc];
}


@end
