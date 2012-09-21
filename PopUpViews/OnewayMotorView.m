//
//  OnewayMotorView.m
//  Somfy
//
//  Created by Sempercon on 5/11/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "OnewayMotorView.h"
#import "DashboardService.h"
#import "DeviceService.h"
#import "Constants.h"
#import "AppDelegate_iPad.h"
#import "SceneConfiguratorHomeownerService.h"
#import "LoginScreen_iPad.h"
#import "UserService.h"
#import "DBAccess.h"
#import "LiveviewDashboard.h"
#import "MJPEGViewer_iPad.h"


@interface OnewayMotorView (Private)
- (void)showLoadingView;
- (void)hideLoadingView;
-(void)scenSetMemberSetting;
-(void)setSomfyPosition:(int)value;
-(void)startAnimateImage;
@end

@implementation OnewayMotorView
@synthesize delegate;
@synthesize BlindOpenBtn,BlindCloseBtn,MypositionBtn,CloseBtn;
@synthesize DeviceNameLbl;
@synthesize deviceDict;
@synthesize imgDevice;
@synthesize selectedRoomDeviceArray;
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

+ (OnewayMotorView*) onewaymotorview
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"OnewayMotorView" owner:nil options:nil];
	return [array objectAtIndex:0]; 
}

-(void) SetMainDelegate:(id<SkinChooserCallback>)callback
{
	delegate = callback;
	[delegate retain];
}

