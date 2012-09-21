//
//  ThermostatEnergySavingMode.m
//  Somfy
//
//  Created by mac user on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThermostatEnergySavingMode.h"
#import "AppDelegate_iPhone.h"
#import "ThermostatService.h"
#import "DashboardService.h"
#import "UserService.h"
#import "DBAccess.h"


@interface ThermostatEnergySavingMode (Private)
- (void)UpdateUI;
-(void)OpenWindow;
@end

extern BOOL  _isLOGOUT;


@implementation ThermostatEnergySavingMode

@synthesize	deviceDict;
@synthesize applyButton;
@synthesize roomNameString;
@synthesize _thermostatInfo,themostatDesiredTempArray;
@synthesize temperatureLbl,deviceNameLbl,roomNameLbl;
@synthesize increaseBtn,decreaseBtn,backwardBtn,lblTempEnergySaving;
@synthesize btnThermostatMode,btnFanMode,btnScheduleMode,btnEnergySavingMode,btnEnergySavingIncrease,btnEnergySavingDecrease;
@synthesize mainScroll,temperatureLblDeg,lblTempEnergySavingDeg;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    
	animationScrollView.hidden = YES;
	
	animationTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, 300, 24)];
	animationTitle1.text = @"myTaHomA Message";
	animationTitle1.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	animationTitle1.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle1];
	//[animationTitle1 release];
	
	NSString *temp=@"";
	animationTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(14, 44, 300, 30)];
	temp = [deviceDict objectForKey:@"name"];
	temp = [temp stringByAppendingString:@" was updated."];
	animationTitle2.text = temp;
	animationTitle2.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
	animationTitle2.backgroundColor = [UIColor clearColor];
	[animateImageView addSubview:animationTitle2];
	//[animationTitle2 release];
	
	maintenanceArray		=	[[NSMutableArray alloc]init];
	maintenanceDictionary	=	[[NSMutableDictionary alloc]init];
	
	applyButton.enabled = NO;
	[mainScroll setContentSize:CGSizeMake(320, 800)];
	roomNameLbl.text = roomNameString;
	deviceNameLbl.text = [deviceDict objectForKey:@"name"];
	[self UpdateUI];
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[maintenanceArray release];
	[maintenanceDictionary release];
}

#pragma mark -
#pragma mark INITIAL LOAD

-(void)determineModeButtonLabel:(int)mode
{
	NSString *strMode = @"";
	increaseBtn.enabled = YES;
	decreaseBtn.enabled = YES;
	switch (mode) {
		case OFF:
		{
			btnThermostatMode.selectedSegmentIndex =0;
			increaseBtn.enabled = NO;
			decreaseBtn.enabled = NO;
			btnEnergySavingIncrease.enabled = NO;
			btnEnergySavingDecrease.enabled = NO;
			strMode = @"OFF";
			break;
		}
		case HEAT:
		{
			
			btnThermostatMode.selectedSegmentIndex =1;
			increaseBtn.enabled = YES;
			decreaseBtn.enabled = YES;
			btnEnergySavingIncrease.enabled = YES;
			btnEnergySavingDecrease.enabled = YES;
			strMode = @"HEAT";
			break;
		}
		case COOL:
		{
			btnThermostatMode.selectedSegmentIndex =2;
			increaseBtn.enabled = YES;
			decreaseBtn.enabled = YES;
			btnEnergySavingIncrease.enabled = YES;
			btnEnergySavingDecrease.enabled = YES;
			strMode = @"COOL";
			break;
		}
		default:
			break;
	}
	
	[maintenanceDictionary setObject:strMode forKey:@"current thermostatMode"];
	[maintenanceDictionary setObject:strMode forKey:@"previous thermostatMode"];
}

-(void)determineFanModeButtonLabel:(int)mode
{
	NSString *strMode = @"";
	switch (mode) {
		case FAN_LOW:
			btnFanMode.selectedSegmentIndex = 0;
			strMode = @"ON";
			//[autoBtn setTitle:@"ON" forState:UIControlStateNormal];
			break;
		case FAN_AUTO_LOW:
			btnFanMode.selectedSegmentIndex = 1;
			strMode = @"AUTO";
			//[autoBtn setTitle:@"AUTO" forState:UIControlStateNormal];
			break;
		case FAN_HIGH:
			//[autoBtn setTitle:@"HIGH" forState:UIControlStateNormal];
			break;
		case FAN_AUTO_HIGH:
			//[autoBtn setTitle:@"AUTO HIGH" forState:UIControlStateNormal];
			break;
		default:
			break;
	}
	
	[maintenanceDictionary setObject:strMode forKey:@"current fanMode"];
	[maintenanceDictionary setObject:strMode forKey:@"previous fanMode"];
}

