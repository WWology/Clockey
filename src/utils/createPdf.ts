import * as fs from "fs";
import * as path from "path";
import * as puppeteer from "puppeteer";

export const generatePdf = async () => {
	try {
		console.log("Starting to generate PDF");
		const browser = await puppeteer.launch({
			headless: true,
			args: ["--no-sandbox"],
		});
		const page = await browser.newPage();
		await page.goto(
			"file://" + path.join(__dirname, "../../pages/invoice.html"),
			{
				waitUntil: "networkidle0",
			}
		);

		const pdf = await page.pdf({
			format: "LETTER",
			margin: {
				top: "48px",
				right: "48px",
				bottom: "48px",
				left: "48px",
			},
		});
		await browser.close();
		fs.writeFileSync(path.join(__dirname, "../../pages/invoice.pdf"), pdf);
		console.log("Generated PDF file");
	} catch (error) {
		console.error("generatePdf Error: ", error);
	}
};
