//
//  DashboardService.m
//  Somfy
//
//  Created by Sempercon on 5/9/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "DashboardService.h"
#import "Constants.h"
#import "DataConversionUtil.h"


@implementation DashboardService

//Get allscenes for liveview dashboard
-(void) getScenes:(id<ParserCallback>)delegate
{
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:GET_SCENES :nil];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:GET_SCENES :command :delegate];
}

//Activate a specified scene in liveview dashboard
-(void) ActivateScenes:(NSString*)sceneId :(id<ParserCallback>)delegate
{
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:sceneId forKey:@"arg"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:ACTIVATE_SCENES :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:ACTIVATE_SCENES :command :delegate];
	[dataDict release];
}

//Set Device value for room devices
-(void)SetDeviceValue:(NSString*)deviceVal :(NSString*)deviceId :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:deviceVal forKey:@"value"];
	[dataDict setObject:deviceId forKey:@"id"];
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:DEVICE_SETVALUE :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:DEVICE_SETVALUE :command :delegate];
	[dataDict release];
}

//Get thermostat status based on deviceId
-(void)getThermostatStatus:(NSString*)deviceId :(id<ParserCallback>)delegate
{
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:deviceId forKey:@"arg"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:THERMOSTAT_GET_STATUS :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:THERMOSTAT_GET_STATUS :command :delegate];
	[dataDict release];
}

//Get thermostat desiredtemp
-(void)getThermostatDesiredTemp:(NSMutableDictionary*)dictionary :(id<ParserCallback>)delegate
{
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:THERMOSTAT_GET_DESIRED_TEMP :dictionary];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:THERMOSTAT_GET_DESIRED_TEMP :command :delegate];
}

//Set thermostat energy save mode
-(void)setThermostatEnergySaveMode:(NSMutableDictionary*)dictionary :(id<ParserCallback>)delegate
{
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:SET_THERMOSTAT_ENERGY_SAVE_MODE :dictionary];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:SET_THERMOSTAT_ENERGY_SAVE_MODE :command :delegate];
}
//set thermostat up
-(void)setThermostatTempUp:(NSString*)deviceId :(id<ParserCallback>)delegate
{
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:deviceId forKey:@"arg"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:SET_THERMOSTAT_TEMP_UP :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:SET_THERMOSTAT_TEMP_UP :command :delegate];
	[dataDict release];
}
//set thermostat down
-(void)setThermostatTempDown:(NSString*)deviceId :(id<ParserCallback>)delegate
{
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:deviceId forKey:@"arg"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:SET_THERMOSTAT_TEMP_DOWN :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:SET_THERMOSTAT_TEMP_DOWN :command :delegate];
	[dataDict release];
}
//set thermostat toggle mode
-(void)setThermostatToggleMode:(NSString*)deviceId :(id<ParserCallback>)delegate
{
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:deviceId forKey:@"arg"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:THERMOSTAT_TOGGLE_MODE :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:THERMOSTAT_TOGGLE_MODE :command :delegate];
	[dataDict release];
}
//set thermostat toggle fan mode
-(void)setThermostatToggleFanMode:(NSString*)deviceId :(id<ParserCallback>)delegate
{
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:deviceId forKey:@"arg"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:THERMOSTAT_TOGGLE_FAN_MODE :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:THERMOSTAT_TOGGLE_FAN_MODE :command :delegate];
	[dataDict release];
}
//Set thermostat toggle schedule hold
-(void)setThermostatToggleScheduleHold:(NSString*)deviceId :(id<ParserCallback>)delegate
{
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:deviceId forKey:@"arg"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:THERMOSTAT_TOGGLE_SCHEDULE_HOLD :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:THERMOSTAT_TOGGLE_SCHEDULE_HOLD :command :delegate];
	[dataDict release];
}


#pragma mark -
#pragma mark Initialization & Deallocation
static DashboardService *sharedInstance = nil;

+(DashboardService *)getSharedInstance {
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
