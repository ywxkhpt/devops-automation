#!/bin/bash

#容器名
containername=devops-integration
#镜像名
imagename=devops-integration

#查询得到指定名称的容器ID
ARG1=$(docker ps -aqf "name=${containername}")

#查询得到指定名称的镜像ID
ARG2=$(docker images -q --filter reference=${imagename})

#如果查询结果不为空，先停容器再删除容器
if [  -n "$ARG1" ]; then
 docker rm -f $(docker stop $ARG1)
 echo "$name容器停止删除成功.....！！！"
fi

#如果查询结果不为空，先删除镜像
if [  -n "$ARG2" ]; then
 docker rmi -f $ARG2
 echo "$name镜像删除成功.....！！！"
fi

#加载新的镜像
cd /root/images/${imagename}
pwd
docker load --input ${imagename}.tar
#启动容器
docker run -d --name ${containername} --restart=always -p 18888:8080 ${imagename}:latest