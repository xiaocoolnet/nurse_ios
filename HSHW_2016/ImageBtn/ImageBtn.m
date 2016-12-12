
//
//  ImageBtn.m
//  a
//
//  Created by 主用户 on 16/2/29.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import "ImageBtn.h"

@implementation ImageBtn
@synthesize lb_title,image;
//创建时直接确定好位置
- (id)initWithFrame:(CGRect)frame :(NSString *)title :(UIImage *)Image
{
    self = [super initWithFrame:frame];
    if (self) {

        lb_title = [[UILabel alloc] initWithFrame:CGRectZero];
        lb_title.numberOfLines = 0;
        lb_title.font = [UIFont systemFontOfSize:14.f];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = title;
        CGSize size = [lb_title.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}];
        //假设lb_title与图片、按钮边缘间隔都是10,图片大小50*50
        if (size.width>self.frame.size.width-10*2-50-10) {
            size.width =self.frame.size.width-10*2-50-10;
        }
        lb_title.frame = CGRectMake(10, 0, size.width, self.frame.size.height);
        [self addSubview:lb_title];
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(lb_title.frame.size.width+lb_title.frame.origin.x+10, (self.frame.size.height-50)/2, 50, 50)];
        image.image = Image;
        image.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:image];
    }
    return self;
}
//先创建，后布局
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        lb_title = [[UILabel alloc] initWithFrame:CGRectZero];
//        lb_title.numberOfLines = 0;
        lb_title.font = [UIFont systemFontOfSize:17.f];
        lb_title.adjustsFontSizeToFitWidth = true;
        lb_title.backgroundColor = [UIColor clearColor];
        [self addSubview:lb_title];
        
        image = [[UIImageView alloc] initWithFrame:CGRectZero];

        image.backgroundColor = [UIColor clearColor];
        [self addSubview:image];
    }
    return self;
}
//更改title内容时可重新布局
-(void)resetdata:(NSString *)title :(UIImage *)Image
{
    lb_title.text = title;
    CGSize size = [lb_title.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.f]}];
    //假设lb_title与图片、按钮边缘间隔都是10,图片大小50*50
    CGFloat margin = 5;
    CGFloat imgWidth = Image.size.width;
    CGFloat imgHeight = Image.size.height;
    
    if (size.width>self.frame.size.width-margin-imgWidth-10) {
        size.width =self.frame.size.width-margin-imgWidth-10;
    }
    image.image = Image;
    lb_title.frame = CGRectMake(margin, 0, size.width, self.frame.size.height);
    image.frame = CGRectMake(lb_title.frame.size.width+lb_title.frame.origin.x+margin, (self.frame.size.height-imgHeight)/2, imgWidth, imgHeight);
}

-(void)resetdataRight:(NSString *)title :(UIImage *)Image
{
    lb_title.text = title;
    CGSize size = [lb_title.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.f]}];
    //假设lb_title与图片、按钮边缘间隔都是10,图片大小50*50
    CGFloat margin = 5;
    CGFloat imgWidth = Image.size.width;
    CGFloat imgHeight = Image.size.height;
    
    if (size.width>self.frame.size.width-margin-imgWidth-10) {
        size.width =self.frame.size.width-margin-imgWidth-10;
    }
    image.image = Image;
    lb_title.frame = CGRectMake(self.frame.size.width-imgWidth-margin-size.width, 0, size.width, self.frame.size.height);
    image.frame = CGRectMake(self.frame.size.width-imgWidth, (self.frame.size.height-imgHeight)/2, imgWidth, imgHeight);
}
-(void)resetdataCenter:(NSString *)title :(UIImage *)Image
{
    lb_title.text = title;
    CGSize size = [lb_title.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.f]}];
    //假设lb_title与图片、按钮边缘间隔都是10,图片大小50*50
    CGFloat margin = 5;
    CGFloat imgWidth = Image.size.width;
    CGFloat imgHeight = Image.size.height;
    
    if (size.width>self.frame.size.width-margin-imgWidth-10) {
        size.width =self.frame.size.width-margin-imgWidth-10;
    }
    image.image = Image;
    lb_title.frame = CGRectMake((self.frame.size.width-size.width-imgWidth)/2.0, 0, size.width, self.frame.size.height);
    image.frame = CGRectMake(CGRectGetMaxX(lb_title.frame), (self.frame.size.height-imgHeight)/2, imgWidth, imgHeight);
}

- (void)setLb_titleColor:(UIColor *)lb_titleColor {
    _lb_titleColor = lb_titleColor;
    lb_title.textColor = lb_titleColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
