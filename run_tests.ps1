#!/usr/bin/env pwsh

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Running Flutter Tests & Analysis" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

Write-Host "`n[1/3] Running flutter test..." -ForegroundColor Yellow
flutter test --reporter=compact
$testResult = $LASTEXITCODE

Write-Host "`n[2/3] Running flutter analyze..." -ForegroundColor Yellow
flutter analyze --no-pub
$analyzeResult = $LASTEXITCODE

Write-Host "`n[3/3] Checking pub get..." -ForegroundColor Yellow
flutter pub get
$pubResult = $LASTEXITCODE

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "RESULTS:" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Tests: $(if ($testResult -eq 0) {'✓ PASSED'} else {'✗ FAILED'})" -ForegroundColor $(if ($testResult -eq 0) {'Green'} else {'Red'})
Write-Host "Analysis: $(if ($analyzeResult -eq 0) {'✓ PASSED'} else {'✗ FAILED'})" -ForegroundColor $(if ($analyzeResult -eq 0) {'Green'} else {'Red'})
Write-Host "Pub Get: $(if ($pubResult -eq 0) {'✓ PASSED'} else {'✗ FAILED'})" -ForegroundColor $(if ($pubResult -eq 0) {'Green'} else {'Red'})
Write-Host "=====================================" -ForegroundColor Cyan