-(void)determineScheduleModeButtonLabel:(int)mode
{
	NSString *strMode = @"";
	switch (mode) {
		case USE_SCHEDULE:
			btnScheduleMode.selectedSegmentIndex = 0;
			strMode = @"HOLD";
			//[holdBtn setTitle:@"HOLD" forState:UIControlStateNormal];
			break;
		case BYPASS_SCHEDULE:
			btnScheduleMode.selectedSegmentIndex = 1;
			strMode = @"BYPASS";
			//[holdBtn setTitle:@"BYPASS" forState:UIControlStateNormal];
			break;
		default:
			break;
	}
	[maintenanceDictionary setObject:strMode forKey:@"current scheduleMode"];
	[maintenanceDictionary setObject:strMode forKey:@"previous scheduleMode"];
}

-(void)setEnergySavingMode:(int)mode
{
	NSString *strMode = @"";
	switch (mode) {
		case NORMAL_MODE:
		{
			btnEnergySavingMode.selectedSegmentIndex =0;
			strMode = @"NORMAL_MODE";
			break;
		}
		case ENERGY_SAVINGS_MODE:
		{
			btnEnergySavingMode.selectedSegmentIndex = 1;
			strMode = @"ENERGY_SAVINGS_MODE";
			break;
		}
		default:
			break;
	}
	[maintenanceDictionary setObject:strMode forKey:@"current EnergySavingMode"];
	[maintenanceDictionary setObject:strMode forKey:@"previous EnergySavingMode"];
}

