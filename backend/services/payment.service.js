
import Stripe from "stripe";
import dotenv from "dotenv";
dotenv.config();

const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

class PaymentService {
    static async createPaymentIntent(amount, currency = "lkr") {
        try {
            const amountInSmallestUnit = Math.round(amount * 100);

            const paymentIntent = await stripe.paymentIntents.create({
                amount: amountInSmallestUnit,
                currency,
                automatic_payment_methods: { enabled: true },
            });

            return {
                clientSecret: paymentIntent.client_secret,
            };
        } catch (error) {
            throw new Error(error.message);
        }
    }

}

export default PaymentService;
