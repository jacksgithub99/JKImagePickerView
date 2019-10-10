//
//  JKImagePickerView.h
//
//  Created by Jack/Zark on 2019/5/10.
//  Copyright © Jack/Zark All rights reserved.
//

#import "MyClass"
#import "JKImagePickerView.h"


@interface MyClass () {
    JKImagePickerView *_imagePicker;
}

@property (weak, nonatomic) IBOutlet UIView *photo_view;    //xib self.view上一个子视图UIView，宽度为屏幕宽度，高度动态计算赋值给photo_view_height
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo_view_height;         //photo_view的高度约束

@end

@implementation MyClass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    //上传图片
    //配置JKImagePickerView的参数，
    JKImagePickerViewLayoutConfig *config = [[JKImagePickerViewLayoutConfig alloc] init];
    config.maxItemCount = 3;
    config.width = ScreenWidth - 40;
    //初始化JKImagePickerView
    _imagePicker = [[JKImagePickerView alloc] initWithConfig:config startPoint:CGPointMake(10, 50)];    //startPoint，_imagePicker在photo_view上的起点坐标
    _imagePicker.image_name_prefix = @"MyClass";
    _imagePicker.canAddImage = YES; //是否允许从相册、相机获取图片（如果未NO则不可获取图片，只能用于本地、网络图片数组的展示）
    _imagePicker.albumAllowed = YES;    //是否允许从相册获取图片
    [self.photo_view addSubview:_imagePicker];
    
    __weak typeof(self) weakSelf = self;
    _imagePicker.getImageUrlsResult = ^(ImageUploadHandleStatus status, NSString * imageUrls) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (status == ImageUploadHandleStatusAllUploadedSuccess || status == ImageUploadHandleStatusPartFailedDonotReupload) {//图片全部上传成功，或者部分失败但用户(通过UIAlertController)决定不重新上传，放弃上传失败的图片
            [strongSelf didGetImageUrls:imageUrls]; //获取图片urls后（图片被选取后，已经直接上传到了云端，如阿里云），使用该urls（逗号分隔）
        }else if (status == ImageUploadHandleStatusPartFailedReupload){//部分图片上传失败，用户要求重新上传。
            //Does nothing here.
        }
    };
    _imagePicker.zoomOutEvent = ^(NSInteger item) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf imageTapAt:item];
    };
    
    CGFloat photo_view_height = [config viewHeightForItemCount:1];
    self.photo_view_height.constant = 60 + photo_view_height;       //起点y = 50,底部留10pt，总计额外增加高度60pt
    //
}

#pragma mark - touch event
//提交数据按钮，先获取图片urls，再在_imagePicker.getImageUrlsResult回调提交全部数据（包括图片urls）
- (IBAction)confirm_btn_click:(id)sender {
    [_imagePicker tryGetImageUrls]; //异步获取图片urls，先判断是否全部图片已经上传成功，如果部分图片上传失败，会弹窗等待用户决定是否重新上传。
}

#pragma mark - request
- (void)didGetImageUrls: (NSString *)imageUrls {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    data[@"key1"] = @"someValue";
    data[@"imageUrls"] = imageUrls;
    [HTTPManager post:@"SomeAPI" datas:data complete:^(BOOL success, NSError *error, NSDictionary *results) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {
        } else {
        }
    }];
}

@end
