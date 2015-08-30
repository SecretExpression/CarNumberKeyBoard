//
//  ViewController.m
//  KeyBoardDome2
//
//  Created by zzy on 15/8/30.
//  Copyright (c) 2015年 zzy. All rights reserved.
//

#import "ViewController.h"

#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define kKeyBoardBackGroundColor [UIColor colorWithRed:221/255.0 green:225/255.0 blue:226/255.0 alpha:1]
#define kDarkKeyColor [UIColor colorWithRed:179/255.0 green:183/255.0 blue:188/255.0 alpha:1]
#define kKeyBoardHeight (KScreenHeight <= 480 ? KScreenHeight * 0.4 : KScreenHeight * 0.35)
#define kKeyHorizontalSpace 5
#define kKeyVerticalSpace 7.5
#define kKeyWidth (KScreenWidth / 10.0 - kKeyHorizontalSpace * 2)
#define kKeyHeight (kKeyBoardHeight / 4.0 - kKeyVerticalSpace * 2)

@interface ViewController ()
{
    //省份键盘
    UIView *_provinceKeyBoard;
    //英数字键盘
    UIView *_englishNumberKeyBoard;
    
    BOOL _isProvinceKeyBoard;
    
    NSArray *_provinceArr;
    
    NSArray *_englishNumberArr;
    
