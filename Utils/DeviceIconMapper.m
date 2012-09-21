//
//  DeviceIconMapper.m
//  Somfy
//
//  Created by Sempercon on 5/9/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "DeviceIconMapper.h"


@implementation DeviceIconMapper


/**
 * Returns the image to show based on the device type
 * @param deviceType Integer that is used to define the device type 
 * @return image class
 */
-(UIImage*) getDeviceImageBasedOnDeviceTypeandDeviceValue:(int)deviceType :(int)deviceValue :(int)somfyDeviceType
{
	NSString *roomImageName;
	UIImage *roomImage;
	BOOL isSomfyDevice = NO;
	//Store a default image
	roomImageName = @"Rollar_Shutter_Animation1";
	
	//Determine the device type based on the DeviceTypeEnum of device types
	switch ( deviceType )
	{	
		case BINARY_SWITCH:
		{
			if(deviceValue==0)
				roomImageName = @"lightdevGray";
			else
				roomImageName = @"lightdev";
			break;
		}
        case MULTILEVEL_SWITCH:
		case REMOTE_SWITCH:
		{
			if(deviceValue==0)
				roomImageName = @"lightdevGray";
			else
				roomImageName = @"lightdev";
			break;
		}
		case SOMFY_ILT:
		{
			isSomfyDevice = YES;
			if(deviceValue==0)
				roomImage = [self getSomfyDeviceImageBasedOnValue:somfyDeviceType:0];
			else
				roomImage = [self getSomfyDeviceImageBasedOnValue:somfyDeviceType:1];
			break;
			
		}
		case SOMFY_RTS:
		{
			isSomfyDevice = YES;
			if(deviceValue==0)
				roomImage = [self getSomfyDeviceImageBasedOnValue:somfyDeviceType:0];
			else
				roomImage = [self getSomfyDeviceImageBasedOnValue:somfyDeviceType:1];
			break;
		}
		case THERMOSTAT_RCS:
		case THERMOSTATV2:
		{
			if(deviceValue==0)
				roomImageName = @"LargeTheromastatFGray";
			else
				roomImageName = @"LargeTheromastat";
			break;	
		}
		case BULOGICS_CORE:
		{
			if(deviceValue==0)
				roomImageName = @"myTahomaGray";
			else
				roomImageName = @"myTahoma";
			break;
		}
		case INSTALLER_TOOL_PORTABLE:
		{
			if(deviceValue==0)
				roomImageName = @"USBStickGray";
			else
				roomImageName = @"USBStick";
			break;
		}
		case STATIC_CONTROLLER:
		{
			if(deviceValue==0)
				roomImageName = @"zrtsdevGray";
			else
				roomImageName = @"zrtsdev";
			break;
		}
		case SCENE_CONTROLLER:
		case SCENE_CONTROLLER_TWO:
		case SCENE_CONTROLLER_THREE:
		case SCENE_CONTROLLER_PORTABLE:
		{
			if(deviceValue==0)
				roomImageName = @"sceneController_LargeGray";
			else
				roomImageName = @"sceneController_Large";
			break;
		}
		case BINARY_SENSOR:
		case BINARY_SENSOR_TWO:
		{
			if(deviceValue==0)
				roomImageName = @"Monitor_sensorGray";
			else
				roomImageName = @"Monitor_sensor";
			break;
		}
		default:
			break;
	}
	
	//get the device image with the devicetype name and return the image
	if(isSomfyDevice)
		return roomImage;
	else
	{
		roomImageName = [roomImageName stringByAppendingString:@".png"];
		roomImage = [UIImage imageNamed:roomImageName];
		return roomImage;
	}
	
}

