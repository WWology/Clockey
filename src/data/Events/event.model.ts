import { Document, Schema, model } from "mongoose";

export interface IEvent extends Document {
	eventName: string;
	eventTime: Date;
	eventType: string;
	gardeners: string[];
	hours: number;
}

export const eventSchema = new Schema<IEvent>({
	eventName: String,
	eventTime: Date,
	eventType: String,
	gardeners: [String],
	hours: Number,
});

export default model<IEvent>("Event", eventSchema);
