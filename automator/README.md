# Mac Automator 工作流程維護

這個目錄用於存放和維護 Mac Automator 的工作流程。

## 目錄結構

```
automator/
├── README.md                    # 本文件
├── install.sh                   # 安裝腳本
├── Library/                     # 備份的系統目錄
│   └── Services/               # 服務目錄備份
│       └── 以 Cursor 開啟.workflow/  # Cursor 開啟服務
├── workflows/                   # 工作流程文件
│   ├── quick-actions/          # 快速操作
│   ├── services/               # 服務
│   └── applications/           # 應用程序
├── scripts/                    # 腳本文件
│   ├── shell/                 # Shell 腳本
│   ├── applescript/           # AppleScript
│   └── javascript/            # JavaScript
└── templates/                  # 模板文件
```

## 備份的服務

### 以 Cursor 開啟 (Open with Cursor)
- **位置**: `Library/Services/以 Cursor 開啟.workflow/`
- **功能**: 在 Finder 中右鍵選單提供「以 Cursor 開啟」選項
- **適用範圍**: 所有文件類型 (`public.item`)
- **觸發條件**: 在 Finder 中選中文件或文件夾
- **操作**: 使用 Cursor 編輯器開啟選中的項目

#### 服務配置詳情
- **服務名稱**: 以 Cursor 開啟
- **背景顏色**: background
- **圖標**: NSActionTemplate
- **應用程序限制**: 僅在 Finder 中可用
- **文件類型**: 支援所有項目類型

## 工作流程類型

### 快速操作 (Quick Actions)
- 在 Finder 中右鍵選單可用的操作
- 可處理選中的文件或文件夾
- 支援多種輸入類型

### 服務 (Services)
- 系統級別的服務
- 可在任何應用程序中使用
- 需要手動啟用

### 應用程序 (Applications)
- 獨立的應用程序
- 可拖拽到 Dock 或 Applications 文件夾

## 安裝說明

### 方法一：使用安裝腳本（推薦）
```bash
# 在 automator 目錄下執行
./install.sh
```

### 方法二：手動安裝
1. 將工作流程文件複製到對應的系統目錄：
   - 快速操作：`~/Library/QuickLook/`
   - 服務：`~/Library/Services/`
   - 應用程序：`~/Applications/` 或 `/Applications/`

2. 在系統偏好設定中啟用服務：
   - 系統偏好設定 > 鍵盤 > 快捷鍵 > 服務

### 備份服務的安裝
```bash
# 複製備份的服務到系統目錄
cp -R "Library/Services/以 Cursor 開啟.workflow" ~/Library/Services/
```