-(UIImage *) getDeviceImageBasedOnDeviceType :(int)deviceType :(int)somfyDeviceType
{
	BOOL isSomfyDevice = NO;
	NSString *roomImageName;
	UIImage *roomImage;
	
	//Store a default image
	roomImageName = @"Rollar_Shutter_Animation1";
    
        
	//Determine the device type based on the DeviceTypeEnum of device types
	switch ( deviceType )
	{	
		case BINARY_SWITCH:
		{
			roomImageName = @"lightdev";
			break;
		}
        case MULTILEVEL_SWITCH:
		case REMOTE_SWITCH:
			roomImageName = @"lightdev";
			break;
		case SOMFY_RTS:
		{
			if(somfyDeviceType == UNKNOWN)
				roomImageName = @"RomanShade";
			else
			{
				roomImage = [self getSomfyDeviceImageBasedOnDeviceType:somfyDeviceType];
				isSomfyDevice = YES;
			}
			break;
		}
		case SOMFY_ILT:
		{
			if(somfyDeviceType == UNKNOWN)
				roomImageName = @"LargeRollerShade";
			else
			{
				roomImage = [self getSomfyDeviceImageBasedOnDeviceType:somfyDeviceType];
				isSomfyDevice = YES;
			}
			break;
		}
		case THERMOSTAT_RCS:
		case THERMOSTATV2:
			roomImageName = @"LargeTheromastat";
			break;	
		case BULOGICS_CORE:
			roomImageName = @"myTahoma";
			break;
		case INSTALLER_TOOL_PORTABLE:
			roomImageName = @"USBStick";
			break;
		case STATIC_CONTROLLER:
			roomImageName = @"zrtsdev";
			break;
		case SCENE_CONTROLLER:
		case SCENE_CONTROLLER_TWO:
		case SCENE_CONTROLLER_THREE:
		case SCENE_CONTROLLER_PORTABLE:
			roomImageName = @"sceneController_Large";
			break;
		case BINARY_SENSOR:
		case BINARY_SENSOR_TWO:
			roomImageName = @"Monitor_sensor";
			break;
		default:
			break;
	}
	
	if(isSomfyDevice)
		return roomImage;
	else
	{
		//get the device image with the devicetype name and return the image
		roomImageName = [roomImageName stringByAppendingString:@".png"];
		roomImage = [UIImage imageNamed:roomImageName];
		return roomImage;
	}
}


/**
 * Returns the image of the device based on the somfy device type stored
 * in the meta data of the device 
 * @param somfyDeviceType The somfy device id that is stored in the meta data
 * @return Image class that represents the icon.
 */
-(UIImage *)getSomfyDeviceImageBasedOnDeviceType:(int)somfyDeviceType
{
	//Initialize the image
	NSString *roomImageName=@"Awning_Animation1";
	UIImage *roomImage;
	
	//Determine the image that is going to be shown based 
	//on the somfyDeviceType
	switch ( somfyDeviceType )
	{
		case RTS_AWNING:
			roomImageName = @"Awning_Animation1";
			break;
		case RTS_BLIND:
			roomImageName = @"Blind_Animation1";
			break;
		case RTS_DRAPERY:
			roomImageName = @"DraPery_Animation6";
			break;
		case RTS_ROLLER_SHADE:
			roomImageName = @"Rollar_Shade_Animation1";
			break;
		case RTS_SOLAR_SCREEN:
			roomImageName = @"Solar_Screen_Animation1";
			break;
		case RTS_ROLLER_SHUTTER:
			roomImageName = @"Rollar_Shutter_Animation1";
			break;
		case RTS_ROMAN_SHADE:
			roomImageName = @"Roman_Shade_Animation1";
			break;
		case RTS_PLANTATION_SHUTTER:
			roomImageName = @"PlantationShadeMedium";
			break;
		case RTS_CELLULAR_SHADE:
			roomImageName = @"Cellular_Wind_Animtaion1";
			break;
		case RTS_SCREEN_SHADE:
			roomImageName = @"Screen_Animation1";
			break;
		case ILT_ROLLER_SHADE:
			roomImageName = @"Rollar_Shade_Animation1";
			break;
		case ILT_ROMAN_SHADE:
			roomImageName = @"Roman_Shade_Animation1";					
			break;
		case ILT_SOLAR_SCREEN:
			roomImageName = @"Solar_Screen_Animation1";
			break;
		case ILT_SCREEN:
			roomImageName = @"Screen_Animation1";
			break;
		case ILT_BLIND:
			roomImageName = @"Blind_Animation1";
			break;
	}
	
	//get the device image with the devicetype name and return the image
	roomImageName = [roomImageName stringByAppendingString:@".png"];
	roomImage = [UIImage imageNamed:roomImageName];
	return roomImage;
}

