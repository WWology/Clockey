import { IEvent } from "./event.model";

export const updateEventData = async (event: IEvent) => {
	await event.save();
	return event;
};
