# Prerequisites
- docker-ce
- (nvidia-docker for nvidia drivers)

# How to execute consai2
- nvidia driverのある環境
```bash
$ ./docker_build.sh # dockerイメージを作る
$ ./catkin_build.sh # catkin buildする
$ ./consai2.sh # consai2を起動する
```

# How to build docker image without cache
```bash
$ ./docker_build.sh --no-cache
```

# How to run bash on the consai2 image

```bash
$ ./bash.sh
```