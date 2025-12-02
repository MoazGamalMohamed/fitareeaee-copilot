import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";

admin.initializeApp();

// Stripe configuration (use environment variables in production)
// const stripe = require('stripe')(functions.config().stripe?.secret_key);

// Platform fee percentage
const PLATFORM_FEE_PERCENT = 0.10;
const STRIPE_PERCENT_FEE = 0.029;
const STRIPE_FIXED_FEE = 0.30;

// Configure email transporter
// In production, use environment variables for credentials
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: functions.config().email?.user || process.env.EMAIL_USER,
    pass: functions.config().email?.pass || process.env.EMAIL_PASS,
  },
});

/**
 * Send email notification when a new booking/match is created
 */
export const onBookingCreated = functions.firestore
  .document("bookings/{bookingId}")
  .onCreate(async (snapshot, context) => {
    const booking = snapshot.data();
    const bookingId = context.params.bookingId;

    try {
      // Get trip details
      const tripDoc = await admin.firestore()
        .collection("trips")
        .doc(booking.tripId)
        .get();

      if (!tripDoc.exists) {
        console.log("Trip not found for booking:", bookingId);
        return null;
      }

      const trip = tripDoc.data()!;

      // Get driver (trip creator) details
      const driverDoc = await admin.firestore()
        .collection("users")
        .doc(trip.userId)
        .get();

      // Get rider (booking creator) details
      const riderDoc = await admin.firestore()
        .collection("users")
        .doc(booking.userId)
        .get();

      if (!driverDoc.exists || !riderDoc.exists) {
        console.log("User not found for booking:", bookingId);
        return null;
      }

      const driver = driverDoc.data()!;
      const rider = riderDoc.data()!;

      // Send email to driver about new booking
      await sendBookingNotificationToDriver(
        driver.email,
        driver.name || "Driver",
        rider.name || "Rider",
        trip,
        booking
      );

      // Send confirmation email to rider
      await sendBookingConfirmationToRider(
        rider.email,
        rider.name || "Rider",
        driver.name || "Driver",
        trip,
        booking
      );

      console.log("Booking notification emails sent for:", bookingId);
      return null;
    } catch (error) {
      console.error("Error sending booking notification:", error);
      return null;
    }
  });

/**
 * Send email to driver about new booking request
 */
