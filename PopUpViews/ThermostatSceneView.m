//
//  ThermostatSceneView.m
//  Somfy
//
//  Created by macuser on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThermostatSceneView.h"
#import "SceneThermostatView.h"
#import "ThermostatService.h"
#import "DashboardService.h"
#import "AppDelegate_iPad.h"
#import "SceneConfiguratorHomeownerService.h"
#import "LoginScreen_iPad.h"
#import "UserService.h"
#import "DBAccess.h"
#import "UserService.h"
#import "MJPEGViewer_iPad.h"

@interface ThermostatSceneView (Private)
- (void)showLoadingView;
- (void)hideLoadingView;
- (void)getThermostatInfo;
- (void)thermostatTask;
- (int)packValues;
- (void)unPackValues:(int)settingValue;
- (void)updateUI;
- (void)scenSetMemberSetting;
- (void)SetTemp;
@end

@implementation ThermostatSceneView

@synthesize btnModeOFF,btnModeCool,btnModeHeat,btnEnergySaving,btnChangeTemp,btnUp,btnDown,btnClose;
@synthesize delegate;
@synthesize lblTemp;
@synthesize lblDeg;
@synthesize deviceDict;
@synthesize lblThermoStat;
@synthesize selectedRoomDeviceArray;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


//Load SceneThermostatview from nib file
+ (ThermostatSceneView*) thermostatSceneView
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"ThermostatSceneView" owner:self options:nil];
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
    lblThermoStat.text = [deviceDict objectForKey:@"name"];
	if([deviceDict objectForKey:@"name"] == nil)
		lblThermoStat.text = @"Thermostat";
}

-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr
{
	selectedRoomDeviceArray = arr;
	[selectedRoomDeviceArray retain];
}

-(void)setSceneId:(int)nSceneID
{
	curSceneID = nSceneID;
}

-(void)setSceneIndex:(int)idx
{
	curSceneIdx = idx;
}

-(void)setIsFromScene:(int)indicator
{
	isFromScene = indicator;
}

-(void)setCurMetaData:(int)mData
{
	curMetaData = mData;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	int packedValue = [[deviceDict objectForKey:@"setting"]intValue];
	[self unPackValues:packedValue];
	[self updateUI];
}

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
	else
	{
		btnModeOFF.titleLabel.textColor =[UIColor blackColor];
		btnModeCool.titleLabel.textColor =[UIColor grayColor];
		btnModeHeat.titleLabel.textColor =[UIColor grayColor];
	}
	
	if(unpackedArray[2] == 100)
	{
		[btnEnergySaving setTitle:@"NORMAL" forState:UIControlStateNormal];
	}
	else if(unpackedArray[2] == 0)
	{
		[btnEnergySaving setTitle:@"ENERGY SAVING" forState:UIControlStateNormal];
	}
	
	_setPoint = unpackedArray[0];
	
	if(_setPoint == 255)
		_enabledSetPoint = NO;
	else 
		_enabledSetPoint = YES;
	
	[self SetTemp];
	
}

-(void)SetTemp
{
	if(_enabledSetPoint)
	{
		if(_setPoint != 255)
		{
			lblDeg.hidden = NO;
			lblTemp.text = [NSString stringWithFormat:@"%d",_setPoint];
		}
		else 
		{
			
			_setPoint = _thermostatCurrentSetPoint;
			lblDeg.hidden = NO;
			lblTemp.text = [NSString stringWithFormat:@"%d",_thermostatCurrentSetPoint];
			_proposedSetPoint = _thermostatCurrentSetPoint;
			[self scenSetMemberSetting];
			
		}
		btnUp.enabled = YES;
		btnDown.enabled = YES;
		[btnChangeTemp setBackgroundImage:[UIImage imageNamed:@"Randomize_selected.png"] forState:UIControlStateNormal];
		isChecked = YES;
	}
	else 
	{
		lblDeg.hidden = YES;
		lblTemp.text = @"";
		btnUp.enabled = NO;
		btnDown.enabled = NO;
		[btnChangeTemp setBackgroundImage:[UIImage imageNamed:@"Randomize.png"] forState:UIControlStateNormal];
		isChecked = NO;
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
	if(unpackedArray[1]!=0)
	{
		unpackedArray[1]=0;
		[self scenSetMemberSetting];
	}
}

-(IBAction)thermostatModeCoolClicked:(id)sender
{
	if(unpackedArray[1]!=2)
	{
		unpackedArray[1]=2;
		[self scenSetMemberSetting];
	}
}

-(IBAction)thermostatModeHeatClicked:(id)sender
{
	if(unpackedArray[1]!=1)
	{
		unpackedArray[1]=1;
		[self scenSetMemberSetting];
	}
	
}

-(IBAction)energySavingModeBtnClicked:(id)sender
{
	if([[btnEnergySaving currentTitle] isEqualToString:@"NORMAL"])
		unpackedArray[2]=0;
	else
		unpackedArray[2]=100;
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
	if(isChecked)
		isChecked = NO;
	else 
		isChecked = YES;
	if(isChecked)
		_enabledSetPoint=YES;
	else
		_enabledSetPoint=NO;
	
	//[self SetTemp];
	
	if (_enabledSetPoint )
	{
		if ( _proposedSetPoint == 0xFF )
			if ( _thermostatCurrentSetPoint != 0 ) _proposedSetPoint = _thermostatCurrentSetPoint;
			else _proposedSetPoint = _thermostatCurrentSetPoint;
			else
				//Need to retrieve the proposed selector for the component
				_proposedSetPoint = _thermostatCurrentSetPoint;
	}
	else
	{
		_proposedSetPoint = 0xFF;
	}
	
	
	if(_enabledSetPoint)
	{
		unpackedArray[0] = _proposedSetPoint;
	}
	else 
	{
		unpackedArray[0] = _proposedSetPoint;
	}
	
	[self scenSetMemberSetting];
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


- (void)dealloc {
	[lblThermoStat release];
	[lblDeg release];
	[deviceDict release];
	[selectedRoomDeviceArray release];
	[btnModeOFF,btnModeCool,btnModeHeat,btnEnergySaving,btnEnergySaving,btnChangeTemp,btnUp,btnDown,btnClose release];
	[lblTemp release];
	[delegate release];
    [super dealloc];
}


@end
