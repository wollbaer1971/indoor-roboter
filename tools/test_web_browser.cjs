/* Actual Chromium integration test. Playwright is a test-only dependency. */
const {chromium} = require("playwright");
const {spawn} = require("node:child_process");
const assert = require("node:assert/strict");
const fs = require("node:fs");
const base = "http://127.0.0.1:18765";
const delay = ms => new Promise(resolve=>setTimeout(resolve,ms));
const child = spawn(process.env.PYTHON || "python3", ["-m","robot_demo.web_server","--port","18765"], {stdio:["ignore","pipe","inherit"]});
let browser;
async function state() {const r=await fetch(`${base}/api/state`);assert.equal(r.status,200);return r.json();}
async function main() {
  for(let i=0;i<100;i++) {
    try {await state();break;}catch(error){if(i===99)throw error;await delay(100);}
  }
  browser=await chromium.launch({headless:true});
  const page=await browser.newPage({viewport:{width:1280,height:1000}});
  const errors=[];page.on("pageerror",error=>errors.push(error.message));
  await page.goto(base);
  await page.waitForFunction(()=>document.getElementById("mode").textContent==="Pausiert");
  assert.equal((await state()).steps,0);
  const pixels=await page.locator("canvas").evaluate(canvas=>{
    const data=canvas.getContext("2d").getImageData(0,0,canvas.width,canvas.height).data;
    let filled=0;for(let i=3;i<data.length;i+=4) if(data[i])filled++;return filled;
  });
  assert.ok(pixels>10000,"Actual world/obstacle/robot pixels must be drawn");
  await page.locator("#resume").click();
  await page.waitForFunction(()=>document.getElementById("mode").textContent==="Drehung",{},{timeout:15000});
  await page.locator("#pause").click();
  await page.waitForFunction(()=>document.getElementById("mode").textContent==="Pausiert");
  const paused=await state();
  assert.notEqual(paused.remaining_turn_rad,0,"Pause must interrupt a real turn");
  await delay(350);
  const still=await state();
  for(const field of ["pose","steps","time_s","remaining_turn_rad","operation_id","turns"])
    assert.deepEqual(still[field],paused[field],`Pause preserves ${field}`);
  await page.locator("#resume").click();
  await page.waitForFunction(()=>document.getElementById("mode").textContent!=="Pausiert");
  const resumed=await state();assert.equal(resumed.operation_id,paused.operation_id);
  // Interrupt only browser polling: no direct state request during lease expiry.
  await page.route("**/api/state",route=>route.abort());
  await delay(2600);
  assert.equal((await state()).mode,"paused","Loss of polling must pause server");
  await page.unroute("**/api/state");
  await page.waitForFunction(()=>document.getElementById("connection").textContent==="Lokal verbunden");
  assert.equal((await state()).mode,"paused","Reconnection must not resume");
  await page.locator("#reset").click();
  await page.waitForFunction(()=>document.getElementById("world").dataset.steps==="0");
  const reset=await state();assert.equal(reset.steps,0);assert.equal(reset.mode,"paused");
  assert.equal(reset.pose.x,1);assert.equal(reset.pose.y,1);assert.equal(reset.seed,7);
  fs.mkdirSync("web-test-results",{recursive:true});
  await page.screenshot({path:"web-test-results/browser-desktop.png",fullPage:true});
  await page.setViewportSize({width:390,height:844});
  assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),true,"Mobile layout must fit");
  await page.screenshot({path:"web-test-results/browser-mobile.png",fullPage:true});
  assert.deepEqual(errors,[]);
  console.log("WEB BROWSER PASS: actual Canvas, turn, pause, manual resume, disconnect, reconnect, reset, mobile layout; no JS errors");
}
main().catch(error=>{console.error(error);process.exitCode=1;}).finally(async()=>{
  if(browser)await browser.close();
  child.kill("SIGTERM");
});
