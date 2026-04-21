const fs = require('fs');
let content = fs.readFileSync('AGENTS.md', 'utf8');

// Fix MD060: tables without spaces around pipes, eg: |foo|bar|
// We specifically target the markdown table definitions that we see.
content = content.replace(/\|([-:]+)\|/g, '| $1 |');
content = content.replace(/\|([-:]+)\|([-:]+)\|/g, '| $1 | $2 |');
content = content.replace(/\|([-:]+)\|([-:]+)\|([-:]+)\|/g, '| $1 | $2 | $3 |');

// But also fix lines like |foo|bar|
content = content.replace(/\|([^\s\|][^\|]*[^\s\|])\|/g, '| $1 |');

// Fix MD037: no spaces in emphasis
content = content.replace(/\*\-model\*\.xml/g, '`*-model*.xml`');
content = content.replace(/\*\-context\.xml/g, '`*-context.xml`');
content = content.replace(/\*\.bpmn/g, '`*.bpmn`');
content = content.replace(/\*\-workflow\-model\.xml/g, '`*-workflow-model.xml`');

// Fix MD040: default empty fences to `text`
content = content.replace(/^```\s*$/gm, '```text');

// Fix duplicate headings reported by IDE by making them unique or removing them
// IDE reported multiple headings around 510, 580, 587, 598, 632
// Let's assume there's '## Deployment Boundary' and '### Deployment Boundary'.
let headings = {};
let lines = content.split('\n');
for (let i = 0; i < lines.length; i++) {
    let m = lines[i].match(/^(#+)\s+(.*)$/);
    if (m) {
        let level = m[1];
        let text = m[2].trim();
        // Skip root ones, but for lower levels we can dedup
        let key = text.toLowerCase();
        if (headings[key] && !lines[i].includes('Agent Skills') && !lines[i].includes('Forbidden Patterns') ) {
            // make it unique safely
            lines[i] = level + ' ' + text + ' (Continued)';
        } else if (headings[key]) {
             if (text.includes('Forbidden Patterns') && i > 600) {
                 // it's the duplicate "Forbidden Patterns" heading ... wait, didn't I fix that?
             }
             lines[i] = level + ' ' + text + ' (More)';
        }
        headings[key] = true;
    }
}
fs.writeFileSync('AGENTS.md', lines.join('\n'));
