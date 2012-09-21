//
//  RoomService.m
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "RoomService.h"
#import "DataConversionUtil.h"
#import "SendCommand.h"
#import "Constants.h"

@implementation RoomService

/**
 * Adds a room to the controller
 * @return
 */
-(void) addRoom:(NSString *)room :(id<ParserCallback>)delegate
{
	
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:room forKey:@"name"];
	[dataDict setObject:@"0" forKey:@"id"];
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:ADD_ROOMS_COMMAND :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:ADD_ROOMS_COMMAND :command :delegate];
	[dataDict release];
}

/**
 * Changes the name of the room.
 * @return
 */
-(void) changeRoomName:(NSString*)newName :(NSString*)roomid  :(id<ParserCallback>)delegate
{
	
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:newName forKey:@"name"];
	[dataDict setObject:roomid forKey:@"id"];
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:CHANGE_ROOM_NAME :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:CHANGE_ROOM_NAME :command :delegate];
	[dataDict release];
}


/**
 * Returns the rooms that are defined on the controller
 * @return
 */
-(void) getRooms:(id<ParserCallback>)delegate
{
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:GET_ROOMS_COMMAND :nil];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:GET_ROOMS_COMMAND :command :delegate];
	
}

/**
 * Removes a room from the controller
 * @return
 */
-(void) removeRoom :(NSString*)roomid  :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:@"false" forKey:@"getList"];
	[dataDict setObject:roomid forKey:@"id"];
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:REMOVE_ROOM_COMMAND :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:REMOVE_ROOM_COMMAND :command :delegate];
	[dataDict release];
	
}

//Getselected rooms for the controller
-(void) GetSelectedRoom :(id<ParserCallback>)delegate
{
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:@"SELECTED_ROOMS" forKey:@"referenceString"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:SELECTED_ROOM_COMMAND :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:SELECTED_ROOM_COMMAND :command :delegate];
	[dataDict release];
}

//SetSelectedRooms for the controller
-(void) SetSelectedRoom :(NSString*)datastring :(id<ParserCallback>)delegate
{
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:@"SELECTED_ROOMS" forKey:@"referenceString"];
	[dataDict setObject:datastring forKey:@"dataString"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:SET_SELECTED_ROOM_COMMAND :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:SET_SELECTED_ROOM_COMMAND :command :delegate];
	[dataDict release];
}

#pragma mark -
#pragma mark Initialization & Deallocation
static RoomService *sharedInstance = nil;

+(RoomService *)getSharedInstance {
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
