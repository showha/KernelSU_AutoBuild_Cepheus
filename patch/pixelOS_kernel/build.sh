#!/bin/bash
# rm .version
KERNEL_NAME=PxielOS-cepheus-"$DATE"
# # Bash Color
# green='\033[01;32m'
# red='\033[01;31m'
# blink_red='\033[05;31m'
# restore='\033[0m'

# clear

# # Resources
# export KERNEL_PATH=$PWD
# export ANYKERNEL_PATH=~/Anykernel3
# export CLANG_PATH=~/prelude-clang
# export PATH=${CLANG_PATH}/bin:${PATH}
# export CROSS_COMPILE=${CLANG_PATH}/aarch64-linux-gnu-
# export CROSS_COMPILE_ARM32=${CLANG_PATH}/arm-linux-gnueabi-
# DEFCONFIG="cepheus_defconfig"

# # Download Clang
# git clone https://gitlab.com/PixelOS-Devices/playgroundtc.git -b 15 $CLANG_PATH

# # Kernel Details
# VER=""

# # Paths
# # KERNEL_DIR=`pwd`
# # REPACK_DIR=~/anykernel
# # ZIP_MOVE=~/TREES

# # Functions
# function clean_all {
# 		rm -rf $REPACK_DIR/Image*
# 		cd $KERNEL_DIR
# 		echo
# 		make clean && make mrproper
# }

# function make_kernel {
# 		echo
# 		make LLVM=1 LLVM_IAS=1 $DEFCONFIG
# 		make LLVM=1 LLVM_IAS=1 -j$(grep -c ^processor /proc/cpuinfo)

# }


# function make_boot {
# 		cp out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR
# }


# function make_zip {
# 		# cd $REPACK_DIR
# 		# zip -r9 `echo $ZIP_NAME`.zip *
# 		# mv  `echo $ZIP_NAME`*.zip $ZIP_MOVE
# 		# cd $KERNEL_DIR
#     echo "=========================Patch========================="
#     rm -r $ANYKERNEL_PATH/modules $ANYKERNEL_PATH/patch $ANYKERNEL_PATH/ramdisk
#     cp $KERNEL_PATH/anykernel.sh $ANYKERNEL_PATH/
#     cp $KERNEL_PATH/out/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_PATH/
#     cd $ANYKERNEL_PATH
#     zip -r $KERNEL_NAME *
#     mv $KERNEL_NAME.zip $KERNEL_PATH/out/
#     cd $KERNEL_PATH
#     #rm -rf $CLANG_PATH
#     rm -rf $ANYKERNEL_PATH
#     echo $KERNEL_NAME.zip
# }


# DATE_START=$(date +"%s")


# echo -e "${green}"
# echo "Making Kernel:"
# echo -e "${restore}"


# # Vars
# BASE_AK_VER="REVUELTO-MI9-"
# DATE=`date +"%Y%m%d-%H%M"`
# AK_VER="$BASE_AK_VER$VER"
# # ZIP_NAME="$AK_VER"-"$DATE"
# #export LOCALVERSION=~`echo $AK_VER`
# #export LOCALVERSION=~`echo $AK_VER`
# export ARCH=arm64
# export SUBARCH=arm64
# export KBUILD_BUILD_USER=balgxmr
# export KBUILD_BUILD_HOST=balgxmr

# echo
# echo Starting cleaning...
# echo
# clean_all
# echo
# echo All cleaned.
# echo
# echo Building kernel...
# echo

# make_kernel
# make_boot
# make_zip

# DATE_END=$(date +"%s")
# DIFF=$(($DATE_END - $DATE_START))

# echo
# # find $ZIP_MOVE -type f -mmin -5 -mmin +0
# find $KERNEL_NAME -type f -mmin -5 -mmin +0

# echo
# echo -e "${green}"
# echo "### build completed in ($(($DIFF / 60)):$(($DIFF % 60)) (mm:ss))."
# echo -e "${restore}"
# echo

DATE=$(date +"%Y%m%d")
VERSION=$(git rev-parse --short HEAD)
# KERNEL_NAME=Evasi0nKernel-cepheus-"$DATE"

export KERNEL_PATH=$PWD
export ANYKERNEL_PATH=~/Anykernel3
export CLANG_PATH=~/prelude-clang
export PATH=${CLANG_PATH}/bin:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
export CLANG_PREBUILT_BIN=${CLANG_PATH}/bin
export CC="ccache clang"
export CXX="ccache clang++"
export LD=${CLANG_PATH}/bin/ld.lld
export LLVM=1
export LLVM_IAS=1
export ARCH=arm64
export SUBARCH=arm64

echo "===================Setup Environment==================="
# git clone --depth=1 https://gitlab.com/jjpprrrr/prelude-clang.git $CLANG_PATH
git clone https://gitlab.com/PixelOS-Devices/playgroundtc.git -b 15 $CLANG_PATH
git clone https://github.com/osm0sis/AnyKernel3 $ANYKERNEL_PATH
sh -c "$(curl -sSL https://github.com/akhilnarang/scripts/raw/master/setup/android_build_env.sh/)"

echo "=========================Clean========================="
rm -rf $KERNEL_PATH/out/ *.zip
# make mrproper && git reset --hard HEAD
make mrproper

echo "=========================Build========================="
make O=out LLVM_IAS=1 LD=${LD} cepheus_defconfig
make O=out LLVM_IAS=1 LD=${LD} -j$(grep -c ^processor /proc/cpuinfo)

if [ ! -e $KERNEL_PATH/out/arch/arm64/boot/Image.gz-dtb ]; then
    echo "=======================FAILED!!!======================="
    rm -rf $ANYKERNEL_PATH
    make mrproper>/dev/null 2>&1
    #git reset --hard HEAD 2>&1
    exit -1>/dev/null 2>&1
fi

echo "=========================Patch========================="
rm -r $ANYKERNEL_PATH/modules $ANYKERNEL_PATH/patch $ANYKERNEL_PATH/ramdisk
cp $KERNEL_PATH/anykernel.sh $ANYKERNEL_PATH/
cp $KERNEL_PATH/out/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_PATH/
cd $ANYKERNEL_PATH
zip -r $KERNEL_NAME *
mv $KERNEL_NAME.zip $KERNEL_PATH/out/
cd $KERNEL_PATH
#rm -rf $CLANG_PATH
rm -rf $ANYKERNEL_PATH
echo $KERNEL_NAME.zip
