//
//  ILTMotorView.m
//  Somfy
//
//  Created by Sempercon on 6/2/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "ILTMotorView.h"
#import "AppDelegate_iPad.h"
#import "DeviceService.h"
#import "DashboardService.h"
#import "SceneConfiguratorHomeownerService.h"
#import "LoginScreen_iPad.h"
#import "UserService.h"
#import "DBAccess.h"
#import "MJPEGViewer_iPad.h"

@interface ILTMotorView (Private)
- (void)showLoadingView;
- (void)hideLoadingView;
-(void)setSliderPosition:(int)value;
-(void)scenSetMemberSetting;
-(void)LoadImageView:(float)val;
@end

@implementation ILTMotorView

@synthesize delegate;
@synthesize deviceDict;
@synthesize selectedRoomDeviceArray;
@synthesize deviceImage;
@synthesize lblDeviceName;
@synthesize trackView;
@synthesize trackingImg,trackBottomImg,iltSliderBg;
@synthesize valueLabel;
@synthesize deviceScrollView;
@synthesize applyALLBtn;
@synthesize sceneValueChangedLbl;


#pragma mark -
#pragma mark LOAD

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

+ (ILTMotorView*) iLTMotorView
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"ILTMotorView" owner:self options:nil];
	return [array objectAtIndex:0]; 
}

-(void) SetMainDelegate:(id<SkinChooserCallback>)callback;
{
	delegate = callback;
	[delegate retain];
}

//Set device array from MainViewController
-(void)setDeviceDict:(NSMutableDictionary*)dict;
{
    // Hint
	deviceDict = dict;
	[deviceDict retain];
	isFromScene = 0;
    lblDeviceName.text = [deviceDict objectForKey:@"name"];
	if([deviceDict objectForKey:@"name"] == nil)
		lblDeviceName.text = @"ILT Motor";
}

-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr
{
	selectedRoomDeviceArray = arr;
	[selectedRoomDeviceArray retain];
}

-(void)setSceneId:(int)sceneId
{
	curSceneID = sceneId;
}
-(void)setSceneIndex:(int)sceneIdx
{
	curSceneIdx = sceneIdx;
}

-(void)setIsFromScene:(int)indicator
{
	isFromScene = indicator;
}

-(void)setCurMetaData:(int)mData
{
	curMetaData = mData;
}


- (void)singleTapGestureCaptured:(UIPanGestureRecognizer *)touch
{ 
	CGPoint touchPoint = [touch locationInView:deviceScrollView];
	if(touchPoint.y>=0&&touchPoint.y<=100)
	{
		//lastSliderValue = sliderValue;
		[self LoadImageView:touchPoint.y];
		lastYPoint = touchPoint.y;
	}
	if(touch.state == UIGestureRecognizerStateEnded)
	{
		if(lastSliderValue!=sliderValue)
		{
			[self showLoadingView];
			NSString *deviceId = [deviceDict objectForKey:@"id"];
			if(isFromScene == 1)
				[self scenSetMemberSetting];
			else 
				[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];
		}
	}
}


-(void)setSliderPosition:(int)value
{
	sliderValue = value;
	trackBottomImg.frame = CGRectMake(0, 100-value, 114,12 );
if(isFromScene != 1)
{
	curMetaData = [[deviceDict objectForKey:@"metaData"]intValue];
}
	if(curMetaData == ILT_ROMAN_SHADE)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 87);
	else if(curMetaData == ILT_ROLLER_SHADE)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 115);
	else if(curMetaData == ILT_SCREEN)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 107);
	else if(curMetaData == ILT_BLIND)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 96);
	else if(curMetaData == ILT_SOLAR_SCREEN)
		trackingImg.frame = CGRectMake(0, 0-value, 112, 96);
	
	lastYPoint = 100-value;
	valueLabel.text = [NSString stringWithFormat:@"%d",sliderValue];
	valueLabel.text = [valueLabel.text stringByAppendingString:@"%"];
}

