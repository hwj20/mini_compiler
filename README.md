# mini_compiler

using yacc and lex to generate a simple C-like compiler

使用方法

```
make clean
make
```
```
.\mini ${your_filename}
gcc ${exec_name} -o ${your_filename}.s
```

# TODO List

1. 语法有自己的设计和改变，与 mini 语言相比，差别越大越好
2. 传地址
3. 修改原来的寄存器分配算法，最差是随机选择，也可以增加其他设计思路
4. 将原先的汇编语言，改为 ARM 汇编语言，保持原先的静态作用域规则

# WorkLoad

## 编码部分：

### 已实现

1. 传地址（采用在 SYM 添加 SYM_ADDR 这个类型）
2. ARM 汇编
3. 寄存器分配（目前为简单的随机选择和活跃度选择）
4. 对语法的修改（没想好具体的项目呈现效果）


## 测试部分

### 已实现

编码功能功能测试

## 其它部分

### 已实现
1. 代码的规格化（比如目录，测试等等）

### 未实现
2. 代码的注释


###
> 三地址码中,t的[作用域]仅限于一行表达式，不必无限增加，可以改进这一点
> 在一个完整的expression解析结束的地方，把temp_next清零即可
> 实际上，比较temp_next<=temp_max即表明已经定义过了，查表也可以

