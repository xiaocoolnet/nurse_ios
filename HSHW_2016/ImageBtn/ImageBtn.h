//
//  ImageBtn.h
//  a
//
//  Created by 主用户 on 16/2/29.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBtn : UIButton
@property(nonatomic, retain)UIImageView *image;
@property(nonatomic, retain)UILabel *lb_title;
@property(nonatomic, retain) UIColor * lb_titleColor;

- (id)initWithFrame:(CGRect)frame :(NSString *)title :(UIImage *)Image;
- (id)initWithFrame:(CGRect)frame;
-(void)resetdata:(NSString *)title :(UIImage *)Image;
-(void)resetdataRight:(NSString *)title :(UIImage *)Image;
-(void)resetdataCenter:(NSString *)title :(UIImage *)Image;

@end
