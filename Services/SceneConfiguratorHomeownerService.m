//
//  SceneConfiguratorHomeownerService.m
//  Somfy
//
//  Created by Sempercon on 5/13/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "SceneConfiguratorHomeownerService.h"
#import "DataConversionUtil.h"
#import "Constants.h"

@implementation SceneConfiguratorHomeownerService

/**
 * Removes a scene from the controller
 * @return
 */
-(void) removeScene :(NSString*)sceneid  :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:@"false" forKey:@"getList"];
	[dataDict setObject:sceneid forKey:@"id"];
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:REMOVE_SCENE :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:REMOVE_SCENE :command :delegate];
	[dataDict release];
}

/**
 * Adds a scene to the controller
 * @return
 */
-(void) addScene:(NSMutableDictionary *)dict :(id<ParserCallback>)delegate
{
	
	/*NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:sceneName forKey:@"name"];
	[dataDict setObject:@"0" forKey:@"sceneType"];
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:ADD_SCENE :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:ADD_SCENE :command :delegate];
	[dataDict release];*/
	
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:ADD_SCENE :dict];
	[[SendCommand getSharedInstance] SendAPICommand:ADD_SCENE :command :delegate];
}
/**
 * Changes the name of the scene.
 * @return
 */
-(void) ChangeSceneName:(NSString *)sceneName :(NSString*)sceneid  :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:sceneName forKey:@"name"];
	[dataDict setObject:sceneid forKey:@"id"];
	//Format commands
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:CHANGE_SCENE_NAME :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:CHANGE_SCENE_NAME :command :delegate];
	[dataDict release];
}
/**
 * Get scene info of the scene.
 * @return
 */
-(void) getSceneInfo:(NSString*)sceneid  :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:sceneid forKey:@"arg"];
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:GET_SCENE_INFO :dataDict];
	//Send the xml command to the service
	[[SendCommand getSharedInstance] SendAPICommand:GET_SCENE_INFO :command :delegate];
	[dataDict release];
}

-(void)includeSceneMember:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : INCLUDE_MEMBER :dataDict :delegate];
}

-(void) setMemberSetting:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest:SET_MEMBER_SETTINGS :dataDict :delegate];
}

//Dispatch request
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate
{
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:strCommand :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:strCommand :command :delegate];
}

#pragma mark -
#pragma mark Initialization & Deallocation
static SceneConfiguratorHomeownerService *sharedInstance = nil;

+(SceneConfiguratorHomeownerService *)getSharedInstance {
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
