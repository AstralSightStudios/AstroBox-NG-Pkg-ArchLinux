# AstroBox-NG Linux 构建说明

## 目录结构

```
scripts/
├── build-linux.sh           ← 主入口
└── archpkg/                 ← Arch Linux 子模块
    ├── build.sh             ← Arch 构建入口
    ├── update-aur.sh        ← 更新 AUR PKGBUILD
    ├── PKGBUILD              ← AUR 发布版
    ├── PKGBUILD.prebuilt     ← 预编译打包
    └── .SRCINFO              ← AUR 元数据
```

## build-linux.sh

版本号从 `src-tauri/modules/app/tauri.conf.json` 提取。

**Step 0** - 同步子仓库（`abtools.py sync --private`）

**Step 1** - `pnpm tauri build`（deb/rpm 用 `--bundles`，arch 用 `--no-bundle`）

**Step 2** - 重命名包（`astro-box` -> `astrobox-ng`）
- deb：`dpkg-deb`
- rpm：`rpmbuild` + `rpm2archive`

之后收集产物到 `dist/linux/`。

## archpkg/build.sh

版本号从 `src-tauri/modules/app/tauri.conf.json` 提取。

1. 查询 AUR，同版本自动 `pkgrel+1`
2. 注入 `pkgver`/`pkgrel` 到 PKGBUILD.prebuilt
3. `makepkg` 打包

## archpkg/update-aur.sh

更新 AUR 的 `PKGBUILD` 和 `.SRCINFO`。

1. 从 `tauri.conf.json` 提取版本号
2. 查询 AUR，同版本自动 `pkgrel+1`
3. 从 `dist/linux/` 的产物计算 sha256
4. 更新 `PKGBUILD` 的 `pkgver`/`pkgrel`/`_expected`
5. 生成 `.SRCINFO`

## PKGBUILD

AUR 用。

1. 多镜像测速选最快
2. 下载 Release 的 `.pkg.tar.zst`
3. sha256 校验
4. 解压安装到 `$pkgdir`

## PKGBUILD.prebuilt

从 `src-tauri/target/release` 取二进制，安装：

- 二进制 -> `/usr/bin/AstroBox-ng`
- 桌面文件 / 图标 / LICENSE

## .SRCINFO

`makepkg --printsrcinfo` 生成，与 `PKGBUILD` 保持同步。