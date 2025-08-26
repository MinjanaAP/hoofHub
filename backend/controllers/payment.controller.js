import PaymentService from "../services/payment.service.js";



class PaymentController {
    static async createPaymentIntent(req, res) {
        try {
            const { amount } = req.body;

            if (!amount) {
                return res.status(400).json({ error: "Amount is required" });
            }

            const payment = await PaymentService.createPaymentIntent(amount);

            return res.status(200).json({
                status: true,
                message: "Payment Intent created successfully",
                data: payment,
            });
        } catch (error) {
            return res.status(500).json({ status: false, error: error.message });
        }
    }
}

export default PaymentController;
