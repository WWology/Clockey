import Event, { IEvent } from "./event.model";

export const createEvent = async (eventData: IEvent) => {
	try {
		await Event.create(eventData);
		return true;
	} catch (err) {
		console.error(err);
	}
};
