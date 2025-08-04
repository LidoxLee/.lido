#!/bin/bash

# Automator 工作流程安裝腳本
# 用於將工作流程安裝到正確的系統目錄

set -e  # 遇到錯誤時停止執行

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印帶顏色的消息函數
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "=== Mac Automator 工作流程安裝腳本 ==="
echo ""

# 設置變量
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUICK_ACTIONS_DIR="$HOME/Library/QuickLook"
SERVICES_DIR="$HOME/Library/Services"
APPLICATIONS_DIR="$HOME/Applications"
BACKUP_DIR="$SCRIPT_DIR/Library"

# 檢查是否為 root 用戶
if [[ $EUID -eq 0 ]]; then
    print_error "請不要使用 root 權限運行此腳本"
    exit 1
fi

# 創建必要的目錄
print_info "創建必要的目錄..."
mkdir -p "$QUICK_ACTIONS_DIR"
mkdir -p "$SERVICES_DIR"
mkdir -p "$APPLICATIONS_DIR"

# 備份現有服務
backup_existing_services() {
    local backup_timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_path="$SCRIPT_DIR/backups/services_backup_$backup_timestamp"
    
    if [ -d "$SERVICES_DIR" ] && [ "$(ls -A "$SERVICES_DIR" 2>/dev/null)" ]; then
        print_info "備份現有服務到: $backup_path"
        mkdir -p "$backup_path"
        cp -R "$SERVICES_DIR"/* "$backup_path/" 2>/dev/null || true
    fi
}

# 安裝備份的服務
install_backup_services() {
    print_info "安裝備份的服務..."
    
    if [ -d "$BACKUP_DIR/Services" ]; then
        local installed_count=0
        for service in "$BACKUP_DIR/Services"/*.workflow; do
            if [ -d "$service" ]; then
                local service_name=$(basename "$service")
                print_info "  安裝: $service_name"
                
                # 檢查是否已存在，如果存在則備份
                if [ -d "$SERVICES_DIR/$service_name" ]; then
                    print_warning "  服務已存在，將被覆蓋: $service_name"
                fi
                
                cp -R "$service" "$SERVICES_DIR/"
                installed_count=$((installed_count + 1))
            fi
        done
        
        if [ $installed_count -gt 0 ]; then
            print_success "已安裝 $installed_count 個服務"
        else
            print_warning "未找到任何備份的服務"
        fi
    else
        print_warning "備份服務目錄不存在: $BACKUP_DIR/Services"
    fi
}

# 安裝快速操作
install_quick_actions() {
    print_info "安裝快速操作..."
    
    if [ -d "$SCRIPT_DIR/workflows/quick-actions" ]; then
        local installed_count=0
        for workflow in "$SCRIPT_DIR/workflows/quick-actions"/*.workflow; do
            if [ -d "$workflow" ]; then
                local workflow_name=$(basename "$workflow")
                print_info "  安裝: $workflow_name"
                cp -R "$workflow" "$QUICK_ACTIONS_DIR/"
                installed_count=$((installed_count + 1))
            fi
        done
        
        if [ $installed_count -gt 0 ]; then
            print_success "已安裝 $installed_count 個快速操作"
        else
            print_warning "未找到任何快速操作"
        fi
    else
        print_warning "快速操作目錄不存在: $SCRIPT_DIR/workflows/quick-actions"
    fi
}

# 安裝服務（從 workflows 目錄）
install_services_from_workflows() {
    print_info "安裝 workflows 目錄中的服務..."
    
    if [ -d "$SCRIPT_DIR/workflows/services" ]; then
        local installed_count=0
        for service in "$SCRIPT_DIR/workflows/services"/*.workflow; do
            if [ -d "$service" ]; then
                local service_name=$(basename "$service")
                print_info "  安裝: $service_name"
                cp -R "$service" "$SERVICES_DIR/"
                installed_count=$((installed_count + 1))
            fi
        done
        
        if [ $installed_count -gt 0 ]; then
            print_success "已安裝 $installed_count 個服務"
        else
            print_warning "未找到任何服務"
        fi
    else
        print_warning "服務目錄不存在: $SCRIPT_DIR/workflows/services"
    fi
}

# 安裝應用程序
install_applications() {
    print_info "安裝應用程序..."
    
    if [ -d "$SCRIPT_DIR/workflows/applications" ]; then
        local installed_count=0
        for app in "$SCRIPT_DIR/workflows/applications"/*.app; do
            if [ -d "$app" ]; then
                local app_name=$(basename "$app")
                print_info "  安裝: $app_name"
                cp -R "$app" "$APPLICATIONS_DIR/"
                installed_count=$((installed_count + 1))
            fi
        done
        
        if [ $installed_count -gt 0 ]; then
            print_success "已安裝 $installed_count 個應用程序"
        else
            print_warning "未找到任何應用程序"
        fi
    else
        print_warning "應用程序目錄不存在: $SCRIPT_DIR/workflows/applications"
    fi
}

# 設置腳本權限
set_script_permissions() {
    print_info "設置腳本權限..."
    
    if [ -d "$SCRIPT_DIR/scripts" ]; then
        find "$SCRIPT_DIR/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
        find "$SCRIPT_DIR/scripts" -name "*.scpt" -exec chmod +x {} \; 2>/dev/null || true
        print_success "腳本權限設置完成"
    else
        print_warning "腳本目錄不存在: $SCRIPT_DIR/scripts"
    fi
}

# 驗證安裝
verify_installation() {
    print_info "驗證安裝..."
    
    local total_services=0
    local total_quick_actions=0
    
    # 檢查服務
    if [ -d "$SERVICES_DIR" ]; then
        total_services=$(find "$SERVICES_DIR" -name "*.workflow" -type d | wc -l)
    fi
    
    # 檢查快速操作
    if [ -d "$QUICK_ACTIONS_DIR" ]; then
        total_quick_actions=$(find "$QUICK_ACTIONS_DIR" -name "*.workflow" -type d | wc -l)
    fi
    
    print_success "安裝驗證完成:"
    echo "  - 服務: $total_services 個"
    echo "  - 快速操作: $total_quick_actions 個"
}

# 顯示後續步驟
show_next_steps() {
    echo ""
    print_success "=== 安裝完成 ==="
    echo ""
    print_info "後續步驟："
    echo "1. 快速操作會在 Finder 的右鍵選單中出現"
    echo "2. 服務需要在系統偏好設定中啟用："
    echo "   系統偏好設定 > 鍵盤 > 快捷鍵 > 服務"
    echo "3. 應用程序已安裝到 ~/Applications 目錄"
    echo ""
    print_info "如需重新安裝，請運行此腳本"
    echo ""
 
}

# 主執行流程
main() {
    backup_existing_services
    install_backup_services
    install_quick_actions
    install_services_from_workflows
    install_applications
    set_script_permissions
    verify_installation
    show_next_steps
}

# 執行主流程
main