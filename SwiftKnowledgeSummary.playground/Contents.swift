//: Playground - noun: a place where people can play

import UIKit

/* 实例化一个 UIView 的对象，保存在堆中
[[UIView alloc] initWithXXX:xxx] 所有 OC中以这种格式的实例化方法，在 swift 中都可以使用 类(XXX:)*/
let view = UIView(frame: CGRectMake(0, 0, 100, 100))

view.backgroundColor = UIColor.orangeColor()
// 在这里修改的是 view 的属性，并没有修改 view 本身的地址

let btn = UIButton(frame: CGRectMake(20, 20, 60, 60))
btn.setTitle("hello", forState: UIControlState.Normal)
view.addSubview(btn)


/*
实际的应用技巧
*/

// ? 表示 可以有值(NSString)，也可以没有值(nil)
// ? 如果对象为空，就不会调用后面的方法，感觉上和 oc 中给 nil 发送消息类似
var str: NSString?
str = "hello"

// 打印可选项的时候，同时会输出一个 Optional，提示开发者，这是一个可选项
println(str?.length)
//println(str!.length)

let l = 10
// 目前的代码存在什么风险？如果 str 没有设置初始值，会直接崩溃
// 苹果把判断对象是否有内容的工作交给了程序员
//let len = l + str!.length

// 隆重推荐：?? 用来快速判断对象是否为 nil
let len2 = l + (str?.length ?? 0)

// 以下代码和上面的代码等效
if str != nil {
    let len3 = l + str!.length
}
// ?? 的应用场景最多的就在tableView 的数据源方法


/*
for 循环
*/

// 传统的写法，几乎一样
// 注意：需要使用 var 而不是 let
for var i = 0; i < 10; i++ {
    println(i)
}

// 更加方便的写法
// in 指定范围 0~9
// 早期的 swift 语法 .. 后来改成了 ..<
for i in 0..<10 {
    println(i)
}

// 0~10
for i in 0...10 {
    println(i)
}

// 如果遍历的时候，对索引下标不关注
// 其实 `_` 在 swift 中，使用的非常广泛，主要用于忽略
for _ in 0...5 {
    println("hello")
}


/*
字符串
*/

/**
在swift中，字符串默认的类型是 String，而不是 NSString

* swift中 String 是一个结构体，的效率更高
* 支持快速遍历
* NSString，继承自 NSObject，是一个 OC 对象
* 不支持快速遍历
*/
var str1 = "Hello, 大家一起飞"
// 对字符串的快速遍历
for c in str1 {
    println(c)
}

// 字符串的拼接
let str2 = str1 + " hello"
let i = 100
println(str1 + " \(i) abc \(view.backgroundColor)")

let frame = CGRectMake(100, 100, 200, 300)
println("区域 \(frame)")

// 但是：如果需要格式怎么办? NSString.stringWithFormat
let str3 = String(format: "%02d:%02d:%02d", arguments: [1, 5, 10])

/**
在 swift 中，如果要结合 range 一起使用 字符串，建议先转成 NSString 再处理
*/
let myString: NSString = "hello"
myString.substringWithRange(NSMakeRange(1, 4))
// 蛋疼的使用 String & Range -> 取子串
//let subStr = myString.substringWithRange(Range<String.Index>(start: advance(str.startIndex, 1), end: advance(str.startIndex, 3)))

/*
数组
*/

// 使用 []
// 定义的数组类型是 [String]
// 表示数组中，只能存放 字符串
// 在 oc 中的数组，分可变和不可变
// swift中 let 是不可变的， var 是可变的
let array1 = ["zhangsan", "lisi"]

// 遍历数组
for a in array1 {
    let str = "hello " + a
    println(str)
}

// 不能向不可变数组中追加元素
//array1.append("abc")

var array2 = ["aaa", "bbb"]
// 添加元素
array2.append("ccc")

// 如果定义数组时，指定的对象类型不一致
// 定义的数组类型是 [NSObject]
// 细节：11是一个整数，在 OC 中，如果要向数组中添加数字，需要转换成 NSNumber
// swift 中，可以直接添加 - 万物皆对象！
// 细节：通常在开始时，不建议在数组中使用不同类型的数据
var array3 = ["zzz", 11, "123"]
for a in array3 {
    let str = "hi \(a)"
    
    println(str)
}

/*
字典
*/

// 定义一个字典，仍然使用 []
// 以下代码定义的字典类型是：[String : NSObject]
// 在目前的 swift 版本中，定义字典通常使用 [String : NSObject]
// 大多数情况下，key的类型是固定的
let dict = ["name": "zhangsan", "title": "boss", "age": 18]

// 遍历字典(注意：k, v 可以随便写，但是，前面是 key, 后面是 value)
// 这里使用了swift中的元祖技巧
for (kk, vv) in dict {
    println("\(kk) -- \(vv)")
}

// 定义并且实例化字典
var dict1 = [String: NSObject]()

// 设置内容
dict1["name"] = "laowang"
dict1["age"] = 80

dict1

// 注意：如果 key 已经存在，设置数值时，会覆盖之前的值
dict1["name"] = "abc"
dict1

// 删除内容
dict1.removeValueForKey("age")
dict1

// 合并字典
var dict2 = ["title": "boss"]
dict2["name"] = "wangxiaoer"

// 字典的特性：key是不允许重复的
// 利用循环来进行合并
// 1> 遍历 dict2
for (k, v) in dict2 {
    // updateValue 更新指定 key 的 value
    // 如果不存在 key，会新建，并且设置数值
    // 如果存在 key，会直接覆盖
    dict1.updateValue(v, forKey: k)
}

dict1
dict2



/*
`函数`
*/

// OC 的 风格 - (void)函数名(参数) {}
/**
函数定义格式
func 函数名(参数列表) -> 返回值 {// 代码实现}

* -> 是 swift 特有的，表示 前面的执行结果，输出给后面的
*/
func sum(a: Int, b: Int) -> Int {
    return a + b
}

sum(10, 20)

// 强制填写参数，使用 #，可以在调用的时候，增加参数
// 会让代码提示更直观，符合 OC 程序员的习惯
func sum1(#a: Int, #b: Int) -> Int {
    return a + b
}

sum1(a: 20, b: 80)


// 如果没有返回值 `-> 返回值` 可以省略
/**
-> Void
-> ()
完全省略

以上三个是等价的
*/
func demo(a: Int) -> () {
    println(a)
}

demo(10)
