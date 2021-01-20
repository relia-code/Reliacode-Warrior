"use strict";

const fs = require("fs");
const path = require("path");

const MAIN_FILE_NAME = "[Reliacode] Warrior.lua";
const MAIN_FILE_PATH = path.resolve(process.cwd(), MAIN_FILE_NAME);

const WARRIOR_PATH = path.resolve("./src/Warrior.lua");
const WARRIOR_CODE = fs.readFileSync(WARRIOR_PATH, "utf8");

const PROFILE_UI_CODE_PATH = path.resolve("./src/ProfileUI.lua");
const PROFILE_UI_CODE = fs.readFileSync(PROFILE_UI_CODE_PATH, "utf8");

const DYNAMIC_BAR_CODE_PATH = path.resolve("./src/DynamicBar.lua");
const DYNAMIC_BAR_CODE = fs.readFileSync(DYNAMIC_BAR_CODE_PATH, "utf8");

const ARMS_CODE_PATH = path.resolve("./src/Arms.lua");
const ARMS_CODE = fs.readFileSync(ARMS_CODE_PATH, "utf8");

const INTERRUPT_CODE_PATH = path.resolve("./src/Interrupts.lua");
const INTERRUPT_CODE = fs.readFileSync(INTERRUPT_CODE_PATH, "utf8");

const SHAREDLIB_CODE_PATH = path.resolve("./src/SharedLib.lua");
const SHAREDLIB_CODE = fs.readFileSync(SHAREDLIB_CODE_PATH, "utf8");

if (fs.existsSync(MAIN_FILE_PATH)) {
  fs.rmSync(MAIN_FILE_PATH);
}

const finalCode = WARRIOR_CODE.replace(
  /\"\{\{PROFILE_UI_CODE\}\}\"/,
  JSON.stringify(PROFILE_UI_CODE)
)
  .replace(/\"\{\{DYNAMIC_BAR_CODE\}\}\"/, JSON.stringify(DYNAMIC_BAR_CODE))
  .replace(/\"\{\{ARMS_CODE\}\}\"/, JSON.stringify(ARMS_CODE))
  .replace(/\"\{\{INTERRUPT_CODE\}\}\"/, JSON.stringify(INTERRUPT_CODE))
  .replace(/\"\{\{SHAREDLIB_CODE\}\}\"/, JSON.stringify(SHAREDLIB_CODE));

fs.writeFileSync(MAIN_FILE_PATH, finalCode);

if (!fs.existsSync(MAIN_FILE_PATH)) {
  console.error(`Unable to find built ${MAIN_FILE_PATH}`);
  process.exit(1);
}

const newCode = fs.readFileSync(MAIN_FILE_PATH, "utf8");

if (WARRIOR_CODE === newCode) {
  console.error(`Failed to template ${MAIN_FILE_PATH}`);
  process.exit(1);
}

process.exit(0);
