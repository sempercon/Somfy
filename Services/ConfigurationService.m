//
//  ConfigurationService.m
//  Somfy
//
//  Created by Sempercon on 5/25/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "ConfigurationService.h"
#import "Constants.h"
#import "DataConversionUtil.h"



@interface ConfigurationService (private)
//TODO: Declare private methods here
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate;
@end

@implementation ConfigurationService

/**
 * 
 * @return 
 */
-(void)getDeviceSetupStatusWizard:(id<ParserCallback>)delegate
{
	
}

/**
 * 
 * @return 
 */
-(void)getSystemInformation:(id<ParserCallback>)delegate
{			
	
}

/**
 * 
 * @return 
 */
-(void)runDeviceSetupWizard:(NSString*) Id :(id<ParserCallback>)delegate
{	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setObject:Id forKey:@"value"];
	[self dispatchRequest : DEVICE_SETUP_WIZARD_RUN :dict :delegate];
	[dict release];
}

/**
 * 
 * @return 
 */
-(void)setMetaData:(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : SET_METADATA :dataDict :delegate];
}

/**
 * 
 * @return 
 */
-(void)zWaveAdd:(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest:ZWAVE_ADD :dataDict :delegate];
}

/**
 * 
 * @return 
 */
-(void)zWaveBroadcastNodeInfo:(id<ParserCallback>)delegate
{
	[self dispatchRequest : ZWAVE_BROADCAST_NODE_INFO :Nil :delegate];
}
/**
 * 
 * @return 
 */
-(void)zWaveCancel:(id<ParserCallback>)delegate
{
	[self dispatchRequest : ZWAVE_CANCEL :Nil :delegate];
}
/**
 * 
 * @return 
 */
-(void)zWaveDBReset :(id<ParserCallback>)delegate
{
	
}
/**
 * 
 * @return 
 */
-(void)zWaveGetStatus:(id<ParserCallback>)delegate
{
	//[self dispatchRequest : ZWAVE_GET_STATUS :Nil :delegate];
	
	//Call statuscommand method to call zwavegetstatus api
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:ZWAVE_GET_STATUS :Nil];
	[[SendStatusCommand getSharedInstance] SendAPICommand:ZWAVE_GET_STATUS :command :delegate];
}
/**
 * 
 * @return 
 */
-(void)zWaveLearn:(id<ParserCallback>)delegate
{
	[self dispatchRequest:ZWAVE_LEARN :Nil :delegate];
}

/**
 * 
 * @return 
 */
-(void)zWaveRediscoverNodes:(NSString*)commandString :(id<ParserCallback>)delegate
{
	[[SendCommand getSharedInstance] SendAPICommand:ZWAVE_REDISCOVER_NODES :commandString :delegate];
}

-(void)zWaveRediscoverNodesDeviceTools:(NSMutableDictionary*)dictionary :(id<ParserCallback>)delegate
{
	[self dispatchRequest:ZWAVE_REDISCOVER_NODES :dictionary :delegate];
}

/**
 * 
 * @return 
 */
-(void)zWaveRediscoverMultipleNodes:(NSMutableArray*) configureArray:(id<ParserCallback>)delegate
{
	
}

/**
 * 
 * @return 
 */
-(void)zWaveRemove:(id<ParserCallback>)delegate
{
	[self dispatchRequest:ZWAVE_REMOVE :Nil :delegate];
}

/**
 * 
 * @return 
 */
-(void)zWaveRemoveFailedNode:(NSMutableDictionary*)dictionary:(id<ParserCallback>)delegate
{
	[self dispatchRequest:ZWAVE_REMOVE_FAILED_NODE :dictionary :delegate];
}

/**
 * 
 * @return 
 */
-(void)zWaveReplaceFailedNode:(NSMutableDictionary*)dictionary:(id<ParserCallback>)delegate
{
	[self dispatchRequest:ZWAVE_REPLACE_FAILED_NODE :dictionary :delegate];
}

//Dispatch request
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate
{
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:strCommand :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:strCommand :command :delegate];
}




#pragma mark -
#pragma mark Initialization & Deallocation
static ConfigurationService *sharedInstance = nil;

+(ConfigurationService *)getSharedInstance {
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
