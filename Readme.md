# VHClassSDK

微吼课堂SDK-iOS<br>


集成和使用文档见[官方文档](http://www.vhall.com/class/doc/1605.html )<br>


## 注意事项：
* SDK不支持模拟器调试
* 需设置TARGETS - Build Setting - Enable Bitcode 将值改为NO
* 添加系统依赖库libicucore.tbd


## 快速集成

将VHClassSDK引入您的工程中，将工程中任意文件.m改为.mm；<br>

在微吼官方平台上[获取AppKey](https://class.vhall.com/#/userSDK)；<br>

在TARGETS - General - Embedded Binaries下添加VhallLiveBaseApi、VhallSignalDynamic、WebRTC；<br>

在TARGETS - Build Setting - Enable Bitcode 将值改为NO；<br>

添加系统依赖库libicucore.tbd；<br>

使用互动功能时，需要添加摄像头和麦克风的权限配置。<br>

## 版本更新信息
### v2.0.1 更新时间：2020.03.11
更新内容：微吼课堂 v2.0.1<br>
1、支持armv7<br>
2、demo iOS 13适配<br>

### v2.0.0 更新时间：2019.04.16
更新内容：微吼课堂 v2.0.0、微吼课堂SDKDemo

1、新增加日志等级设置；<br>
2、修复已知的播放器bug；<br>
3、提供回放和直播文档功能；<br>
4、优化互动，提升连麦体验；<br>

### v1.1 更新时间：2018.10.18
1、更新互动库，解决互动偶尔的crash问题；<br>
2、更新回放播放器；<br>
3、优化SDK，增加掉线自动重连功能；<br>
4、demo增加掉线处理。	 <br>

### v1.0 更新时间：2018.09.29
更新内容：微吼课堂SDK v1.0<br>
1、用户登录（进入课堂）<br>
2、观看直播<br>
3、互动连麦<br>
4、文档/白板<br>
5、讨论聊天<br>


