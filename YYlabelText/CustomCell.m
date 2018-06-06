//
//  CustomCell.m
//  YYlabelText
//
//  Created by oprah on 2018/6/6.
//  Copyright © 2018年 oprah. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(void)setModel:(ReplaceModel *)model{
    
    [self addSubview:self.showLabel];
     YYTextLayout *layout= model.contentLayout;
     CGFloat commentHeight = layout.textBoundingSize.height;
    _showLabel.frame = CGRectMake(10, 5, ScreenWidth - 20, commentHeight);
    _showLabel.numberOfLines = 0;
    self.showLabel.attributedText = model.contentString;
}

-(YYLabel *)showLabel{
    
    if (_showLabel == nil) {
        
        _showLabel = [[YYLabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth - 20, 0)];
        
        _showLabel.userInteractionEnabled=YES;
        
        _showLabel.numberOfLines=0;
        
        UIFont *font=[UIFont systemFontOfSize:16];
        
        _showLabel.font=font;
        
        _showLabel.displaysAsynchronously=YES;/// enable async display
        
        _showLabel.textVerticalAlignment=YYTextVerticalAlignmentTop;
    }
    
     return _showLabel;
}

@end
