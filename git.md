## 1、简介
Git 是一个开源的分布式版本控制系统，用于敏捷高效地处理任何或小或大的项目。在后期的
项目协同开发中起到重大作用

## 2、工作流程
![](/img/git/workflow.png)
### 2.1 本地
   先文件夹中执行git init进行初始化创建本地仓库
   对于文件修改是在工作区，修改完成后要先git add到暂存区再commit到本地仓库

### 2.2 分支
   关于分支其主要作用就是将工作从开发主线上分离开来进行开发、修改，最终合并到主线中

### 2.3 版本回退
利用resset --hard commitID 可以实现版本回退，
其中commitID可以通过git log查看

### 2.4 远程仓库
使用远程仓库应先通过git remote add 仓库名创建一个远程仓库
我们将本地推送到远程仓库时使用git push,但在第一次使用时需
git push -f --set-upstream  仓库名 本地分支名:远程分支名
对本地和远程进行追踪绑定，下次使用则直接git push 仓库名 分支名即可

### 2.5 远程到本地
使用fetch抓取文件到本地，但并不会和本地文件合并，需再直接merge
一般直接使用pull实现抓取并且合并

## 3、常用指令
1. git log -查回溯，分支
2. git branch 获取当前分支 , 参数 -d frokname 删除分支
3. git checkout 切换到目标分支
4. git reset --hard commitID 回溯
5. git reflog 查找历史操作
6. git merge frokname 合并分支 
7. git config --globai user.name/user.email ""
8. ssh-keygen -t rsa 生成key
9. git branch -vv 查看分支
10. git push -f --set-upstream(第一次远端分支绑定) origin(远端名) 本地分支名：远端分支名(相同可以省略)  (-f表示强制覆盖)
11. git fetch origin branchname 抓取但不合并
12. git pull origin branchname 拉取:抓取并且合并
13. git remote add 仓库名 SSH 连接远程仓库
14. git remote -vv查看远程仓库
15. git clone SSH 克隆仓库到本地

#### 指令别名

**作用**
使用git过程中难免会遇到一些常用指令很长的情况，这种时候可以使用指令别名
例如输入git-log相当于输入git log --pretty=oneline --all --graph --abbrev-commit

**实现**
只需在C盘用户文件夹下创建一个.bashrc文件(可在gitBash中用touch ~/.bashrc来创建)，在文件中利用alias修饰来给指令命别名，如：
![](/img/git/bashrc.png)
然后再在当前文件夹中执行source ~/.bashrc即可