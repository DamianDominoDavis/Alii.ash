import <zlib.ash>
void main(string settings) {

string[int] argument;
argument = split_string(settings, " ");

string[string] available_choices = {
  "coffee":"",
  "ascend":"",
  "gyou":"", 
  "lunch":"",
  "smoke":"", 
  "all":"",
  "post":"",
  "To make another option, copy another line of this and change just this text field":"",
};

foreach key in argument{  
  foreach it in available_choices{
    if(contains_text(to_lower_case(argument[key].to_string()), it)){
      print(`Running choice {it}!`, "teal");
      available_choices[it] = "true";
    }
  }
}

/* The above is just a fancy way of running multiple options at once haha. So you can run `alii coffee ascend gyou lunch smoke` all at once and take a nap after */

if (available_choices["all"].to_boolean()){
  print("Running All. Whole day loop has been activated!");
  foreach it in available_choices{
    available_choices[it] = "true";
  }
}

if (available_choices["post"].to_boolean()){
  print("Running post run leg. Lunch and Smoke enabled!");
  foreach it in $strings[lunch, smoke]{
    available_choices[it] = "true";
  }
}

if (available_choices["coffee"].to_boolean()) {
  print("Doing start-of-day activities!", "teal");
  cli_execute("ptrack add coffeeBegin"); 
  cli_execute("breakfast");
  cli_execute("acquire carpe");

  if(!get_property("_essentialTofuUsed").to_boolean()){ 
    print("Tofu unused! Trying to buy some!", "teal"); 
    cli_execute(`buy essential tofu @{(get_property("valueOfAdventure").to_int() * 4)}`);
    if (item_amount($item[essential tofu]) > 0) { 
      use(1, $item[Essential Tofu]); 
    } else{
      print("Tofu is more expensive than would be vialble. Skipping Tofu.");
    }
  } /* FYI: Garbo usually doesn't use one of these, so free 5 adventures. Yay!*/
  
  //monkey paw while garbo adds support
  //visit_url("main.php?action=cmonk&pwd"); foreach str in $strings["Frosty", "Sinuses for Miles", "Braaaaaains", "Frosty", "Sinuses for Miles"] { run_choice(1, `wish=${str}`); } visit_url("main.php");

  cli_execute("garbo ascend workshed=cmc");
  cli_execute("shrug ur-kel");
  cli_execute("drink stillsuit distillate");
  cli_execute("CONSUME NIGHTCAP");
  cli_execute("garbo ascend");
  }

if(available_choices["ascend"].to_boolean()){
  print("Ascending into gyou!", "teal");
  wait(5);
  visit_url("ascend.php?action=ascend&confirm=on&confirm2=on"); 

  visit_url("afterlife.php?action=pearlygates");
  visit_url("afterlife.php?action=buydeli&whichitem=5046" );
  visit_url("afterlife.php?action=buyarmory&whichitem=5039");

  print("Stepping into the Mortal Realm in 15 seconds without any perms! Press ESC to manually perm skills!", "teal");
  waitq(10); 
  wait(5);

  visit_url("afterlife.php?action=ascend&confirmascend=1&whichsign=8&gender=2&whichclass=4&whichpath=44&asctype=2&nopetok=1&noskillsok=1&pwd", true);
  visit_url("choice.php");
  run_choice(1);
  
}

if (available_choices["gyou"].to_boolean()) {
  print("Running gyou!", "teal");
  //cli_execute("ptrack add gyouBegin");
  cli_execute("loopgyou");
  if(my_adventures() > 40){
    abort("We have more than 40 adventures remaining after the run! Please manually spend them down to 40 before breaking prism.");
  }
  print("Breaking the Prism in t-10 seconds", "teal");
  waitq(16);
  visit_url("place.php?whichplace=nstower&action=ns_11_prism");
  visit_url("main.php");
  run_choice(1); // Club Seals! 
  visit_url("main.php");
}

if (available_choices["lunch"].to_boolean()) {
  print("Having a bite and leveling up!", "teal");
  cli_execute("hagnk all");
  cli_execute("ptrack add lunchBegin");
  cli_execute("acquire carpe");  /*This is here becasue sometimes buffy be slow.*/
  cli_execute("levelup");
  cli_execute("PandamoniumQuestAliiUpdate.ash");//testing updated quest logic
  drink($item[Steel margarita]);
  use($item[Asdon Martin keyfob]);
}

if (available_choices["smoke"].to_boolean()) {
  print("Running garbo and ending the day off!", "teal");
  cli_execute("ptrack add smokeBegin");
  cli_execute("breakfast");

  if(!get_property("_essentialTofuUsed").to_boolean()){ 
  print("Tofu unused! Trying to buy some!", "teal"); 
  cli_execute(`buy essential tofu @{(get_property("valueOfAdventure").to_int() * 4)}`);
  if (item_amount($item[essential tofu]) > 0) { 
    use(1, $item[Essential Tofu]); 
  } else{
    print("Tofu is more expensive than would be vialble. Skipping Tofu.");
    }
  } /* FYI: Garbo usually doesn't use one of these, so free 5 adventures. Yay!*/

  //janky handling of using shotglass to make use of the +5 turns from blender before swapping to Wombat.
  if(!get_property("_mimeArmyShotglassUsed").to_boolean()){
    print("We have not used shotglass yet.");
    use($item[astral six-pack]);
    drink(1, $item[astral pilsner]);
  }else{
    print("We already used our shotglass...somehow. Big sad!");
  }
  //tuning to wombat
  if((!get_property('moonTuned').to_boolean()) && (my_sign() == "Blender") && (available_amount($item[Hewn moon-rune spoon]).to_boolean()) ){
  foreach sl in $slots[acc1, acc2, acc3]{
    if(equipped_item(sl) == $item[Hewn moon-rune spoon]){
      equip(sl, $item[none]);
    }
  }
    visit_url("inv_use.php?whichitem=10254&doit=96&whichsign=7");
  }

  //monkey paw while garbo adds support
  visit_url("main.php?action=cmonk&pwd"); foreach str in $strings["Frosty", "Sinuses for Miles", "Braaaaaains", "Frosty", "Sinuses for Miles"] { run_choice(1, `wish=${str}`); } visit_url("main.php");

  cli_execute("garbo");
  cli_execute("shrug ur-kel");
  cli_execute("CONSUME NIGHTCAP");
  retrieve_item($item[Burning cape]);
  //Buy as many day passes as Disney bucks allow
  if(get_property("_dinseyGarbageDisposed").to_boolean()){
    buy($coinmaster[The Dinsey Company Store], (item_amount($item[Funfunds&trade;]) / 20), $item[One-day ticket to dinseylandfill]);
  }

  if(item_amount($item[clockwork maid]) < 1){
    cli_execute(`buy clockwork maid @{(get_property("valueOfAdventure").to_int() * 8)}`);
  }
  if(item_amount($item[Clockwork Maid]).to_boolean()) { 
    use(1, $item[Clockwork Maid]); 
  } /* Refrains from using a clockwork maid if you it's lower then 8x VOA */

  cli_execute("rollover management.ash");
  cli_execute("ptrack add smokeEnd");
  cli_execute("mallbuy 9999 surprisingly capacious handbag @ 120");
  cli_execute("mallbuy 9999 fireclutch @ 650");
  cli_execute("pTrack recap");
  
  if(item_amount($item[navel ring of navel gazing]) > 0){
    print("Returning ring to Noob.");
    kmail("Noobsauce", "Returning your ring.", 0, int[item] {$item[navel ring of navel gazing] : 1});
  }

cli_execute("raffle 11");
print("Done!", "teal");
}
}