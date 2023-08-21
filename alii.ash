void main(string settings) {
	// task keywords
	boolean[string] available_choices;
	foreach task in $strings[
		coffee,
		ascend,
		gyou,
		cs,
		lunch,
		smoke
	] available_choices[task] = false;
	// abbreviations
	string[string] abbreviations = {
		# "all": "coffee ascend gyou cs lunch smoke",
		"post": "lunch smoke",
		"gloop":"coffee ascend gyou lunch smoke",
		"cloop":"coffee ascend cs smoke"
	};
	// parse settings
	foreach i,key in settings.split_string(" ") {
		if (abbreviations contains key.to_lower_case()) {
			print(`Running choice {key}!`, "teal");
			foreach i,task in abbreviations[key].split_string(" ")
				available_choices[task] = true;
		}
		else if (available_choices contains key.to_lower_case()) {
			print(`Running choice {key}!`, "teal");
			available_choices[key] = true;
		}
	}
	// selected tasks run in this order:
	foreach task in $strings[coffee, ascend, gyou, cs, lunch, smoke]
		if (available_choices[task])
			call void task();
}

void coffee() {
	print("Doing start-of-day activities!", "teal");
	cli_execute("ptrack add coffeeBegin");
	cli_execute("breakfast");
	cli_execute("/whitelist cgc");
	cli_execute("acquire carpe");

	if (!get_property("_essentialTofuUsed").to_boolean()) {
		print("Tofu unused! Trying to buy some!", "teal");
		buy(1, $item[essential tofu], get_property(to_int("valueOfAdventure")) * 4);
		if (item_amount($item[essential tofu]) > 0) {
			use(1, $item[Essential Tofu]);
		}
		else {
			print("Tofu is more expensive than would be vialble. Skipping Tofu.");
		}
	} /* FYI: Garbo usually doesn't use one of these, so free 5 adventures. Yay!*/
	yachtzee();
	cli_execute("shrug ur-kel");
	cli_execute("drink stillsuit distillate");
	cli_execute("CONSUME NIGHTCAP");
	yachtzee();
	print("Garbo finished running. Safely setting Yachtzee off.","blue");
}

void ascend() {
	print("Jumping through the Gash!", "teal");
	HandleC2T();
	wait(5);
	cli_execute("c2t_ascend"); //c2t call to ascend. Change settings via the relay page.
	visit_url("choice.php"); //think I still need to click thru the choice adv
	run_choice(1);
	/* **Former handling of ascending to gyou and picking astral items **
	visit_url("ascend.php?action=ascend&confirm=on&confirm2=on");
	visit_url("afterlife.php?action=pearlygates");
	visit_url("afterlife.php?action=buydeli&whichitem=5046" );
	visit_url("afterlife.php?action=buyarmory&whichitem=5039");
	print("Stepping into the Mortal Realm in 15 seconds without any perms! Press ESC to manually perm skills!", "teal");
	waitq(10);
	wait(5);
	visit_url("afterlife.php?action=ascend&confirmascend=1&whichsign=8&gender=2&whichclass=4&whichpath=44&asctype=2&nopetok=1&noskillsok=1&pwd", true);
	*/
}

void gyou() {
	print("Running gyou!", "teal");
	cli_execute("ptrack add gyouBegin");
	cli_execute("loopgyou");
	if (my_adventures() >= 41) {
		cli_execute("PandAliisza 40");//call using 40 as arg. Should execute script but stop when ever advs remaining is == 40
		//abort("We have more than 40 adventures remaining after the run! Please manually spend them down to 40 before breaking prism.");
	}
	print("Breaking the Prism in t-10 seconds", "teal");
	waitq(16);
	visit_url("place.php?whichplace=nstower&action=ns_11_prism");
	visit_url("main.php");
	run_choice(1); //Change number to pick class. 1=SC; 2=TT; 3=PM; 4=SA; 5=DB; 6=AT
	visit_url("main.php");
}

void cs() {
	print("Running CS!", "teal");
	print("ptrack add csBegin");
	cli_execute("lcswrapper");
	cli_execute("make deep dish of legend");
}

