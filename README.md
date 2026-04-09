# FileHub 文件分类管理系统

一个面向本地文件管理的工程化项目，目标是实现：文件导入、分类、标签、检索、日志追踪，并支持桌面端安装包交付（Windows + Linux）。

## 1. 项目状态

当前仓库已具备以下能力：

- 后端工程骨架：`Java 17 + Spring Boot 3 + Flyway + MySQL + Redis`
- 前端工程骨架：`Vue 3 + Vite`
- 桌面壳工程：`Electron + electron-builder`
- 安装包产物链路：
- Windows 11: `NSIS .exe`
- Linux (Ubuntu): `AppImage + .deb`
- 环境内聚策略：缓存、运行数据、构建产物全部在项目目录内

## 2. 技术栈

- Backend: Java 17, Spring Boot 3.x, Spring Data JPA, Flyway
- Frontend: Vue 3, Vite, TypeScript
- Database: MySQL 8.x
- Cache: Redis 7.x
- Desktop: Electron 33, electron-builder
- Build: Maven, npm

## 3. 目录结构

```text
.
├─ backend/                  # Spring Boot 后端
├─ frontend/                 # Vue 前端
├─ desktop/                  # Electron 壳 + 打包配置
├─ scripts/                  # 构建/打包脚本（Win + Linux）
├─ infra/                    # docker-compose（MySQL/Redis）
├─ runtime/                  # 本地运行数据（数据库卷、文件目录等）
├─ dist/                     # 构建和安装包输出
├─ .cache/                   # Maven/NPM 本地缓存
└─ .github/workflows/        # CI 双平台打包
```

## 4. 环境内聚规则（核心要求已落实）

本项目默认将所有可变数据收敛到仓库目录：

- Maven 用户目录：`./.cache/maven-home`
- Maven 本地仓库：`./.cache/maven-repo`
- NPM 缓存：`./.cache/npm`
- Docker 数据卷映射：`./runtime/mysql-data`、`./runtime/redis-data`
- 编译与安装包输出：`./dist`

## 5. 运行前准备

### 5.1 通用要求

- Git
- Docker Desktop（或 Linux Docker Engine）
- Node.js 20+
- npm 10+
- JDK 17

### 5.2 Windows 11 建议

- PowerShell 5/7
- Maven 3.9+
- 可选：IDEA、DataGrip

### 5.3 Ubuntu 建议版本

- 推荐：Ubuntu 22.04 LTS 或 24.04 LTS

Ubuntu 安装建议（示例）：

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk maven docker.io docker-compose-plugin fakeroot dpkg rpm libgtk-3-0 libnss3 libxss1 libasound2
```

## 6. 本地开发（Windows 11）

### 6.1 启动基础依赖

```powershell
cd E:\codex_project_Java_FileHub_MS
docker compose -f infra\docker-compose.dev.yml up -d
```

### 6.2 构建后端

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build-backend.ps1
```

输出：`dist/backend/`

### 6.3 构建前端

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build-frontend.ps1
```

输出：`dist/frontend/`

### 6.4 运行后端（Jar）

```powershell
cd E:\codex_project_Java_FileHub_MS\dist\backend
.\run-backend-win.bat
```

## 7. Linux 编译与打包（Ubuntu）

> 你要求的 Linux 版本说明：本项目已按 Ubuntu 可执行方式配置，建议在 Ubuntu 22.04/24.04 上执行下列命令。

### 7.1 赋予脚本执行权限

```bash
cd /path/to/codex_project_Java_FileHub_MS
chmod +x scripts/*.sh
```

### 7.2 启动 MySQL/Redis

```bash
docker compose -f infra/docker-compose.dev.yml up -d
```

### 7.3 编译后端

```bash
./scripts/build-backend.sh
```

说明：

- 若本机有 `mvn`，优先走本机 Maven
- 若无 `mvn` 但有 Docker，会自动用 Maven 容器编译
- 输出目录：`dist/backend/`

### 7.4 编译前端

```bash
./scripts/build-frontend.sh
```

输出目录：`dist/frontend/`

### 7.5 打 Linux 安装包（AppImage + DEB）

```bash
./scripts/package-linux.sh
```

产物目录：`dist/installers/`

期望文件：

- `*.AppImage`
- `*.deb`

## 8. Windows 安装包打包

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\package-win.ps1
```

产物目录：`dist/installers/`

期望文件：

- `FileHubMS Setup 0.1.0.exe`
- `FileHubMS Setup 0.1.0.exe.blockmap`

## 9. CI 自动双平台打包

仓库已提供 GitHub Actions：

- 文件：`.github/workflows/build-installers.yml`
- Windows Runner：构建 NSIS 安装包
- Ubuntu Runner：构建 AppImage/DEB

触发方式：

- 推送到 `main` 或 `master`
- 手动触发 `workflow_dispatch`

## 10. 默认环境变量

参考文件：`.env.example`

关键项：

- `APP_PORT=18080`
- `DB_HOST=127.0.0.1`
- `DB_PORT=3306`
- `DB_NAME=filehub`
- `DB_USER=filehub`
- `DB_PASSWORD=filehub_dev_pwd`
- `REDIS_HOST=127.0.0.1`
- `REDIS_PORT=6379`
- `APP_STORAGE_ROOT=./runtime/data`

## 11. API 入口（当前骨架）

- `GET /api/health`
- `GET /api/system-config`
- `PUT /api/system-config`
- `GET /api/files?keyword=&page=&size=`

## 12. 常见问题

### 12.1 Windows PowerShell 执行策略报错

现象：`running scripts is disabled on this system`

使用以下命令运行脚本：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\package-win.ps1
```

### 12.2 npm 网络波动

项目脚本默认使用：`https://registry.npmmirror.com`

可临时覆盖：

```powershell
$env:FILEHUB_NPM_REGISTRY="https://registry.npmjs.org"
```

```bash
export FILEHUB_NPM_REGISTRY="https://registry.npmjs.org"
```

### 12.3 编码问题

仓库文本文件统一使用 `UTF-8 (No BOM)`，避免 Java 编译时出现 `非法字符 '\ufeff'`。

## 13. Git 仓库上传建议流程

```bash
git init
git add .
git commit -m "feat: bootstrap filehub engineering project"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```

## 14. 后续建议

- 增加正式发布版本号策略（`0.1.0 -> 0.1.1`）
- 增加数据库初始化样例数据
- 增加安装后健康检查与日志收集脚本
- 增加代码签名与安装包校验