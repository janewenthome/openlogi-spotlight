# OpenLogi Spotlight 排錯指南

這份文件記錄實際整合 LIFT For Business、OpenLogi 0.7.4 與 macOS companion 時遇到的問題，讓下一次安裝不必重走相同的路。

## 先看選單列圖示

`OpenLogiSpotlight` 是選單列常駐程式：

| 圖示 | 意義 |
| --- | --- |
| `◉` | companion 已取得輔助使用，已準備監聽全域 F13 |
| `⚠️` | companion 沒有輔助使用，F13 全域監聽不會可靠工作 |

按鍵鏈路是：

```text
LIFT Forward 側鍵
  → OpenLogiAgent（輸入監控）
  → OpenLogi CustomShortcut = F13
  → OpenLogiSpotlight（輔助使用）
  → overlay
```

這裡有兩個不同程式、兩個不同權限。只開啟其中一個，不會替另一個程式授權。

## 權限設定

### OpenLogiAgent：輸入監控

Bluetooth 直連的 LIFT 需要 OpenLogi agent 讀取輸入：

1. 開啟「系統設定 → 隱私權與安全性 → 輸入監控」。
2. 加入並開啟 `OpenLogiAgent.app`。
3. 若按 `+` 找不到它，用 `⌘⇧G` 前往：

   `/Applications/OpenLogi.app/Contents/Library/LoginItems/OpenLogiAgent.app`

4. 回到 OpenLogi，必要時重新啟動 OpenLogi。

### OpenLogiSpotlight：輔助使用

companion 的全域 F13 監聽需要另一個權限：

1. 開啟「系統設定 → 隱私權與安全性 → 輔助使用」。
2. 加入並開啟 `~/Applications/OpenLogiSpotlight.app`。
3. 若清單已有同名項目但選單列仍是 `⚠️`，先移除舊項目，再加入上述安裝路徑；不要加入 `outputs/OpenLogiSpotlight.app`。
4. 完全退出並重新開啟 OpenLogiSpotlight。
5. 從選單確認圖示變成 `◉`，且權限選單顯示 `Accessibility Permission: Granted`。

macOS 對 ad-hoc 編譯的 app 可能保留舊的 TCC 項目。重新編譯、重新安裝或改變 app 路徑後，移除並重新加入是最直接的修復方式。

## OpenLogi 按鍵設定

OpenLogi 0.7.4 的 GUI 動作清單沒有 Custom Shortcut，因此不要在 GUI 中尋找 `⌘⇧9`。在 `~/.config/openlogi/config.toml` 對實體裝置的 bindings table 設定：

```toml
[devices."<your-physical-device-key>".bindings]
Forward = { CustomShortcut = "F13" }
```

`<your-physical-device-key>` 必須使用 OpenLogi 實際寫出的完整 key；不要自行猜 `unit:` 或 `serial:`。F13 使用零修飾鍵，不受注音輸入法、Windows 鍵盤的 Command/Option 標示或文字鍵盤配置影響。

## 判斷問題在哪一段

1. 從 companion 選單按 `Show Spotlight (F13)`。
   - overlay 出現：繪圖與視窗正常，問題在 OpenLogi 或權限鏈路。
   - overlay 不出現：先處理 companion 的「輔助使用」；確認圖示為 `◉`。
2. `OpenLogiAgent` 有輸入監控後，確認 OpenLogi 正在執行，且 Logitech Options+ 已完全退出。
3. 檢查 TOML 是否仍保留 `Forward = { CustomShortcut = "F13" }`。
4. 重新按 LIFT 的 Forward 側鍵。

如果 Bluetooth 系統設定顯示 LIFT 已連線，但 `openlogi list` 仍回報 `Failed to open device`，先注意 OpenLogi background agent 可能已經持有 HID++ channel；CLI 與背景 agent 同時存取時，這個結果不能單獨證明滑鼠斷線。

## 常見誤區

- OpenLogi GUI 沒有 `⌘⇧9` 並不是程式壞掉，而是 v0.7.4 沒有顯示 Custom Shortcut 編輯器。
- OpenLogi 自己顯示「輔助使用已授權」，不代表 `OpenLogiSpotlight` 也已授權。
- OpenLogi background agent 存活，不代表 companion app 也在執行；選單列必須看得到 `◉` 或 `⚠️`。
- 測試時若從 `outputs/` 直接開 app，之後要記得改用安裝腳本放到 `~/Applications/` 的 bundle，並把正確路徑加入 macOS 權限。
