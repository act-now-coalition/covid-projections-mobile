const app = require("express")();
const fetch = require("node-fetch");

const getPage = (path) => {
  return fetch(`https://www.covidactnow.org${path}`).then((r) => r.text())
};

app.get("**", async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  console.log(`${new Date()} - ${req.path}`);
  res.send(await getPage(req.path));
});


app.listen(8080);
