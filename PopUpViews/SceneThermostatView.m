    //
//  SceneThermostatView.m
//  Somfy
//
//  Created by Sempercon on 6/4/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "SceneThermostatView.h"
#import "ThermostatService.h"
#import "DashboardService.h"
#import "AppDelegate_iPad.h"
#import "SceneConfiguratorHomeownerService.h"
#import "LoginScreen_iPad.h"
#import "UserService.h"
#import "DBAccess.h"
#import "MJPEGViewer_iPad.h"

@interface SceneThermostatView (Private)
- (void)showLoadingView;
- (void)hideLoadingView;
- (void)getThermostatInfo;
- (void)thermostatTask;
- (int)packValues;
- (void)unPackValues:(int)settingValue;
- (void)updateUI;
- (void)scenSetMemberSetting;
@end

@implementation SceneThermostatView
@synthesize btnModeOFF,btnModeCool,btnModeHeat,btnEnergySaving,btnChangeTemp,btnUp,btnDown,btnClose;
@synthesize delegate;
@synthesize lblTemp;
@synthesize deviceDict,thermostatDeviceDict;
@synthesize lblSceneThermo;

#pragma mark -
#pragma mark LOAD

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

//Load SceneThermostatview from nib file
+ (SceneThermostatView*) sceneThermostatview
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"SceneThermostatView" owner:self options:nil];
	return [array objectAtIndex:0]; 
}

//Set maindelegate to get back to MainViewControllers
-(void) SetMainDelegate:(id<SkinChooserCallback>)callback
{
	delegate = callback;
	[delegate retain];
}

//Set device array from MainViewController
-(void)setDeviceDict:(NSMutableDictionary*)dict
{
	deviceDict = dict;
	[deviceDict retain];
    lblSceneThermo.text = [deviceDict objectForKey:@"name"];
	if([deviceDict objectForKey:@"name"] == nil)
		lblSceneThermo.text = @"Thermostat";
}

-(void)setSceneId:(int)nSceneID
{
	curSceneID = nSceneID;
}

-(void)setSceneIndex:(int)idx
{
	curSceneIdx = idx;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
/*	initTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 
												 target:self 
											   selector:@selector(getThermostatInfo) 
											   userInfo:nil 
												repeats:YES];*/
	int packedValue = [[deviceDict objectForKey:@"setting"]intValue];
	[self unPackValues:packedValue];
	[self updateUI];
	
	
}

-(void)setCurMetaData:(int)mData
{
	curMetaData = mData;
}

/*-(void)determineModeButtonLabel:(int)mode
{
	switch (mode) {
		case OFF:
		{
			[thermostatModeBtn setTitle:@"OFF" forState:UIControlStateNormal];
			lblPointTemperature.hidden = YES;
			lblTemperatureDeg.hidden = YES;
			lblEsSetPoint.hidden = YES;
			lblEsPointDeg.hidden = YES;
			break;
		}
		case HEAT:
		{
			[thermostatModeBtn setTitle:@"HEAT" forState:UIControlStateNormal];
			lblPointTemperature.hidden = NO;
			lblTemperatureDeg.hidden = NO;
			lblEsSetPoint.hidden = NO;
			lblEsPointDeg.hidden = NO;
			break;
		}
		case COOL:
		{
			[thermostatModeBtn setTitle:@"COOL" forState:UIControlStateNormal];
			lblPointTemperature.hidden = NO;
			lblTemperatureDeg.hidden = NO;
			lblEsSetPoint.hidden = NO;
			lblEsPointDeg.hidden = NO;
			break;
		}
		default:
			break;
	}
}

-(void)determineFanModeButtonLabel:(int)mode
{
	switch (mode) {
		case FAN_LOW:
			[thermostatFanModeBtn setTitle:@"ON" forState:UIControlStateNormal];
			break;
		case FAN_AUTO_LOW:
			[thermostatFanModeBtn setTitle:@"AUTO" forState:UIControlStateNormal];
			break;
		case FAN_HIGH:
			[thermostatFanModeBtn setTitle:@"HIGH" forState:UIControlStateNormal];
			break;
		case FAN_AUTO_HIGH:
			[thermostatFanModeBtn setTitle:@"AUTO HIGH" forState:UIControlStateNormal];
			break;
		default:
			break;
	}
}

-(void)determineScheduleModeButtonLabel:(int)mode
{
	switch (mode) {
		case USE_SCHEDULE:
			[thermostatScheduleBtn setTitle:@"HOLD" forState:UIControlStateNormal];
			break;
		case BYPASS_SCHEDULE:
			[thermostatScheduleBtn setTitle:@"BYPASS" forState:UIControlStateNormal];
			break;
		default:
			break;
	}
}

-(void)setEnergySavingMode:(int)mode
{
	switch (mode) {
		case NORMAL_MODE:
		{
			[energySavingModeBtn setTitle:@"NORMAL MODE" forState:UIControlStateNormal];
			lblEsSetPoint.hidden = YES;
			btnEsSetPointDown.hidden = YES;
			btnEsSetPointUp.hidden = YES;
			lblEsPointDeg.hidden = YES;
			break;
		}
		case ENERGY_SAVINGS_MODE:
		{
			[energySavingModeBtn setTitle:@"ENERGY SAVINGS MODE" forState:UIControlStateNormal];
			lblEsSetPoint.hidden = NO;
			btnEsSetPointDown.hidden = NO;
			btnEsSetPointUp.hidden = NO;
			lblEsPointDeg.hidden = NO;
			break;
		}
		default:
			break;
	}
}

-(void)TemperatureValues
{
	
	lblCurrentTemperature.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"ambientTemp"];
	lblPointTemperature.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"setTemp"];
	if([[[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"]intValue ] != 0)
		lblEsSetPoint.text = [[themostatDesiredTempArray objectAtIndex:0]objectForKey:@"value"];
	else 
		lblEsSetPoint.text =@"";
}


-(void)UpdateUI
{
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
}


-(void)getThermostatInfo
{
	
	if(initTimer!=nil)
	{
		[initTimer invalidate];
		initTimer = nil;
	}
	[self showLoadingView];
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
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}*/


