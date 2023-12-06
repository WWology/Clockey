import {
	ActionRowBuilder,
	ApplicationCommandType,
	ButtonBuilder,
	ButtonStyle,
	ContextMenuCommandBuilder,
	MessageActionRowComponentBuilder,
	MessageComponentInteraction,
	MessageContextMenuCommandInteraction,
} from "discord.js";

import Event from "../data/Events/event.model";
export const data = new ContextMenuCommandBuilder()
	.setName("Cancel")
	.setType(ApplicationCommandType.Message);

export async function execute(
	interaction: MessageContextMenuCommandInteraction
) {
	const message = interaction.targetMessage;
	let eventName: string;

	//* Check if event has been rolled before, if it hasn't been rolled, inform user
	if (message.reactions.cache.get("👍")?.count! === 0) {
		await interaction.reply({
			content: "This event hasn't been rolled yet",
		});
		return;
	}

	if (message.content.includes("Other")) {
		eventName = message.content.substring(
			message.content.search("-") + 2,
			message.content.search(",")
		);
	} else {
		eventName = message.content.substring(
			message.content.search("OG vs"),
			message.content.search(",")
		);
	}

	const eventToBeDeleted = await Event.findOne({ eventName: eventName }).exec();

	const event = new Event({
		eventName: eventToBeDeleted?.eventName,
		eventTime: eventToBeDeleted?.eventTime,
		eventType: eventToBeDeleted?.eventType,
		gardeners: eventToBeDeleted?.gardeners,
		hours: eventToBeDeleted?.hours,
	});

	const confirm = new ButtonBuilder()
		.setCustomId("confirm")
		.setLabel("Confirm")
		.setStyle(ButtonStyle.Danger);

	const cancel = new ButtonBuilder()
		.setCustomId("cancel")
		.setLabel("Cancel")
		.setStyle(ButtonStyle.Secondary);

	const row =
		new ActionRowBuilder<MessageActionRowComponentBuilder>().addComponents(
			confirm,
			cancel
		);

	const response = await interaction.reply({
		content: "Are you sure you want to cancel the signups for this game?",
		components: [row],
		ephemeral: true,
	});

	response
		.awaitMessageComponent({ time: 30_000 })
		.then(async (componentInteraction: MessageComponentInteraction) => {
			if (componentInteraction.customId === "confirm") {
				await Event.findByIdAndDelete(eventToBeDeleted!["_id"]);
				await componentInteraction.update({
					content: "Signups cancelled successfully",
					components: [],
				});
				await message.reactions.cache.get("787697278190223370")?.remove();
			} else {
				await componentInteraction.update({
					content: "Action cancelled",
					components: [],
				});
			}
		})
		.catch(async (err) => {
			if (event.eventName) {
				await event.save();
			}
			await interaction.editReply({
				content: "Unable to cancel sign ups, please try the command again",
				components: [],
			});
			console.error(err);
		});
}
