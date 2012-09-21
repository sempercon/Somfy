//
//  ThermostatService.m
//  Somfy
//
//  Created by Sempercon on 5/23/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "ThermostatService.h"
#import "DataConversionUtil.h"
#import "SendCommand.h"
#import "Constants.h"

@interface ThermostatService (private)
//TODO: Declare private methods here
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate;
-(NSMutableDictionary*)bindThermostatToDict :(NSMutableArray*)thermostat;
@end

@implementation ThermostatService


-(void) getThermostats :(id<ParserCallback>)delegate
{
	[self dispatchRequest : GET_THERMOSTATS :Nil :delegate];
}

-(void) getStatus :(NSString*) nId :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:nId forKey:@"arg"];
	[self dispatchRequest : GET_STATUS :dataDict :delegate];
	[dataDict release];
}

-(void)toggleMode:(NSString*) nId :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:nId forKey:@"arg"];
	[self dispatchRequest : TOGGLE_MODE :dataDict :delegate];
	[dataDict release];
}

-(void) toggleScheduleHold :(NSString*) nId :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:nId forKey:@"arg"];
	[self dispatchRequest : TOGGLE_SCHEDULE_HOLD :dataDict :delegate];
	[dataDict release];
}

-(void) toggleFanMode:(NSString*) nId :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:nId forKey:@"arg"];
	[self dispatchRequest : TOGGLE_FAN_MODE :dataDict :delegate];
	[dataDict release];
}

-(void) tempUp:(NSString*) nId :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:nId forKey:@"arg"];
	[self dispatchRequest : TEMP_UP :dataDict :delegate];
	[dataDict release];
}

-(void) tempDown:(NSString*) nId :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:nId forKey:@"arg"];
	[self dispatchRequest : TEMP_DOWN :dataDict :delegate];
	[dataDict release];
}

-(void) setTemp:(NSMutableDictionary*) thermostat :(id<ParserCallback>)delegate
{
	/*NSMutableDictionary *dataDict = [self bindThermostatToDict :thermostat];
	[self dispatchRequest : SET_TEMP :dataDict :delegate];
	[dataDict release];*/
	
	[self dispatchRequest : SET_TEMP :thermostat :delegate];
}

-(void) setEsDesiredTemperature:(NSMutableDictionary*)thermostat :(id<ParserCallback>)delegate
{
	[self dispatchRequest : SET_ES_DESIRED_TEMP :thermostat :delegate];
}

-(void) getEsDesiredTemp:(NSMutableDictionary*)thermostat :(id<ParserCallback>)delegate
{
	[self dispatchRequest : GET_ES_DESIRED_TEMP :thermostat :delegate];
}

-(void) setEnergySavingMode: (NSMutableArray*) thermostat:(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [self bindThermostatToDict :thermostat];
	[self dispatchRequest : SET_ENERGY_SAVE_MODE :dataDict :delegate];
	[dataDict release];
	
}

/*-(void) changeName(name:ChangeNameType):AsyncToken
{
	return dispatchRequest ( CHANGE_NAME, name, ChangeNameType );
}*/

-(NSMutableDictionary*)bindThermostatToDict :(NSMutableArray*)thermostat
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"ambientTemp"] forKey:@"ambientTemp"];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"devType"] forKey:@"devType"];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"scheduleBypass"] forKey:@"scheduleBypass"];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"id"] forKey:@"id"];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"mode"] forKey:@"mode"];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"fanMode"] forKey:@"fanMode"];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"setTemp"] forKey:@"setTemp"];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"engSaveMode"] forKey:@"engSaveMode"];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"roomID"] forKey:@"roomID"];
	[dataDict setObject:[[thermostat objectAtIndex:0]objectForKey:@"esSetPoint"] forKey:@"esSetPoint"];
	return dataDict;
}

//-----------------------------------------------------------------------------
//
//	Private Method
//
//-----------------------------------------------------------------------------

-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate
{
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:strCommand :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:strCommand :command :delegate];
}

#pragma mark -
#pragma mark Initialization & Deallocation
static ThermostatService *sharedInstance = nil;

+(ThermostatService *)getSharedInstance {
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
