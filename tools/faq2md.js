/* 

1. Copy this into a JS console on the FAQ page

```
var faq = []; var currentSection, currentQuestion;
[...document.querySelector("#root > div > div").children].forEach((el) => {
switch (el.tagName) {
  case "H1": 
    currentSection = {title: el.innerText, children: []};
    faq.push(currentSection);
    break;
  case "H5":
    currentQuestion = {title: el.innerText, children: []};
    currentSection.children.push(currentQuestion)
    break;
  case "P":
    currentQuestion.children.push(el.innerHTML);
}
});
console.log(JSON.stringify(faq, undefined, 2));
```

2. Copy output to faq.json
3. run this script
*/

var TurndownService = require('turndown')
var faq = require("./faq.json");
var {writeFileSync} = require("fs");

var turndownService = new TurndownService()


faq.forEach((section) => {
  section.children.forEach((question) => {
    question.children = question.children.map(turndownService.turndown.bind(turndownService)).join("\n\n");
  });
});

console.log(faq);
writeFileSync("faqmd.json", JSON.stringify(faq, undefined, 2));
