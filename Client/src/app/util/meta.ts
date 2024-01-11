import { MetaDefinition } from "@angular/platform-browser";

export function generateTags(title: string, description: string, type: string, url: string, imageUrl: string, authorUrl?: string): MetaDefinition[] {
    let tags: MetaDefinition[] = [
        { name: "title", content: title },
        { name: "description", content: description },

        // Open Graph
        { property: "og:type", content: type },
        { property: "og:url", content: url },
        { property: "og:title", content: title },
        { property: "og:description", content: description },
        { property: "og:image", content: imageUrl },

        // Twitter
        { property: "twitter:card", content: "summary" },
        { property: "twitter:url", content: url },
        { property: "twitter:title", content: title },
        { property: "twitter:description", content: description },
        { property: "twitter:image", content: imageUrl },
    ];

    if (authorUrl) {
        if (type === "book") {
            tags.push({ property: "book:author", content: authorUrl });
        } else if (type === "article") {
            tags.push({ property: "article:author", content: authorUrl });
        }
    }

    return tags;
}
