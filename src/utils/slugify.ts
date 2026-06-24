export function slugify(text: string | number): string {
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '-')
    .replace(/[^\w\-]+/g, '')
    .replace(/\-\-+/g, '-')
    .replace(/^-+/, '')
    .replace(/-+$/, '');
}

export function getChannelSlug(channel: { id: string; name: string }): string {
  const nameSlug = slugify(channel.name);
  const id = channel.id;
  if (id.startsWith(nameSlug) || id.endsWith(nameSlug)) {
    return id;
  }
  return `${nameSlug}-${id}`;
}