-(void)LoadImageView:(float)val
{
	lastYPoint = val;
	trackBottomImg.frame = CGRectMake(0, val, 114,12 );
	
	if(isFromScene != 1)
	{
		curMetaData = [[deviceDict objectForKey:@"metaData"]intValue];
	}
	
	if(curMetaData == ILT_ROMAN_SHADE)
		trackingImg.frame = CGRectMake(0, val-100, 112, 87);
	else if(curMetaData == ILT_ROLLER_SHADE)
		trackingImg.frame = CGRectMake(0, val-100, 112, 115);
	else if(curMetaData == ILT_SCREEN)
		trackingImg.frame = CGRectMake(0, val-100, 112, 107);
	else if(curMetaData == ILT_BLIND)
		trackingImg.frame = CGRectMake(0, val-100, 112, 96);
	else if(curMetaData == ILT_SOLAR_SCREEN)
		trackingImg.frame = CGRectMake(0, val-100, 112, 96);
	
	//Find value of adjust slider
	sliderValue = 100 - val;
	//set slider value label text
	valueLabel.text = [NSString stringWithFormat:@"%d",sliderValue];
	valueLabel.text = [valueLabel.text stringByAppendingString:@"%"];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
    sceneValueChangedLbl.alpha = 0.0f;
	tempDevicesArray = [[NSMutableArray alloc]init];
	if(isFromScene == 1)
	{
		applyALLBtn.hidden = YES;
		[self setSliderPosition:[[deviceDict objectForKey:@"setting"]intValue]];
		
	}
	else
	{
		applyALLBtn.hidden = NO;
		[self setSliderPosition:[[deviceDict objectForKey:@"value"]intValue]];
		curMetaData = [[deviceDict objectForKey:@"metaData"]intValue];
	}
	
	if(curMetaData == ILT_SOLAR_SCREEN)
		iltSliderBg.image = [UIImage imageNamed:@"ILT_Solar_Screen_Slider_bg.png"];
	else 
		iltSliderBg.image = [UIImage imageNamed:@"ILT_sliderbg.png"];
	
	if(curMetaData == ILT_ROMAN_SHADE)
		trackingImg.image = [UIImage imageNamed:@"ILT_RomanShade_Slider.png"];
	else if(curMetaData == ILT_ROLLER_SHADE)
		trackingImg.image = [UIImage imageNamed:@"ILT_RollerShade_Slider.png"];
	else if(curMetaData == ILT_SOLAR_SCREEN)
		trackingImg.image = [UIImage imageNamed:@"ILT_Solar_Screen_Slider.png"];
	else if(curMetaData == ILT_SCREEN)
		trackingImg.image = [UIImage imageNamed:@"ILT_Screen_Slider.png"];
	else if(curMetaData == ILT_BLIND)
		trackingImg.image = [UIImage imageNamed:@"ILT_Blind_Slider.png"];
	
	
	UIPanGestureRecognizer *singleTap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
	[deviceScrollView addGestureRecognizer:singleTap];
}

