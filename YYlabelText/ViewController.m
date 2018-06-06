//
//  ViewController.m
//  YYlabelText
//
//  Created by oprah on 2018/6/6.
//  Copyright © 2018年 oprah. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "ReplaceModel.h"
#import "YYTextView.h"
#import "YYImage.h"
#import "NSAttributedString+YYText.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * listTableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.listTableView];
    
    [self addTheDataToArray];
}


-(void)addTheDataToArray{
    
    NSArray * listArray  = [NSArray arrayWithObjects:@"哈哈哈，今天就是你的死期了，明年的今天就是你的忌日[face:05][face:05][face:05],还有什么话要说吗，没有我就要出[face:18][face:18][face:18]",@"我[face:29]你，你[face:29]我吗？如果你嫁给我，我会辈子对你好的，所有的东西都给你[face:39]",@"[face:10][face:01][face:20],[face:19][face:04][face:44][face:34][face:23][face:10][face:30][face:10][face:22]",@"从此以后不要再搭理我了，伤心了[face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45][face:45]", nil];
    
    for (int i = 0; i<listArray.count; i++) {
        ReplaceModel * model = [[ReplaceModel alloc] init];
        model.contentString =  [self processCommentContent:listArray[i]];
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(ScreenWidth- 50, MAXFLOAT)];
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text: model.contentString];
        model.contentLayout = textLayout;
        [_dataArray addObject:model];
    }
    
    [_listTableView reloadData];
    
}

-(UITableView *)listTableView{
    
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        
    }
    return _listTableView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellId = @"cellId";
    CustomCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    ReplaceModel * model = _dataArray[indexPath.row];
    cell.model = model;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReplaceModel * model = _dataArray[indexPath.row];
    
    float height = model.contentLayout.textBoundingSize.height;
    
    return height + 10;
}

-(NSMutableAttributedString *)processCommentContent:(NSString *)text
{
    //转成可变属性字符串
    NSMutableAttributedString * mAttributedString = [[NSMutableAttributedString alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [paragraphStyle setParagraphSpacing:4];//调整行间距
    NSDictionary *attri = [NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:15],[UIColor redColor],paragraphStyle] forKeys:@[NSFontAttributeName,NSForegroundColorAttributeName,NSParagraphStyleAttributeName]];
    [mAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:attri]];
    //创建匹配正则表达式的类型描述模板
    NSString * pattern = @"\\[face:\\d{1,2}\\]";
    //创建匹配对象
    NSError * error;
    NSRegularExpression * regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    //判断
    if (!regularExpression)//如果匹配规则对象为nil
    {
        NSLog(@"正则创建失败！");
        NSLog(@"error = %@",[error localizedDescription]);
        return nil;
    }
    else
    {
        NSArray * resultArray = [regularExpression matchesInString:mAttributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, mAttributedString.string.length)];
        //开始遍历 逆序遍历
        for (NSInteger i = resultArray.count - 1; i >= 0; i --)
        {
            //获取检查结果，里面有range
            NSTextCheckingResult * result = resultArray[i];
            //根据range获取字符串
            NSString * rangeString = [mAttributedString.string substringWithRange:result.range];
            NSLog(@"%@",rangeString);
            //            NSInteger  indexs = [rangeString substringToIndex:2] integerValue];
            NSString * numberString =  [rangeString substringWithRange:NSMakeRange(6,2)];
            //            NSString * imageName = ;
            NSLog(@"%ld",[numberString integerValue]);
            NSString * imageName = [NSString stringWithFormat:@"emotion_%@.png",numberString];
            if (imageName)
            {
                //获取图片
                UIImage * image = [self getImageWithRangeString:imageName];//这是个自定义的方法
                if (image != nil)
                {
                    CGSize tmpSize = CGSizeMake(20, 20);
                    CGRect frame;
                    frame.size = tmpSize;
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    imageView.frame = frame;
                    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
                    //开始替换
                    [mAttributedString replaceCharactersInRange:result.range withAttributedString:attachText];
                }
            }
        }
    }
    
    return mAttributedString;
}
//根据rangeString获取plist中的图片
-(UIImage *)getImageWithRangeString:(NSString *)rangeString
{
    return [UIImage imageNamed:rangeString];
}


@end
