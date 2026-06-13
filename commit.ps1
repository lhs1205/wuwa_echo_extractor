# ============================================================
# 변경사항 커밋 스크립트
# 사용법: .\commit.ps1 "커밋 메시지"
# 예시:   .\commit.ps1 "fix: HP% 오인식 수정"
# ============================================================

param(
    [string]$Message = ""
)

$ProjectDir = "$env:USERPROFILE\Documents\wuwa-echo-extractor"

# 메시지 없으면 입력 요청
if (-not $Message) {
    $Message = Read-Host "커밋 메시지를 입력하세요"
}
if (-not $Message) {
    Write-Host "커밋 메시지가 필요합니다." -ForegroundColor Red
    exit 1
}

# HTML 최신 파일을 프로젝트 폴더로 복사 (Cowork 출력 폴더 → 프로젝트 폴더)
$SourceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item "$SourceDir\wuwa-echo-extractor.html" "$ProjectDir\" -Force
Copy-Item "$SourceDir\CHANGELOG.md" "$ProjectDir\" -Force -ErrorAction SilentlyContinue

# 커밋
Set-Location $ProjectDir
git add .
git status

$confirm = Read-Host "`n위 변경사항을 커밋할까요? (y/n)"
if ($confirm -eq 'y') {
    git commit -m $Message
    Write-Host "`n커밋 완료." -ForegroundColor Green

    # GitHub 연결되어 있으면 push
    $remote = git remote get-url origin 2>$null
    if ($remote) {
        $push = Read-Host "GitHub에 push할까요? (y/n)"
        if ($push -eq 'y') {
            git push
            Write-Host "Push 완료: $remote" -ForegroundColor Green
        }
    }
} else {
    Write-Host "취소됨." -ForegroundColor Yellow
}