-(UIImage *)getSomfyDeviceImageBasedOnValue:(int)somfyDeviceType : (int) deviceValue
{
	//Initialize the image
	NSString *roomImageName=@"Awning_Animation1";
	UIImage *roomImage;
	
	//Determine the image that is going to be shown based 
	//on the somfyDeviceType
	switch ( somfyDeviceType )
	{
		case RTS_AWNING:
			if(deviceValue == 0)
				roomImageName = @"Awning_Animation1Gray";
			else
				roomImageName = @"Awning_Animation1";
			break;
		case RTS_BLIND:
			if(deviceValue == 0)
				roomImageName = @"Blind_Animation1Gray";
			else
				roomImageName = @"Blind_Animation1";
			break;
		case RTS_DRAPERY:
			if(deviceValue == 0)
				roomImageName = @"DraPery_Animation6Gray";
			else
				roomImageName = @"DraPery_Animation6";
			break;
		case RTS_ROLLER_SHADE:
			if(deviceValue == 0)
				roomImageName = @"Rollar_Shade_Animation1Gray";
			else
				roomImageName = @"Rollar_Shade_Animation1";
			break;
		case RTS_SOLAR_SCREEN:
			if(deviceValue == 0)
				roomImageName = @"Solar_Screen_Animation1Gray";
			else
				roomImageName = @"Solar_Screen_Animation1";
			break;
		case RTS_ROLLER_SHUTTER:
			if(deviceValue == 0)
				roomImageName = @"Rollar_Shutter_Animation1Gray";
			else
				roomImageName = @"Rollar_Shutter_Animation1";
			break;
		case RTS_ROMAN_SHADE:
			if(deviceValue == 0)
				roomImageName = @"Roman_Shade_Animation1Gray";
			else
				roomImageName = @"Roman_Shade_Animation1";
			break;
		case RTS_PLANTATION_SHUTTER:
			if(deviceValue == 0)
				roomImageName = @"PlantationShadeMediumGray";
			else
				roomImageName = @"PlantationShadeMedium";
			break;
		case RTS_CELLULAR_SHADE:
			if(deviceValue == 0)
				roomImageName = @"Cellular_Wind_Animtaion1Gray";
			else
				roomImageName = @"Cellular_Wind_Animtaion1";
			break;
		case RTS_SCREEN_SHADE:
			if(deviceValue == 0)
				roomImageName = @"Screen_Animation1Gray";
			else
				roomImageName = @"Screen_Animation1";
			break;
		case ILT_ROLLER_SHADE:
			if(deviceValue == 0)
				roomImageName = @"Rollar_Shade_Animation1Gray";
			else
				roomImageName = @"Rollar_Shade_Animation1";
			break;
		case ILT_ROMAN_SHADE:
			if(deviceValue == 0)
				roomImageName = @"Roman_Shade_Animation1Gray";	
			else
				roomImageName = @"Roman_Shade_Animation1";					
			break;
		case ILT_SOLAR_SCREEN:
			if(deviceValue == 0)
				roomImageName = @"Solar_Screen_Animation1Gray";
			else
				roomImageName = @"Solar_Screen_Animation1";
			break;
		case ILT_SCREEN:
			if(deviceValue == 0)
				roomImageName = @"Screen_Animation1Gray";
			else
				roomImageName = @"Screen_Animation1";
			break;
		case ILT_BLIND:
			if(deviceValue == 0)
				roomImageName = @"Blind_Animation1Gray";
			else
				roomImageName = @"Blind_Animation1";
			break;
	}
	
	//get the device image with the devicetype name and return the image
	roomImageName = [roomImageName stringByAppendingString:@".png"];
	roomImage = [UIImage imageNamed:roomImageName];
	return roomImage;
}

