import { CommandInteraction, SlashCommandBuilder } from "discord.js";

export const data = new SlashCommandBuilder()
	.setName("invoice")
	.setDescription("Generate an invoice for user");

export async function execute(interaction: CommandInteraction) {
	await interaction.deferReply({ ephemeral: true });
	// TODO Generate invoice from Data
	await interaction.editReply("Here's your generated invoice <link-here>");
}
