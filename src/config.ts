import dotenv from "dotenv";

dotenv.config();

const { CLOCKEY_TOKEN, CLOCKEY_ID, OG_GUILD_ID } = process.env;

if (!CLOCKEY_TOKEN || !CLOCKEY_ID) {
	throw new Error("Missing Environment variable");
}

export const config = {
	CLOCKEY_TOKEN,
	CLOCKEY_ID,
	OG_GUILD_ID,
};
