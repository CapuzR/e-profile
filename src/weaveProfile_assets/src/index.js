import { weaveProfile } from "../../declarations/weaveProfile";

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  // Interact with weaveProfile actor, calling the greet method
  const greeting = await weaveProfile.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
