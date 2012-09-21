//
//  DeviceService.m
//  Somfy
//
//  Created by Sempercon on 5/7/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "DeviceService.h"
#import "DataConversionUtil.h"
#import "SendCommand.h"
#import "Constants.h"

@interface DeviceService (private)
//TODO: Declare private methods here
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate;
@end

@implementation DeviceService

-(void)getAll:(id<ParserCallback>)delegate
{
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:GET_ALL :nil];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:GET_ALL :command :delegate];
}

-(void)setSomfyMyPosition :(NSString*)deviceId :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:deviceId forKey:@"value"];
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:SET_SOMFY_MY_POSITION :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:SET_SOMFY_MY_POSITION :command :delegate];
	[dataDict release];
}

-(void)changeName :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : CHANGE_NAME :dict :delegate];
}

-(void)changeRoom :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : CHANGE_ROOM :dict :delegate];
}

-(void)getDevice :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	/*var rawId:int = id.id;
	var command:XML=DataConversionUtil.buildXMLCommand( GET_DEVICE, rawId, int );
	return service.send( command );*/
}

-(void)getDeviceName :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
}

-(void)getProtection :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
}

-(void)setAsShortcut :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
}

-(void)setControlledWatts :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
}

-(void)setProtection :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
}

-(void)setValue :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
}

//Dispatch request
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate
{
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:strCommand :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:strCommand :command :delegate];
}



#pragma mark -
#pragma mark Initialization & Deallocation

static DeviceService *sharedInstance = nil;

+(DeviceService *)getSharedInstance {
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
