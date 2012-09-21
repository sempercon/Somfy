//
//  RoomIconMapper.h
//  Somfy
//
//  Created by Sempercon on 5/6/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface RoomIconMapper : NSObject {

}
+ (RoomIconMapper *)getSharedInstance;
-(UIImage *) getRoomImageBasedOnRoomId : (int) roomId;
-(UIImage *) getRoomImageBasedOnRoomId : (int) roomId :(int)selected;
-(UIImage *) getRoomImageBasedOnRoomIdForIphone : (int) roomId;

@end
