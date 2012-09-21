//
//  SendCommand.h
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Method of parser callback implemented here
@protocol ParserCallback <NSObject>
-(void)commandCompleted:(NSMutableArray*)resultArray commandString:(NSString*)strCommand;
-(void)commandFailed:(NSString*)errorMsg:(NSString*)errorDescription;
@end

@protocol SkinChooserCallback <NSObject>
-(void)removePopup;
-(void)refreshViewFromPopup;
@end


@interface SendCommand : NSObject {

	NSMutableData  *receivedData;
	NSMutableArray *resultArray;
	NSObject<ParserCallback> *Parserdelegate;
	NSString		*CommandString;
}

@property (nonatomic, assign) NSObject<ParserCallback> *Parserdelegate;
@property (nonatomic, assign) NSString *CommandString;

+ (SendCommand *)getSharedInstance;
-(BOOL) SendAPICommand :(NSString *) strCommand :(NSString *) postCommand :(id<ParserCallback>)delegate;
-(void) parsetHttpResponse;
-(int)parseStatus;
-(void)parseData:(NSString*)strNode;

@end
