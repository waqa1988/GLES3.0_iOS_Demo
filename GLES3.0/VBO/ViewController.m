//
//  ViewController.m
//  VBO
//
//  Created by davi on 2017/11/7.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "ViewController.h"
#import "VBOView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    DvGLESView *glView = [[VBOView alloc] initWithFrame:screenBounds];
    [self.view addSubview:glView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
