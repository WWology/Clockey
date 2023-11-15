"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const discord_js_1 = require("discord.js");
const commands_1 = require("./commands");
const config_1 = require("./config");
const deploy_commands_1 = require("./deploy_commands");
const client = new discord_js_1.Client({
    intents: ["Guilds", "GuildMessages", "DirectMessages"],
});
client.once("ready", () => {
    console.log("Clockey ready ⏰");
});
client.on("guildCreate", async (guild) => {
    await (0, deploy_commands_1.deployCommands)({ guildId: guild.id });
});
client.on("interactionCreate", async (interaction) => {
    if (!interaction.isCommand()) {
        return;
    }
    const { commandName } = interaction;
    if (commands_1.commands[commandName]) {
        commands_1.commands[commandName].execute(interaction);
    }
});
client.login(config_1.config.CLOCKEY_TOKEN);
//# sourceMappingURL=index.js.map