async function sendBookingNotificationToDriver(
  email: string,
  driverName: string,
  riderName: string,
  trip: FirebaseFirestore.DocumentData,
  booking: FirebaseFirestore.DocumentData
): Promise<void> {
  const mailOptions = {
    from: "Fitareeaee <noreply@fitareeaee.com>",
    to: email,
    subject: `New Booking Request - ${trip.origin} to ${trip.destination}`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #4CAF50;">New Booking Request!</h2>
        <p>Hello ${driverName},</p>
        <p><strong>${riderName}</strong> has requested to book your trip.</p>
        
        <div style="background: #f5f5f5; padding: 15px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0;">Trip Details</h3>
          <p><strong>From:</strong> ${trip.origin}</p>
          <p><strong>To:</strong> ${trip.destination}</p>
          <p><strong>Date:</strong> ${formatDate(trip.departureTime)}</p>
          <p><strong>Seats Requested:</strong> ${booking.seatsBooked || 1}</p>
          <p><strong>Type:</strong> ${booking.includesPerson ? "Person" : ""} ${booking.includesPackage ? "Package" : ""}</p>
        </div>
        
        <p>Please open the app to accept or decline this booking.</p>
        
        <p style="color: #666; font-size: 12px; margin-top: 30px;">
          This is an automated message from Fitareeaee. Please do not reply to this email.
        </p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
}

/**
 * Send booking confirmation email to rider
 */
async function sendBookingConfirmationToRider(
  email: string,
  riderName: string,
  driverName: string,
  trip: FirebaseFirestore.DocumentData,
  booking: FirebaseFirestore.DocumentData
): Promise<void> {
  const mailOptions = {
    from: "Fitareeaee <noreply@fitareeaee.com>",
    to: email,
    subject: `Booking Submitted - ${trip.origin} to ${trip.destination}`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #2196F3;">Booking Submitted!</h2>
        <p>Hello ${riderName},</p>
        <p>Your booking request has been submitted to <strong>${driverName}</strong>.</p>
        
        <div style="background: #f5f5f5; padding: 15px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0;">Trip Details</h3>
          <p><strong>From:</strong> ${trip.origin}</p>
          <p><strong>To:</strong> ${trip.destination}</p>
          <p><strong>Date:</strong> ${formatDate(trip.departureTime)}</p>
          <p><strong>Price:</strong> $${booking.totalPrice || trip.price}</p>
          <p><strong>Status:</strong> Pending Confirmation</p>
        </div>
        
        <p>You will receive a notification once the driver responds to your request.</p>
        
        <p style="color: #666; font-size: 12px; margin-top: 30px;">
          This is an automated message from Fitareeaee. Please do not reply to this email.
        </p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
}

/**
 * Send email when booking status changes (accepted/rejected)
 */
export const onBookingStatusChanged = functions.firestore
  .document("bookings/{bookingId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    const bookingId = context.params.bookingId;

    // Only proceed if status changed
    if (before.status === after.status) {
      return null;
    }

    try {
      // Get rider details
      const riderDoc = await admin.firestore()
        .collection("users")
        .doc(after.userId)
        .get();

      if (!riderDoc.exists) {
        console.log("Rider not found for booking:", bookingId);
        return null;
      }

      const rider = riderDoc.data()!;

      // Get trip details
      const tripDoc = await admin.firestore()
        .collection("trips")
        .doc(after.tripId)
        .get();

      const trip = tripDoc.exists ? tripDoc.data()! : {};

      // Send appropriate email based on new status
      if (after.status === "confirmed") {
        await sendBookingAcceptedEmail(
          rider.email,
          rider.name || "Rider",
          trip,
          after
        );
      } else if (after.status === "cancelled" || after.status === "rejected") {
        await sendBookingRejectedEmail(
          rider.email,
          rider.name || "Rider",
          trip,
          after
        );
      }

      console.log("Booking status email sent for:", bookingId);
      return null;
    } catch (error) {
      console.error("Error sending booking status email:", error);
      return null;
    }
  });

/**
 * Send email when booking is accepted
 */
async function sendBookingAcceptedEmail(
  email: string,
  riderName: string,
  trip: FirebaseFirestore.DocumentData,
  booking: FirebaseFirestore.DocumentData
): Promise<void> {
  const mailOptions = {
    from: "Fitareeaee <noreply@fitareeaee.com>",
    to: email,
    subject: `Booking Confirmed! - ${trip.origin || "Trip"} to ${trip.destination || "Destination"}`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #4CAF50;">🎉 Booking Confirmed!</h2>
        <p>Hello ${riderName},</p>
        <p>Great news! Your booking has been confirmed by the driver.</p>

        <div style="background: #e8f5e9; padding: 15px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #2e7d32;">Trip Details</h3>
          <p><strong>From:</strong> ${trip.origin || "N/A"}</p>
          <p><strong>To:</strong> ${trip.destination || "N/A"}</p>
          <p><strong>Date:</strong> ${formatDate(trip.departureTime)}</p>
          <p><strong>Total Price:</strong> $${booking.totalPrice || trip.price || "N/A"}</p>
        </div>

        <p>Please make sure to be at the pickup location on time. You can contact the driver through the app.</p>

        <p style="color: #666; font-size: 12px; margin-top: 30px;">
          This is an automated message from Fitareeaee. Please do not reply to this email.
        </p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
}

/**
 * Send email when booking is rejected
 */
async function sendBookingRejectedEmail(
  email: string,
  riderName: string,
  trip: FirebaseFirestore.DocumentData,
  booking: FirebaseFirestore.DocumentData
): Promise<void> {
  const mailOptions = {
    from: "Fitareeaee <noreply@fitareeaee.com>",
    to: email,
    subject: `Booking Update - ${trip.origin || "Trip"} to ${trip.destination || "Destination"}`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #f44336;">Booking Not Confirmed</h2>
        <p>Hello ${riderName},</p>
        <p>Unfortunately, your booking request was not confirmed.</p>

        <div style="background: #ffebee; padding: 15px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #c62828;">Trip Details</h3>
          <p><strong>From:</strong> ${trip.origin || "N/A"}</p>
          <p><strong>To:</strong> ${trip.destination || "N/A"}</p>
          <p><strong>Date:</strong> ${formatDate(trip.departureTime)}</p>
        </div>

        <p>Don't worry! There are many other trips available. Open the app to find another ride.</p>

        <p style="color: #666; font-size: 12px; margin-top: 30px;">
          This is an automated message from Fitareeaee. Please do not reply to this email.
        </p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
}

/**
 * Send welcome email when new user signs up
 */
export const onUserCreated = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snapshot, context) => {
    const user = snapshot.data();
    const userId = context.params.userId;

    if (!user.email) {
      console.log("No email for user:", userId);
      return null;
    }

    try {
      const mailOptions = {
        from: "Fitareeaee <noreply@fitareeaee.com>",
        to: user.email,
        subject: "Welcome to Fitareeaee! 🚗",
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #2196F3;">Welcome to Fitareeaee!</h2>
            <p>Hello ${user.name || "there"},</p>
            <p>Thank you for joining Fitareeaee - your trusted ride-sharing and package delivery platform.</p>

            <div style="background: #e3f2fd; padding: 15px; border-radius: 8px; margin: 20px 0;">
              <h3 style="margin-top: 0; color: #1565c0;">Get Started</h3>
              <ul>
                <li><strong>Find a Ride:</strong> Search for available trips to your destination</li>
                <li><strong>Offer a Ride:</strong> Share your trip and earn money</li>
                <li><strong>Send Packages:</strong> Get your packages delivered safely</li>
              </ul>
            </div>

            <p>Complete your profile to build trust with other users and unlock all features.</p>

            <p>Safe travels!</p>
            <p>The Fitareeaee Team</p>
          </div>
        `,
      };

      await transporter.sendMail(mailOptions);
      console.log("Welcome email sent to:", user.email);
      return null;
    } catch (error) {
      console.error("Error sending welcome email:", error);
      return null;
    }
  });

// Helper function to format date
function formatDate(timestamp: FirebaseFirestore.Timestamp | string): string {
  if (!timestamp) return "TBD";
  const date = typeof timestamp === "string"
    ? new Date(timestamp)
    : timestamp.toDate();
  return date.toLocaleDateString("en-US", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

/**
 * Create Stripe Payment Intent for escrow payment
 * Called from Flutter app when user initiates payment
 */
export const createPaymentIntent = functions.https.onCall(async (data, context) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  const { amount, currency, bookingId, payeeId } = data;

  if (!amount || !bookingId || !payeeId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required fields"
    );
  }

  try {
    // Calculate fees
    const processingFee = (amount * STRIPE_PERCENT_FEE) + STRIPE_FIXED_FEE;
    const platformFee = amount * PLATFORM_FEE_PERCENT;
    const netAmount = amount - processingFee - platformFee;

    // In production, create actual Stripe PaymentIntent:
    // const paymentIntent = await stripe.paymentIntents.create({
    //   amount: Math.round(amount * 100), // Stripe uses cents
    //   currency: currency || 'usd',
    //   metadata: {
    //     bookingId,
    //     payerId: context.auth.uid,
    //     payeeId,
    //   },
    //   // For escrow, use manual capture
    //   capture_method: 'manual',
    // });

    // Simulated response for development
    const paymentIntentId = `pi_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    const clientSecret = `${paymentIntentId}_secret_${Math.random().toString(36).substr(2, 9)}`;

    // Store payment record
    const paymentRef = admin.firestore().collection("payments").doc();
    await paymentRef.set({
      id: paymentRef.id,
      bookingId,
      payerId: context.auth.uid,
      payeeId,
      amount,
      currency: currency || "USD",
      paymentMethod: "stripe",
      status: "pending",
      stripePaymentIntentId: paymentIntentId,
      platformFee: parseFloat(platformFee.toFixed(2)),
      processingFee: parseFloat(processingFee.toFixed(2)),
      netAmount: parseFloat(netAmount.toFixed(2)),
      escrowStatus: "none",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      paymentIntentId,
      clientSecret,
      paymentId: paymentRef.id,
      fees: {
        platformFee: parseFloat(platformFee.toFixed(2)),
        processingFee: parseFloat(processingFee.toFixed(2)),
        netAmount: parseFloat(netAmount.toFixed(2)),
      },
    };
  } catch (error) {
    console.error("Error creating payment intent:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to create payment intent"
    );
  }
});

/**
 * Confirm payment and hold in escrow
 * Called after Stripe payment is confirmed
 */
export const confirmPaymentEscrow = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  const { paymentId } = data;

  if (!paymentId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Payment ID is required"
    );
  }

  try {
    const paymentRef = admin.firestore().collection("payments").doc(paymentId);
    const paymentDoc = await paymentRef.get();

    if (!paymentDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Payment not found");
    }

    const payment = paymentDoc.data()!;

    // Verify the payer is the authenticated user
    if (payment.payerId !== context.auth.uid) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Not authorized"
      );
    }

    // In production, capture the payment:
    // await stripe.paymentIntents.capture(payment.stripePaymentIntentId);

    // Update payment to escrow status
    await paymentRef.update({
      status: "escrow",
      escrowStatus: "held",
      escrowHeldAt: admin.firestore.FieldValue.serverTimestamp(),
      transactionId: `TXN_${Date.now()}`,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Update booking
    await admin.firestore().collection("bookings").doc(payment.bookingId).update({
      paymentStatus: "escrow",
      paymentId: paymentId,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, status: "escrow" };
  } catch (error) {
    console.error("Error confirming payment:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to confirm payment"
    );
  }
});

/**
 * Release escrow payment to driver after trip completion
 */
export const releaseEscrowPayment = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  const { paymentId } = data;

  if (!paymentId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Payment ID is required"
    );
  }

  try {
    const paymentRef = admin.firestore().collection("payments").doc(paymentId);
    const paymentDoc = await paymentRef.get();

    if (!paymentDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Payment not found");
    }

    const payment = paymentDoc.data()!;

    if (payment.escrowStatus !== "held") {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Payment is not in escrow"
      );
    }

    // In production, transfer funds to driver's Stripe Connect account:
    // const transfer = await stripe.transfers.create({
    //   amount: Math.round(payment.netAmount * 100),
    //   currency: payment.currency.toLowerCase(),
    //   destination: driverStripeAccountId,
    //   transfer_group: payment.bookingId,
    // });

    const stripeTransferId = `tr_${Date.now()}`;

    // Update payment status
    await paymentRef.update({
      status: "completed",
      escrowStatus: "released",
      escrowReleasedAt: admin.firestore.FieldValue.serverTimestamp(),
      stripeTransferId: stripeTransferId,
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Update booking
    await admin.firestore().collection("bookings").doc(payment.bookingId).update({
      paymentStatus: "completed",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Add to driver's wallet
    const walletRef = admin.firestore().collection("wallets").doc(payment.payeeId);
    const walletDoc = await walletRef.get();

    if (walletDoc.exists) {
      const currentBalance = walletDoc.data()?.balance || 0;
      await walletRef.update({
        balance: currentBalance + payment.netAmount,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      await walletRef.set({
        userId: payment.payeeId,
        balance: payment.netAmount,
        currency: payment.currency,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    // Record wallet transaction
    await admin.firestore().collection("wallet_transactions").add({
      userId: payment.payeeId,
      type: "credit",
      amount: payment.netAmount,
      description: "Trip payment received",
      paymentId: paymentId,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, status: "released" };
  } catch (error) {
    console.error("Error releasing escrow:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to release escrow"
    );
  }
});

/**
 * Refund escrow payment
 */
export const refundPayment = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  const { paymentId, reason } = data;

  if (!paymentId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Payment ID is required"
    );
  }

  try {
    const paymentRef = admin.firestore().collection("payments").doc(paymentId);
    const paymentDoc = await paymentRef.get();

    if (!paymentDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Payment not found");
    }

    const payment = paymentDoc.data()!;

    if (payment.status === "refunded") {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Payment already refunded"
      );
    }

    // In production, refund via Stripe:
    // await stripe.refunds.create({
    //   payment_intent: payment.stripePaymentIntentId,
    // });

    // Update payment status
    await paymentRef.update({
      status: "refunded",
      escrowStatus: "refunded",
      refundReason: reason || "Requested by user",
      refundedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Update booking
    await admin.firestore().collection("bookings").doc(payment.bookingId).update({
      paymentStatus: "refunded",
      status: "cancelled",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, status: "refunded" };
  } catch (error) {
    console.error("Error refunding payment:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to refund payment"
    );
  }
});

