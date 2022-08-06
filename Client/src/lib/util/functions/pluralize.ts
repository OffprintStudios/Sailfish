/**
 * Adds a plural suffix to a word to indicate either one or many of some value.
 * @param value
 * @param suffix
 */
export function pluralize(value: number, suffix?: string): string {
	if (suffix) {
		if (value === 0 || value > 1) {
			return suffix;
		} else {
			return '';
		}
	} else if (value === 0 || value > 1) {
		return 's';
	} else {
		return '';
	}
}