//
//  ViewController.m
//  2048D
//
//  Created by DAA on 2018/5/15.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "ViewController.h"
#import "TDDCanvasView.h"


@interface ViewController ()<TDDCanvasViewDelegate>
@property (nonatomic, strong)UILabel *unitActionsLab;
@property (nonatomic, strong)UILabel *integralLab;

@property (nonatomic, assign)int intergral;
@property (nonatomic, assign)int unitActions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.intergral = 0;
    self.unitActions = 0;
    
    self.unitActionsLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 150, 40)];
    self.unitActionsLab.text = [NSString stringWithFormat: @"行动次数：%d",self.unitActions];
    [self.view addSubview:self.unitActionsLab];
    
    self.integralLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2.0 + 30, 70, 150, 40)];
    self.integralLab.text = [NSString stringWithFormat:@"积分：%d",self.intergral];
    [self.view addSubview:self.integralLab];
    
    TDDCanvasView *canvasView = [[TDDCanvasView alloc]init];
    canvasView.frame = CGRectMake(0, 150, TDD_ScreenWidth, TDD_ScreenWidth);
    [canvasView startLayout];
    canvasView.delegate = self;
    [self.view addSubview:canvasView];
}

- (void)actionComplete{
    self.unitActionsLab.text = [NSString stringWithFormat:@"行动次数：%d", ++self.unitActions];
    
}
- (void)generateDigital:(int)num{
    self.integralLab.text = [NSString stringWithFormat:@"积分：%d",self.intergral += num];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

