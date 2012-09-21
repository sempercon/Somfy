//
//  SendStatusCommand.h
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"


/*//Method of parser callback implemented here
@protocol ParserCallback <NSObject>
-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand;
-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription;
@end*/

@interface SendStatusCommand : NSObject {

	NSMutableData  *receivedData;
	NSMutableArray *resultArray;
	NSObject<ParserCallback> *Parserdelegate;
	NSString		*CommandString;
}

@property (nonatomic, assign) NSObject<ParserCallback> *Parserdelegate;
@property (nonatomic, assign) NSString *CommandString;

+ (SendStatusCommand *)getSharedInstance;
-(BOOL) SendAPICommand :(NSString *) strCommand :(NSString *) postCommand :(id<ParserCallback>)delegate;
-(void) parsetHttpResponse;
-(int)parseStatus;
-(void)parseData:(NSString*)strNode;

@end
