//
//  ViewController.m
//  JavaScriptCoreDemo
//
//  Created by mac on 2019/4/29.
//  Copyright © 2019 ikangtai. All rights reserved.
//

#import "ViewController.h"
#import "JSBridge.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultLbl;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)callJSFunction:(UIButton *)sender {
    JSBridge *bridge = [[JSBridge alloc] init];
    NSString *result = [bridge callJSHello:self.nameTF.text];
    self.resultLbl.text = result;
}

@end
