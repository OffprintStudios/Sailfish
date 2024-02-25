import { Roles } from "$lib/models/accounts";
import toast from "svelte-french-toast";
import slug from "slug";
import numbro from "numbro";

export function intersection<T>(a: T[], b: T[]): T[] {
    let t;
    if (b.length > a.length) t = b, b = a, a = t;
    return a.filter(function (e) {
        return b.indexOf(e) > -1;
    });
}

export function hasRoles(has: Roles[], needs: Roles[]): boolean {
    return intersection(has, needs).length !== 0;
}

export function throttle(
    func: (...args: unknown[]) => void,
    timeFrame: number
): (...args: unknown[]) => void {
    let lastTime = 0;
    return function (...args: unknown[]): void {
        const now: number = new Date().getTime();
        if (now - lastTime >= timeFrame) {
            func(...args);
            lastTime = now;
        }
    }
}

export function capitalize(text: string) {
    return text.charAt(0).toUpperCase() + text.slice(1);
}

export function slugify(value: string): string {
    return slug(value);
}

export function pluralize(value: number, suffix?: string): string {
    if (value === 0 || value > 1) {
        return suffix ?? 's';
    }
    return '';
}

export function abbreviate(value: number): string {
    if (value < 1000) {
        return `${value}`;
    } else {
        return numbro(value).format({ average: true, totalLength: 2 });
    }
}

export async function copyToClipboard(text: string) {
	await navigator.clipboard.writeText(text).then(() => {
		toast.success('Copied!');
	});
}

/* localeDate */
type dateFormat =
	| 'short'
	| 'shortDate'
	| 'shortTime'
	| 'medium'
	| 'mediumDate'
	| 'mediumTime'
	| 'long'
	| 'longDate'
	| 'longTime'
	| 'full'
	| 'fullDate'
	| 'fullTime';

/**
 * Takes a Date object or a string and produces a localized date in the desired format.
 * @param value
 * @param format
 */
export function localeDate(value: Date | string, format: dateFormat = 'short'): string {
	const date = new Date(value);
	let options: Intl.DateTimeFormatOptions;

	switch (format) {
		case 'short':
			options = {
				year: '2-digit',
				month: 'numeric',
				day: 'numeric',
				hour12: true,
				hour: 'numeric',
				minute: '2-digit',
			};
			break;
		case 'shortDate':
			options = { year: '2-digit', month: 'numeric', day: 'numeric' };
			break;
		case 'shortTime':
			options = { hour12: true, hour: 'numeric', minute: '2-digit' };
			break;
		case 'medium':
			options = {
				year: 'numeric',
				month: 'short',
				day: 'numeric',
				hour12: true,
				hour: 'numeric',
				minute: '2-digit',
				second: '2-digit',
			};
			break;
		case 'mediumDate':
			options = { year: 'numeric', month: 'short', day: 'numeric' };
			break;
		case 'mediumTime':
			options = { hour12: true, hour: 'numeric', minute: '2-digit', second: '2-digit' };
			break;
		case 'long':
			options = {
				year: 'numeric',
				month: 'long',
				day: 'numeric',
				hour12: true,
				hour: 'numeric',
				minute: '2-digit',
				second: '2-digit',
				timeZoneName: 'short',
			};
			break;
		case 'longDate':
			options = { year: 'numeric', month: 'long', day: 'numeric' };
			break;
		case 'longTime':
			options = {
				hour12: true,
				hour: 'numeric',
				minute: '2-digit',
				second: '2-digit',
				timeZoneName: 'short',
			};
			break;
		case 'full':
			options = {
				weekday: 'long',
				year: 'numeric',
				month: 'long',
				day: 'numeric',
				hour12: true,
				hour: 'numeric',
				minute: '2-digit',
				second: '2-digit',
				timeZoneName: 'long',
			};
			break;
		case 'fullDate':
			options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
			break;
		case 'fullTime':
			options = {
				hour12: true,
				hour: 'numeric',
				minute: '2-digit',
				second: '2-digit',
				timeZoneName: 'long',
			};
			break;
	}

	if (
		format === 'shortTime' ||
		format === 'mediumTime' ||
		format === 'longTime' ||
		format === 'fullTime'
	) {
		return date.toLocaleTimeString(undefined, options);
	} else {
		return date.toLocaleDateString(undefined, options);
	}
}
