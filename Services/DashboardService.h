//
//  DashboardService.h
//  Somfy
//
//  Created by Sempercon on 5/9/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"

@interface DashboardService : NSObject {
	NSString *command;
}

+ (DashboardService *)getSharedInstance;
-(void) getScenes:(id<ParserCallback>)delegate;
-(void) ActivateScenes:(NSString*)sceneId :(id<ParserCallback>)delegate;
-(void)SetDeviceValue:(NSString*)deviceVal :(NSString*)deviceId :(id<ParserCallback>)delegate;
-(void)getThermostatStatus:(NSString*)deviceId :(id<ParserCallback>)delegate;
-(void)getThermostatDesiredTemp:(NSMutableDictionary*)dictionary :(id<ParserCallback>)delegate;
-(void)setThermostatEnergySaveMode:(NSMutableDictionary*)dictionary :(id<ParserCallback>)delegate;
-(void)setThermostatTempUp:(NSString*)deviceId :(id<ParserCallback>)delegate;
-(void)setThermostatTempDown:(NSString*)deviceId :(id<ParserCallback>)delegate;
-(void)setThermostatToggleMode:(NSString*)deviceId :(id<ParserCallback>)delegate;
-(void)setThermostatToggleFanMode:(NSString*)deviceId :(id<ParserCallback>)delegate;
-(void)setThermostatToggleScheduleHold:(NSString*)deviceId :(id<ParserCallback>)delegate;

@end
