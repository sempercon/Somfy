//
//  UserService.m
//  Somfy
//
//  Created by Sempercon on 5/31/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "UserService.h"
#import "Constants.h"
#import "DataConversionUtil.h"

@interface UserService (private)

-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate;

@end

@implementation UserService

-(void)authenticate:(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : AUTHENTICATE_USER :dataDict :delegate];
}

-(void)HomeOccupationGetInfo:(id<ParserCallback>)delegate
{
	[self dispatchRequest : HOME_OCCUPANCY_INFO_GET :Nil :delegate];
}

-(void)HomeOccupationEnable :(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : HOME_OCCUPANCY_ENABLE :dataDict :delegate];
}

-(void)HomeOccupancyStateGroupDeviceAdd :(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : HOME_OCCUPANCY_STATE_GROUP_DEVICE_ADD :dataDict :delegate];
}

-(void)selectTahomaController:(NSString*)index :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setObject:index forKey:@"index"];
	[self dispatchRequest:SELECT_CONTROLLER :dict :delegate];
	[dict release];
}

-(void)Logout:(id<ParserCallback>)delegate
{
	[self dispatchRequest:LOGOUT :Nil :delegate];
}

//Dispatch request
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate
{
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:strCommand :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:strCommand :command :delegate];
}

#pragma mark -
#pragma mark Initialization & Deallocation
static UserService *sharedInstance = nil;

+(UserService *)getSharedInstance {
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
