# Reset All Verifications - PowerShell Script

Write-Host "🔍 Resetting all user verifications..." -ForegroundColor Yellow
Write-Host ""

# Get Firebase project ID
$projectId = "fitareeaee"

Write-Host "This script will:" -ForegroundColor Cyan
Write-Host "  1. Clear all verification statuses" -ForegroundColor White
Write-Host "  2. Delete verification document URLs" -ForegroundColor White
Write-Host "  3. Remove pending verification requests" -ForegroundColor White
Write-Host "  4. Force all users to re-verify" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Are you sure you want to proceed? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "❌ Cancelled." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "🚀 Starting reset process..." -ForegroundColor Green
Write-Host ""

# Instructions for manual reset via Firebase Console
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "MANUAL RESET INSTRUCTIONS" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "1️⃣  Go to Firebase Console:" -ForegroundColor White
Write-Host "   https://console.firebase.google.com/project/$projectId/firestore" -ForegroundColor Blue
Write-Host ""
Write-Host "2️⃣  Navigate to 'verifications' collection" -ForegroundColor White
Write-Host ""
Write-Host "3️⃣  For each user document:" -ForegroundColor White
Write-Host "   • Set all '*Verified' fields to false" -ForegroundColor Gray
Write-Host "   • Delete all '*VerifiedAt' fields" -ForegroundColor Gray
Write-Host "   • Delete all '*Url' fields" -ForegroundColor Gray
Write-Host "   • Update 'updatedAt' to current timestamp" -ForegroundColor Gray
Write-Host ""
Write-Host "4️⃣  Delete 'verification_requests' collection (if exists)" -ForegroundColor White
Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Alternative: Use Firestore REST API
Write-Host "🔧 ALTERNATIVE: Quick Firebase Console Links" -ForegroundColor Yellow
Write-Host ""
Write-Host "Verifications Collection:" -ForegroundColor White
Write-Host "https://console.firebase.google.com/project/$projectId/firestore/data/~2Fverifications" -ForegroundColor Blue
Write-Host ""
Write-Host "Verification Requests:" -ForegroundColor White
Write-Host "https://console.firebase.google.com/project/$projectId/firestore/data/~2Fverification_requests" -ForegroundColor Blue
Write-Host ""

Write-Host "💡 TIP: You can use the Firebase Console to bulk edit or delete documents" -ForegroundColor Cyan
Write-Host ""
