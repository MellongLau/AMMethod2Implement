AMMethod2Implement
==================

A simple Xcode plugin to generate implement code for the selected method and const string.

##Features(v2.3):
1. Support `extern NSString * const` implement.
2. Support multiline method and const string implement.
3. Support categories.
4. Support declare method(New).
5. Support `@select(method:)` implement(New).


## Usage

Use key `Ctrl+A` or go to menu `Edit` > `Implement Method`.

1. Multiline method and const string implement.
![usageScreenshot.gif](https://raw.github.com/MellongLau/AMMethod2Implement/master/Screenshots/usageScreenshot.gif)

2. Implement method.
![implement_method.gif](https://raw.github.com/MellongLau/AMMethod2Implement/master/Screenshots/implement_method.gif)

3. Implement const string.
![implement_const_string.gif](https://raw.github.com/MellongLau/AMMethod2Implement/master/Screenshots/implement_const_string.gif)

4. Declare method.
![declare_method.gif](https://raw.github.com/MellongLau/AMMethod2Implement/master/Screenshots/declare_method.gif)

5. Implement selector.
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