//Set device array from MainViewController
-(void)setDeviceDict:(NSMutableDictionary*)dict;
{
	deviceDict = dict;
	[deviceDict retain];
	currentValue = 0;
	isFromScene = 0;
    DeviceNameLbl.text = [deviceDict objectForKey:@"name"];
	if([deviceDict objectForKey:@"name"] == nil)
		DeviceNameLbl.text = @"Blind";
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

-(void)setSomfyPosition:(int)value
{
	if(value == 0)
	{
		BlindOpenBtn.alpha =0.5;
		BlindCloseBtn.alpha =1.0;
		MypositionBtn.alpha = 0.5;
		
	}
	else if(value == 100)
	{
		BlindOpenBtn.alpha =1.0;
		BlindCloseBtn.alpha =0.5;
		MypositionBtn.alpha = 0.5;
	}
	else
	{
		BlindOpenBtn.alpha =0.5;
		BlindCloseBtn.alpha =0.5;
		MypositionBtn.alpha = 1.0;
	}
}

#pragma mark -
#pragma mark HANDLERS FOR BUTTON CLICK EVENT

-(IBAction)CloseBtnClicked:(id)sender
{
	[delegate removePopup];
}

-(IBAction)BlindOpenBtnClicked:(id)sender
{
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	currentValue = 100;
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else 
	{
		[[DashboardService getSharedInstance]SetDeviceValue:@"100" :deviceId :self];
		
	}
	[self startAnimateImage];
}

-(IBAction)BlindCloseBtnClicked:(id)sender
{
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	currentValue = 0;
	if(isFromScene == 1)
		[self scenSetMemberSetting];
	else 
	{
			[[DashboardService getSharedInstance]SetDeviceValue:@"0" :deviceId :self];
	}
		
	[self startAnimateImage];
	
}

-(IBAction)MypositionBtnClicked:(id)sender
{
	[self showLoadingView];
	NSString *deviceId = [deviceDict objectForKey:@"id"];
	if(isFromScene == 1)
	{
		currentValue = (DEVICE_MY_POSITION_DEFAULT_VALUE & 0xFF) | ((MY_POSITION_VALUE & 0xFF) <<8);
		[self scenSetMemberSetting];
	}
	else 
		[[DeviceService getSharedInstance]setSomfyMyPosition:deviceId :self];
	[self startAnimateImage];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
    sceneValueChangedLbl.alpha = 0.0f;
	if(isFromScene == 1)
		[self setSomfyPosition:[[deviceDict objectForKey:@"setting"]intValue]];
	else
	{
		curMetaData = [[deviceDict objectForKey:@"metaData"]intValue];
		[self setSomfyPosition:[[deviceDict objectForKey:@"value"]intValue]];
	}
	if(curMetaData == RTS_AWNING)
		imgDevice.image = [UIImage imageNamed:@"Awning_Animation1.png"];
	else if(curMetaData == RTS_BLIND)
		imgDevice.image = [UIImage imageNamed:@"Blind_Animation1.png"];
	else if(curMetaData == RTS_CELLULAR_SHADE)
		imgDevice.image = [UIImage imageNamed:@"Cellular_Wind_Animtaion1.png"];
	else if(curMetaData == RTS_DRAPERY)
		imgDevice.image = [UIImage imageNamed:@"DraPery_Animation6.png"];
	else if(curMetaData == RTS_ROLLER_SHADE)
		imgDevice.image = [UIImage imageNamed:@"Rollar_Shade_Animation1.png"];
	else if(curMetaData == RTS_ROLLER_SHUTTER)
		imgDevice.image = [UIImage imageNamed:@"Rollar_Shutter_Animation1.png"];
	else if(curMetaData == RTS_ROMAN_SHADE)
		imgDevice.image = [UIImage imageNamed:@"Roman_Shade_Animation1.png"];
	else if(curMetaData == RTS_SCREEN_SHADE)
		imgDevice.image = [UIImage imageNamed:@"Screen_Animation1.png"];
	else if(curMetaData == RTS_SOLAR_SCREEN)
		imgDevice.image = [UIImage imageNamed:@"Solar_Screen_Animation1.png"];
	
	if(curMetaData == RTS_DRAPERY)
	{
		[BlindOpenBtn setBackgroundImage:[UIImage imageNamed:@"drapery_OPen.png"] forState:UIControlStateNormal];
		[BlindCloseBtn setBackgroundImage:[UIImage imageNamed:@"drapery_Close.png"] forState:UIControlStateNormal];

	}
	/*else if(curMetaData == RTS_AWNING)
	{
		[BlindOpenBtn setBackgroundImage:[UIImage imageNamed:@"vertical_open_up_Close.png"] forState:UIControlStateNormal];
		[BlindCloseBtn setBackgroundImage:[UIImage imageNamed:@"vertical_close_Open.png"] forState:UIControlStateNormal];
	}*/
	else 
	{
		[BlindOpenBtn setBackgroundImage:[UIImage imageNamed:@"vertical_open_up.png"] forState:UIControlStateNormal];
		[BlindCloseBtn setBackgroundImage:[UIImage imageNamed:@"vertical_close_up.png"] forState:UIControlStateNormal];
	}
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
			NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
			[dataDict setObject:@"1" forKey:@"include"];
			[dataDict setObject:[deviceDict objectForKey:@"id"] forKey:@"id"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",curSceneID] forKey:@"scene"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",ZWAVE_DEVICE] forKey:@"settingType"];
			[dataDict setObject:@"1" forKey:@"setValue"];
			[dataDict setObject:[NSString stringWithFormat:@"%d",currentValue] forKey:@"value"];
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

-(void)startAnimateImage
{
	if(isFromScene != 1)
		curMetaData = [[deviceDict objectForKey:@"metaData"]intValue];
	
	if(curMetaData == RTS_AWNING)
	{
		
		if(currentValue==100 || currentValue!=0)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Awning_Animation6.png"],
										 [UIImage imageNamed:@"Awning_Animation5.png"],
										 [UIImage imageNamed:@"Awning_Animation4.png"],
										 [UIImage imageNamed:@"Awning_Animation3.png"],
										 [UIImage imageNamed:@"Awning_Animation2.png"],
										 [UIImage imageNamed:@"Awning_Animation1.png"],
										 nil];
			
			
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Awning_Animation1.png"],
										 [UIImage imageNamed:@"Awning_Animation2.png"],
										 [UIImage imageNamed:@"Awning_Animation3.png"],
										 [UIImage imageNamed:@"Awning_Animation4.png"],
										 [UIImage imageNamed:@"Awning_Animation5.png"],
										 [UIImage imageNamed:@"Awning_Animation6.png"],
										 [UIImage imageNamed:@"Awning_Animation1.png"],
										 nil];
		}
	}
	else if(curMetaData == RTS_BLIND)
	{
		if(currentValue==100 || currentValue!=0)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Blind_Animation1.png"],
										 [UIImage imageNamed:@"Blind_Animation2.png"],
										 [UIImage imageNamed:@"Blind_Animation3.png"],
										 [UIImage imageNamed:@"Blind_Animation4.png"],
										 [UIImage imageNamed:@"Blind_Animation5.png"],
										 [UIImage imageNamed:@"Blind_Animation6.png"],
										 [UIImage imageNamed:@"Blind_Animation7.png"],
										 [UIImage imageNamed:@"Blind_Animation8.png"],
										 [UIImage imageNamed:@"Blind_Animation9.png"],
										 [UIImage imageNamed:@"Blind_Animation10.png"],
										 [UIImage imageNamed:@"Blind_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Blind_Animation10.png"],
										 [UIImage imageNamed:@"Blind_Animation9.png"],
										 [UIImage imageNamed:@"Blind_Animation8.png"],
										 [UIImage imageNamed:@"Blind_Animation7.png"],
										 [UIImage imageNamed:@"Blind_Animation6.png"],
										 [UIImage imageNamed:@"Blind_Animation5.png"],
										 [UIImage imageNamed:@"Blind_Animation4.png"],
										 [UIImage imageNamed:@"Blind_Animation3.png"],
										 [UIImage imageNamed:@"Blind_Animation2.png"],
										 [UIImage imageNamed:@"Blind_Animation1.png"],
										 nil];
		}
	}
	else if(curMetaData == RTS_CELLULAR_SHADE)
	{
		if(currentValue==100 || currentValue!=0)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion1.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion2.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion3.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion4.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion5.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion6.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion7.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion8.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion9.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion10.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion11.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion12.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion13.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion14.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion15.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion16.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion17.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion17.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion16.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion15.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion14.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion13.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion12.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion11.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion10.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion9.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion8.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion7.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion6.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion5.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion4.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion3.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion2.png"],
										 [UIImage imageNamed:@"Cellular_Wind_Animtaion1.png"],
										 nil];
		}
	}
	else if(curMetaData == RTS_DRAPERY)
	{
		if(currentValue==100 || currentValue!=0)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"DraPery_Animation1.png"],
										 [UIImage imageNamed:@"DraPery_Animation2.png"],
										 [UIImage imageNamed:@"DraPery_Animation3.png"],
										 [UIImage imageNamed:@"DraPery_Animation4.png"],
										 [UIImage imageNamed:@"DraPery_Animation5.png"],
										 [UIImage imageNamed:@"DraPery_Animation6.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"DraPery_Animation6.png"],
										 [UIImage imageNamed:@"DraPery_Animation5.png"],
										 [UIImage imageNamed:@"DraPery_Animation4.png"],
										 [UIImage imageNamed:@"DraPery_Animation3.png"],
										 [UIImage imageNamed:@"DraPery_Animation2.png"],
										 [UIImage imageNamed:@"DraPery_Animation1.png"],
										 [UIImage imageNamed:@"DraPery_Animation6.png"],
										 nil];
		}
	}
	else if(curMetaData == RTS_ROLLER_SHADE)
	{
		
		if(currentValue==100 || currentValue!=0)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Rollar_Shade_Animation1.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation2.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation3.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation4.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation5.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation6.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation7.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation8.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation9.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation10.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Rollar_Shade_Animation10.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation9.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation8.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation7.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation6.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation5.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation4.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation3.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation2.png"],
										 [UIImage imageNamed:@"Rollar_Shade_Animation1.png"],
										 nil];
		}
	}
	else if(curMetaData == RTS_ROLLER_SHUTTER)
	{
		if(currentValue==100 || currentValue!=0)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Rollar_Shutter_Animation1.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation2.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation3.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation4.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation5.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation6.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation7.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation8.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation9.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation10.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation11.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation12.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation13.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation14.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation15.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation16.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation17.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation18.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation19.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation20.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation21.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation22.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation23.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Rollar_Shutter_Animation23.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation22.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation21.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation20.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation19.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation18.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation17.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation16.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation15.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation14.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation13.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation12.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation11.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation10.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation9.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation8.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation7.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation6.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation5.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation4.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation3.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation2.png"],
										 [UIImage imageNamed:@"Rollar_Shutter_Animation1.png"],
										 nil];
		}
	}
	else if(curMetaData == RTS_ROMAN_SHADE)
	{
		if(currentValue==100 || currentValue!=0)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Roman_Shade_Animation1.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation2.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation3.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation4.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation5.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation6.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation7.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation8.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation9.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation10.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation11.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Roman_Shade_Animation11.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation10.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation9.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation8.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation7.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation6.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation5.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation4.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation3.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation2.png"],
										 [UIImage imageNamed:@"Roman_Shade_Animation1.png"],
										 nil];
		}
	}
	else if(curMetaData == RTS_SCREEN_SHADE)
	{
		if(currentValue==100 || currentValue!=0)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Screen_Animation1.png"],
										 [UIImage imageNamed:@"Screen_Animation2.png"],
										 [UIImage imageNamed:@"Screen_Animation3.png"],
										 [UIImage imageNamed:@"Screen_Animation4.png"],
										 [UIImage imageNamed:@"Screen_Animation5.png"],
										 [UIImage imageNamed:@"Screen_Animation6.png"],
										 [UIImage imageNamed:@"Screen_Animation7.png"],
										 [UIImage imageNamed:@"Screen_Animation8.png"],
										 [UIImage imageNamed:@"Screen_Animation9.png"],
										 [UIImage imageNamed:@"Screen_Animation10.png"],
										 [UIImage imageNamed:@"Screen_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Screen_Animation10.png"],
										 [UIImage imageNamed:@"Screen_Animation9.png"],
										 [UIImage imageNamed:@"Screen_Animation8.png"],
										 [UIImage imageNamed:@"Screen_Animation7.png"],
										 [UIImage imageNamed:@"Screen_Animation6.png"],
										 [UIImage imageNamed:@"Screen_Animation5.png"],
										 [UIImage imageNamed:@"Screen_Animation4.png"],
										 [UIImage imageNamed:@"Screen_Animation3.png"],
										 [UIImage imageNamed:@"Screen_Animation2.png"],
										 [UIImage imageNamed:@"Screen_Animation1.png"],
										 nil];
		}
	}
	else if(curMetaData == RTS_SOLAR_SCREEN)
	{
		if(currentValue==100 || currentValue!=0)
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:	
										 [UIImage imageNamed:@"Solar_Screen_Animation1.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation2.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation3.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation4.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation5.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation6.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation7.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation1.png"],
										 nil];
		}
		else
		{
			imgDevice.animationImages = [NSArray arrayWithObjects:
										 [UIImage imageNamed:@"Solar_Screen_Animation7.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation6.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation5.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation4.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation3.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation2.png"],
										 [UIImage imageNamed:@"Solar_Screen_Animation1.png"],
										 nil];
		}
	}
	imgDevice.animationDuration = 1.2;
	// repeat the annimation forever
	imgDevice.animationRepeatCount = 1;
	// start animating
	[imgDevice startAnimating];
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
		[[DeviceService getSharedInstance] getAll:self];
		[self setSomfyPosition:currentValue];
	}
	else if (strCommand == GET_ALL)
	{
		[AppDelegate_iPad  sharedAppDelegate].g_DevicesArray = [resultArray mutableCopy];
		[delegate refreshViewFromPopup];
		[self hideLoadingView];
	}
	else if(strCommand == SET_SOMFY_MY_POSITION)
	{
		[self setSomfyPosition:currentValue];
		[self hideLoadingView];
	}
	else if(strCommand==SET_MEMBER_SETTINGS)
	{
		[self setSomfyPosition:currentValue];
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
	[imgDevice release];
	[deviceDict release];
	[DeviceNameLbl release];
	[delegate release];
    [sceneValueChangedLbl release];
	[BlindOpenBtn,BlindCloseBtn,MypositionBtn,CloseBtn release];
    [super dealloc];
}


@end
