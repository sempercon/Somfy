//
//  ConfigurationService.h
//  Somfy
//
//  Created by Sempercon on 5/25/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"
#import "SendStatusCommand.h"
#import "Constants.h"

@interface ConfigurationService : NSObject {
		NSString *command;
}
+ (ConfigurationService *)getSharedInstance;
-(void)getDeviceSetupStatusWizard:(id<ParserCallback>)delegate;
-(void)getSystemInformation:(id<ParserCallback>)delegate;
-(void)runDeviceSetupWizard:(NSString*) Id :(id<ParserCallback>)delegate;
-(void)setMetaData:(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate;
-(void)zWaveAdd:(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate;
-(void)zWaveBroadcastNodeInfo :(id<ParserCallback>)delegate;
-(void)zWaveCancel :(id<ParserCallback>)delegate;
-(void)zWaveDBReset:(id<ParserCallback>)delegate;
-(void)zWaveGetStatus:(id<ParserCallback>)delegate;
-(void)zWaveLearn :(id<ParserCallback>)delegate;
-(void)zWaveRediscoverNodes:(NSString*)commandString :(id<ParserCallback>)delegate;
-(void)zWaveRediscoverNodesDeviceTools:(NSMutableDictionary*)dictionary :(id<ParserCallback>)delegate;
-(void)zWaveRediscoverMultipleNodes:(NSMutableArray*)configureArray :(id<ParserCallback>)delegate;
-(void)zWaveRemove:(id<ParserCallback>)delegate;
-(void)zWaveRemoveFailedNode:(NSMutableDictionary*)dictionary:(id<ParserCallback>)delegate;
-(void)zWaveReplaceFailedNode:(NSMutableDictionary*)dictionary:(id<ParserCallback>)delegate;

@end
