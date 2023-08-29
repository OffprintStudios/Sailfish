export function readingTime(wordcount: number): string {
    const val = Math.ceil(wordcount / 238);
    if (val > 60) {
        const hours = Math.ceil(val / 60);
        const min = val % 60;
        return `${hours} hours, ${min} minutes`;
    }
    return `${val} minutes`;
}