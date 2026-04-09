# 打包说明

## 产物

- Windows: `FileHubMS Setup *.exe`（NSIS）
- Linux: `FileHubMS-*.AppImage` 和 `filehubms_*.deb`

产物默认输出到：`dist/installers/`

## 关键流程

1. `scripts/build-backend.*` 打包 Spring Boot Jar 并生成后端启动脚本
2. `scripts/build-frontend.*` 打包 Vue 前端静态文件
3. `desktop/package.json` 使用 electron-builder 生成安装包

## 后端运行时

- 脚本会优先使用 `dist/backend/runtime/bin/java`（若存在）
- 不存在时退回系统 `java`

如需强制随包分发 Java 运行时，可在构建机安装 JDK 17 并确保 `jlink` 可用，脚本会自动生成 `dist/backend/runtime`。
