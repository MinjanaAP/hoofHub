import hoofcoinsService from "../services/hoofcoins.service.js";


const deductHoofcoins = async (req, res) => {
    try {
        const { riderId, hoofcoins, bookingId, discountAmount } = req.body;
        const result = await  hoofcoinsService.deductHoofcoins({ riderId, hoofcoins, bookingId, discountAmount });
        res.json({ status: true, ...result });
    } catch (error) {
        res.status(500).json({ status: false, error: error.message });
    }
};

const returnHoofcoins = async (req, res) => {
    try {
        const { riderId, hoofcoins, bookingId } = req.body;
        const result = await hoofcoinsService.returnHoofcoins({ riderId, hoofcoins, bookingId });
        res.json({ status: true, ...result });
    } catch (error) {
        res.status(500).json({ status: false, error: error.message });
    }
};

export default { deductHoofcoins, returnHoofcoins };