-(NSString*)determineDeviceLabel:(int)_somfyDeviceType
{
	NSString *deviceName;
	//Based on the value of the somfy device type, we
	//are going to apply the appropriate label
	switch ( _somfyDeviceType ) 
	{
		case RTS_AWNING:
			deviceName = @"Awning";
			break;
		case RTS_BLIND:
			deviceName = @"Blind";
			break;
		case RTS_CELLULAR_SHADE:
			deviceName = @"Cellular Shade";
			break;
		case RTS_DRAPERY:
			deviceName = @"Drapery";
			break;
		case RTS_ROLLER_SHADE:
			deviceName = @"Roller Shade";
			break;
		case RTS_SOLAR_SCREEN:
			deviceName = @"Solar Screen";
			break;
		case RTS_PLANTATION_SHUTTER:
			deviceName = @"Plantation Shutter";
			break;
		case RTS_ROMAN_SHADE:
			deviceName = @"Roman Shade";
			break;
		case RTS_ROLLER_SHUTTER:
			deviceName = @"Roller Shutter";
			break;
		case RTS_SCREEN_SHADE:
			deviceName = @"Screen";
			break;
		default:
			deviceName = @"Click to select";
	}
	return deviceName;
}
-(UIImage *)getSmallSomfyDeviceForiPhoneImageBasedOnDeviceType:(int)somfyDeviceType
{
	//Initialize the image
	NSString *roomImageName=@"iP_MediumAwning";
	UIImage *roomImage;
	
	//Determine the image that is going to be shown based 
	//on the somfyDeviceType
	switch ( somfyDeviceType )
	{
		case RTS_AWNING:
			roomImageName = @"iP_MediumAwning";
			break;
		case RTS_BLIND:
			roomImageName = @"iP_MediumBlinds";
			break;
		case RTS_DRAPERY:
			roomImageName = @"iP_MediumCurtain";
			break;
		case RTS_ROLLER_SHADE:
			roomImageName = @"iP_MediumRollerShade";
			break;
		case RTS_SOLAR_SCREEN:
			roomImageName = @"iP_MediumSolarShade";
			break;
		case RTS_ROLLER_SHUTTER:
			roomImageName = @"iP_RollerShutter";
			break;
		case RTS_ROMAN_SHADE:
			roomImageName = @"iP_RomanShade";
			break;
		case RTS_PLANTATION_SHUTTER:
			roomImageName = @"iP_PlantationShadeMedium";
			break;
		case RTS_CELLULAR_SHADE:
			roomImageName = @"iP_CellularShade";
			break;
		case RTS_SCREEN_SHADE:
			roomImageName = @"iP_ScreenMedium";
			break;
		case ILT_ROLLER_SHADE:
			roomImageName = @"iP_MediumRollerShade";
			break;
		case ILT_ROMAN_SHADE:
			roomImageName = @"iP_RomanShade";					
			break;
		case ILT_SOLAR_SCREEN:
			roomImageName = @"iP_MediumSolarShade";
			break;
		case ILT_SCREEN:
			roomImageName = @"iP_ScreenMedium";
			break;
		case ILT_BLIND:
			roomImageName = @"iP_Blinds";
			break;
	}
	
	//get the device image with the devicetype name and return the image
	roomImageName = [roomImageName stringByAppendingString:@".png"];
	roomImage = [UIImage imageNamed:roomImageName];
	return roomImage;
}

