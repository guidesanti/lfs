# Instructions

## 0. Create LFS group and user
```
create-lfs-user.sh
```
The above command will create the default LFs group and user which are both 'lfs' by default.
For more details about the options of create-lfs-user.sh run it with --help option.

This step can be skipped if the user to be used to build the LFS is already created.

## 1. Preparation

### Create partition layout on target disk
TODO

### Login as LFS user and set LFS environment
```
# Assuming the LFS user is 'lfs', if different change the command accordinly
su - lfs
source env.sh set --lfs-partition /dev/sda4
```
This step sets the LFS environment which is required for all the following steps.
If this step is skipped the next scripts will not run and will rise an error saying that the LFS environment was not set. 

### Mount LFS target partition
```
mount-lfs.sh
```

### Prepare for build
```
prepare.sh run
```

## 2. Build the LFS cross toolchain and temporary tools
```
build-cross-toolchain.sh run
```

## 3. Build the LFS system
TODO