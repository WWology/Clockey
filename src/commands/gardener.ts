import {
	ActionRowBuilder,
	ApplicationCommandType,
	ContextMenuCommandBuilder,
	MessageContextMenuCommandInteraction,
	ModalActionRowComponentBuilder,
	ModalBuilder,
	TextInputBuilder,
	TextInputStyle,
} from "discord.js";

import Event from "../data/Events/event.model";

export const data = new ContextMenuCommandBuilder()
	.setName("Gardener")
	.setType(ApplicationCommandType.Message);

export async function execute(
	interaction: MessageContextMenuCommandInteraction
) {
	let eventName = "";
	let gardenersReacted: string[] = [];
	let gardenersWorking: string[] = [];
	let replyMessage: string = "The people selected are: ";
	let eventType: string = "";

	const botID = interaction.client.application.id;

	const message = interaction.targetMessage;
	const messageContent = message.content;

	// Check if message has already been processed before
	if (message.reactions.cache.get("787697278190223370")?.count! > 0) {
		await interaction.reply({
			content: "This message has been processed for signups",
			ephemeral: true,
		});
		return;
	}

	if (messageContent.includes("Dota")) {
		eventType = "Dota";
	} else if (messageContent.includes("CS")) {
		eventType = "CS";
	} else if (messageContent.includes("Other")) {
		eventType = "Other";
	}

	if (eventType !== "Other") {
		eventName = messageContent.substring(
			messageContent.search("OG vs"),
			messageContent.search(",")
		);
	} else {
		eventName = messageContent.substring(
			messageContent.search("-") + 2,
			messageContent.search(",")
		);
	}

	const eventUnixTime =
		parseInt(
			messageContent.substring(
				messageContent.search("<t:") + 3,
				messageContent.search("<t:") + 13
			)
		) * 1000;

	const hours = parseInt(
		messageContent.charAt(messageContent.search("add") + 4)
	);

	const modal = gardenerModal();
	await interaction.showModal(modal);

	interaction
		.awaitModalSubmit({ time: 30_000 })
		.then(async (modalInteraction) => {
			let numberOfGardeners = parseInt(
				modalInteraction.fields.getTextInputValue("numberOfGardenerInput")
			);

			// Get the list of users who reacted with the specific emoji
			const reactors = await message.reactions.cache
				.get("730890894814740541")
				?.users.fetch();

			// Gardeners Who reacted towards the message
			reactors?.forEach((reactor) => {
				gardenersReacted.push(reactor.id);
			});

			// Remove the bot ID from the list of potential gardeners
			if (gardenersReacted.indexOf(botID) > -1) {
				gardenersReacted.splice(gardenersReacted.indexOf(botID), 1);
			}

			// Select random gardeners based on the amount of gardeners required, if there's less gardeners than what's required
			// then immediately select all the gardeners who reacted
			if (gardenersReacted.length <= numberOfGardeners) {
				gardenersWorking = gardenersReacted.slice();
				numberOfGardeners = gardenersReacted.length;
			} else {
				gardenersWorking = gardenersReacted.slice();
				gardenersWorking.sort(() => Math.random() - 0.5);
				gardenersWorking = gardenersWorking.slice(0, numberOfGardeners);
			}

			for (let i = 0; i < numberOfGardeners; i++) {
				replyMessage += `<@${gardenersWorking[i]}> `;
			}

			await modalInteraction.reply({
				content: `${replyMessage} - ${message.url}`,
				allowedMentions: { parse: ["users"] },
			});

			await message.react("787697278190223370");

			const event = new Event({
				eventName: eventName,
				eventTime: eventUnixTime,
				eventType: eventType,
				gardeners: gardenersWorking,
				hours: hours,
			});

			await event.save();
		})
		.catch((err) => {
			console.error(err);
		});
}

function gardenerModal(): ModalBuilder {
	const modal = new ModalBuilder()
		.setCustomId("gardenerModal")
		.setTitle("Gardener Modal");

	const numberOfGardenersInput = new TextInputBuilder()
		.setCustomId("numberOfGardenerInput")
		.setLabel("Number of Gardeners to work")
		.setStyle(TextInputStyle.Short)
		.setRequired(true);

	const firstActionRow =
		new ActionRowBuilder<ModalActionRowComponentBuilder>().addComponents(
			numberOfGardenersInput
		);

	modal.addComponents(firstActionRow);

	return modal;
}
