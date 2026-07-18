Write-Host "🔄 Calling Cloud Function to Reset All Verifications..." -ForegroundColor Yellow
Write-Host ""

# Function URL
$functionUrl = "https://us-central1-fitareeaee.cloudfunctions.net/resetAllVerifications"

Write-Host "📍 Function URL: $functionUrl" -ForegroundColor Cyan
Write-Host ""

# Note: This requires authentication
Write-Host "⚠️  This function requires Firebase Authentication" -ForegroundColor Yellow
Write-Host ""
Write-Host "To call this function, you have two options:" -ForegroundColor White
Write-Host ""
Write-Host "Option 1: Call from the app (recommended)" -ForegroundColor Green
Write-Host "  Add this button to your admin screen:" -ForegroundColor Gray
Write-Host "  ```dart" -ForegroundColor DarkGray
Write-Host "  ElevatedButton(" -ForegroundColor DarkGray
Write-Host "    onPressed: () => callResetVerifications(context)," -ForegroundColor DarkGray
Write-Host "    child: Text('Reset All Verifications')," -ForegroundColor DarkGray
Write-Host "  )" -ForegroundColor DarkGray
Write-Host "  ```" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Option 2: Use Firebase Console" -ForegroundColor Green
Write-Host "  1. Go to: https://console.firebase.google.com/project/fitareeaee/firestore/data/~2Fverifications" -ForegroundColor Gray
Write-Host "  2. Delete all documents in 'verifications' collection" -ForegroundColor Gray
Write-Host "  3. Delete all documents in 'verification_requests' collection" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "Do you want to open Firebase Console now? (y/n)"

if ($choice -eq "y" -or $choice -eq "Y") {
    Start-Process "https://console.firebase.google.com/project/fitareeaee/firestore/data/~2Fverifications"
    Write-Host ""
    Write-Host "✅ Opened Firebase Console" -ForegroundColor Green
    Write-Host "   Please manually delete the verification documents" -ForegroundColor Gray
}

Write-Host ""
Write-Host "ℹ️  The Cloud Function 'resetAllVerifications' is deployed and ready" -ForegroundColor Cyan
Write-Host "   Call it from your Flutter app when logged in as admin" -ForegroundColor Gray
Write-Host ""
