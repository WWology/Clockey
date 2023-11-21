import Gardener from "./gardener.model";
export const getGardener = async (discordID: string) => {
	const gardener = await Gardener.findOne({ discordID: discordID }).lean();
	return gardener;
};
