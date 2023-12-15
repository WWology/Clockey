import { Client } from "discord.js";
import { commands } from "./commands";
import { config } from "./config";
import { connectDatabase } from "./data/connectDatabase";
import { deployCommands } from "./deploy_commands";

const client = new Client({
	intents: ["Guilds", "GuildMessages", "DirectMessages"],
});

client.once("ready", async () => {
	await connectDatabase();
	console.log("Clockey ready ⏰");
});

client.on("guildCreate", async (guild) => {
	await deployCommands({ guildId: guild.id });
});

client.on("interactionCreate", async (interaction: any) => {
	if (!interaction.isCommand()) {
		return;
	}

	// Register command
	const { commandName } = interaction;
	if (commands[commandName as keyof typeof commands]) {
		commands[commandName as keyof typeof commands].execute(interaction);
	}
});

client.login(config.CLOCKEY_TOKEN);
