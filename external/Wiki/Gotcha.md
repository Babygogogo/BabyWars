# 游戏引擎的选择
我选用cocos2d系列，原因主要有以下几点：
- 免费（unity的好大家都知道，但是发布到iOS和android好像各要2000美刀来着？）
- 跨平台
- 用户多
- 开源

用了这么段时间，发现的缺点嘛：
- 引擎更新经常大幅度不向下兼容（导致难以更新引擎、引擎资料断档，谁试谁知道）
- 文档烂（尤其是-lua，遇到问题基本上就要参照着看c++的文档和源码）
- 书籍也烂（要么就是api罗列，要么就是版本太旧；-lua的书就更别提了）
- 官方不务正业（2d功能还没完善就去搞3d，居然还要做VR；引擎配套的ide，好像都有三款以上了，哪一款真的能用？居然还在搞新的）

我使用过cocos2d-x引擎旗下的以下几个版本：
- cocos2d-x

  优点：
  - 运行效率高
  - 静态类型（我个人比较喜欢）
  - IDE完善（VS + Visual Assist，c++的无敌组合了应该）

  缺点：
  - 不好做热更新（导致我改用lua的根本原因）
  - 开发略慢
  
- cocos2d-lua（cocos2d-community)

  优点：
  - 比较容易热更新
  - 开发效率高
  
  缺点：
  - 官方态度暧昧，貌似处于半放弃状态（其实我用过一阵子cocos2d-community，但维护者太少了，前途未卜，遂放弃）
  - 动态类型
  - 开发环境比较糟糕（官方的直接无视，我试用多款第三方的ide后，现在使用VS Code作为编辑器，调试靠打印log）

- cocos2d-js

  优点：
  - 比较容易热更新
  - 开发效率高
  - 官方主推  
  关于官方主推，我再多说两句。官方最近推出了一款名叫cocos creator的开发环境，大力宣扬其各种优点。
  我也被迷得晕头转向，特意看了一阵子JS的书（我之前没接触过JS），试用了一个星期的creator，甚至有打算改用它来开发BabyWars。  
  直到我发现，在creator里，只要加入一个含有200张左右的图片的plist文件到资源管理器，整个环境立马卡的半死（后续每一个操作的响应时间拖长到以分钟计算）乃至崩溃，我就知道是我想太多了（官方还想拿这货跟unity比？呵呵呵）。  
  是的，我确实没给官方付过一分钱，但是官方能不能不要把资源放在这种华而不实的玩意上面，多完善一下引擎已有功能不好吗？你们怎么知道没有人愿意为你们买单呢？
  
  缺点：
  - require等各种配置能让人蛋疼死
  - 动态类型
  - 开发环境比较糟糕
  - 我没发现-js比起-lua有什么优点

综上所述，我最终选择了cocos2d-lua。  

# cocos2d-lua
## ccui.ListView
### 无法显示已添加的子节点？
#### 解决方案  
调用ccui.ListView:setContentSize(width, height)来设置ListView的可见大小。

### 无法显示背景？
#### 解决方案
1. 设置合适的可见大小（调用ccui.ListView:setContentSize()）
2. 用合法参数调用ccui.ListView:setBackGroundImage()。这个函数有两个参数，按顺序分别是：
  1. 图片资源的名称或完整路径
  2. 图片资源类型，有以下取值：
    - ccui.TextureResType.localType（默认，图片是单个图像文件时使用，可忽略）
    - ccui.TextureResType.plistType（如图片是plist中的一个时使用，不可忽略）

#### 踩坑心得  
- 这函数特么居然有两个参数？参数不对不写log，引擎test直接忽略了第二参数，网上还查不到资料，人干事？？
我卡了半天，最后是突然想起c++下同名函数需要传入资源类型的参数，试验后才找到答案的。给跪。
- ccui下有许多类的方法都有类似设定，如遭遇类似问题可以参照本方案解决。

## ccui.Button
### 如何让title文字duang起来（加轮廓）？
#### 解决方案
1. 调用ccui.Button:setTitleFontName()，以ttf文件的路径为参数
2. 调用ccui.Button:getTitleRenderer():enableOutline()。
enableOutline()有两个参数，分别是outline的颜色和尺寸，具体可查阅cc.Label:enableOutline()的文档。

#### 踩坑心得
我找到解决方案的过程如下：
 
1. 查找ccui.Button的资料（包括test，api文档，网上文章），发现没有直接给title文字加轮廓的函数
- 按常理，既然已有了cc.Label，那么Button没理由重写一次渲染文字的代码，很可能是直接用了Label来实现title文字
- 果然发现了ccui.Button:getTitleRenderer()，返回的是cc.Label，Button正是用这个renderer来渲染title的
- 查找给Label文字加轮廓的办法，是cc.Label:enableOutline()
- 尝试直接调用ccui.Button:getTitleRenderer():enableOutline()，发现无效
- 查找给文字加轮廓的相关信息，发现加轮廓的前提是这个Label必须是用ttf（或systemfont，由于使用范围有限，可无视）创建
- 既然上面的调用无法成功加上轮廓，就说明失败的原因可能是这个title renderer并非用ttf渲染，因此我们需要搞清楚这个renderer的值的来龙去脉
- 查引擎源代码UIButton.cpp，发现renderer最初会被赋值为Label:create()的返回值，此时它的渲染方式还未确定
- 继续读代码，发现决定renderer是以什么方式渲染的，是ccui.Button:setTitleFontName()！这个函数会对传入的字符串参数做判断，如果是一个文件的路径，就会试图以TTF或BMFont的方式来渲染title，否则会用systemfont。
而我先前传入的参数，决定了renderer会用systemfont。按道理应该也能成功加上轮廓的，但不知道为什么失败了
- 都查到这地步了，死马当活马医，改了参数调用ccui.Button:setTitleFontName()使得renderer以TTF的方式渲染
- 再调用ccui.Button:getTitleRenderer():enableOutline()，终于成功加上轮廓

解决问题自然高兴，但这种问题其实是不应该出现的。ccui.Button试图封装掉title文字的渲染方式，但并不很成功。
一旦像我这样遇到程序行为不符预期的情况，就很可能得花几倍的力气去查找原因。其实，如果setTitleFontName()能换个名字，暗示一下它可以接受文件路径作为参数，我就肯定不会在这里卡这么久。  

最后，加其他文字特效的方法和上面的解决方案类似，就不多说了。
