[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/janewenthome/openlogi-spotlight)](https://github.com/janewenthome/openlogi-spotlight/stargazers)
[![CI](https://github.com/janewenthome/openlogi-spotlight/actions/workflows/ci.yml/badge.svg)](https://github.com/janewenthome/openlogi-spotlight/actions/workflows/ci.yml)

# OpenLogi Spotlight

讓滑鼠自訂按鍵在簡報時切換 macOS 聚光燈效果的原生 companion app。它搭配 [OpenLogi](https://github.com/AprilNEA/OpenLogi) 使用：OpenLogi 負責把 Logitech 滑鼠按鍵映射成快捷鍵，本專案負責顯示全螢幕、可穿透滑鼠操作的聚光燈 overlay。

目前版本是 macOS 13+ 的 MVP，預設快捷鍵為 `F13`。它不使用 Command、Option 或文字鍵，因此不受 Windows 鍵盤標示與注音輸入法影響。按一次顯示/隱藏聚光燈，按 `Esc` 可隱藏；游標移動時光圈會跟隨。

## 快速開始

1. 安裝 OpenLogi：

   ```sh
   brew install --cask openlogi
   ```

2. 編譯並安裝 companion app：

   ```sh
   ./scripts/install.sh
   ```

3. 設定兩個不同的 macOS 權限：Bluetooth 直連的 LIFT 需要讓 `OpenLogiAgent.app` 使用「輸入監控」；本 companion app 則需要在「輔助使用」中允許 `OpenLogiSpotlight.app`。兩者不是同一個開關，詳見 [排錯指南](docs/TROUBLESHOOTING.md)。
4. 依照 [OpenLogi 設定說明](docs/OPENLOGI-SETUP.md)，把滑鼠的 Forward 側鍵映射成 `F13`。
5. 開啟 PowerPoint、Keynote、Google Slides 或其他簡報播放畫面，按下該滑鼠按鍵即可切換聚光燈。

也可以直接用快捷鍵測試：

```sh
make app
open outputs/OpenLogiSpotlight.app
```

## 功能

- 全域快捷鍵切換聚光燈，不攔截簡報軟體的滑鼠操作。
- 多螢幕 overlay，視窗會跟隨游標所在螢幕。
- 選單列常駐，可手動切換、開啟輔助使用設定與結束程式。
- 設定檔放在 `~/Library/Application Support/OpenLogiSpotlight/config.json`，可調整快捷鍵、透明度、光圈半徑與外框顏色。

## 權限與常見陷阱

- 選單列顯示 `⚠️` 代表 `OpenLogiSpotlight` 尚未取得「輔助使用」信任；顯示 `◉` 才代表全域 F13 監聽已準備好。
- 「輸入監控」的 `OpenLogiAgent.app` 授權只負責讓 OpenLogi 讀取 Bluetooth 滑鼠；它不會替 `OpenLogiSpotlight.app` 授權。
- 授權後必須完全退出並重新開啟對應程式。重新編譯或重新安裝 ad-hoc app 後，macOS 可能需要移除舊項目，再加入目前的 `~/Applications/OpenLogiSpotlight.app`。
- `outputs/OpenLogiSpotlight.app` 是編譯產物，不是安裝後應加入權限清單的版本；安裝腳本使用的是 `~/Applications/OpenLogiSpotlight.app`。
- OpenLogi v0.7.4 GUI 沒有 Custom Shortcut；請使用 TOML 設定 `F13`，不要在內建動作清單中尋找 `⌘⇧9`。

完整排錯步驟請看 [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)。

## 專案資料夾

- `Sources/`：Swift 原始碼。
- `Tests/`：設定與快捷鍵邏輯測試。
- `docs/`：架構、研究與 OpenLogi 設定說明。
- `materials/`：需求與參考資料。
- `assets/`：未來的圖示或設計素材；本 MVP 不使用 OpenLogi 品牌資產。
- `outputs/`：本機編譯出的 `.app`；產物不納入 Git。

## 開發

```sh
make test
swift build
make app
```

這個 repo 不包含 OpenLogi 原始碼，也不重新發佈 OpenLogi 的商標或圖示；OpenLogi 由其官方套件獨立安裝。本專案與 Logitech、OpenLogi 維護者沒有隸屬關係。

## License

本專案採 MIT License。詳見 [LICENSE](LICENSE)。

## Citation

如果這個專案對你的工作有幫助，請引用 [CITATION.cff](CITATION.cff) 或使用以下 BibTeX：

```bibtex
@software{lin2026openlogispotlight,
  author = {Lin, Hsieh-Ting},
  title = {{openlogi-spotlight}: macOS presentation spotlight companion for OpenLogi},
  year = {2026},
  url = {https://github.com/janewenthome/openlogi-spotlight},
  version = {0.1.0}
}
```
