#######################################################################################################
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                          企业级项目自动化打包脚本
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#
## 将MakeIPA.sh添加到项目的根目录下
## 此脚本针对企业级项目打包，不会编译项目，在打包前确认项目已经编译完成生成了”XXX.app“文件
## 使用前需要配置该脚本部分路径才能正确打包，需要修改的字段有”~~~~...~~~~“标识
#
## Xcode可修改.app文件的生成路径，具体方法请参考（感谢”花老🐯“的这篇文章）：
## https://www.cnblogs.com/huahuahu/p/Xcode-bian-yi-geng-gai-Build-shu-chu-lu-jing.html
## 默认使用Relative模式
#
## 使用方法（保证所有配置都完全正确，编译项目生成.app文件）：
## 打开”终端“，切换到MakeIPA.sh文件所在目录 执行”./MakeIPA.sh“
#

#
########################################################################################################


# 获取项目名称，自动获取，无需修改
ProjectName=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`

# 设置项目全路径~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~需要根据项目修改
ProjectPath="/Users/XXX/$ProjectName"

# 设置.app文件根路径~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Xcode设置路径后不用修改，如未设置需手动获取路径填写在下面
AppPath="$ProjectPath/DerivedData"

# .app文件全路径，自动获取，无需修改
AppFilePath="$AppPath/$ProjectName/Build/Products/Release-iphoneos/$ProjectName.app"

# 设置BundleId~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~需要根据项目修改
BundleId="com.xxx.xxx"

# 时间，自动生成，无需修改
Day=`date '+%m-%d'`
Time=`date '+%H%M%S'`

# Info.plist文件路径，自动获取，无需修改
InfoPlistPath="$ProjectPath/$ProjectName/Info.plist"

# 获取版本号,构建版本号，自动获取，无需修改
BundleVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $InfoPlistPath`
BundleBuildVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $InfoPlistPath`

# 设置.ipa文件目录~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~默认放到项目根目录，可按需修改
IpaFilePath="$ProjectPath/$Day"

# 设置.ipa文件名~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~默认是时间加包名加版本号加构建版本号，可按需修改
IpaFileName="$Time-$BundleId-V$BundleVersion-B$BundleBuildVersion.ipa"

# 上面定义了常量
################################################################################################################################################
# 下面执行打包命令

# 指定输出文件目录不存在则创建
if [ -d "$IpaFilePath" ] ; then
echo $IpaFilePath
else
mkdir -pv $IpaFilePath
fi

#执行打包命令
xcrun -sdk iphoneos  PackageApplication \
-v \
$AppFilePath \
-o \
$IpaFilePath/$IpaFileName

# 打开生成的ipa文件目录
open $IpaFilePath/
