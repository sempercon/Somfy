//
//  ActiveStarCell.h
//  NobleMDNetwork
//
//  Created by mac user on 6/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface DeviceCell : UITableViewCell
{
	IBOutlet UILabel *lblDeviceName,*lblRoomName,*lblDeviceType,*lblProductID,*lblManufacturer,*lblZwaveID,*lblZwaveProtocol;
	IBOutlet UIImageView *imgLine1,*imgLine2,*imgLine3,*imgLine4,*imgLine5,*imgLine6,*imgLine7;
}

@property(nonatomic,retain) UILabel *lblDeviceName,*lblRoomName,*lblDeviceType,*lblProductID,*lblManufacturer,*lblZwaveID,*lblZwaveProtocol;
@property(nonatomic,retain) UIImageView *imgLine1,*imgLine2,*imgLine3,*imgLine4,*imgLine5,*imgLine6,*imgLine7;

@end
