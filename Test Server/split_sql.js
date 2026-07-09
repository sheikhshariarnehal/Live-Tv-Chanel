const fs = require('fs');
const path = require('path');

const sqlContent = fs.readFileSync('insert_reborn_sports.sql', 'utf8');
const lines = sqlContent.split('\n');

const maxLines = 750;
let currentChunk = [];
let chunkIndex = 0;

const scratchDir = 'C:\\Users\\sheik\\.gemini\\antigravity-ide\\brain\\28670084-18c8-4cb6-91c1-92200f8f07ed\\scratch';
if (!fs.existsSync(scratchDir)) {
    fs.mkdirSync(scratchDir, { recursive: true });
}

for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    
    // If we've reached the threshold and the current line is a safe splitting point (e.g., starts with INSERT or is a comment)
    if (currentChunk.length >= maxLines && (line.startsWith('INSERT INTO') || line.startsWith('--') || line.trim() === '')) {
        const chunkPath = path.join(scratchDir, `sql_chunk_${chunkIndex}.sql`);
        fs.writeFileSync(chunkPath, currentChunk.join('\n'));
        console.log(`Saved chunk ${chunkIndex} with ${currentChunk.length} lines.`);
        chunkIndex++;
        currentChunk = [];
    }
    
    currentChunk.push(line);
}

// Write the last chunk
if (currentChunk.length > 0) {
    const chunkPath = path.join(scratchDir, `sql_chunk_${chunkIndex}.sql`);
    fs.writeFileSync(chunkPath, currentChunk.join('\n'));
    console.log(`Saved chunk ${chunkIndex} with ${currentChunk.length} lines.`);
}
