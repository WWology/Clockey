import { REST, Routes } from "discord.js";
import { commands } from "./commands";
import { config } from "./config";

const commandsData = Object.values(commands).map((command) => command.data);

const rest = new REST().setToken(config.CLOCKEY_TOKEN);

type DeployCommandsProps = {
	guildId: string;
};

export async function deployCommands({ guildId }: DeployCommandsProps) {
	try {
		console.log("Started refreshing application (/) commands.");

		await rest.put(
			Routes.applicationGuildCommands(config.CLOCKEY_ID, guildId),
			{
				body: commandsData,
			}
		);

		console.log("Successfully reloaded application (/) commands.");
	} catch (error) {
		console.error(error);
	}
}
