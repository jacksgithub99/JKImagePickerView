# JKImagePickerView
图片选取器（相册、相机都可以），也可以用作展示本地图片、网络图片的容器（9宫格形式）。可从相册选取多张图片；可指定每行图片数量，最大选取图片数量；能够标识出之前已选中的图片，防止重复勾选；可自定义图片宽、高，间距等等。

上传图片用法示例见：
如果仅仅展示图片，请直接调用
[imagePickerView reloadDataWith: imageModelArray];
注意，reloadDataWith:接收的数组，其元素必须是JKImagePickerModel对象。

