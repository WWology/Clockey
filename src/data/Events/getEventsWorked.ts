import Event from "./event.model";

export const getEventsWorked = async (
	gardenerID: string,
	startDate: Date,
	endDate: Date
) => {
	let invoiceData = new Map<string, any[]>();

	const dotaEventsWorked = await Event.find({
		eventTime: { $gte: startDate },
	})
		.where({ eventType: "Dota" })
		.where("gardeners")
		.in([gardenerID])
		.sort({ eventTime: 1 })
		.exec();

	const csEventsWorked = await Event.find({
		eventTime: { $gte: startDate },
	})
		.where({ eventType: "CS" })
		.where("gardeners")
		.in([gardenerID])
		.sort({ eventTime: 1 })
		.exec();

	const otherEventsWorked = await Event.find({
		eventTime: { $gte: startDate },
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
