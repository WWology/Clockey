import Event from "./event.model";

/**
 * @param {string} gardenerID - The ID of the gardener to get invoice data for
 * @param {Date} startDate - The date to start looking for invoices
 * @param {Date} [EndDate=Date.now()] - The cutoff date for the invoice generated, defaults to current date if empty
 * @returns {Promise<Map<String, any[]>>} - Promise containing the data from MongoDB
 */
export const getEventsWorked = async (
	gardenerID: string,
	startDate: Date,
	endDate: Date
) => {
	let invoiceData = new Map<string, any[]>();
	const endDatePlus1 = new Date(endDate.getTime() + 86400_000); //86400_000 is 1 day in milliseconds

	const dotaEventsWorked = await Event.find({
		eventTime: { $gte: startDate, $lte: endDatePlus1 },
	})
		.where({ eventType: "Dota" })
		.where("gardeners")
		.in([gardenerID])
		.sort({ eventTime: 1 })
		.exec();

	const csEventsWorked = await Event.find({
		eventTime: { $gte: startDate, $lte: endDatePlus1 },
	})
		.where({ eventType: "CS" })
		.where("gardeners")
		.in([gardenerID])
		.sort({ eventTime: 1 })
		.exec();

	const otherEventsWorked = await Event.find({
		eventTime: { $gte: startDate, $lte: endDatePlus1 },
	})
		.where({ eventType: "Other" })
		.where("gardeners")
		.in([gardenerID])
		.sort({ eventTime: 1 })
		.exec();

	invoiceData.set("Dota", dotaEventsWorked ?? []);
	invoiceData.set("CS", csEventsWorked ?? []);
	invoiceData.set("Other", otherEventsWorked ?? []);

	return invoiceData;
};