/*-(void)commitProperties
 {
 //need to go through and set the values of the text properties and also 
 //set the values of the buttons
 
 //Lets set the label of the mode button to the correct value based on the 
 //value of the mode property
 btnMode.label = [self determineModeButtonLabel: _thermostatInfo.mode];
 btnFanMode.label = determineFanModeButtonLabel( _thermostatInfo.fanMode );
 
 //Need to determine the state of the schedule bypass satte
 if ( _thermostatInfo.scheduleBypass == ThermostatScheduleBypassEnums.USE_SCHEDULE )
 {
 tgbScheduleByPass.selected = true;
 tgbScheduleByPass.label = "BYPASS SCHEDULE";
 }else if ( _thermostatInfo.scheduleBypass == ThermostatScheduleBypassEnums.BYPASS_SCHEDULE )
 {
 tgbScheduleByPass.selected = false;
 tgbScheduleByPass.label = "USE SCHEDULE";
 }
 
 if ( _thermostatInfo.engSaveMode == ThermostatEnergySaveModeEnum.NORMAL_MODE )
 {
 tgbEngSaveMode.selected = true;
 tgbEngSaveMode.label = 'NORMAL MODE';
 tiEsSetPoint.enabled = false;
 
 lblEsSetPointValue.enabled = false;
 btnEsSetPointDown.enabled = false;
 btnEsSetPointUp.enabled = false;
 }
 else if ( _thermostatInfo.engSaveMode == ThermostatEnergySaveModeEnum.ENERGY_SAVINGS_MODE )
 {
 tgbEngSaveMode.selected = false;
 tgbEngSaveMode.label = 'ENERGY MODE';
 tiEsSetPoint.enabled = true;
 
 lblEsSetPointValue.enabled = true;
 btnEsSetPointDown.enabled = true;
 btnEsSetPointUp.enabled = true;
 }
 
 
 //Set the values for the text fields
 lblAmbientTemp.text = String(_thermostatInfo.ambientTemp) + "¬∫";
 
 //Set the setpoint temperature
 if ( _thermostatInfo.mode != ThermostateModeEnum.OFF )
 tiSetTemp.text = String ( _thermostatInfo.setTemp ) + "¬∫";
 else
 tiSetTemp.text = '';
 
 //Need to set the off value for the es set point
 if ( _thermostatInfo.mode == ThermostateModeEnum.OFF )
 {
 lblEsSetPointValue.text = '';
 }
 else if ( _thermostatInfo.esSetPoint != 0 )
 {				
 lblEsSetPointValue.text = String ( _thermostatInfo.esSetPoint ) + "¬∫";
 }
 
 //For degree
 @"\xC2\xB0"
 
 -(void)TemperatureValues
 {
 lblCurrentTemperature.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"ambientTemp"];
 lblPointTemperature.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"setTemp"];
 lblEsSetPoint.text = [[_thermostatInfo objectAtIndex:0]objectForKey:@"esSetPoint"];
 }
 
 
 -(void)UpdateUI
 {
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
 }
 
 }*/

