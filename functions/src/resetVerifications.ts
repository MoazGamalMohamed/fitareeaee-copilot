import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

/**
 * Callable function to reset all user verifications
 * Only for admin use
 */
export const resetAllVerifications = functions.https.onCall(async (data, context) => {
  // Check if user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const db = admin.firestore();

  try {
    functions.logger.info('Starting verification reset...');
    
    // Get all verification documents
    const verificationsSnapshot = await db.collection('verifications').get();
    
    if (verificationsSnapshot.empty) {
      return {
        success: true,
        message: 'No verifications found',
        count: 0
      };
    }

    functions.logger.info(`Found ${verificationsSnapshot.size} verification documents`);
    
    // Use batched writes for better performance
    const batchSize = 500;
    const batches: admin.firestore.WriteBatch[] = [];
    let currentBatch = db.batch();
    let operationCount = 0;
    let totalCount = 0;

    for (const doc of verificationsSnapshot.docs) {
      // Reset all verification fields
      currentBatch.update(doc.ref, {
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
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });

      operationCount++;
      totalCount++;

      // When batch is full, add to batches array and create new batch
      if (operationCount === batchSize) {
        batches.push(currentBatch);
        currentBatch = db.batch();
        operationCount = 0;
      }
    }

    // Add the last batch if it has operations
    if (operationCount > 0) {
      batches.push(currentBatch);
    }

    // Commit all batches
    functions.logger.info(`Committing ${batches.length} batches...`);
    await Promise.all(batches.map(batch => batch.commit()));

    // Also clear pending verification requests
    const requestsSnapshot = await db.collection('verification_requests').get();
    if (!requestsSnapshot.empty) {
      functions.logger.info(`Deleting ${requestsSnapshot.size} verification requests...`);
      
      const deleteBatches: admin.firestore.WriteBatch[] = [];
      let deleteBatch = db.batch();
      let deleteCount = 0;

      for (const doc of requestsSnapshot.docs) {
        deleteBatch.delete(doc.ref);
        deleteCount++;

        if (deleteCount === batchSize) {
          deleteBatches.push(deleteBatch);
          deleteBatch = db.batch();
          deleteCount = 0;
        }
      }

      if (deleteCount > 0) {
        deleteBatches.push(deleteBatch);
      }

      await Promise.all(deleteBatches.map(batch => batch.commit()));
    }

    functions.logger.info('Verification reset complete!');

    return {
      success: true,
      message: `Successfully reset ${totalCount} verifications and deleted ${requestsSnapshot.size} pending requests`,
      verificationsReset: totalCount,
      requestsDeleted: requestsSnapshot.size
    };

  } catch (error) {
    functions.logger.error('Error resetting verifications:', error);
    throw new functions.https.HttpsError('internal', 'Failed to reset verifications');
  }
});
