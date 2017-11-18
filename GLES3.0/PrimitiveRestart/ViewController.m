//
//  ViewController.m
//  PrimitiveRestart
//
//  Created by davi on 2017/11/18.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "ViewController.h"
#import "PrimitiveRestartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    DvGLESView *glView = [[PrimitiveRestartView alloc] initWithFrame:screenBounds];
    [self.view addSubview:glView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
