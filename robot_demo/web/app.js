"use strict";
const byId = id => document.getElementById(id);
const canvas = byId("world"), ctx = canvas.getContext("2d");
let busy = false, commandPending = false;
function text(id, value) { byId(id).textContent = value; }
function draw(s) {
  const w = s.world, p = s.pose, r = s.parameters.radius_m;
  canvas.height = Math.round(canvas.width * w.height / w.width);
  const k = canvas.width / w.width;
  ctx.save(); ctx.scale(k, -k); ctx.translate(0, -w.height);
  ctx.lineWidth = 1/k; ctx.strokeStyle = "#dce6eb";
  ctx.beginPath();
  for(let x=0; x<=w.width; x++) {ctx.moveTo(x,0);ctx.lineTo(x,w.height);}
  for(let y=0; y<=w.height; y++) {ctx.moveTo(0,y);ctx.lineTo(w.width,y);}
  ctx.stroke();ctx.fillStyle="#647583";
  for(const o of w.obstacles) ctx.fillRect(o.left,o.bottom,o.right-o.left,o.top-o.bottom);
  ctx.strokeStyle="#357ec5";ctx.lineWidth=2/k;ctx.beginPath();
  s.trace.forEach(([x,y],i)=>i ? ctx.lineTo(x,y):ctx.moveTo(x,y));ctx.stroke();
  const dx=Math.cos(p.heading),dy=Math.sin(p.heading);
  ctx.strokeStyle=s.clearance_m<=s.parameters.detection_distance_m+1e-9 ? "#d93636":"#58a89a";
  ctx.beginPath();ctx.moveTo(p.x+r*dx,p.y+r*dy);
  ctx.lineTo(p.x+(r+s.clearance_m)*dx,p.y+(r+s.clearance_m)*dy);ctx.stroke();
  ctx.fillStyle={forward:"#2aaf7e",turning:"#e8b237",paused:"#98a7b2"}[s.mode];
  ctx.strokeStyle="#183247";ctx.beginPath();ctx.arc(p.x,p.y,r,0,2*Math.PI);ctx.fill();ctx.stroke();
  ctx.beginPath();ctx.moveTo(p.x,p.y);ctx.lineTo(p.x+r*dx,p.y+r*dy);ctx.stroke();
  ctx.restore();ctx.strokeStyle="#183247";ctx.lineWidth=3;ctx.strokeRect(0,0,canvas.width,canvas.height);
  canvas.dataset.steps=String(s.steps);
}
function render(s) {
  draw(s);
  text("mode",{forward:"Geradeausfahrt",turning:"Drehung",paused:"Pausiert"}[s.mode]);
  text("time",`${s.time_s.toFixed(2)} s`);text("distance",`${s.distance_m.toFixed(2)} m`);
  text("turns",s.turns);text("seed",s.seed);text("pose",`${s.pose.x.toFixed(2)} / ${s.pose.y.toFixed(2)} m`);
  text("remaining",`${(s.remaining_turn_rad*180/Math.PI).toFixed(1)}°`);text("error",s.error || "");
  text("connection","Lokal verbunden");
  byId("resume").disabled=s.mode!=="paused" || !!s.error;
  byId("pause").disabled=s.mode==="paused";byId("reset").disabled=false;
}
async function request(path, options={}) {
  const response=await fetch(path,{cache:"no-store",...options});
  const data=await response.json();if(!response.ok) throw new Error(data.error || `HTTP ${response.status}`);
  return data;
}
function failure(error) {
  text("connection","Keine Verbindung — Server pausiert nach 2 Sekunden ohne Statusabruf.");
  text("error",error.message);["resume","pause","reset"].forEach(id=>byId(id).disabled=true);
}
async function command(command) {
  if(commandPending)return;commandPending=true;
  ["resume","pause","reset"].forEach(id=>byId(id).disabled=true);
  while(busy) await new Promise(resolve=>setTimeout(resolve,5));
  busy=true;
  try {render(await request("/api/command",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({command})}));}
  catch(error){failure(error);}finally{busy=false;commandPending=false;}
}
for(const name of ["resume","pause","reset"]) byId(name).addEventListener("click",()=>command(name));
async function poll() {
  if(!busy && !commandPending) {busy=true;try{render(await request("/api/state"));}catch(error){failure(error);}finally{busy=false;}}
  setTimeout(poll,100);
}
poll();
