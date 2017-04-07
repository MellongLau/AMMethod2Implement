![AMMethod2Implement Banner](https://raw.github.com/MellongLau/AMMethod2Implement/master/Screenshots/banner.png)

AMMethod2Implement
==================

<p align="left">

<a href="https://travis-ci.org/MellongLau/AMMethod2Implement"><img src="https://travis-ci.org/MellongLau/AMMethod2Implement.svg" alt="Build Status" /></a>
<img src="https://img.shields.io/badge/platform-Xcode%206%2B-blue.svg?style=flat" alt="Platform: Xcode 6+"/>
<img src="http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat" alt="License: MIT" />
    
</p>

A simple Xcode plugin to generate implement code for the selected method, selector and const string, currently, only support objective-c.  

*可以自动的将.h或者.m .mm里边需要写入的方法自动填充进来。可以选择要导入的方法，然后按 Ctrl+A  或者 Edit > AMMethod2Implement > Implement Method.就会自动填充方法.也可以自行设置快捷键。*

**如果觉得这款插件不错的话请点击右上角的star和推荐给你的朋友，如果想即时了解到我的最新消息，请拉到底部扫描二维码关注我的公众号**

##Features(v3.4):

1. Support `extern NSString * const` implement.
2. Support multiline method and const string implement.
3. Support categories.
4. Support declare method.
5. Support `@select(method:)` implement.
6. Support selector with none parameter.
7. Support changing the keyboard shortcut.
8. Support parameterless method invocation(New).
9. Support get method for property if get method not exist(New).

*目前版本支持h文件声明方法自动生成实现，m或者mm文件已写好的方法生成方法声明到h文件， `extern NSString * const`， `@select(method:)` 和 `[self methodName]` 实现代码生成*

## Usage

Use key `Ctrl+A` or go to menu `Edit` > `AMMethod2Implement` > `Implement Method`.

1. Multiline method and const string implement.
![usageScreenshot.gif](https://raw.github.com/MellongLau/AMMethod2Implement/master/Screenshots/usageScreenshot.gif)

2. Declare method.
![declare_method.gif](https://raw.github.com/MellongLau/AMMethod2Implement/master/Screenshots/declare_method.gif)

3. Implement selector.
![implement_selector.gif](https://raw.github.com/MellongLau/AMMethod2Implement/master/Screenshots/implement_selector.gif)

## Install

You can:

Install from github.

* Get the source code from github

    `$ git clone git@github.com:MellongLau/AMMethod2Implement.git`
    
* Build the AMMethod2Implement target in the Xcode project and the plug-in will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`.
* Relaunch Xcode.

or

Install via [Alcatraz](http://alcatraz.io/)

![AMMethodImplementInAlcatraz.png](https://raw.github.com/MellongLau/AMMethod2Implement/master/Screenshots/AMMethodImplementInAlcatraz.png)

In any case, relaunch Xcode to load it.


## Support

Developed and tested against Xcode 6+.

After upgrade your Xcode, you may need to run below shell script to add your current Xcode DVTPlugInCompatibilityUUID to all the Xcode plugins:

> curl https://raw.githubusercontent.com/cielpy/RPAXU/master/refreshPluginsAfterXcodeUpgrading.sh | sh


## Thanks
- (@HelloZJW)[https://github.com/HelloZJW] [Added get method for property if get method not exist]

## Todo

1. Support selector with multi parameters.
2. Support method invocation with multi parameters. 


## More
Learn more? Follow my `WeChat` public account `mellong`:

![WeChat QRcode](http://www.devlong.com/blogImages/qrcode_for_mellong.jpg)

## License

MIT License

    Copyright (c) 2014 Mellong Lau

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
