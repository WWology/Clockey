import {
	ActionRowBuilder,
	CacheType,
	ChatInputCommandInteraction,
	ModalActionRowComponentBuilder,
	ModalBuilder,
	ModalSubmitInteraction,
	SlashCommandBuilder,
	TextInputBuilder,
	TextInputStyle,
} from "discord.js";

export const data = new SlashCommandBuilder()
	.setName("event")
	.setDescription("Create a new event for gardeners to sign up")
	.addStringOption((option) =>
		option
			.setName("type")
			.setRequired(true)
			.setDescription("Event Type")
			.addChoices(
				{
					name: "Dota",
					value: "Dota",
				},
				{
					name: "CS",
					value: "CS",
				},
				{
					name: "Other",
					value: "Other",
				}
			)
	);

export async function execute(interaction: ChatInputCommandInteraction) {
	let replyMessage: string = "Hey Gardener\n\nI need up to ";
	let eventName: string = "";
	let eventTime: string = "";
	let eventSeriesLength: string = "";
	let numberOfGardeners: number = 0;
	let hours: string = "";

	const type = interaction.options.getString("type");
	const modal = eventModal(type!);
	await interaction.showModal(modal);

	interaction
		.awaitModalSubmit({ time: 120_000 })
		.then(async (modal) => {
			eventName = valueFromModal(modal, "eventName");
			eventTime = valueFromModal(modal, "eventTime");
			switch (type) {
				case "Dota":
					eventSeriesLength = valueFromModal(modal, "eventSeriesLength");
					numberOfGardeners = 4;
					hours = checkHours(eventSeriesLength);
					break;
				case "CS":
					eventSeriesLength = valueFromModal(modal, "eventSeriesLength");
					numberOfGardeners = 2;
					hours = checkHours(eventSeriesLength);
					break;
				case "Other":
					numberOfGardeners = parseInt(
						valueFromModal(modal, "numberOfGardeners")
					);
					hours = valueFromModal(modal, "hours");
					break;
			}

			if (type !== "Other") {
				replyMessage += `${numberOfGardeners} gardeners to work the ${type} game - ${eventName}, at <t:${eventTime}:F>

Please react below with a <:ruggahPain:951843834554376262> to sign up!

As this is a ${eventSeriesLength}, you will be able to add ${hours} hours of work to your invoice for the month`;
			} else {
				replyMessage += `${numberOfGardeners} gardeners to work the ${type} event - ${eventName}, at <t:${eventTime}:F>

Please react below with a <:ruggahPain:951843834554376262> to sign up!

You will be able to add ${hours} hours of work to your invoice for the month`;
			}

			const message = await modal.reply({
				content: replyMessage,
				fetchReply: true,
			});

			message.react("951843834554376262");
		})
		.catch((err) => {
			console.error(err);
		});
}

function eventModal(type: string): ModalBuilder {
	let components: ActionRowBuilder<ModalActionRowComponentBuilder>[] = [];
	const modal = new ModalBuilder().setCustomId("eventModal").setTitle("Event");

	const eventName = new TextInputBuilder()
		.setCustomId("eventName")
		.setLabel("Event / Game name")
		.setStyle(TextInputStyle.Short)
		.setRequired(true)
		.setPlaceholder("OG vs <opp team name>");

	const firstActionRow =
		new ActionRowBuilder<ModalActionRowComponentBuilder>().addComponents(
			eventName
		);

	const eventTime = new TextInputBuilder()
		.setCustomId("eventTime")
		.setLabel("Event / Game time")
		.setStyle(TextInputStyle.Short)
		.setRequired(true)
		.setPlaceholder("Insert unix time here");

	const secondActionRow =
		new ActionRowBuilder<ModalActionRowComponentBuilder>().addComponents(
			eventTime
		);

	const eventSeriesLength = new TextInputBuilder()
		.setCustomId("eventSeriesLength")
		.setLabel("Game Series Length")
		.setStyle(TextInputStyle.Short)
		.setRequired(true)
		.setPlaceholder("Bo1 / Bo2 / Bo3 / Bo5");

	const thirdActionRow =
		new ActionRowBuilder<ModalActionRowComponentBuilder>().addComponents(
			eventSeriesLength
		);

	const numberOfGardeners = new TextInputBuilder()
		.setCustomId("numberOfGardeners")
		.setLabel("Number of Gardeners Required")
		.setStyle(TextInputStyle.Short)
		.setRequired(true);

	const fourthActionRow =
		new ActionRowBuilder<ModalActionRowComponentBuilder>().addComponents(
			numberOfGardeners
		);

	const hours = new TextInputBuilder()
		.setCustomId("hours")
		.setLabel("How many hours is this event")
		.setStyle(TextInputStyle.Short);

	const fifthActionRow =
		new ActionRowBuilder<ModalActionRowComponentBuilder>().addComponents(hours);

	if (type === "Other") {
		components = [
			firstActionRow,
			secondActionRow,
			fourthActionRow,
			fifthActionRow,
		];
	} else {
		components = [firstActionRow, secondActionRow, thirdActionRow];
	}

	modal.addComponents(components);
	return modal;
}

function checkHours(gameType: string): string {
	switch (gameType) {
		case "Bo1":
			return "2";
		case "Bo2":
			return "3";
		case "Bo3":
			return "4";
		case "Bo5":
			return "5";
		default:
			return "";
	}
}

function valueFromModal(
	modalInteraction: ModalSubmitInteraction<CacheType>,
	fieldName: string
): string {
	return modalInteraction.fields.getTextInputValue(fieldName);
}

function checkValidUnixTime(eventTime: string): boolean {
	return true;
}