-(void)unPackValues:(int)settingValue
{
	unpackedArray[0] = settingValue & 0xFF;
	unpackedArray[1] = (settingValue >> 8) & 0xFF;
	unpackedArray[2] = (settingValue >> 16) & 0xFF;
	unpackedArray[3] = (settingValue >> 24) & 0xFF;
}

-(int)packValues
{
	int packedInteger=-1;
	packedInteger = (unpackedArray[0] & 0xFF) | ((unpackedArray[1] & 0xFF )<<8)| ((unpackedArray[2] & 0xFF)<<16) | ((unpackedArray[3] & 0xFF)<<24);
	return packedInteger;
}

-(void)updateUI
{
	currDeviceZwaveId = [[deviceDict objectForKey:@"id"] intValue];
	if (currDeviceZwaveId > 0)
	{
		for(int i=0;i<[[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray count];i++)
		{
			if(currDeviceZwaveId == [[[[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray objectAtIndex:i]objectForKey:@"id"]intValue] )
			{
				thermostatDeviceDict = [[AppDelegate_iPad  sharedAppDelegate].g_getThermostatsArray objectAtIndex:i];
				break;
			}
		}	
	}
	if([thermostatDeviceDict count]>0)
		_thermostatCurrentSetPoint = [[thermostatDeviceDict objectForKey:@"setTemp"]intValue];
	else
		_thermostatCurrentSetPoint = 0;

	
	if(unpackedArray[1] == 0)//OFF
	{
		btnModeOFF.titleLabel.textColor =[UIColor blackColor];
		btnModeCool.titleLabel.textColor =[UIColor grayColor];
		btnModeHeat.titleLabel.textColor =[UIColor grayColor];
	}
	else if(unpackedArray[1] == 1)//HEAT
	{
		btnModeOFF.titleLabel.textColor =[UIColor grayColor];
		btnModeCool.titleLabel.textColor =[UIColor grayColor];
		btnModeHeat.titleLabel.textColor =[UIColor blackColor];
	}
	else if(unpackedArray[1] == 2)//COOL
	{
		btnModeOFF.titleLabel.textColor =[UIColor grayColor];
		btnModeCool.titleLabel.textColor =[UIColor blackColor];
		btnModeHeat.titleLabel.textColor =[UIColor grayColor];
	}
	
	if(unpackedArray[2] == 0)
	{
		[btnEnergySaving setTitle:@"Energy Saving" forState:UIControlStateNormal];
	}
	else if(unpackedArray[2] == 255)
	{
		[btnEnergySaving setTitle:@"Normal" forState:UIControlStateNormal];
	}
	
	_setPoint = unpackedArray[0];
	
	if(_setPoint == 255)
		_enabledSetPoint = NO;
	else 
		_enabledSetPoint = YES;
	
	if(_enabledSetPoint)
	{
		if(_setPoint != 255)
			lblTemp.text = [NSString stringWithFormat:@"%d",_setPoint];
		else 
		{
			
			_setPoint = _thermostatCurrentSetPoint;
			lblTemp.text = [NSString stringWithFormat:@"%d",_thermostatCurrentSetPoint];
			_proposedSetPoint = _thermostatCurrentSetPoint;
			[self scenSetMemberSetting];
			
		}
		btnUp.enabled = YES;
		btnDown.enabled = YES;
		[btnChangeTemp setBackgroundImage:[UIImage imageNamed:@"Randomize_selected.png"] forState:UIControlStateNormal];
		
	}
	else 
	{
		lblTemp.text = [NSString stringWithFormat:@"%d",_thermostatCurrentSetPoint];
		btnUp.enabled = NO;
		btnDown.enabled = NO;
		[btnChangeTemp setBackgroundImage:[UIImage imageNamed:@"Randomize.png"] forState:UIControlStateNormal];
	}


	
}

#pragma mark -
#pragma mark SEND COMMANDS TO SERVER

-(void)scenSetMemberSetting
{
	
	if(commandTimer!=nil)
	{
		[commandTimer invalidate];
		commandTimer = nil;
	}
	[self showLoadingView];
	commandTimer = [NSTimer scheduledTimerWithTimeInterval:0 
													target:self 
												  selector:@selector(setMemberSettingTask) 
												  userInfo:nil 
												   repeats:YES];
	commandEnum = NONE;
}

-(void)setMemberSettingTask
{
	switch(commandEnum)
	{
		case NONE:
		{
			commandEnum = SET_SCENE_MEMBER_SETTING;
			break;
		}
		case SET_SCENE_MEMBER_SETTING:
		{
			[self showLoadingView];
			NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
			[dataDict setObject:@"1" forKey:@"include"];
			[dataDict setObject:[deviceDict objectForKey:@"id"] forKey:@"id"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",curSceneID] forKey:@"scene"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",ZWAVE_DEVICE] forKey:@"settingType"];
			[dataDict setObject:@"1" forKey:@"setValue"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",[self packValues]] forKey:@"value"];
			//[[SceneConfiguratorHomeownerService getSharedInstance]setMemberSetting:[deviceDict objectForKey:@"zwaveID"] :self];
			[[SceneConfiguratorHomeownerService getSharedInstance]setMemberSetting:dataDict :self];
			[dataDict release];
			commandEnum = PROCESSING;
			break;
		}
		case SET_SCENE_MEMBER_SETTING_DONE:
		{
			commandEnum = GETSCENE_INFO;
			break;
		}
		case GETSCENE_INFO:
		{
			[[SceneConfiguratorHomeownerService getSharedInstance]getSceneInfo:[NSString stringWithFormat:@"%d",curSceneID] :self];
			commandEnum = PROCESSING;
			break;
		}
		case GETSCENE_INFO_DONE:
		{
			commandEnum = DONE;
			break;
		}
		case DONE:
		{
			[commandTimer invalidate];
			commandTimer=nil;
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)CloseBtnClicked:(id)sender
{
	[delegate removePopup];
}

-(IBAction)thermostatModeOffClicked:(id)sender
{
	unpackedArray[1]=0;
	[self scenSetMemberSetting];
}

-(IBAction)thermostatModeCoolClicked:(id)sender
{
	unpackedArray[1]=2;
	[self scenSetMemberSetting];
}

-(IBAction)thermostatModeHeatClicked:(id)sender
{
	unpackedArray[1]=1;
	[self scenSetMemberSetting];
}

-(IBAction)energySavingModeBtnClicked:(id)sender
{
	if([[btnEnergySaving currentTitle] isEqualToString:@"Normal"])
		unpackedArray[2]=0;
	else
		unpackedArray[2]=255;
	[self scenSetMemberSetting];
}

-(IBAction)btnTempDownClicked:(id)sender
{
	unpackedArray[0]=_setPoint-1;
	[self scenSetMemberSetting];
}

-(IBAction)btnTempUpClicked:(id)sender
{
	unpackedArray[0]=_setPoint+1;
	[self scenSetMemberSetting];
}

-(IBAction)btnChangeTempClicked:(id)sender
{
	
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
		UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, 1024, 100)];
        loadingLabel.text = @"";
		loadingLabel.textAlignment=UITextAlignmentCenter;
		loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
		loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.backgroundColor = [UIColor clearColor];
        [loadingView addSubview:loadingLabel];
		[loadingLabel release];
		
		UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(494, 402, 37.0, 37.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [loadingView addSubview:spinningWheel];
        [spinningWheel release];
    }
    
	[self addSubview:loadingView];
}

- (void)hideLoadingView
{
    [loadingView removeFromSuperview];
	[loadingView release];
	loadingView=nil;
}

#pragma mark -
#pragma mark SEND COMMAND CALLBACKS

-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand
{
	if(strCommand==SET_MEMBER_SETTINGS)
	{
		commandEnum = SET_SCENE_MEMBER_SETTING_DONE;
	}
	else if(strCommand==GET_SCENE_INFO)
	{
		//NSMutableDictionary *tempdict = [resultArray objectAtIndex:0];
		[[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray replaceObjectAtIndex:curSceneIdx withObject:resultArray];
		commandEnum = GETSCENE_INFO_DONE;
		[self updateUI];
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
    
	[commandTimer invalidate];
	commandTimer = nil;
	commandEnum = NONE;
	
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
			[[AppDelegate_iPad sharedAppDelegate].window addSubview:[AppDelegate_iPad sharedAppDelegate].loginScreen_iPadController.view];
		}
	}
}

#pragma mark -
#pragma mark DEALLOC

- (void)dealloc {
    [lblSceneThermo release];
	[deviceDict,thermostatDeviceDict release];
	[btnModeOFF,btnModeCool,btnModeHeat,btnEnergySaving,btnEnergySaving,btnChangeTemp,btnUp,btnDown,btnClose release];
	[lblTemp release];
	[delegate release];
    [super dealloc];
}
@end
