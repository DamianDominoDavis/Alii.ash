import <zlib.ash>

int voa = get_property("valueOfAdventure").to_int();
boolean[string] available_choices;

// tasker

void main(string settings) {
	// task keywords
	foreach key in $strings[
		ascend,
		coffee,
		cs,
		nightcap,
		pvp,
		smoke,
		sleep,
		stash,
		yachtzee
	] available_choices[key] = false;
	// abbreviations
	string[string] abbreviations = {
		"cloop":"coffee ascend cs smoke"
	};
	// parse settings
	foreach i,key in settings.to_lower_case().split_string(" ") {
		if (abbreviations contains key) {
			print(`Running choice {key}!`, "teal");
			foreach i,key in abbreviations[key].split_string(" ") {
				available_choices[key] = true;
				call void key();
			}
		}
		else if (available_choices contains key) {
			print(`Running choice {key}!`, "teal");
				available_choices[key] = true;
				call void key();
		}
	}
}

// define key tasks

void stash() {
	cli_execute("/whitelist The Consortium of the Syndicate of the Kingdom");
	waitq(2);
	foreach f in $familiars[left-hand man, disembodied hand]
		cli_execute("try; familiar "+f+"; unequip familiar;");
	outfit('birthday suit');
	foreach it in $items[Bag o Tricks, Crown of Thrones, defective Game Grid token, Pantsgiving, Platinum Yendorian Express Card, Spooky Putty sheet, Talisman of Baio, defective Game Grid token, haiku katana, mafia pointer finger ring]
		if (it.available_amount() > 0 && get_clan_name() == 'The Consortium of the Syndicate of the Kingdom' && it.stash_amount() < 1)
			cli_execute("try; stash put 1 " + it );
	cli_execute("/whitelist Cool Guy Crew");
	waitq(2);
}

void yachtzee() {
	void unlockSleazeAirport() {
		if (!get_property("_sleazeAirportToday").to_boolean()) {
			if (available_amount($item[one-day ticket to Spring Break Beach]) < 1)
				buy(1, $item[one-day ticket to Spring Break Beach], 400000);
			cli_execute("try; use one-day ticket to Spring Break Beach");
		}
	}
	cli_execute("/whitelist Cool Guy Crew");
 	waitq(2);
	cli_execute("try; acquire carpe");
	if (my_inebriety() > inebriety_limit()) {
		print("We're overdrunk. Running Garbo overdrunk turns.", "blue");
		cli_execute("garbo");
		return;
	}
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

	cli_execute("shop put -3 park garb @ 210;");
	cli_execute("use * gathered meat;");
	foreach it in $items[meat stack, dense meat stack, cheap sunglasses, expensive camera, fat stacks of cash, knob visor, embezzler oil]
		cli_execute(`autosell * {it}`);
	if (get_property("_stenchAirportToday").to_boolean())
		buy($coinmaster[The Dinsey Company Store], available_amount($item[Funfunds&trade;]) / 20, $item[One-day ticket to dinseylandfill]);
	if (get_property("_sleazeAirportToday").to_boolean())
		buy($coinmaster[Buff Jimmys Souvenir Shop], available_amount($item[Beach Buck]) / 100, $item[one-day ticket to Spring Break Beach]);
	stash();
}

void pvp() {
	cli_execute('/wl cool guy crew');
	cli_execute("familiar left;");
	cli_execute("unequip familiar;");
	cli_execute("outfit nothing;");
	set_location($location[noob cave]);
	cli_execute("maximize hat,shirt,pants,da; maximize -hat,-shirt,-pants,hot damage, hot spell damage;");
	cli_execute("pvp loot Hot;");
}

void nightcap() {
	cli_execute("familiar stooper;");
	cli_execute("shrug ur-kel;");
	cli_execute("shrug polka of plenty;");
	cli_execute("cast 2 ode to booze;");
	cli_execute("drink stillsuit distillate;");
	cli_execute(`consume all nomeat nightcap value {voa} valuepvp {voa};`.to_upper_case());
}

void coffee() {
	cli_execute('git update; svn update;');
	mall_prices('allitems');
	print("Aftercore day, start to finish", "teal");
	cli_execute("ptrack add coffeeBegin");
	cli_execute("/whitelist Cool Guy Crew");
	cli_execute("secondbreakfast");
	yachtzee();
	nightcap();
	yachtzee();
	pvp();
	cli_execute("ptrack add coffeeEnd");
}

void ascend() {
	if (my_inebriety() <= inebriety_limit())
		abort("You have not nightcapped yet! Overdrink and burn turns, then run again!");
	if (my_adventures() > 0)
		abort("You have nightcapped, but have turns remaining! Burn turns, then run again!");
	wait(5);
	cli_execute("c2t_ascend"); //c2t call to ascend. Change settings via the relay page.
	visit_url("choice.php"); //think I still need to click thru the choice adv
	run_choice(1);
	visit_url("peevpee.php?action=smashstone&pwd&confirm=on", true);
}

void cs() {
	print("Running CS!", "teal");
	print("ptrack add csBegin");
	cli_execute("c2t_hccs");
	cli_execute("prism");
	cli_execute("acquire deep dish of legend, calzone of legend, pizza of legend");
}

void smoke() {
	print("Running garbo and ending the day off!", "teal");
	cli_execute("ptrack add smokeBegin");
	yachtzee();
	nightcap();
	yachtzee();
	pvp();
	cli_execute("ptrack add smokeEnd");	
}

void sleep() {
	retrieve_item($item[Burning cape]);
	if (available_amount($item[clockwork maid]) < 1)
		cli_execute(`try; mallbuy clockwork maid @{voa * 8}`);
	cli_execute("try; use Clockwork Maid;");
	stash();
	cli_execute("familiar left;");
	cli_execute("unequip familiar;");
	cli_execute("outfit nothing;");
	cli_execute("maximize 1.1 adv, fites;");
	cli_execute("3d_itemguard;");
	cli_execute("pTrack recap");
	print("Done!", "teal");
}
