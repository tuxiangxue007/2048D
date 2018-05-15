//
//  TDDCanvasView.m
//  2048D
//
//  Created by DAA on 2018/5/15.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "TDDCanvasView.h"


@interface TDDCanvasView ()


@end
@implementation TDDCanvasView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)startLayout{
    if (!self.mDataDict) {
        
        self.mDataDict = [NSMutableDictionary dictionary];
        self.mDataArr = [NSMutableArray array];
        
        self.backgroundColor = [self colorWithHexString:@"b1b2a1"];
        for (int i = 1; i <= TD_MaxLineNum; i ++) {
            for (int j = 1; j <= TD_MaxLineNum; j ++) {
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(TD_BLOCK_Interval + (TD_BLOCK_Interval + TD_BLOCK_WITH) * (j - 1), TD_BLOCK_Interval + (TD_BLOCK_Interval + TD_BLOCK_WITH) * (i - 1), TD_BLOCK_WITH, TD_BLOCK_WITH)];
                lab.backgroundColor = [UIColor whiteColor];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.tag = i * 100 + j;
                [self addSubview:lab];
                
                [self.mDataArr addObject:[NSString stringWithFormat:@"%d",i * 100 + j]];
            }
        }
        [self startGame];
    }
    
    NSArray * array = @[@(UISwipeGestureRecognizerDirectionLeft),@(UISwipeGestureRecognizerDirectionRight),@(UISwipeGestureRecognizerDirectionUp),@(UISwipeGestureRecognizerDirectionDown)];
    
    // 定义一个手势
    UISwipeGestureRecognizer * swipe;
    for (NSNumber * number in array) {
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        swipe.direction = [number integerValue];
        [self addGestureRecognizer:swipe];
    }
}
- (void)startGame{
    for (int num = 0; num < 4; num ++) {
        [self randomDigit];
    }
}

- (void)randomDigit{
    for (int num = 0; num < self.mDataArr.count; num ++) {
        NSString *key = [self.mDataArr objectAtIndex:num];
        UILabel *lab = [self viewWithTag:[key integerValue]];
        if (lab.text.length < 1) {
            break;
        }
        if (num == self.mDataArr.count - 1) {
            
            NSLog(@"game over!!!");
            [self gameOver];
            return;
        }
    }
    
    
    int num = arc4random()%self.mDataArr.count;
    NSString *key = [self.mDataArr objectAtIndex:num];
    UILabel *lab = [self viewWithTag:[key integerValue]];
    if (lab.text.length >= 1) {
        [self randomDigit];
        NSLog(@"该方块已存在数字 重新随机^^^^");
        
        return;
    }
    
    
    int iDigit = arc4random()%3;
    iDigit = (int)pow(2, iDigit);
    [self.delegate generateDigital:iDigit];
    
    [self.mDataDict setObject:[NSString stringWithFormat:@"%d",iDigit] forKey:key];
    
    lab.text = [NSString stringWithFormat:@"%d",iDigit];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe{
    [self swipeManageType:swipe.direction];
}

- (void)swipeManageType:(UISwipeGestureRecognizerDirection )direction{
    int i = 0,j = 0,z = 0;
    
    if (direction == UISwipeGestureRecognizerDirectionUp) {
        i = 2;
        j = 1;
        z = i;
    }else if (direction == UISwipeGestureRecognizerDirectionDown) {
        i = TD_MaxLineNum - 1;
        j = 1;
        z = i;
    }else if (direction == UISwipeGestureRecognizerDirectionLeft) {
        i = 1;
        j = 2;
        z = j;
    }else if (direction == UISwipeGestureRecognizerDirectionRight) {
        i = 1;
        j = TD_MaxLineNum - 1;
        z = j;
    }
    
    for (int num_i = i; i == TD_MaxLineNum - 1? num_i > 0 : num_i <= TD_MaxLineNum; i == TD_MaxLineNum - 1?num_i --:num_i ++) {
        for (int num_j = j; j == TD_MaxLineNum - 1? num_j > 0 : num_j <= TD_MaxLineNum; j == TD_MaxLineNum - 1?num_j --:num_j ++) {
            int key = i == 1?(j==2?num_i * 100 + num_j - 1:num_i * 100 + num_j + 1):(i==2?(num_i - 1) * 100 + num_j:(num_i + 1) * 100 + num_j);
            UILabel *lab = [self viewWithTag:key];
            
            for (int num_z = (i == 1?num_j:num_i) ; z == TD_MaxLineNum - 1? num_z > 0 : num_z <= TD_MaxLineNum; z == TD_MaxLineNum - 1?num_z --:num_z ++) {
                
                int dicKey = z==i?num_z * 100 + num_j:num_i * 100 + num_z;
                NSString *dicKeyStr = [NSString stringWithFormat:@"%d",dicKey];
                if ([self.mDataDict objectForKey:dicKeyStr]) {
                    NSLog(@"%d",dicKey);
                    NSString *value = [self.mDataDict objectForKey:dicKeyStr];
                    if (lab.text.length >= 1) {
                        if ([lab.text isEqualToString:value]) {
                            value = [NSString stringWithFormat:@"%d",[value intValue] * 2] ;
                            [self.mDataDict setObject:value forKey:[NSString stringWithFormat:@"%d",key]];
                            [self.mDataDict removeObjectForKey:dicKeyStr];
                            
                            lab.text = value;
                            UILabel *subLab = [self viewWithTag:dicKey];
                            subLab.text = @"";
                        }else{
                            if (z==i?(z== 2?num_z - num_i > 1:num_i - num_z >1):(z== 2?num_z - num_j > 1:num_j - num_z >1)) {
                                
                                key = num_i * 100 + num_j;
                                lab = [self viewWithTag:key];
                                lab.text = value;
                                [self.mDataDict setObject:value forKey:[NSString stringWithFormat:@"%d",key]];
                                [self.mDataDict removeObjectForKey:dicKeyStr];
                                
                                UILabel *subLab = [self viewWithTag:dicKey];
                                subLab.text = @"";
                            }
                        }
                        break;
                    }else{
                        lab.text = value;
                        [self.mDataDict setObject:value forKey:[NSString stringWithFormat:@"%d",key]];
                        [self.mDataDict removeObjectForKey:dicKeyStr];
                        
                        UILabel *subLab = [self viewWithTag:dicKey];
                        subLab.text = @"";
                    }
                }
            }
        }
    }
    [self randomDigit];
    [self.delegate actionComplete];
}

- (void)gameOver{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"游戏结束，重新开始" preferredStyle:UIAlertControllerStyleAlert];//UIAlertControllerStyleAlert视图在中央
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        exit(0);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self.mDataDict removeAllObjects];
        for (int num = 0; num < self.mDataArr.count; num ++) {
            NSString *key = [self.mDataArr objectAtIndex:num];
            UILabel *lab = [self viewWithTag:[key integerValue]];
            lab.text = @"";
        }
        [self startGame];
        [self.delegate gameOver];
    }];//https在iTunes中找，这里的事件是前往手机端App store下载微信
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [[self viewController] presentViewController:alertController animated:YES completion:nil];
}

- (UIViewController *)viewController {
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }while(next != nil);
    return nil;
}

- (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];;
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end

