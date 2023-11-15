"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.config = void 0;
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const { CLOCKEY_TOKEN, CLOCKEY_ID, OG_GUILD_ID } = process.env;
if (!CLOCKEY_TOKEN || !CLOCKEY_ID) {
    throw new Error("Missing Environment variable");
}
exports.config = {
    CLOCKEY_TOKEN,
    CLOCKEY_ID,
    OG_GUILD_ID,
};
//# sourceMappingURL=config.js.map