import numbro from "numbro";

/**
 * Abbreviates numbers greater than 1000
 */
export function abbreviate(toAbbreviate: number): string {
	if (toAbbreviate < 1000) {
		return `${toAbbreviate}`
	} else {
		return numbro(toAbbreviate).format({ average: true, totalLength: 2 });
	}
}