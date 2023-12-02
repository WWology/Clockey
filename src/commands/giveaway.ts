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

export const data = new ContextMenuCommandBuilder()
	.setName("Giveaway")
	.setType(ApplicationCommandType.Message);

export async function execute(
	interaction: MessageContextMenuCommandInteraction
) {
	let peopleReacted: string[] = [];
	let winners: string[] = [];
	let replyMessage: string = "The giveaway winners are: ";

	const botID = interaction.client.application.id;

	const message = interaction.targetMessage;

	// Check if message has already been reacted
	if (message.reactions.cache.get("👍")?.count! > 0) {
		await interaction.reply({
			content: "This message has been processed for giveaway",
			ephemeral: true,
		});
	}

	const modal = giveawayModal();
	await interaction.showModal(modal);

	interaction
		.awaitModalSubmit({ time: 30_000 })
		.then(async (modalInteraction) => {
			let numberOfWinners = parseInt(
				modalInteraction.fields.getTextInputValue("numberOfWinnersInput")
			);

			// Get the list of users who reacted with the specific emoji
			const reactors = await message.reactions.cache
				.get("951843834554376262")
				?.users.fetch();

			// People Who reacted towards the message
			reactors?.forEach((reactor) => {
				peopleReacted.push(reactor.id);
			});

			// Remove the bot ID from the list of potential gardeners
			if (peopleReacted.indexOf(botID) > -1) {
				peopleReacted.splice(peopleReacted.indexOf(botID), 1);
			}

			winners = peopleReacted.slice();
			winners.sort(() => Math.random() - 0.5);
			winners = winners.slice(0, numberOfWinners);

			for (let i = 0; i < numberOfWinners; i++) {
				replyMessage += `<@${winners[i]}> `;
			}

			await modalInteraction.reply({
				content: `${replyMessage} - ${message.url}`,
				ephemeral: true,
			});

			await message.react("👍");
		})
		.catch((err) => {
			console.error(err);
		});
}

function giveawayModal(): ModalBuilder {
	const modal = new ModalBuilder()
		.setCustomId("giveawayModal")
		.setTitle("Giveaway Modal");

	const numberOfWinnersInput = new TextInputBuilder()
		.setCustomId("numberOfWinnersInput")
		.setLabel("Number of people to win")
		.setStyle(TextInputStyle.Short)
		.setRequired(true);

	const firstActionRow =
		new ActionRowBuilder<ModalActionRowComponentBuilder>().addComponents(
			numberOfWinnersInput
		);

	modal.addComponents(firstActionRow);

	return modal;
}
