//
//  ViewController.m
//  VAO
//
//  Created by davi on 2017/11/12.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "ViewController.h"
#import "VAOView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    VAOView * view = [[VAOView alloc] initWithFrame:screenBound];
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
