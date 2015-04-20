//
//  ViewController.m
//  TextFieldFocusScroll
//
//  Created by yokotasan on 2015/04/19.
//  Copyright (c) 2015年 yokotasan. All rights reserved.
//

#import "ViewController.h"

#define V_MARGIN 20
#define TEXTFIELD_HEIGTH 20

@interface ViewController () {
@private
    CGFloat y;
    UIScrollView *scrollView;
    UITextField *activeField;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //TODO: it seems not good, making frame with navi&statusBar height...
    //(1)
//    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
//                                                               0,
//                                                               self.view.bounds.size.width,
//                                                               self.view.bounds.size.height - 64)];
    //(2)
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                self.view.bounds.size.width,
                                                                self.view.bounds.size.height)];
    
    self.view.backgroundColor = [UIColor cyanColor];
    for (int i; i < 50; i++){
        y += V_MARGIN;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0 + 10,
                                                                            y,
                                                                            self.view.frame.size.width /2,
                                                                            TEXTFIELD_HEIGTH)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.delegate = self;
        [scrollView addSubview:textField];
        NSLog(@"%f", self.view.frame.size.width);
        y += TEXTFIELD_HEIGTH;
    }
    
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, y)];
    [self registerForKeyboardNotifications];
    [self.view addSubview:scrollView];
//    self.view = scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TextFieldDelegateMethods

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //(1)
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
    
    //(2)
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(
                                                  scrollView.contentInset.top, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

@end
