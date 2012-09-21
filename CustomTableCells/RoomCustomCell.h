//
//  RoomCustomCell.h
//  Somfy
//
//  Created by macuser on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomCustomCell.h"

@class RoomCustomCell;

@protocol RoomCustomCellDelegate <NSObject>
-(void)RoomSelected:(RoomCustomCell*)cell;
@end

@interface RoomCustomCell : UITableViewCell {
@private
	UILabel		*lblRoomName;
	UIImageView	*img,*imgBg,*backgroundImg;
	NSObject<RoomCustomCellDelegate> *delegate;
	UILabel *lblDeviceName,*lblDeviceSubTitle1,*lblDeviceSubTitle2,*lblDeviceSubValue1,*lblDeviceSubValue2,*lblDeviceSubValue1Deg,*lblDeviceSubValue2Deg;
}

@property(nonatomic,retain) IBOutlet UILabel *lblRoomName;
@property(nonatomic,retain) IBOutlet UILabel *lblDeviceName,*lblDeviceSubTitle1,*lblDeviceSubTitle2,*lblDeviceSubValue1,*lblDeviceSubValue2,*lblDeviceSubValue1Deg,*lblDeviceSubValue2Deg;
@property(nonatomic,retain) IBOutlet UIImageView	*img,*imgBg,*backgroundImg;
@property(nonatomic,assign) NSObject<RoomCustomCellDelegate> *delegate;

@end
