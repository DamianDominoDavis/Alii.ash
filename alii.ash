import <zlib.ash>

boolean[string] available_choices;

void main(string settings) {
	// task keywords
	foreach task in $strings[
		coffee,
		ascend,
//		gyou,
		cs,
//		lunch,
		smoke,
		sleep
	] available_choices[task] = false;
	// abbreviations
	string[string] abbreviations = {
		"cloop":"coffee ascend cs lunch smoke"
	};
	// parse settings
	foreach i,key in settings.to_lower_case().split_string(" ") {
		if (abbreviations contains key) {
			print(`Running choice {key}!`, "teal");
			foreach i,task in abbreviations[key].split_string(" ")
				available_choices[task] = true;
		}
		else if (available_choices contains key) {
			print(`Running choice {key}!`, "teal");
			available_choices[key] = true;
		}
	}
	// selected tasks run in this order:
	foreach task in $strings[coffee, ascend, gyou, cs, lunch, smoke, sleep]
		if (available_choices[task])
			call void task();
}

void yachtzee() {
	void unlockSleazeAirport() {
		if (!get_property("_sleazeAirportToday").to_boolean()) {
			if (available_amount($item[one-day ticket to Spring Break Beach]) < 1)
				buy(1, $item[one-day ticket to Spring Break Beach], 400000);
			cli_execute("try; use one-day ticket to Spring Break Beach");
		}
	}

	cli_execute("try; acquire carpe");
	if (my_inebriety() > inebriety_limit()) {
		print("We're overdrunk. Running Garbo overdrunk turns.", "blue");
		cli_execute("garbo");
		return;
	}
//	else if (get_property("ascensionsToday").to_int() > 0 && available_choices["gyou"]) {
//			print("We have ascended today and it was a gyou run. We will not Yachtzeechain this leg.", "blue");
//			cli_execute("garbo");
//	}
	else if (get_property("ascensionsToday").to_int() > 0 && available_choices["cs"]) {
		print("We have ascended today, and it was a CS run. We will Yachtzeechain this leg.", "blue");
		unlockSleazeAirport();
		cli_execute("garbo yachtzeechain");
	}
	else {
		print("We have not ascended today. Breakfast leg always does Yachtzee!", "blue");
		unlockSleazeAirport();
		cli_execute("garbo yachtzeechain ascend workshed=cmc");
	}

	// stash
	cli_execute("/whitelist The Consortium of the Syndicate of the Kingdom");
	waitq(2);
	foreach it in $items[Bag o Tricks, Crown of Thrones, defective Game Grid token, Pantsgiving, Platinum Yendorian Express Card, Spooky Putty sheet, Talisman of Baio, defective Game Grid token, haiku katana, mafia pointer finger ring]
		if (it.available_amount() > 0 && get_clan_name() == 'The Consortium of the Syndicate of the Kingdom') && it.stash_amount() < 1)
			cli_execute("try; stash put 1 " + it );
	// shop
	cli_execute("shop put -3 park garb @ 210;");
	// spend
	cli_execute("use * gathered meat;");
	// sell
	foreach it in $items[meat stack, dense meat stack, cheap sunglasses, expensive camera, fat stack of cash, knob visor, embezzler oil]
		cli_execute(`autosell * {it}`);
	// supply
	if (get_property("_stenchAirportToday").to_boolean())
		buy($coinmaster[The Dinsey Company Store], available_amount($item[Funfunds&trade;]) / 20, $item[One-day ticket to dinseylandfill]);
	if (!get_property("_sleazeAirportToday").to_boolean())
		buy($coinmaster[Buff Jimmy's Souvenir Shop], available_amount($item[Beach Buck]) / 100, $item[one-day ticket to Spring Break Beach]);
}

void coffee() {
	int voa = get_property("valueOfAdventure").to_int();
	print("Aftercore day, start to finish", "teal");
	cli_execute("ptrack add coffeeBegin");
	cli_execute("/whitelist cgc");
	cli_execute("secondbreakfast");
	if (!get_property("_essentialTofuUsed").to_boolean()) {
		print("Tofu unused! Trying to buy some!", "teal");
		buy(1, $item[essential tofu], voa * 4);
		if (available_amount($item[essential tofu]) > 0)
			use(1, $item[Essential Tofu]);
	}
	yachtzee();
	cli_execute("shrug ur-kel");
	cli_execute("drink stillsuit distillate");
	cli_execute(`consume all nomeat nightcap value {voa} valuepvp {voa};`.to_upper_case());
	yachtzee();
}

void ascend() {
	if (my_inebriety() <= inebriety_limit())
		abort("You have not nightcapped yet! Overdrink and burn turns, then run again!");
	if (my_adventures() > 0)
		abort("You have nightcapped, but have turns remaining! Burn turns, then run again!");
//	print("Jumping through the Gash!", "teal");
//	if (available_choices["gyou"])
//		set_property("c2t_ascend", "2,27,2,44,8,5046,5039,2,0");
//	else if (available_choices["cs"])
//		set_property("c2t_ascend", "2,3,2,25,2,5046,5040,2,0");
	wait(5);
	cli_execute("c2t_ascend"); //c2t call to ascend. Change settings via the relay page.
	visit_url("choice.php"); //think I still need to click thru the choice adv
	run_choice(1);
	visit_url("peevpee.php?action=smashstone&pwd&confirm=on", true);
}

void gyou() {
	print("Running gyou!", "teal");
	cli_execute("ptrack add gyouBegin");
	cli_execute("loopgyou");
	if (my_adventures() > 40)
		abort();
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
	cli_execute("c2t_hccs");
	cli_execute("prism");
	cli_execute("acquire deep dish of legend, calzone of legend, pizza of legend");
}

void lunch() {
	print("Having a bite and leveling up!", "teal");
	cli_execute("hagnk all");
	cli_execute("ptrack add lunchBegin");
	cli_execute("/whitelist cgc");
	// cli_execute("levelup");
	// cli_execute("PandAliisza 5");//call using random low number of adventures remaining, but more than 0 for testing
	// drink($item[Steel margarita]);
	//janky handling of using shotglass to make use of the +5 turns from blender before swapping to Wombat.
	if (!get_property("_mimeArmyShotglassUsed").to_boolean() && my_sign() == "Blender") {
		if (available_amount($item[astral six-pack]) > 0)
			use($item[astral six-pack]);
		drink(1, $item[astral pilsner]);
	}
}

void smoke() {
	print("Running garbo and ending the day off!", "teal");
	cli_execute("ptrack add smokeBegin");
	yachtzee();
	cli_execute("ptrack add smokeEnd");	
}

void sleep() {
	int voa = get_property("valueOfAdventure").to_int();
	retrieve_item($item[Burning cape]);
	if (available_amount($item[clockwork maid]) < 1)
		cli_execute(`try; buy clockwork maid @{voa * 8}`);
	cli_execute("try; use Clockwork Maid;");
	cli_execute('/wl cool guy crew');
	cli_execute("familiar left;");
	cli_execute("unequip familiar;");
	cli_execute("outfit nothing;");
	set_location($location[noob cave]);
	cli_execute("maximize hat,shirt,pants,da; maximize -hat,-shirt,-pants,hot damage, hot spell damage;");
	cli_execute("pvp loot Hot;");
	cli_execute("familiar stooper;");
	cli_execute("shrug ur-kel;");
	cli_execute("shrug polka of plenty;");
	cli_execute("cast 2 ode to booze;");
	cli_execute("drink stillsuit distillate;");
	cli_execute(`consume all nomeat nightcap value {voa} valuepvp {voa};`.to_upper_case());
	yachtzee();
	cli_execute("familiar left;");
	cli_execute("unequip familiar;");
	cli_execute("outfit nothing;");
	cli_execute("/whitelist cool guy crew");
	cli_execute("outfit nothing;");
	cli_execute("familiar left;");
	cli_execute("maximize 1.1 adv, fites;");
	cli_execute("3d_itemguard;");
	cli_execute("pTrack recap");
	print("Done!", "teal");
}
