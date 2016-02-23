
## Actor简介
本作中的大部分游戏元素在代码中以Actor的形式出现。Actor实际上就是一个简单的容器，能够容纳最多一个Model实例和最多一个View实例。  
比如，一个作战单位（Unit）的Actor的结构如下：
- Actor
 - ModelUnit （如果Actor不含此项，则该Unit不含逻辑和数据）
 - ViewUnit  （如果Actor不含此项，则该Unit不可视）  

Actor所包含的Model和View实例决定了这个Actor的行为。  
本作中，Actor是由Scene或上层Actor的Model来创建和持有的。

### Model简介
本作中Model的定义类似于传统MVC中的Model。具体而言，Model包含了相应的游戏元素的数据和逻辑，而且需要对来自View的玩家输入进行正确处理。  
Model自身带有逻辑和数据（比如ModelUnit应该持有所有作战单位共有的逻辑和数据），而且可以通过绑定不同的component来获得某些可复用的功能。
比如，我们知道infantry可以攻击和占领，但不能装载单位，而lander正好相反。那么它们的model就可以分别按以下形式来实现：
infantry的model：
- ModelUnit
  - ComponentCapturer
  - ComponentAttacker
 
lander的model：
- ModelUnit
  - ComponentLoader

### View简介
本作中View的定义类似于传统MVC中的View和Controller的合集。具体而言，本作中的View不仅负责显示，也负责接受玩家输入，并传递给相应的Model进行处理。  
View以cocos2d-x中的各个显示节点的子类的形式进行实现。
以ViewUnit为例，它具有以下特性：
- 是cc.Sprite的子类
- 正确地显示单位在各个状态下的动画，不需要ModelUnit的介入（比如，单位在空闲状态下有循环动画，那么ViewUnit应当自己切换动画帧而不需要Model介入，因为动画本身对Model没有任何影响）
- 接受Model推送过来的状态改变的信息并做出正确处理（比如，ModelUnit从空闲状态进入移动状态时，ViewUnit也要切换为相应的动画）
- 接收触摸事件消息，并推送给Model做处理

## 游戏元素组织架构
本作中的各种游戏元素是以树状的形式进行组织的，游戏场景是树根，场景内的各种元素（以Actor的形式存在）则是树节点。
以战场场景为例，架构如下（具体以代码为准）：
- 战场场景
  - 场景HUD
    - 信息栏
      - 金钱与能量槽信息栏
      - 焦点地形信息栏
      - 焦点单位信息栏
    - 操作菜单
      - 菜单项1
      - 菜单项2
      - ……
    - 菜单子页面1
    - 菜单子页面2
    - ……
  - 战场
    - 单位图
      - 单位1
      - 单位2
      - ……
    - 地形图
      - 地形1
      - 地形2
      - ……
      
## 玩家输入处理机制
本作目前只考虑触摸输入，不考虑键盘等其他输入方式。  

### 集中式处理
所谓集中式处理，是只在scene中注册触摸侦听器。scene收到触摸消息后，通过查询属下所有Actor的状态，判断出这次触摸的意义是什么，然后做出相应处理。  
这种处理方式的缺点很明显：随着scene属下的Actor的数量的增多和层次结构复杂化，scene相应的查询和判断逻辑会迅速变得过于复杂；而且，scene与属下Actor的耦合性也大幅增加。

### 分散式处理
所谓分散式处理，是指为每一个显示节点分别注册触摸侦听器，并各自处理触摸消息。  
在cocos2d-x中，触摸侦听器不会自动判断触摸点是否在节点的显示范围之内，所以分散式处理会导致一些问题。举例来说，如果我们为地图里的每一个地形都注册侦听器，那么玩家点击任意一块地形，所有地形的的侦听器都会一起被触发；
我们必须手动判断触摸点的位置以阻挡无关的触发，这样一来，代码量没有减少，计算量还增加了。  

### 混合式处理
本作采用混合式处理。所谓混合式处理，简单来说就是只在scene中注册触摸侦听器，scene把收到的触摸消息以深度优先的形式分发给属下的所有view和子view，各个view把消息推送给各自的model进行处理。  

#### 常规处理流程的例子
假设有这样的一个场景结构：
- scene
  - view1
    - child1
    - child1
  - view2

再假设推送消息的做法是调用view:handleTouch()，那么这个场景结构处理触摸消息的常规流程如下：
- scene事先注册的触摸侦听器收到一条触摸消息
  - scene调用view1:handleTouch()
    - view1调用child1:handleTouch()
      - child1处理消息
    - view1调用child2:handleTouch()
      - child2处理消息
    - view1处理消息
  - scene调用view2:handleTouch()
    - view2处理消息
  - scene处理消息
  
在流程中，根据实际需要，同一嵌套层次的步骤可以调换顺序，某些步骤可以省略。但为了减低代码理解上复杂度，应避免在运行时动态调整流程。

#### 处理流程的特例
常规处理流程并不能应付所有情况。某些时候，某个view可能需要“吞没”一个触摸消息，以阻止后面的其他view对其响应。  
为此，可以把handleTouch()改名为handleAndSwallowTouch()，添加bool返回值，true表示吞没，false表示不吞没。这样，调用者就可以根据返回值来改变流程。

