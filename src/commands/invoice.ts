import {
	ChatInputCommandInteraction,
	EmbedBuilder,
	SlashCommandBuilder,
	User,
} from "discord.js";
import * as path from "path";

import { getEventsWorked } from "../data/Events/getEventsWorked";
import { generateInvoiceHtml } from "../utils/createHtml";
import { generatePdf } from "../utils/createPdf";

export const data = new SlashCommandBuilder()
	.setName("invoice")
	.setDescription("Generate an invoice for user")
	.addStringOption((option) =>
		option
			.setName("startdate")
			.setDescription("The start date of the invoice")
			.setRequired(true)
	)
	.addStringOption((option) =>
		option.setName("enddate").setDescription("End date of this invoice")
	);

export async function execute(interaction: ChatInputCommandInteraction) {
	await interaction.deferReply({ ephemeral: true });

	const user = interaction.user;
	const startDate = new Date(interaction.options.getString("startdate")!);
	if (startDate instanceof Date && isNaN(startDate.valueOf())) {
		await interaction.editReply({
			content: "Start date format is invalid, please use YYYY-MM-DD",
		});
		return;
	}

	const endDate = new Date(
		interaction.options.getString("enddate") ?? Date.now()
	);
	if (endDate instanceof Date && isNaN(endDate.valueOf())) {
		await interaction.editReply({
			content: "End date format is invalid, please use YYYY-MM-DD",
		});
		return;
	}

	const invoiceData = await getEventsWorked(user.id, startDate, endDate);
	await generateInvoiceHtml(invoiceData, user.id, startDate, endDate);
	await generatePdf();

	const invoiceEmbed = createInvoiceEmbed(
		user,
		invoiceData,
		startDate,
		endDate
	);

	await interaction.editReply({
		embeds: [invoiceEmbed],
		files: [path.join(__dirname, "../../pages/invoice.pdf")],
	});
}

function createInvoiceEmbed(
	user: User,
	invoiceData: Map<string, any[]>,
	startDate: Date,
	endDate: Date
) {
	let dotaEventsWorked: string = "";
	let csEventsWorked: string = "";
	let otherEventsWorked: string = "";
	let totalhours: number = 0;
	const startDateMonthName = startDate.toLocaleString("default", {
		month: "long",
	});
	const endDateMonthName = endDate.toLocaleString("default", {
		month: "long",
	});

	for (let dotaEvent of invoiceData.get("Dota")!) {
		dotaEventsWorked += `${
			dotaEvent.eventName
		} at ${dotaEvent.eventTime.toDateString()} - ${dotaEvent.hours} hours\n`;
		totalhours += dotaEvent.hours;
	}

	for (let csEvent of invoiceData.get("CS")!) {
		csEventsWorked += `${
			csEvent.eventName
		} at ${csEvent.eventTime.toDateString()} - ${csEvent.hours} hours\n`;
		totalhours += csEvent.hours;
	}

	for (let otherEvent of invoiceData.get("Other")!) {
		otherEventsWorked += `${
			otherEvent.eventName
		} at ${otherEvent.eventTime.toDateString()} - ${otherEvent.hours} hours\n`;
		totalhours += otherEvent.hours;
	}

	return new EmbedBuilder()
		.setColor(0x0099ff)
		.setTitle(`${startDateMonthName} - ${endDateMonthName}'s Invoice`)
		.setAuthor({
			name: user.displayName,
			iconURL: user.displayAvatarURL(),
		})
		.addFields(
			{
				name: "Dota",
				value:
					dotaEventsWorked.length > 0
						? dotaEventsWorked
						: "No Dota game worked this month",
			},
			{
				name: "CS",
				value:
					csEventsWorked.length > 0
						? csEventsWorked
						: "No CS game worked this month",
			},
			{
				name: "Other",
				value:
					otherEventsWorked.length > 0
						? otherEventsWorked
						: "No Other event worked this month",
			}
		)
		.addFields({
			name: "Total hours",
			value: `${totalhours}`,
		})
		.setTimestamp();
}
