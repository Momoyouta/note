## 常用指令
1. git log -查回溯，分支
2. git branch 获取当前分支 , 参数 -d frokname 删除分支
3. git checkout 切换到目标分支
4. git reset --hard commitID 回溯
5. git reflog 查找历史操作
6. git merge frokname 合并分支 
7. git config --globai user.name/user.email ""
8. ssh-keygen -t rsa 生成key
9. git branch -vv 查看分支
10. git push --set-upsteam(第一次远端分支绑定) origin(远端名) 本地分支名：远端分支名(相同可以省略)
11. git fetch origin branchname 抓取但不合并
12. git pull origin branchname 拉取:抓取并且合并
13. git remote -v/add 远程仓库相关 (add接ssh)