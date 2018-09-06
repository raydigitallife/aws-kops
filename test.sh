#!/bin/bash


case ${1} in
  "hello")
	echo "Hello, how are you ?"
	;;
  "")
	echo "You MUST input parameters, ex> {${0} someword}"
	;;
  *)   # 其實就相當於萬用字元，0~無窮多個任意字元之意！
	echo "Usage ${0} {hello}"
	;;
esac