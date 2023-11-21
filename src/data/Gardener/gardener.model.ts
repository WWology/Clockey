import { Document, Schema, model } from "mongoose";

export interface IGardener extends Document {
	discordID: string;
	name: string;
	phone: string;
	email: string;
	addrl1: string;
	addrl2: string;
	postcode: string;
	iban?: string;
	swift?: string;
}

export const gardenerSchema = new Schema<IGardener>({
	discordID: String,
	name: String,
	phone: String,
	email: String,
	addrl1: String,
	addrl2: String,
	postcode: String,
	iban: String,
	swift: String,
});

export default model<IGardener>("Gardener", gardenerSchema);
