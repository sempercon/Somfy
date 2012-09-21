//
//  ThermostatService.h
//  Somfy
//
//  Created by Sempercon on 5/23/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"

@interface ThermostatService : NSObject {
	NSString *command;
}

+ (ThermostatService *)getSharedInstance;

-(void) getThermostats :(id<ParserCallback>)delegate;
-(void) getStatus :(NSString*) nId :(id<ParserCallback>)delegate;
-(void) toggleMode:(NSString*) nId :(id<ParserCallback>)delegate;
-(void) toggleScheduleHold :(NSString*) nId :(id<ParserCallback>)delegate;
-(void) toggleFanMode:(NSString*) nId :(id<ParserCallback>)delegate;
-(void) tempUp:(NSString*) nId :(id<ParserCallback>)delegate;
-(void) tempDown:(NSString*) nId :(id<ParserCallback>)delegate;
-(void) setTemp:(NSMutableDictionary*) thermostat :(id<ParserCallback>)delegate;
-(void) setEsDesiredTemperature:(NSMutableDictionary*)thermostat :(id<ParserCallback>)delegate;
-(void) getEsDesiredTemp:(NSMutableDictionary*)thermostat :(id<ParserCallback>)delegate;
-(void) setEnergySavingMode: (NSMutableArray*) thermostat:(id<ParserCallback>)delegate;

@end