void lunch() {
	print("Having a bite and leveling up!", "teal");
	cli_execute("hagnk all");
	cli_execute("ptrack add lunchBegin");
	cli_execute("/whitelist cgc");
	cli_execute("acquire carpe");  //This is here becasue sometimes buffy be slow.
	cli_execute("levelup");
	cli_execute("PandAliisza 5");//call using random low number of adventures remaining, but more than 0 for testing
	drink($item[Steel margarita]);
	use($item[Asdon Martin keyfob]);
	//janky handling of using shotglass to make use of the +5 turns from blender before swapping to Wombat.
	if (!get_property("_mimeArmyShotglassUsed").to_boolean()) {
		print("We have not used shotglass yet.");
		if (item_amount($item[astral six-pack]) > 0) {
			use($item[astral six-pack]);
		}
		drink(1, $item[astral pilsner]);
	}
	else {
		print("We already used our shotglass...somehow. Big sad!");
	}
	//tuning to wombat
	if ((!get_property('moonTuned').to_boolean()) && (my_sign() != "Wombat") && (available_amount($item[Hewn moon-rune spoon]).to_boolean()) ) {
	foreach sl in $slots[acc1, acc2, acc3] {
		if (equipped_item(sl) == $item[Hewn moon-rune spoon]) {
			equip(sl, $item[none]);
		}
	}
	visit_url("inv_use.php?whichitem=10254&doit=96&whichsign=7");
	//monkey paw wishes cause garbo does silly things in post gyou leg
	visit_url("main.php?action=cmonk&pwd");
	foreach str in $strings["Frosty", "Sinuses for Miles", "Braaaaaains", "Frosty", "Sinuses for Miles"] {
		run_choice(1, `wish=${str}`);
	}
	visit_url("main.php");
}

void smoke() {
	print("Running garbo and ending the day off!", "teal");
	cli_execute("ptrack add smokeBegin");
	cli_execute("breakfast");
	cli_execute("/whitelist cgc");
	if (!available_amount($item[carpe])) {
		cli_execute("acquire carpe");
	}
		if (!get_property("_essentialTofuUsed").to_boolean()) {
			print("Tofu unused! Trying to buy some!", "teal");
			cli_execute(`buy essential tofu @{(get_property("valueOfAdventure").to_int() * 4)}`);
			if (item_amount($item[essential tofu]) > 0) {
				use(1, $item[Essential Tofu]);
			} else{
				print("Tofu is more expensive than would be vialble. Skipping Tofu.");
		}
	} //FYI: Garbo usually doesn't use one of these, so free 5 adventures. Yay!
	yachtzee();
	cli_execute("shrug ur-kel");
	cli_execute("CONSUME NIGHTCAP");
	retrieve_item($item[Burning cape]);
	//Buy as many day passes as Disney bucks and beach bucks allow
	if (get_property("_dinseyGarbageDisposed").to_boolean()) {
		buy($coinmaster[The Dinsey Company Store], floor((item_amount($item[Funfunds&trade;]) / 20)), $item[One-day ticket to dinseylandfill]);
	}
	if (get_property("_sleazeAirportToday").to_boolean()) {
		buy($coinmaster[Buff Jimmy's Souvenir Shop], floor((item_amount($item[Beach Buck]) / 100)), $item[One-day ticket to Spring Break Beach]);
	}
	if (item_amount($item[clockwork maid]) < 1) {
		cli_execute(`buy clockwork maid @{(get_property("valueOfAdventure").to_int() * 8)}`);
	}
	if (item_amount($item[Clockwork Maid]).to_boolean()) {
		use(1, $item[Clockwork Maid]);
	} /* Refrains from using a clockwork maid if you it's lower then 8x VOA */
	cli_execute("rollover management.ash");
	//Simplest jank way of ensuring that Sasq watch is equipped over ticksliver as I don't care about fites
	if (equipped_item($slot[acc3]) == $item[ticksilver ring]) {
		equip($slot[acc3], $item[Sasq&trade; watch]);
	}
	cli_execute("ptrack add smokeEnd");
	cli_execute("mallbuy 9999 surprisingly capacious handbag @ 120");
	cli_execute("mallbuy 9999 fireclutch @ 650");
	cli_execute("pTrack recap");
	put_closet(max(0, my_meat() - 10000000)); //Stash all but 10mil meat while saving up big numbers
	//max function returns whichever is higher. So in the case of less than 10mil, 0 is returned and nothing is closeted
	if (item_amount($item[navel ring of navel gazing]) > 0) {
		print("Returning ring to Noob.");
		kmail("Noobsauce", "Returning your ring.", 0, int[item] {$item[navel ring of navel gazing] : 1});
	}
	cli_execute("raffle 11");
	print("Done!", "teal");
}

void HandleC2T() {
	if (to_boolean(available_choices["gyou"])) {
		set_property("c2t_ascend", "2,27,2,44,8,5046,5039,2,0");
	}
	if (to_boolean(available_choices["cs"])) {
		set_property("c2t_ascend", "2,3,2,25,2,5046,5040,2,0");
	}
}

void yachtzee() {
	if (my_inebriety() > inebriety_limit()) {
		print("We're overdrunk. Running Garbo overdrunk turns.", "blue");
		cli_execute("garbo");
	}

	if (get_property(to_int("ascensionsToday") == 1)) {
		if (to_boolean(available_choices["gyou"])) {
			print("We have ascended today and it was a gyou run. We will not Yachtzeechain this leg.", "blue");
			cli_execute("garbo");
		}
		else {
			print("We have ascended today, and it was a CS run. We will Yachtzeechain this leg.", "blue");
			cli_execute("garbo yachtzeechain");
		}
	}
	else {
		print("We have not ascended today. Breakfast leg always does Yachtzee!", "blue");
		cli_execute("garbo yachtzeechain ascend workshed=cmc");
	}
}
