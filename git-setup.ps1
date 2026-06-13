# ============================================================
# 명조 에코 스탯 추출기 — Git + GitHub 초기 설정 스크립트
# PowerShell로 실행: 우클릭 → "PowerShell로 실행"
# ============================================================

# 1. 프로젝트 폴더 위치 설정 (원하는 경로로 변경 가능)
$ProjectDir = "$env:USERPROFILE\Documents\wuwa-echo-extractor"

# 2. Git 설치 확인
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git이 설치되어 있지 않습니다. 설치를 시작합니다..." -ForegroundColor Yellow
    # winget으로 설치 (Windows 10 1809 이상)
    winget install --id Git.Git -e --source winget
    # 환경변수 새로고침
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    Write-Host "Git 설치 완료." -ForegroundColor Green
} else {
    Write-Host "Git 확인: $(git --version)" -ForegroundColor Green
}

# 3. 프로젝트 폴더 생성 및 파일 복사
Write-Host "`n프로젝트 폴더 생성: $ProjectDir" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null

# 이 스크립트와 같은 폴더의 HTML, CHANGELOG 복사
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item "$ScriptDir\wuwa-echo-extractor.html" "$ProjectDir\" -Force
Copy-Item "$ScriptDir\CHANGELOG.md" "$ProjectDir\" -Force

# 4. Git 초기화 및 초기 커밋
Set-Location $ProjectDir

if (-not (Test-Path ".git")) {
    git init
    git add .
    git commit -m "init: 명조 에코 스탯 추출기 초기 버전"
    Write-Host "`n로컬 Git 저장소 초기화 완료." -ForegroundColor Green
} else {
    Write-Host "`n이미 Git 저장소가 존재합니다." -ForegroundColor Yellow
}

# 5. GitHub 연결 안내
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "GitHub 원격 저장소 연결 방법:" -ForegroundColor Cyan
Write-Host "  1. https://github.com/new 에서 새 저장소 생성" -ForegroundColor White
Write-Host "  2. 아래 명령어 실행 (URL을 본인 저장소로 교체):" -ForegroundColor White
Write-Host '     git remote add origin https://github.com/YOUR_ID/wuwa-echo-extractor.git' -ForegroundColor Yellow
Write-Host '     git branch -M main' -ForegroundColor Yellow
Write-Host '     git push -u origin main' -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "완료! 프로젝트 폴더: $ProjectDir" -ForegroundColor Green
Write-Host "앞으로 변경 후 커밋하려면 commit.ps1을 실행하세요." -ForegroundColor White