-(UIImage *) getDeviceForiPhoneImageBasedOnDeviceType :(int)deviceType :(int)somfyDeviceType:(int)deviceValue
{
	BOOL isSomfyDevice = NO;
	NSString *roomImageName;
	UIImage *roomImage;
	
	//Store a default image
	roomImageName = @"iP_SmallBlind";
	
	//Determine the device type based on the DeviceTypeEnum of device types
	switch ( deviceType )
	{	
		case BINARY_SWITCH:
		{
			if(deviceValue == 0)
				roomImageName = @"iP_LargeLight_gray";
			else 
				roomImageName = @"iP_SmallLight";
			
			break;
		}
        case MULTILEVEL_SWITCH:
		case REMOTE_SWITCH:
			if(deviceValue == 0)
				roomImageName = @"iP_LargeLight_gray";
			else 
				roomImageName = @"iP_SmallLight";
			break;
		case SOMFY_RTS:
		{
			if(somfyDeviceType == UNKNOWN)
				roomImageName = @"iP_RomanShade";
			else
			{
				roomImage = [self getSmallSomfyDeviceForiPhoneImageBasedOnDeviceType:somfyDeviceType];
				isSomfyDevice = YES;
			}
			break;
		}
		case SOMFY_ILT:
		{
			if(somfyDeviceType == UNKNOWN)
				roomImageName = @"iP_LargeRollerShade";
			else
			{
				roomImage = [self getSmallSomfyDeviceForiPhoneImageBasedOnDeviceType:somfyDeviceType];
				isSomfyDevice = YES;
			}
			break;
		}
		case THERMOSTAT_RCS:
		case THERMOSTATV2:
			roomImageName = @"iP_LargeTheromastatF";
			break;	
		case BULOGICS_CORE:
			roomImageName = @"iP_MyTahomaMedium";
			break;
		case INSTALLER_TOOL_PORTABLE:
			roomImageName = @"iP_USBStickMedium";
			break;
		case STATIC_CONTROLLER:
			roomImageName = @"iP_ZrtsiMedium";
			break;
		case SCENE_CONTROLLER:
		case SCENE_CONTROLLER_TWO:
		case SCENE_CONTROLLER_THREE:
		case SCENE_CONTROLLER_PORTABLE:
			roomImageName = @"iP_SceneControllerMedium";
			break;
		case BINARY_SENSOR:
		case BINARY_SENSOR_TWO:
			roomImageName = @"iP_MediumMotionSensor";
			break;
		default:
			break;
	}
	
	if(isSomfyDevice)
		return roomImage;
	else
	{
		//get the device image with the devicetype name and return the image
		roomImageName = [roomImageName stringByAppendingString:@".png"];
		roomImage = [UIImage imageNamed:roomImageName];
		return roomImage;
	}
}

-(UIImage *)getSomfyDeviceForiPhoneImageBasedOnDeviceType:(int)somfyDeviceType
{
	//Initialize the image
	NSString *roomImageName=@"iP_Room_RTS_Highlight";
	UIImage *roomImage;
	
	//Determine the image that is going to be shown based 
	//on the somfyDeviceType
	switch ( somfyDeviceType )
	{
		case RTS_AWNING:
			roomImageName = @"iP_Room_RTS_Highlight";
			break;
		case RTS_BLIND:
			roomImageName = @"iP_Room_RTS_Blinds";
			break;
		case RTS_DRAPERY:
			roomImageName = @"iP_Room_RTS_curtain";
			break;
		case RTS_ROLLER_SHADE:
			roomImageName = @"iP_Room_RTS_RollarShade";
			break;
		case RTS_SOLAR_SCREEN:
			roomImageName = @"iP_Room_RTS_SloarShade";
			break;
		case RTS_ROLLER_SHUTTER:
			roomImageName = @"iP_Room_RTS_RollerShutter";
			break;
		case RTS_ROMAN_SHADE:
			roomImageName = @"iP_RomanShadeMedium";
			break;
		case RTS_PLANTATION_SHUTTER:
			roomImageName = @"iP_Room_RTS_Plantation-shutter";
			break;
		case RTS_CELLULAR_SHADE:
			roomImageName = @"iP_Room_RTS_Cellular Shade";
			break;
		case RTS_SCREEN_SHADE:
			roomImageName = @"iP_Room_RTS_screen";
			break;
		case ILT_ROLLER_SHADE:
			roomImageName = @"iP_Room_RTS_RollarShade";
			break;
		case ILT_ROMAN_SHADE:
			roomImageName = @"iP_RomanShadeMedium";					
			break;
		case ILT_SOLAR_SCREEN:
			roomImageName = @"iP_Room_RTS_SloarShade";
			break;
		case ILT_SCREEN:
			roomImageName = @"iP_Room_RTS_screen";
			break;
	}
	
	//get the device image with the devicetype name and return the image
	roomImageName = [roomImageName stringByAppendingString:@".png"];
	roomImage = [UIImage imageNamed:roomImageName];
	return roomImage;
}


#pragma mark -
#pragma mark Initialization & Deallocation
static DeviceIconMapper *sharedInstance = nil;

+(DeviceIconMapper *)getSharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			[[self alloc] init];
		}
	}
	
	return sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

-(id)copyWithZone:(NSZone *)zone {
	return self;
}

-(id)retain {
	return self;
}

-(unsigned)retainCount {
	return UINT_MAX;
}

-(void)release { }

-(id)autorelease {
	return self;
}

-(id) init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}

-(void) dealloc {
	[super dealloc];
}


@end
