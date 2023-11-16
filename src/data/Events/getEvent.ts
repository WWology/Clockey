import Event from "./event.model";

export const getEventData = async (id: string) => {
	const eventData = await Event.findOne({ id });
	return eventData;
};
