


@interface RRSGlowLabel : UILabel {
    CGSize glowOffset;
    UIColor *glowColor;
    CGFloat glowAmount;
}

@property (nonatomic, assign) CGSize glowOffset;
@property (nonatomic, assign) CGFloat glowAmount;
@property (nonatomic, retain) UIColor *glowColor;

@end
