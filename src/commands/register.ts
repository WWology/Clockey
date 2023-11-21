import { ChatInputCommandInteraction, SlashCommandBuilder } from "discord.js";
import Gardener from "../data/Gardener/gardener.model";

export const data = new SlashCommandBuilder()
	.setName("register")
	.setDescription("Register a gardener's info")
	.addStringOption((option) =>
		option
			.setName("name")
			.setDescription("Gardener's Full Name")
			.setRequired(true)
	)
	.addStringOption((option) =>
		option.setName("phone").setDescription("Phone Number").setRequired(true)
	)
	.addStringOption((option) =>
		option.setName("email").setDescription("Email Address").setRequired(true)
	)
	.addStringOption((option) =>
		option
			.setName("address")
			.setDescription("Address line 1 & 2 + Postcode, each line separated by >")
			.setRequired(true)
	)
	.addStringOption((option) =>
		option
			.setName("iban")
			.setDescription("IBAN Number or Bank Account Number")
			.setRequired(true)
	)
	.addStringOption((option) =>
		option.setName("swift").setDescription("Swift code")
	);

export async function execute(interaction: ChatInputCommandInteraction) {
	await interaction.deferReply({ ephemeral: true });

	const options = interaction.options;
	const name = options.getString("name");
	const phone = options.getString("phone");
	const email = options.getString("email");
	const address = options.getString("address");
	const iban = options.getString("iban");
	const swift = options.getString("swift") ?? "";

	const [addrl1, addrl2, postcode] = segmentAddress(address!);

	const gardener = new Gardener({
		discordID: interaction.user.id,
		name: name,
		phone: phone,
		email: email,
		addrl1: addrl1,
		addrl2: addrl2,
		postcode: postcode,
		iban: iban,
		swift: swift,
	});

	await gardener.save();
	await interaction.editReply({
		content: "Gardener successfully registered",
	});
}

function segmentAddress(address: string): [string, string, string] {
	const segmentedAddress = address.split(">");
	const addrl1 = segmentedAddress[0];
	const addrl2 = segmentedAddress[1];
	const postcode = segmentedAddress[2];
	return [addrl1, addrl2, postcode];
}
