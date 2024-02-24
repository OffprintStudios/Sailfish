import { Roles } from "$lib/models/accounts";
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
