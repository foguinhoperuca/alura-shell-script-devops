const fs = require('fs');

const csvDatabase = 'database.csv';
const db = fs.readFileSync(csvDatabase, "utf-8");

function matchDb(regex) {
    const matchRegex = db.match(regex);
    console.log(matchRegex);
}

console.log('--- Match Anna');
//matchDb(/Anna/);

console.log('--- Match Phone');
const patternPhone = /\(\d+\)\s\d+-\d+/g;
// matchDb(patternPhone);
console.log('--- Match Phone Advanced');
const patternPhoneAdvanced = /\(\d{2}\)\s\d{4,5}-\d{4}/g;
// matchDb(patternPhoneAdvanced);

console.log('--- Match Custom Mobile');
const customPatternMobile = /\([0-9]{2}\) [0-9]{5}-[0-9]{4}/g;
// matchDb(customPatternMobile);
console.log('--- Match Mobile Advanced');
const patternCel = /\(\d{2}\)\s\d{5}-\d{4}/g;
// matchDb(patternCel);

console.log('--- Match CPF');
const patternCPF = /\d{3}[.-]?\d{3}[.-]?\d{3}[.-]?\d{2}/g
// matchDb(patternCPF);

console.log('--- Match date');
const patternDate = /\d{2}[.\/ ]?\d{2}[. \/ ]?\d{4}$/gm;
// matchDb(patternDate);

console.log('--- Match name');
const patternName = /^([A-Za-zÀ-ÿ]+)(?:\s([A-Za-zÀ-ÿ]+))+/gm
matchDb(patternName);
