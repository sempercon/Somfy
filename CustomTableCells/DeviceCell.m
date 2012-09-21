//
//  CustomTableCell.m
//  NobleMDNetwork
//
//  Created by mac user on 6/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell

@synthesize lblDeviceName,lblRoomName,lblDeviceType,lblProductID,lblManufacturer,lblZwaveID,lblZwaveProtocol;
@synthesize imgLine1,imgLine2,imgLine3,imgLine4,imgLine5,imgLine6,imgLine7;

#pragma mark -
#pragma mark Constructor and destructor

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
		lblDeviceName=[[UILabel alloc]initWithFrame:CGRectMake(10,0,110,50)];
		lblDeviceName.textColor=[UIColor colorWithRed:(float)17/255 green:(float)36/255 blue:(float)48/255 alpha:1.0]; //204 219 212
		lblDeviceName.backgroundColor=[UIColor clearColor];
		lblDeviceName.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
		lblDeviceName.textAlignment = UITextAlignmentLeft;
		lblDeviceName.lineBreakMode= UILineBreakModeWordWrap;
		lblDeviceName.contentMode = UIViewContentModeScaleToFill;
		lblDeviceName.numberOfLines=0;
		lblDeviceName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
		[self.contentView addSubview:lblDeviceName];
		
		imgLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(110, 0, 5 ,50)];
		imgLine1.backgroundColor = [UIColor clearColor];
		imgLine1.contentMode = UIViewContentModeScaleToFill;
		imgLine1.image = [UIImage imageNamed:@"Line_BG.png"];
		[self.contentView addSubview:imgLine1];
		
		lblRoomName=[[UILabel alloc]initWithFrame:CGRectMake(140,0,110,50)];
		lblRoomName.textColor= [UIColor colorWithRed:(float)17/255 green:(float)36/255 blue:(float)48/255 alpha:1.0]; 
		lblRoomName.backgroundColor=[UIColor clearColor];
		lblRoomName.textAlignment = UITextAlignmentLeft;
		lblRoomName.lineBreakMode= UILineBreakModeWordWrap;
		lblRoomName.contentMode = UIViewContentModeScaleToFill;
		lblRoomName.numberOfLines=0;
		lblRoomName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
		[self.contentView addSubview:lblRoomName];
		
		imgLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(250, 0, 5 ,50)];
		imgLine2.backgroundColor = [UIColor clearColor];
		imgLine2.contentMode = UIViewContentModeScaleToFill;
		imgLine2.image = [UIImage imageNamed:@"Line_BG.png"];
		[self.contentView addSubview:imgLine2];
		
		lblDeviceType=[[UILabel alloc]initWithFrame:CGRectMake(270,0, 110,50)];
		lblDeviceType.textColor= [UIColor colorWithRed:(float)17/255 green:(float)36/255 blue:(float)48/255 alpha:1.0]; 
		lblDeviceType.textAlignment = UITextAlignmentLeft;
		lblDeviceType.backgroundColor=[UIColor clearColor];
		lblDeviceType.lineBreakMode= UILineBreakModeWordWrap;
		lblDeviceType.contentMode = UIViewContentModeScaleToFill;
		lblDeviceType.numberOfLines=0;
		lblDeviceType.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
		[self.contentView addSubview:lblDeviceType];
		
		imgLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(380, 0, 5 ,50)];
		imgLine3.backgroundColor = [UIColor clearColor];
		imgLine3.contentMode = UIViewContentModeScaleToFill;
		imgLine3.image = [UIImage imageNamed:@"Line_BG.png"];
		[self.contentView addSubview:imgLine3];
		
		lblProductID=[[UILabel alloc]initWithFrame:CGRectMake(400,0,110,50)];
		lblProductID.textColor= [UIColor colorWithRed:(float)17/255 green:(float)36/255 blue:(float)48/255 alpha:1.0]; 
		lblProductID.textAlignment = UITextAlignmentLeft;
		lblProductID.backgroundColor=[UIColor clearColor];
		lblProductID.lineBreakMode= UILineBreakModeWordWrap;
		lblProductID.contentMode = UIViewContentModeScaleToFill;
		lblProductID.numberOfLines=0;
		lblProductID.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
		[self.contentView addSubview:lblProductID];
		
		imgLine4 = [[UIImageView alloc]initWithFrame:CGRectMake(510, 0, 5 ,50)];
		imgLine4.backgroundColor = [UIColor clearColor];
		imgLine4.contentMode = UIViewContentModeScaleToFill;
		imgLine4.image = [UIImage imageNamed:@"Line_BG.png"];
		[self.contentView addSubview:imgLine4];
		
		lblManufacturer=[[UILabel alloc]initWithFrame:CGRectMake(530,0,110,50)];
		lblManufacturer.textColor= [UIColor colorWithRed:(float)17/255 green:(float)36/255 blue:(float)48/255 alpha:1.0]; 
		lblManufacturer.textAlignment = UITextAlignmentLeft;
		lblManufacturer.backgroundColor=[UIColor clearColor];
		lblManufacturer.lineBreakMode= UILineBreakModeWordWrap;
		lblManufacturer.contentMode = UIViewContentModeScaleToFill;
		lblManufacturer.numberOfLines=0;
		lblManufacturer.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
		[self.contentView addSubview:lblManufacturer];
		
		imgLine5 = [[UIImageView alloc]initWithFrame:CGRectMake(640, 0, 5 ,50)];
		imgLine5.backgroundColor = [UIColor clearColor];
		imgLine5.contentMode = UIViewContentModeScaleToFill;
		imgLine5.image = [UIImage imageNamed:@"Line_BG.png"];
		[self.contentView addSubview:imgLine5];
		
		lblZwaveID=[[UILabel alloc]initWithFrame:CGRectMake(660,0,110,50)];
		lblZwaveID.textColor= [UIColor colorWithRed:(float)11/255 green:(float)111/255 blue:(float)152/255 alpha:1.0]; 
		lblZwaveID.textAlignment = UITextAlignmentLeft;
		lblZwaveID.backgroundColor=[UIColor clearColor];
		lblZwaveID.lineBreakMode= UILineBreakModeWordWrap;
		lblZwaveID.contentMode = UIViewContentModeScaleToFill;
		lblZwaveID.numberOfLines=0;
		lblZwaveID.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
		[self.contentView addSubview:lblZwaveID];
		
		imgLine6 = [[UIImageView alloc]initWithFrame:CGRectMake(770, 0, 5 ,50)];
		imgLine6.backgroundColor = [UIColor clearColor];
		imgLine6.contentMode = UIViewContentModeScaleToFill;
		imgLine6.image = [UIImage imageNamed:@"Line_BG.png"];
		[self.contentView addSubview:imgLine6];
		
		lblZwaveProtocol=[[UILabel alloc]initWithFrame:CGRectMake(800,0,120,50)];
		lblZwaveProtocol.textColor= [UIColor colorWithRed:(float)11/255 green:(float)111/255 blue:(float)152/255 alpha:1.0]; 
		lblZwaveProtocol.textAlignment = UITextAlignmentLeft;
		lblZwaveProtocol.backgroundColor=[UIColor clearColor];
		lblZwaveProtocol.lineBreakMode= UILineBreakModeWordWrap;
		lblZwaveProtocol.contentMode = UIViewContentModeScaleToFill;
		lblZwaveProtocol.numberOfLines=0;
		lblZwaveProtocol.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
		[self.contentView addSubview:lblZwaveProtocol];
		
		/*imgLine7 = [[UIImageView alloc]initWithFrame:CGRectMake(920, 0, 5 ,50)];
		imgLine7.backgroundColor = [UIColor clearColor];
		imgLine7.contentMode = UIViewContentModeScaleToFill;
		imgLine7.image = [UIImage imageNamed:@"Line_BG.png"];
		[self.contentView addSubview:imgLine7];*/
		
		self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}



- (void)dealloc 
{
	[imgLine1,imgLine2,imgLine3,imgLine4,imgLine5,imgLine6,imgLine7 release];
    [lblDeviceName,lblRoomName,lblDeviceType,lblProductID,lblManufacturer,lblZwaveID,lblZwaveProtocol release];
    [super dealloc];
}


@end
