// Script to reset all verifications - run with: node reset_verifications.js
// This will clear all existing verifications so users must re-verify

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json'); // You'll need to download this from Firebase Console

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function resetVerifications() {
  try {
    console.log('🔍 Fetching all verification documents...');
    
    const verificationsSnapshot = await db.collection('verifications').get();
    
    if (verificationsSnapshot.empty) {
      console.log('✅ No verifications found. Nothing to reset.');
      return;
    }
    
    console.log(`📊 Found ${verificationsSnapshot.size} verification documents.`);
    console.log('🗑️  Resetting verifications...\n');
    
    const batch = db.batch();
    let count = 0;
    
    verificationsSnapshot.forEach((doc) => {
      const data = doc.data();
      console.log(`   - User ${doc.id}: ${JSON.stringify(data, null, 2)}`);
      
      // Reset all verification fields
      batch.update(doc.ref, {
        identityVerified: false,
        selfieWithIdVerified: false,
        driversLicenseVerified: false,
        vehicleRegistrationVerified: false,
        insuranceVerified: false,
        identityVerifiedAt: admin.firestore.FieldValue.delete(),
        selfieWithIdVerifiedAt: admin.firestore.FieldValue.delete(),
        driversLicenseVerifiedAt: admin.firestore.FieldValue.delete(),
        vehicleRegistrationVerifiedAt: admin.firestore.FieldValue.delete(),
        insuranceVerifiedAt: admin.firestore.FieldValue.delete(),
        identityUrl: admin.firestore.FieldValue.delete(),
        selfieWithIdUrl: admin.firestore.FieldValue.delete(),
        driversLicenseUrl: admin.firestore.FieldValue.delete(),
        vehicleRegistrationUrl: admin.firestore.FieldValue.delete(),
        insuranceUrl: admin.firestore.FieldValue.delete(),
        verificationConfidence: admin.firestore.FieldValue.delete(),
        faceMatchConfidence: admin.firestore.FieldValue.delete(),
        idValidityConfidence: admin.firestore.FieldValue.delete(),
        verificationMethod: admin.firestore.FieldValue.delete(),
        verifiedBy: admin.firestore.FieldValue.delete(),
        updatedAt: new Date().toISOString()
      });
      
      count++;
    });
    
    if (count > 0) {
      await batch.commit();
      console.log(`\n✅ Successfully reset ${count} verification documents.`);
      console.log('👥 All users will need to verify again.');
    }
    
    // Also clear any pending verification requests
    const requestsSnapshot = await db.collection('verification_requests').get();
    if (!requestsSnapshot.empty) {
      console.log(`\n🗑️  Found ${requestsSnapshot.size} pending verification requests.`);
      const requestBatch = db.batch();
      requestsSnapshot.forEach((doc) => {
        requestBatch.delete(doc.ref);
      });
      await requestBatch.commit();
      console.log('✅ Cleared all pending verification requests.');
    }
    
    console.log('\n🎉 Reset complete!');
    
  } catch (error) {
    console.error('❌ Error resetting verifications:', error);
  } finally {
    process.exit();
  }
}

resetVerifications();