    NSMutableString *_textStr;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _textStr = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateKeyBoard];
    
    NSLog(@"%f",kKeyBoardHeight);
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -CreatekeyBoard
- (void)CreateKeyBoard {
    
    _provinceArr = @[@"京", @"津", @"渝", @"沪", @"冀", @"晋", @"辽", @"吉", @"黑", @"苏", @"浙", @"皖", @"闽", @"赣", @"鲁", @"豫", @"鄂", @"湘", @"粤", @"琼", @"川", @"贵", @"云", @"陕", @"甘", @"青", @"蒙", @"桂", @"宁", @"新", @"藏", @"台", @"港", @"澳"];
    
    _englishNumberArr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"Z", @"X", @"C", @"V", @"B", @"N", @"M"];
    
    
    //省份键盘
    _provinceKeyBoard = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, kKeyBoardHeight)];
    _provinceKeyBoard.backgroundColor = kKeyBoardBackGroundColor;
    
    [self.view addSubview:_provinceKeyBoard];
    //切换键盘按钮
    UIButton *changeToENBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeToENBtn.frame = CGRectMake(kKeyHorizontalSpace, kKeyBoardHeight - kKeyHeight - kKeyVerticalSpace, kKeyWidth * 1.5, kKeyHeight);
    [changeToENBtn setBackgroundColor:kDarkKeyColor];
    [changeToENBtn setTitle:@"ABC" forState:UIControlStateNormal];
    changeToENBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    changeToENBtn = [self setShadowWithButton:changeToENBtn];
    [changeToENBtn addTarget:self action:@selector(changeKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [_provinceKeyBoard addSubview:changeToENBtn];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(KScreenWidth - kKeyWidth * 1.5 - kKeyHorizontalSpace, kKeyBoardHeight - kKeyHeight - kKeyVerticalSpace, kKeyWidth * 1.5, kKeyHeight);
    [deleteBtn setImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7"] forState:UIControlStateNormal];
    [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [deleteBtn setBackgroundColor:kDarkKeyColor];
    deleteBtn = [self setShadowWithButton:deleteBtn];
    [deleteBtn addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [_provinceKeyBoard addSubview:deleteBtn];
    
    for (int i = 0; i < _provinceArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_provinceArr[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn = [self setShadowWithButton:btn];
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(clickCharacter:) forControlEvents:UIControlEventTouchUpInside];
        
        int k = i;
        int j = i / 10;
        if (i >= 10 && i < 28) {
            k = i % 10;
        }
        else if (i >= 28) {
            k = i - 28;
            j = 3;
        }
        
        if (i < 20) {
            btn.frame = CGRectMake(kKeyHorizontalSpace + k * (KScreenWidth / 10) , kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        else if (i < 28) {
            
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 1) * (KScreenWidth / 10), kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        else {
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 2) * (KScreenWidth / 10), kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        
        [_provinceKeyBoard addSubview:btn];
    }
    
    
    //英数字键盘
    _englishNumberKeyBoard = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, kKeyBoardHeight)];
    _englishNumberKeyBoard.backgroundColor = kKeyBoardBackGroundColor;
    [self.view addSubview:_englishNumberKeyBoard];
    
    //切换键盘按钮
    UIButton *changeToProvinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeToProvinceBtn.frame = CGRectMake(kKeyHorizontalSpace, kKeyBoardHeight - kKeyHeight - kKeyVerticalSpace, kKeyWidth * 1.5, kKeyHeight);
    [changeToProvinceBtn setBackgroundColor:kDarkKeyColor];
    [changeToProvinceBtn setTitle:@"省份" forState:UIControlStateNormal];
    changeToProvinceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    changeToProvinceBtn = [self setShadowWithButton:changeToProvinceBtn];
    [changeToProvinceBtn addTarget:self action:@selector(changeKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [_englishNumberKeyBoard addSubview:changeToProvinceBtn];
    
    //英数字删除按钮
    UIButton *deleteEnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteEnBtn.frame = CGRectMake(KScreenWidth - kKeyWidth * 1.5 - kKeyHorizontalSpace, kKeyBoardHeight - kKeyHeight - kKeyVerticalSpace, kKeyWidth * 1.5, kKeyHeight);
    [deleteEnBtn setImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7"] forState:UIControlStateNormal];
    [deleteEnBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [deleteEnBtn setBackgroundColor:kDarkKeyColor];
    deleteEnBtn = [self setShadowWithButton:deleteEnBtn];
    [deleteEnBtn addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [_englishNumberKeyBoard addSubview:deleteEnBtn];
    
    for (int i = 0; i < _englishNumberArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_englishNumberArr[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn = [self setShadowWithButton:btn];
        btn.tag = i + 1000;
        [btn addTarget:self action:@selector(clickCharacter:) forControlEvents:UIControlEventTouchUpInside];
        
        int k = i;
        int j = i / 10;
        if (i >= 10 && i < 29) {
            k = i % 10;
        }
        else if (i >= 29) {
            k = i - 29;
            j = 3;
        }
        
        if (i < 20) {
            btn.frame = CGRectMake(kKeyHorizontalSpace + k * (KScreenWidth / 10) , kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        else if (i < 29) {
            
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 0.5) * (KScreenWidth / 10), kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        else {
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 1.5) * (KScreenWidth / 10), kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        
        [_englishNumberKeyBoard addSubview:btn];
    }
    
    [self.view bringSubviewToFront:_provinceKeyBoard];
}

#pragma mark -Action
- (void)keyboardWillShow:(NSNotification *)noti {
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        _provinceKeyBoard.frame = CGRectMake(0, KScreenHeight - kKeyBoardHeight, KScreenWidth, kKeyBoardHeight);
        
        _englishNumberKeyBoard.frame = CGRectMake(0, KScreenHeight - kKeyBoardHeight, KScreenWidth, kKeyBoardHeight);
    }];
    
    
}

//切换键盘
- (void)changeKeyBoard {
    _isProvinceKeyBoard = !_isProvinceKeyBoard;
    _provinceKeyBoard.hidden = _isProvinceKeyBoard;
    _englishNumberKeyBoard.hidden = !_isProvinceKeyBoard;
}

- (void)clickDeleteButton {
    if (_textStr.length) {
        NSRange range = {_textStr.length - 1, 1};
        [_textStr deleteCharactersInRange:range];
        self.textField.text = _textStr;
    }
}

- (void)clickCharacter:(UIButton *)btn {
    if (btn.tag > 500) {
        [_textStr appendString:_englishNumberArr[btn.tag - 1000]];
    }
    else {
        [_textStr appendString:_provinceArr[btn.tag - 100]];
    }
    self.textField.text = _textStr;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
    UITouch *touch = [touches anyObject];
    if (self.view == touch.view) {
        [UIView animateWithDuration:0.25 animations:^{
            _provinceKeyBoard.frame = CGRectMake(0, KScreenHeight , KScreenWidth, 250);
            _englishNumberKeyBoard.frame = CGRectMake(0, KScreenHeight , KScreenWidth, 250);
        }];
    }
}

#pragma mark -Tools

- (UIButton *)setShadowWithButton:(UIButton *)btn {
    btn.layer.cornerRadius = 5;
    btn.layer.shadowOffset =  CGSizeMake(1, 1);
    btn.layer.shadowOpacity = 0.8;
    btn.layer.shadowColor =  [UIColor blackColor].CGColor;
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
