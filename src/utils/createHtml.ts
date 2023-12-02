import * as fs from "fs";
import * as path from "path";
import * as pug from "pug";

/**
 * Generate HTML
 * @param {Map<String, any[]>} invoiceData - Invoice data taken from mongoDB
 */
export const generateInvoiceHtml = async (
	invoiceData: Map<string, any[]>,
	endDate: Date
) => {
	const compiledHtml = pug.compileFile(
		path.join(__dirname, "../../pages/invoice.pug")
	);

	try {
		let dotaEventsWorked = [];
		let csEventsWorked = [];
		let otherEventsWorked = [];
		let totalHours = 0;

		for (let dotaEvent of invoiceData.get("Dota")!) {
			dotaEventsWorked.push(dotaEvent);
			totalHours += dotaEvent.hours;
		}
		for (let csEvent of invoiceData.get("CS")!) {
			csEventsWorked.push(csEvent);
			totalHours += csEvent.hours;
		}
		for (let otherEvent of invoiceData.get("Other")!) {
			otherEventsWorked.push(otherEvent);
			totalHours += otherEvent.hours;
		}

		if (doesFileExists(path.join(__dirname, "../../pages/invoice.html"))) {
			console.log("Deleting old file");
			fs.unlinkSync(path.join(__dirname, "../../pages/invoice.html"));
		}
		fs.writeFileSync(
			path.join(__dirname, "../../pages/invoice.html"),
			compiledHtml({
				dotaEventsWorked: dotaEventsWorked,
				csEventsWorked: csEventsWorked,
				otherEventsWorked: otherEventsWorked,
				totalHours: totalHours,
				endDate: endDate,
			})
		);

		console.log("Generated HTML Invoice");
		return "Generate HTML Successful";
	} catch (err) {
		console.error("createHtml error: ", err);
		return "Error generating HTML";
	}
};

function doesFileExists(filePath: string): boolean {
	try {
		fs.statSync(filePath);
		return true;
	} catch (err) {
		console.error("doesFileExists error: ", err);
		return false;
	}
}
