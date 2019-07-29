package main

import (
	"fmt"
)

func GetClass() (stuNum int, className string, headTeacher string) {
	return 49, "一班", "张三"
}
func main() {
	stuNum, _, _ := GetClass() //只想获取班级人数stuNum,其他不需要
	fmt.Println(stuNum)
}
