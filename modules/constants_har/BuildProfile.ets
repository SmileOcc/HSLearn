/**
 * Use these variables when you tailor your ArkTS code. They must be of the const type.
 */
export const HAR_VERSION = '1.0.0';
export const BUILD_MODE_NAME = 'default';
export const DEBUG = true;
export const TARGET_NAME = 'default';
export const IS_PRODUCTION = false;
export const URL_BASE = 'https://*';

/**
 * BuildProfile Class is used only for compatibility purposes.
 */
export default class BuildProfile { 
	static readonly HAR_VERSION = HAR_VERSION;
	static readonly BUILD_MODE_NAME = BUILD_MODE_NAME;
	static readonly DEBUG = DEBUG;
	static readonly TARGET_NAME = TARGET_NAME;
	static readonly IS_PRODUCTION = IS_PRODUCTION;
	static readonly URL_BASE = URL_BASE;
}