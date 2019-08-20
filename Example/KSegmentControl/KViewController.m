//
//  KViewController.m
//  KSegmentControl
//
//  Created by KimLucky on 08/20/2019.
//  Copyright (c) 2019 KimLucky. All rights reserved.
//

#import "KViewController.h"

#import <KSegmentControl/KSegmentControl.h>

@interface KViewController ()

@end

@implementation KViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray *titles = @[@"测试1", @"测试2", @"测试3", @"测试4"];
    
    KControlParameters *parameters = [KControlParameters new];
    parameters.separatorDisplay = YES;
    parameters.sliderDisplay = YES;
    parameters.sliderHeight = 3;
    parameters.selectedTitleAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:15], NSForegroundColorAttributeName: [UIColor redColor] };
    parameters.titleAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:15], NSForegroundColorAttributeName: [UIColor blackColor] };
    KSegmentControl *segmentControl = [KSegmentControl segmentControlWith:parameters titles:titles];
    segmentControl.frame = CGRectMake(0, 200, 200, 40);
    [self.view addSubview:segmentControl];
    segmentControl.didSelectedBlock = ^(NSInteger index) {
        NSLog(@"selected title = %@", titles[index]);
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
