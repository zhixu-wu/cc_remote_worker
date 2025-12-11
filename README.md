# Remote Worker - SSH运维助手

专业的SSH远程服务器运维工具,帮助用户通过SSH连接远程服务器并解决各类技术问题。

## 快速开始

### 1. 配置服务器连接

复制配置模板:
```bash
cp servers.conf.template servers.conf
```

编辑 `servers.conf`,添加你的服务器信息:
```
# 格式: 别名|主机|端口|用户名|密码
hawkbit|192.168.77.142|22|hawkbit|YourPassword
production|10.0.0.100|22|admin|YourPassword
```

### 2. 使用SSH执行命令

基本用法:
```bash
./ssh_exec.sh <服务器别名> "命令"
```

示例:
```bash
# 查看当前目录
./ssh_exec.sh hawkbit "pwd"

# 查看Docker容器状态
./ssh_exec.sh hawkbit "docker ps"

# 执行多个命令
./ssh_exec.sh production "cd /var/log && tail -f nginx/access.log"
```

查看可用服务器:
```bash
./ssh_exec.sh
```

## 项目结构

```
remote_worker/
├── ssh_exec.sh              # 通用SSH执行器
├── servers.conf             # 服务器配置(gitignored)
├── servers.conf.template    # 配置模板
├── CLAUDE.md               # Claude Code 工作指南
├── README.md               # 本文件
└── .gitignore              # Git忽略规则
```

## 工作流程

系统遵循三阶段工作流:

### Phase 1: 任务初始化
1. 接收任务名称
2. 收集SSH凭证(或使用servers.conf中已配置的服务器)
3. 建立SSH连接并验证
4. 确认当前工作目录

### Phase 2: 问题分析
1. 明确具体问题
2. 分析根本原因和影响范围
3. 生成多个解决方案(A, B等),附带优缺点
4. 推荐最优方案
5. 创建详细执行Todo清单

### Phase 3: 解决方案执行
1. 用户确认选择的方案
2. 顺序执行方案步骤
3. 通过验证清单验证结果
4. 用户确认后关闭任务

## 安全提示

⚠️ **重要**: `servers.conf` 包含敏感凭证信息
- 已添加到 `.gitignore`,不会提交到Git
- 请妥善保管,不要分享
- 任务完成后,可删除不再使用的服务器配置

## 高风险操作

以下操作需要明确的用户确认才能执行:

- 任何带 `sudo` 的命令
- 系统文件修改/删除 (`/etc/`, `/usr/`, `/var/`)
- 删除操作 (`rm`, `rmdir`)
- 服务重启/停止 (`systemctl`, `service`)
- 权限修改 (`chmod`, `chown`)
- 用户管理 (`useradd`, `userdel`, `passwd`)
- 防火墙规则变更 (`iptables`, `firewall-cmd`)
- 数据库操作 (DROP, DELETE, TRUNCATE)
- 进程终止 (`kill -9`)

## 任务记录

历史任务记录保存在 `任务记录_*.md` 文件中,包含:
- 问题描述和根本原因
- 解决方案详情
- 执行步骤和验证结果
- 经验总结和最佳实践

## 依赖要求

- **本地环境**: macOS/Linux
- **必需工具**:
  - `sshpass` - SSH密码认证工具
  - `ssh` - SSH客户端
  - `bash` - Shell环境

安装 sshpass (macOS):
```bash
brew install sshpass
```

## 常见问题

### SSH连接失败?
- 检查网络连通性: `ping <服务器IP>`
- 验证端口开放: `nc -zv <服务器IP> <端口>`
- 确认凭证正确: 检查 `servers.conf` 中的配置

### 命令执行超时?
- 检查命令是否需要交互式输入(不支持)
- 增加超时时间或改为后台任务

### 权限被拒绝?
- 确认用户有执行权限
- 可能需要 `sudo` (需明确用户确认)

## 开发指南

本项目使用 Claude Code 作为AI助手。详细的工作指南请参考 `CLAUDE.md`。

关键原则:
- 始终使用 `ssh_exec.sh` 而非直接SSH命令
- 高风险操作需要用户明确确认
- 修改配置文件前务必备份
- Docker配置更新使用 `--force-recreate`

