// 数字0、1、2分别表示连接成功、连接断开和未知
// 用关键字实现枚举
package main
import (
     "fmt"
)
const (
     a = iota
     b
     c
     d,e,f = iota,iota,iota
     g = iota
     h = "h"
     i
     j = iota
)
const z = iota
func main(){
     fmt.Println(a,b,c,d,e,f,g,h,i,j,z)
}