#pragma mark -
#pragma mark TOUCH DELEGATES

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if ([touch view] == trackView)
	{
		CGPoint touchPoint = [touch locationInView:trackView];
		if(touchPoint.y>=0&&touchPoint.y<=100)
		{
			lastSliderValue = sliderValue;
		}
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	UITouch *touch = [touches anyObject];
	if ([touch view] == trackView)
	{
		CGPoint touchPoint = [touch locationInView:trackView];
		if(touchPoint.y>=0&&touchPoint.y<=100)
		{
			[self LoadImageView:touchPoint.y];
			lastYPoint = touchPoint.y;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(lastSliderValue!=sliderValue)
	{
		[self showLoadingView];
		NSString *deviceId = [deviceDict objectForKey:@"id"];
		if(isFromScene == 1)
			[self scenSetMemberSetting];
		else 
			[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];
	}
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)CloseBtnClicked:(id)sender
{
	[delegate removePopup];
	[tempDevicesArray release];
}

-(IBAction)ILTMotorIncreaseClicked:(id)sender
{
	lastYPoint-= 10;
	if(lastYPoint>0&&lastYPoint<=100)
		[self LoadImageView:lastYPoint];
	else
	{
		lastYPoint = 0;
		[self LoadImageView:lastYPoint];
	}
	
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else 
		[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];
}
-(IBAction)ILTMotorDecreaseClicked:(id)sender
{
	lastYPoint+= 10;
	if(lastYPoint>0&&lastYPoint<=100)
		[self LoadImageView:lastYPoint];
	else
	{
		lastYPoint = 100;
		[self LoadImageView:lastYPoint];
	}
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else 
		[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];	
}
-(IBAction)ILTMotorOpenClicked:(id)sender
{
	[self LoadImageView:0];
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else 
		[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];	
	
}
-(IBAction)ILTMotorCloseClicked:(id)sender
{
	[self LoadImageView:100];
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else 
		[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :deviceId :self];	
}

-(void)setApplyAlltoDevices
{
	[self showLoadingView];
	QueueTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
												  target:self 
												selector:@selector(QueueProcess) 
												userInfo:nil 
												 repeats:YES];
	queueEnum = NONE;
	deviceIndex = 0;
}

-(void)QueueProcess
{
	switch(queueEnum)
	{
		case NONE:
		{
			queueEnum = SET_DEVICE_VALUE;
			break;
		}
		case SET_DEVICE_VALUE:
		{
			[[DashboardService getSharedInstance]SetDeviceValue:[NSString stringWithFormat:@"%d",sliderValue] :[[tempDevicesArray objectAtIndex:deviceIndex]objectForKey:@"id"] :self];
			queueEnum = PROCESSING;
			break;
		}
		case SET_DEVICE_VALUE_DONE:
		{
			if(deviceIndex<[tempDevicesArray count]-1)
			{
				deviceIndex++;
				queueEnum = SET_DEVICE_VALUE;
			}
			else
				queueEnum = GET_ALL_DEVICE_INFO;
			break;
		}
		case GET_ALL_DEVICE_INFO:
		{
			queueEnum = PROCESSING;
			[[DeviceService getSharedInstance] getAll:self];
		}
		case APPLYTO_ALLDONE:
		{
			[QueueTimer invalidate];
			QueueTimer=nil;
			[self hideLoadingView];
			break;
		}
		default:
			break;
	}
}


-(IBAction)ILTMotorApplyAllClicked:(id)sender
{
	if([tempDevicesArray count]>0)
		[tempDevicesArray removeAllObjects];
	
	if(selectedRoomDeviceArray!=nil)
	{
		for (int i=0; i<[selectedRoomDeviceArray count]; i++) {
			int deviceType = [[[selectedRoomDeviceArray objectAtIndex:i]objectForKey:@"deviceType"] intValue];
			if(deviceType == [[deviceDict objectForKey:@"deviceType"] intValue] && 
			   [[[selectedRoomDeviceArray objectAtIndex:i]objectForKey:@"id"] intValue] != [[deviceDict objectForKey:@"id"] intValue])
			{
				//Add all same devicetype devices in the tempDevicesArray 
				[tempDevicesArray addObject:[selectedRoomDeviceArray objectAtIndex:i]];
			}
		}
	}
	
	if([tempDevicesArray count]>0)
		[self setApplyAlltoDevices];
}

-(void)hideSceneValueLabel
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    sceneValueChangedLbl.alpha = 0.0f;
    [UIView commitAnimations];
}
-(void)showSceneValueLabel
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    sceneValueChangedLbl.alpha = 1.0f;
    [UIView commitAnimations];
}


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
			
			/*NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
			[dataDict setObject:@"1" forKey:@"includeInScene"];
			[dataDict setObject:[deviceDict objectForKey:@"id"] forKey:@"id"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",curSceneID] forKey:@"scene"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",ZWAVE_DEVICE] forKey:@"settingType"];
			[dataDict setObject:@"1" forKey:@"setValue"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",sliderValue] forKey:@"value"];
			[[SceneConfiguratorHomeownerService getSharedInstance]setMemberSetting:[deviceDict objectForKey:@"zwaveID"] :self];
			[dataDict release];*/
			
			NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
			[dataDict setObject:@"1" forKey:@"include"];
			[dataDict setObject:[deviceDict objectForKey:@"id"] forKey:@"id"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",curSceneID] forKey:@"scene"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",ZWAVE_DEVICE] forKey:@"settingType"];
			[dataDict setObject:@"1" forKey:@"setValue"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",sliderValue] forKey:@"value"];
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
            if(isFromScene == 1)
            {
                [self showSceneValueLabel];
                [self performSelector:@selector(hideSceneValueLabel) withObject:nil afterDelay:2.5];
            }
			break;
		}
		default:
			break;
	}
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
	if(strCommand == DEVICE_SETVALUE)
	{
		if(queueEnum == PROCESSING)
		{
			queueEnum = SET_DEVICE_VALUE_DONE;
		}
		else
			[[DeviceService getSharedInstance] getAll:self];
	}
	else if (strCommand == GET_ALL)
	{
		if(queueEnum == PROCESSING)
			queueEnum = APPLYTO_ALLDONE;
		
		[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray = [resultArray mutableCopy];
		[delegate refreshViewFromPopup];
		[self hideLoadingView];
	}
	else if(strCommand==SET_MEMBER_SETTINGS)
	{
		commandEnum = SET_SCENE_MEMBER_SETTING_DONE;
	}
	else if(strCommand==GET_SCENE_INFO)
	{
		//NSMutableDictionary *tempdict = [resultArray objectAtIndex:0];
		[[AppDelegate_iPad sharedAppDelegate].g_ScenesInfoArray replaceObjectAtIndex:curSceneIdx withObject:resultArray];
		commandEnum = GETSCENE_INFO_DONE;
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
	[QueueTimer invalidate];
	QueueTimer=nil;
	queueEnum = NONE;
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
	[selectedRoomDeviceArray release];
	[applyALLBtn release];
	[trackView,trackingImg,trackBottomImg,iltSliderBg release];
	[valueLabel release];
	[deviceImage release];
	[lblDeviceName release];
	[deviceDict release];
	[delegate release];
	[deviceScrollView release];
    [sceneValueChangedLbl release];
    [super dealloc];
}


@end
