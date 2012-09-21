//
//  RoomService.h
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"

@interface RoomService : NSObject {
	NSString *command;
}

+ (RoomService *)getSharedInstance;
-(void) getRooms:(id<ParserCallback>)delegate;
-(void) addRoom:(NSString *)room :(id<ParserCallback>)delegate;
-(void) changeRoomName:(NSString*)newName :(NSString*)roomid  :(id<ParserCallback>)delegate;
-(void) removeRoom :(NSString*)roomid  :(id<ParserCallback>)delegate;
-(void) GetSelectedRoom :(id<ParserCallback>)delegate;
-(void) SetSelectedRoom :(NSString*)datastring :(id<ParserCallback>)delegate;

@end
