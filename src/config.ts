import dotenv from "dotenv";

dotenv.config();

const { CLOCKEY_TOKEN, CLOCKEY_ID, OG_GUILD_ID, WW_TEST_GUILD_ID, MONGO_URL } =
	process.env;

if (
	!CLOCKEY_TOKEN ||
	!CLOCKEY_ID ||
	!OG_GUILD_ID ||
	!WW_TEST_GUILD_ID ||
	!MONGO_URL
) {
	throw new Error("Missing Environment variable");
}

export const config = {
	CLOCKEY_TOKEN,
	CLOCKEY_ID,
	OG_GUILD_ID,
	WW_TEST_GUILD_ID,
	MONGO_URL,
};