-(void)TemperatureValues
{
	NSString *strTemp = @"",*strEsTemp=@"";
	if([[[_thermostatInfo objectAtIndex:0]objectForKey:@"mode"]intValue] == OFF)
	{
		temperatureLbl.text = @"OFF";
		temperatureLblDeg.hidden = YES;
		lblTempEnergySaving.text=@"";
		lblTempEnergySavingDeg.hidden = YES;
		
		strTemp = @"OFF";
		strEsTemp = @"";
	}
	else
	{
		temperatureLbl.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"setTemp"];
		temperatureLblDeg.hidden = NO;
		lblTempEnergySaving.text=[[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"];
		lblTempEnergySavingDeg.hidden = NO;
		
		strTemp = [[_thermostatInfo objectAtIndex:0]objectForKey:@"setTemp"];
		strEsTemp = [[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"];
	}
	
	[maintenanceDictionary setObject:strTemp forKey:@"current setTemp"];
	[maintenanceDictionary setObject:strTemp forKey:@"previous setTemp"];
	
	[maintenanceDictionary setObject:strEsTemp forKey:@"current setEsTemp"];
	[maintenanceDictionary setObject:strEsTemp forKey:@"previous setEsTemp"];
}

-(void)UpdateUI
{
	/*if([[[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"]intValue ] != 0)
	 temperatureLbl.text = [[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"];
	 else 
	 temperatureLbl.text =@"";*/
	isLoadingSegment = YES;
	//set thermostat mode btn lbl
	[self determineModeButtonLabel:[[[_thermostatInfo objectAtIndex:0]objectForKey:@"mode"]intValue]];
	//set thermostat fan mode btn lbl
	[self determineFanModeButtonLabel:[[[_thermostatInfo objectAtIndex:0]objectForKey:@"fanMode"]intValue]];
	//set thermostat schedule mode btn lbl
	[self determineScheduleModeButtonLabel:[[[_thermostatInfo objectAtIndex:0]objectForKey:@"scheduleBypass"]intValue]];
	//setEnergysaving mode
	[self setEnergySavingMode:[[[_thermostatInfo objectAtIndex:0]objectForKey:@"engSaveMode"]intValue]];
	//set all label value
	[self TemperatureValues];
	
	if([maintenanceArray count]>0)
		[maintenanceArray removeAllObjects];
	
	[maintenanceArray addObject:maintenanceDictionary];
	
	isLoadingSegment = NO;
}

-(void)getThermostatInfo
{
	[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	ProcessTimer = [NSTimer scheduledTimerWithTimeInterval:0 
													target:self 
												  selector:@selector(thermostatTask) 
												  userInfo:nil 
												   repeats:YES];
	thermostatEnum = NONE;
}

-(void)thermostatTask
{
	switch(thermostatEnum)
	{
		case NONE:
		{
			thermostatEnum = GET_THERMOSTATUS;
			break;
		}
		case GET_THERMOSTATUS:
		{
			[[DashboardService getSharedInstance]getThermostatStatus:[deviceDict objectForKey:@"zwaveID"] :self];
			thermostatEnum = PROCESSING;
			break;
		}
		case GET_THERMOSTATUS_DONE:
		{
			thermostatEnum = GET_THERMOSTAT_DESIRED_TEMP;
			break;
		}
		case GET_THERMOSTAT_DESIRED_TEMP:
		{
			//TODO Need to check the command
			NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
			[dataDict setObject:@"0" forKey:@"esSetPoint"];
			[dataDict setObject:@"0" forKey:@"ambientTemp"];
			[dataDict setObject:@"0" forKey:@"setTemp"];
			[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
			[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"mode"] forKey:@"mode"];
			[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"engSaveMode"] forKey:@"engSaveMode"];
			[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"fanMode"] forKey:@"fanMode"];
			[dataDict setObject:@"0" forKey:@"roomID"];
			[dataDict setObject:@"0" forKey:@"devType"];
			[dataDict setObject:@"0" forKey:@"scheduleBypass"];
			[[DashboardService getSharedInstance]getThermostatDesiredTemp:dataDict :self];
			[dataDict release];
			
			thermostatEnum = PROCESSING;
			break;
		}
		case GET_THERMOSTAT_DESIRED_TEMP_DONE:
		{
			thermostatEnum = DONE;
			break;
		}
		case DONE:
		{
			[ProcessTimer invalidate];
			ProcessTimer=nil;
			[[AppDelegate_iPhone sharedAppDelegate] hideLoadingView];
			if(isSaveThermostat)
			{
				isSaveThermostat = NO;
				applyButton.enabled = NO;
				animationScrollView.hidden = NO;
				[self OpenWindow];
			}
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark FIND APPLY BUTTON NEED TO BE ENABLE OR DISABLE

-(void)applyButtonEnableorDisable
{
	if([maintenanceArray count]>0)
	{
		NSMutableDictionary *dict = [maintenanceArray objectAtIndex:0];
		if(![[dict objectForKey:@"current thermostatMode"] isEqualToString:[dict objectForKey:@"previous thermostatMode"]])
			applyButton.enabled = YES;
		else if(![[dict objectForKey:@"current fanMode"] isEqualToString:[dict objectForKey:@"previous fanMode"]])
			applyButton.enabled = YES;
		else if(![[dict objectForKey:@"current scheduleMode"] isEqualToString:[dict objectForKey:@"previous scheduleMode"]])
			applyButton.enabled = YES;
		else if(![[dict objectForKey:@"current EnergySavingMode"] isEqualToString:[dict objectForKey:@"previous EnergySavingMode"]])
			applyButton.enabled = YES;
		else if(![[dict objectForKey:@"current setTemp"] isEqualToString:[dict objectForKey:@"previous setTemp"]])
			applyButton.enabled = YES;
		else if(![[dict objectForKey:@"current setEsTemp"] isEqualToString:[dict objectForKey:@"previous setEsTemp"]])
			applyButton.enabled = YES;
		else
			applyButton.enabled = NO;
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
#pragma mark SAVE THERMOSTAT CHANGES

-(void)saveScheduleTask
{
	[[AppDelegate_iPhone sharedAppDelegate]showCustomLoadingView];
	isSaveThermostat = YES;
	saveThermostatTimer = [NSTimer scheduledTimerWithTimeInterval:0 
														 target:self 
													   selector:@selector(saveThermostatTask) 
													   userInfo:nil 
														repeats:YES];
	saveThermostatEnum = NONE;
}

-(void)saveThermostatTaskComplete
{
	[saveThermostatTimer invalidate];
	saveThermostatTimer=nil;
}

-(void)saveThermostatTask
{
	switch(saveThermostatEnum)
	{
		case NONE:
		{
			saveThermostatEnum = FAN_MODE;
			maintenanceDictionary = [maintenanceArray objectAtIndex:0];
			break;
			
		}
		case FAN_MODE:
		{
			if(![[maintenanceDictionary objectForKey:@"current fanMode"] isEqualToString:[maintenanceDictionary objectForKey:@"previous fanMode"]])
			{
				//THERMOSTAT_TOGGLE_FAN_MODE command
				[[DashboardService getSharedInstance]setThermostatToggleFanMode:[deviceDict objectForKey:@"zwaveID"] :self];
				saveThermostatEnum = PROCESSING;
			}
			else
				saveThermostatEnum = SCHEDULE_MODE;
			break;
		}
		case SCHEDULE_MODE:
		{
			if(![[maintenanceDictionary objectForKey:@"current scheduleMode"] isEqualToString:[maintenanceDictionary objectForKey:@"previous scheduleMode"]])
			{
				//THERMOSTAT_TOGGLE_SCHEDULE_HOLD command
				[[DashboardService getSharedInstance]setThermostatToggleScheduleHold:[deviceDict objectForKey:@"zwaveID"] :self];
				saveThermostatEnum = PROCESSING;
			}
			else
				saveThermostatEnum = ENERGY_SAVING_MODE;
			break;
		}
		case ENERGY_SAVING_MODE:
		{
			if(![[maintenanceDictionary objectForKey:@"current EnergySavingMode"] isEqualToString:[maintenanceDictionary objectForKey:@"previous EnergySavingMode"]])
			{
				//SET_THERMOSTAT_ENERGY_SAVE_MODE command
				int esModeValue = 0;
				if([[maintenanceDictionary objectForKey:@"current EnergySavingMode"] isEqualToString:@"NORMAL_MODE"])
					esModeValue = 100;
				else {
					esModeValue = 0;
				}
				NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
				[dataDict setObject:@"0" forKey:@"mode"];
				[dataDict setObject:@"0" forKey:@"devType"];
				[dataDict setObject:@"0" forKey:@"roomID"];
				[dataDict setObject:@"0" forKey:@"fanMode"];
				[dataDict setObject:[NSString stringWithFormat:@"%d",esModeValue] forKey:@"engSaveMode"];
				[dataDict setObject:@"0" forKey:@"esSetPoint"];
				[dataDict setObject:@"0" forKey:@"setTemp"];
				[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
				[dataDict setObject:@"0" forKey:@"scheduleBypass"];
				[dataDict setObject:@"0" forKey:@"ambientTemp"];
				[[DashboardService getSharedInstance]setThermostatEnergySaveMode:dataDict :self];
				[dataDict release];
				saveThermostatEnum = PROCESSING;
			}
			else
				saveThermostatEnum = SET_TEMPERATURE;
			break;
		}
		case SET_TEMPERATURE:
		{
			if(![[maintenanceDictionary objectForKey:@"current setTemp"] isEqualToString:[maintenanceDictionary objectForKey:@"previous setTemp"]])
			{
				//SET_TEMP command
				NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
				[dataDict setObject:@"0" forKey:@"ambientTemp"];
				[dataDict setObject:@"0" forKey:@"scheduleBypass"];
				[dataDict setObject:[maintenanceDictionary objectForKey:@"current setTemp"] forKey:@"setTemp"];
				[dataDict setObject:@"0" forKey:@"roomID"];
				[dataDict setObject:[deviceDict objectForKey:@"zwaveID"] forKey:@"id"];
				[dataDict setObject:@"0" forKey:@"devType"];
				[dataDict setObject:@"0" forKey:@"mode"];
				[dataDict setObject:@"0" forKey:@"fanMode"];
				[dataDict setObject:@"0" forKey:@"esSetPoint"];
				[dataDict setObject:@"0" forKey:@"engSaveMode"];
				[[ThermostatService getSharedInstance]setTemp:dataDict :self];
				[dataDict release];
				saveThermostatEnum = PROCESSING;
			}
			else
				saveThermostatEnum = SET_ES_TEMPERATURE;
			break;
		}
		case SET_ES_TEMPERATURE:
		{
			if(![[maintenanceDictionary objectForKey:@"current setEsTemp"] isEqualToString:[maintenanceDictionary objectForKey:@"previous setEsTemp"]])
			{
				//SET_ES_DESIRED_TEMP command
				NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
				[dataDict setObject:@"1" forKey:@"mode"];
				[dataDict setObject:@"0" forKey:@"setTemp"];
				[dataDict setObject:@"0" forKey:@"ambientTemp"];
				[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
				[dataDict setObject:@"0" forKey:@"engSaveMode"];
				[dataDict setObject:@"0" forKey:@"roomID"];
				[dataDict setObject:[maintenanceDictionary objectForKey:@"current setEsTemp"] forKey:@"esSetPoint"];
				[dataDict setObject:@"0" forKey:@"scheduleBypass"];
				[dataDict setObject:@"0" forKey:@"fanMode"];
				[dataDict setObject:@"0" forKey:@"devType"];
				[[ThermostatService getSharedInstance]setEsDesiredTemperature:dataDict :self];
				[dataDict release];				
				saveThermostatEnum = PROCESSING;
			}
			else
				saveThermostatEnum = THERMOSTAT_MODE;
			break;
		}
		case THERMOSTAT_MODE:
		{
			if(![[maintenanceDictionary objectForKey:@"current thermostatMode"] isEqualToString:[maintenanceDictionary objectForKey:@"previous thermostatMode"]])
			{
				if([[maintenanceDictionary objectForKey:@"previous thermostatMode"] isEqualToString:@"OFF"])
				{
					if([[maintenanceDictionary objectForKey:@"current thermostatMode"] isEqualToString:@"HEAT"])
						noofTimes = 1;
					else
						noofTimes = 2;
				}
				else if([[maintenanceDictionary objectForKey:@"previous thermostatMode"] isEqualToString:@"HEAT"])
				{
					if([[maintenanceDictionary objectForKey:@"current thermostatMode"] isEqualToString:@"COOL"])
						noofTimes = 1;
					else
						noofTimes = 2;
				}
				else if([[maintenanceDictionary objectForKey:@"previous thermostatMode"] isEqualToString:@"COOL"])
				{
					if([[maintenanceDictionary objectForKey:@"current thermostatMode"] isEqualToString:@"OFF"])
						noofTimes = 1;
					else
						noofTimes = 2;
				}
				//THERMOSTAT_TOGGLE_MODE command
				[[DashboardService getSharedInstance]setThermostatToggleMode:[deviceDict objectForKey:@"zwaveID"] :self];
				saveThermostatEnum = PROCESSING;
			}
			else
				saveThermostatEnum = DONE;
			break;
		}
		case DONE:
		{
			[self saveThermostatTaskComplete];
			[self getThermostatInfo];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)thermostatIncrease:(id)sender
{
	/*[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	[[DashboardService getSharedInstance]setThermostatTempUp:[deviceDict objectForKey:@"zwaveID"] :self];*/
	
	if([maintenanceArray count]>0)
	{
		maintenanceDictionary = [maintenanceArray objectAtIndex:0];
		if(![[maintenanceDictionary objectForKey:@"current setTemp"] isEqualToString:@""])
		{
			esSetpoint = [[maintenanceDictionary objectForKey:@"current setTemp"] intValue];
			esSetpoint+=1;
			[maintenanceDictionary setObject:[NSString stringWithFormat:@"%d",esSetpoint] forKey:@"current setTemp"];
			[maintenanceArray replaceObjectAtIndex:0 withObject:maintenanceDictionary];
			[self applyButtonEnableorDisable];
			
			temperatureLbl.text = [NSString stringWithFormat:@"%d",esSetpoint];
		}
	}
	
}

-(IBAction)thermostatDecrease:(id)sender
{
	//[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
	//[[DashboardService getSharedInstance]setThermostatTempDown:[deviceDict objectForKey:@"zwaveID"] :self];
	
	if([maintenanceArray count]>0)
	{
		maintenanceDictionary = [maintenanceArray objectAtIndex:0];
		if(![[maintenanceDictionary objectForKey:@"current setTemp"] isEqualToString:@""])
		{
			esSetpoint = [[maintenanceDictionary objectForKey:@"current setTemp"] intValue];
			esSetpoint-=1;
			[maintenanceDictionary setObject:[NSString stringWithFormat:@"%d",esSetpoint] forKey:@"current setTemp"];
			[maintenanceArray replaceObjectAtIndex:0 withObject:maintenanceDictionary];
			[self applyButtonEnableorDisable];
			
			temperatureLbl.text = [NSString stringWithFormat:@"%d",esSetpoint];
		}
	}
}

-(IBAction)ApplyClicked:(id)sender
{
	//[self.navigationController popViewControllerAnimated:YES];
	applyButton.enabled = NO;
	[self saveScheduleTask];
}

-(IBAction)backwardBtnClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnThermostatModeClicked:(id)sender
{
	UISegmentedControl *segControl = (UISegmentedControl*)sender;
	if(!isLoadingSegment)
	{
		//[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
		//[[DashboardService getSharedInstance]setThermostatToggleMode:[deviceDict objectForKey:@"zwaveID"] :self];
		
		switch ([segControl selectedSegmentIndex]) {
			case 0:
			{
				[maintenanceDictionary setObject:@"OFF" forKey:@"current thermostatMode"];
				break;
			}
			case 1:
			{
				[maintenanceDictionary setObject:@"HEAT" forKey:@"current thermostatMode"];
				break;
			}
			case 2:
			{
				[maintenanceDictionary setObject:@"COOL" forKey:@"current thermostatMode"];
				break;
			}
			default:
				break;
		}
		[maintenanceArray replaceObjectAtIndex:0 withObject:maintenanceDictionary];
		[self applyButtonEnableorDisable];
	}
}

-(IBAction)btnFanMode:(id)sender
{
	UISegmentedControl *segControl = (UISegmentedControl*)sender;
	if(!isLoadingSegment)
	{
		//[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
		//[[DashboardService getSharedInstance]setThermostatToggleFanMode:[deviceDict objectForKey:@"zwaveID"] :self];
		
		switch ([segControl selectedSegmentIndex]) {
			case 0:
			{
				[maintenanceDictionary setObject:@"ON" forKey:@"current fanMode"];
				break;
			}
			case 1:
			{
				[maintenanceDictionary setObject:@"AUTO" forKey:@"current fanMode"];
				break;
			}
			default:
				break;
		}
		[maintenanceArray replaceObjectAtIndex:0 withObject:maintenanceDictionary];
		[self applyButtonEnableorDisable];
	}
	
}
-(IBAction)btnScheduleMode:(id)sender
{
	UISegmentedControl *segControl = (UISegmentedControl*)sender;
	if(!isLoadingSegment)
	{
		//[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
		//[[DashboardService getSharedInstance]setThermostatToggleScheduleHold:[deviceDict objectForKey:@"zwaveID"] :self];
		switch ([segControl selectedSegmentIndex]) {
			case 0:
			{
				[maintenanceDictionary setObject:@"HOLD" forKey:@"current scheduleMode"];
				break;
			}
			case 1:
			{
				[maintenanceDictionary setObject:@"BYPASS" forKey:@"current scheduleMode"];
				break;
			}
			default:
				break;
		}
		[maintenanceArray replaceObjectAtIndex:0 withObject:maintenanceDictionary];
		[self applyButtonEnableorDisable];
	}
	
}
-(IBAction)btnEnergySavingMode:(id)sender
{
	UISegmentedControl *segControl = (UISegmentedControl*)sender;
	if(!isLoadingSegment)
	{
		/*int esModeValue = 0;
		[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
		if(btnEnergySavingMode.selectedSegmentIndex == 0)
			esModeValue = 100;
		else {
			esModeValue = 0;
		}
		
		//TODO Need to check the command
		NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
		[dataDict setObject:@"0" forKey:@"mode"];
		[dataDict setObject:@"0" forKey:@"devType"];
		[dataDict setObject:@"0" forKey:@"roomID"];
		[dataDict setObject:@"0" forKey:@"fanMode"];
		[dataDict setObject:[NSString stringWithFormat:@"%d",esModeValue] forKey:@"engSaveMode"];
		[dataDict setObject:@"0" forKey:@"esSetPoint"];
		[dataDict setObject:@"0" forKey:@"setTemp"];
		[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
		[dataDict setObject:@"0" forKey:@"scheduleBypass"];
		[dataDict setObject:@"0" forKey:@"ambientTemp"];
		[[DashboardService getSharedInstance]setThermostatEnergySaveMode:dataDict :self];
		[dataDict release];*/
		
		
		switch ([segControl selectedSegmentIndex]) {
			case 0:
			{
				[maintenanceDictionary setObject:@"NORMAL_MODE" forKey:@"current EnergySavingMode"];
				break;
			}
			case 1:
			{
				[maintenanceDictionary setObject:@"ENERGY_SAVINGS_MODE" forKey:@"current EnergySavingMode"];
				break;
			}
			default:
				break;
		}
		[maintenanceArray replaceObjectAtIndex:0 withObject:maintenanceDictionary];
		[self applyButtonEnableorDisable];
	}
}


-(IBAction)btnEnergySavingIncrease:(id)sender
{
	/*esSetpoint = [[[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"] intValue];
	//esSetpoint = [[[_thermostatInfo objectAtIndex:0] objectForKey:@"esSetPoint"] intValue];
	esSetpoint+=1;
	if(esSetpoint>=0&&esSetpoint<=100)
	{
		[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
		NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
		[dataDict setObject:@"1" forKey:@"mode"];
		[dataDict setObject:@"0" forKey:@"setTemp"];
		[dataDict setObject:@"0" forKey:@"ambientTemp"];
		[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
		[dataDict setObject:@"0" forKey:@"engSaveMode"];
		[dataDict setObject:@"0" forKey:@"roomID"];
		[dataDict setObject:[NSString stringWithFormat:@"%d",esSetpoint] forKey:@"esSetPoint"];
		[dataDict setObject:@"0" forKey:@"scheduleBypass"];
		[dataDict setObject:@"0" forKey:@"fanMode"];
		[dataDict setObject:@"0" forKey:@"devType"];
		[[ThermostatService getSharedInstance]setEsDesiredTemperature:dataDict :self];
		[dataDict release];
	}*/
	
	if([maintenanceArray count]>0)
	{
		maintenanceDictionary = [maintenanceArray objectAtIndex:0];
		if(![[maintenanceDictionary objectForKey:@"current setEsTemp"] isEqualToString:@""])
		{
			esSetpoint = [[maintenanceDictionary objectForKey:@"current setEsTemp"] intValue];
			esSetpoint+=1;
			[maintenanceDictionary setObject:[NSString stringWithFormat:@"%d",esSetpoint] forKey:@"current setEsTemp"];
			[maintenanceArray replaceObjectAtIndex:0 withObject:maintenanceDictionary];
			[self applyButtonEnableorDisable];
			lblTempEnergySaving.text = [NSString stringWithFormat:@"%d",esSetpoint];
		}
	}
	
}
-(IBAction)btnEnergySavingDecrease:(id)sender
{
	/*esSetpoint = [[[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"] intValue];
	//esSetpoint = [[[_thermostatInfo objectAtIndex:0] objectForKey:@"esSetPoint"] intValue];
	esSetpoint-=1;
	if(esSetpoint>=0&&esSetpoint<=100)
	{
		[[AppDelegate_iPhone sharedAppDelegate] showCustomLoadingView];
		NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
		[dataDict setObject:@"1" forKey:@"mode"];
		[dataDict setObject:@"0" forKey:@"setTemp"];
		[dataDict setObject:@"0" forKey:@"ambientTemp"];
		[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
		[dataDict setObject:@"0" forKey:@"engSaveMode"];
		[dataDict setObject:@"0" forKey:@"roomID"];
		[dataDict setObject:[NSString stringWithFormat:@"%d",esSetpoint] forKey:@"esSetPoint"];
		[dataDict setObject:@"0" forKey:@"scheduleBypass"];
		[dataDict setObject:@"0" forKey:@"fanMode"];
		[dataDict setObject:@"0" forKey:@"devType"];
		[[ThermostatService getSharedInstance]setEsDesiredTemperature:dataDict :self];
		[dataDict release];
	}*/
	
	if([maintenanceArray count]>0)
	{
		maintenanceDictionary = [maintenanceArray objectAtIndex:0];
		if(![[maintenanceDictionary objectForKey:@"current setEsTemp"] isEqualToString:@""])
		{
			esSetpoint = [[maintenanceDictionary objectForKey:@"current setEsTemp"] intValue];
			esSetpoint-=1;
			[maintenanceDictionary setObject:[NSString stringWithFormat:@"%d",esSetpoint] forKey:@"current setEsTemp"];
			[maintenanceArray replaceObjectAtIndex:0 withObject:maintenanceDictionary];
			[self applyButtonEnableorDisable];
			lblTempEnergySaving.text = [NSString stringWithFormat:@"%d",esSetpoint];
		}
	}
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
	if(strCommand==THERMOSTAT_GET_STATUS)
	{
		//Copy the getscenes result
		_thermostatInfo = [resultArray mutableCopy];
		//update in gobal array
		NSString *devId = [deviceDict objectForKey:@"zwaveID"];
		for(int i=0;i<[[AppDelegate_iPhone  sharedAppDelegate].g_getThermostatsArray count];i++)
		{
			if([devId isEqualToString:[[[AppDelegate_iPhone  sharedAppDelegate].g_getThermostatsArray objectAtIndex:i]objectForKey:@"id"]] )
			{
				if([_thermostatInfo count] > 0)
					[[AppDelegate_iPhone  sharedAppDelegate].g_getThermostatsArray replaceObjectAtIndex:i withObject:[_thermostatInfo objectAtIndex:0]];
				break;
			}
		}
		[self UpdateUI];
		thermostatEnum = GET_THERMOSTATUS_DONE;
	}
	else if(strCommand==THERMOSTAT_GET_DESIRED_TEMP || strCommand==GET_ES_DESIRED_TEMP)
	{
		[[AppDelegate_iPhone sharedAppDelegate]hideLoadingView];
		thermostatEnum = GET_THERMOSTAT_DESIRED_TEMP_DONE;
		//Copy the getscenes result
		themostatDesiredTempArray = [resultArray mutableCopy];
		[self UpdateUI];
	}
	else if(strCommand == SET_ES_DESIRED_TEMP)
	{
		/*NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
		[dataDict setObject:@"1" forKey:@"mode"];
		[dataDict setObject:@"0" forKey:@"setTemp"];
		[dataDict setObject:@"0" forKey:@"ambientTemp"];
		[dataDict setObject:[[_thermostatInfo objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
		[dataDict setObject:@"0" forKey:@"engSaveMode"];
		[dataDict setObject:@"0" forKey:@"roomID"];
		[dataDict setObject:[NSString stringWithFormat:@"%d",esSetpoint] forKey:@"esSetPoint"];
		[dataDict setObject:@"0" forKey:@"scheduleBypass"];
		[dataDict setObject:@"0" forKey:@"fanMode"];
		[dataDict setObject:@"0" forKey:@"devType"];
		[[ThermostatService getSharedInstance]getEsDesiredTemp:dataDict :self];
		[dataDict release];*/
		saveThermostatEnum = THERMOSTAT_MODE;
	}
	/*else if(strCommand==SET_THERMOSTAT_TEMP_DOWN||strCommand==SET_THERMOSTAT_TEMP_UP||strCommand==THERMOSTAT_TOGGLE_SCHEDULE_HOLD||strCommand==THERMOSTAT_TOGGLE_FAN_MODE||strCommand==THERMOSTAT_TOGGLE_MODE)
	{
		[self getThermostatInfo];
	}*/
	else if(strCommand == THERMOSTAT_TOGGLE_FAN_MODE)
	{
		saveThermostatEnum = SCHEDULE_MODE;
	}
	else if(strCommand == THERMOSTAT_TOGGLE_SCHEDULE_HOLD)
	{
		saveThermostatEnum = ENERGY_SAVING_MODE;
	}
	else if(strCommand == THERMOSTAT_TOGGLE_MODE)
	{
		if(noofTimes==2)
		{
			noofTimes = 1;
			//THERMOSTAT_TOGGLE_MODE command
			[[DashboardService getSharedInstance]setThermostatToggleMode:[deviceDict objectForKey:@"zwaveID"] :self];
		}
		else
			saveThermostatEnum = DONE;
	}
	else if(strCommand == SET_TEMP)
	{
		saveThermostatEnum = SET_ES_TEMPERATURE;
	}
	else if(strCommand == SET_THERMOSTAT_ENERGY_SAVE_MODE)
	{
		saveThermostatEnum = SET_TEMPERATURE;
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
	
	if(isSaveThermostat)
	{
		isSaveThermostat = NO;
		[self saveThermostatTaskComplete];
		applyButton.enabled = YES;
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
}


#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
	[Logout release];
	[animateImageView release];
	[animationScrollView release];
	[animationTitle1,animationTitle2 release];
	[applyButton release];
	

	[mainScroll,temperatureLblDeg,lblTempEnergySavingDeg release];
	[increaseBtn,decreaseBtn,backwardBtn release];
	[temperatureLbl,deviceNameLbl,roomNameLbl release];
	[_thermostatInfo,themostatDesiredTempArray release];
	[deviceDict,roomNameString release];
	[btnThermostatMode,btnFanMode,btnScheduleMode,btnEnergySavingMode,btnEnergySavingIncrease,btnEnergySavingDecrease release];
	[lblTempEnergySaving release];
    [super dealloc];
}


@end
