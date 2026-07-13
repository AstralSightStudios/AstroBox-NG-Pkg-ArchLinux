# AstroBox-NG Linux 发版

<p align="center">
    <img src="https://img.shields.io/badge/pnpm-required-02ACFA.svg?style=flat-square&logo=pnpm">
    <img src="https://img.shields.io/badge/python-3+-3776AB.svg?style=flat-square&logo=python">
    <img src="https://img.shields.io/badge/makepkg-required-1793D1.svg?style=flat-square&logo=archlinux">
    <img src="https://img.shields.io/badge/rpmbuild-required-891400.svg?style=flat-square&logo=redhat">
    <img src="https://img.shields.io/badge/dpkg--deb-required-A81D33.svg?style=flat-square&logo=debian">
    <img src="https://img.shields.io/badge/submodules-private%20repo%20access-red.svg?style=flat-square&logo=git">
</p>

> 构建脚本原理与细节见 [BUILD.md](BUILD.md)

## 1. 构建 Linux 包

```bash
pnpm install #记得构建前手动pnpm i
./scripts/build-linux.sh
# 输入: 1 2 3
# 产物输出到 dist/linux/
```

| 选项 | 目标 | 产物 |
|---|---|---|
| `1` / `deb` | Debian/Ubuntu | `.deb` |
| `2` / `rpm` | Fedora/RHEL | `.rpm` |
| `3` / `arch` | Arch Linux | `.pkg.tar.zst` |
| `a` | deb + rpm | `.deb` + `.rpm` |
| `q` | 退出 | - |

可多选，空格分隔。发版选 `1 2 3` 全选，同时生成 deb、rpm、arch 三个包。

产物目录：

```
dist/linux/
├── AstroBox-2.0.1_amd64.deb
├── AstroBox-2.0.1_x86_64.rpm
└── AstroBox-2.0.1-1_x86_64.pkg.tar.zst
```

## 2. 发包给搜星

将 `dist/linux/` 下的全部包发送给 [Searchstars](https://github.com/Searchstars)，由 Searchstars 上传至 [Releases](https://github.com/Searchstars/AstroBox-NG/releases)。

## 3. 发布 AUR

等待搜星发布完成后，运行脚本自动更新 `PKGBUILD`（`pkgver`、`pkgrel`、`_expected` sha256）和 `.SRCINFO`：

```bash
./scripts/archpkg/update-aur.sh
```

脚本从 `tauri.conf.json` 提取版本号，查询 AUR 自动递增 `pkgrel`，从 `dist/linux/` 的产物计算 sha256。

### 3.1 测试

```bash
sudo pacman -Rs astrobox-ng   # 卸载旧版
makepkg -si                   # 本地构建安装
```

### 3.2 推送 AUR

AUR `astrobox-ng` 仅以下两个账号有推送权限：[WaiJade](https://aur.archlinux.org/account/WaiJade)、[OrPudding](https://aur.archlinux.org/account/OrPudding)。

```bash
git clone ssh://aur@aur.archlinux.org/astrobox-ng.git
cd astrobox-ng
# 替换 PKGBUILD 和 .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "修改提交消息"
git push
```
