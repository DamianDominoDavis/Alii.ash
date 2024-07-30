import <zlib>

void main(string tasks) {
	// key tasks
	boolean[string] available_choices = $strings[
		coffee,
		gorb,
		stash,
		nightcap,
		pvp,
		ascend_cs,
		ascend_smol,
		ascend_yr,
		forcenightcap,
		sleep
	];

	// task patterns
	string[string] abbreviations = {
		"gorbday":	"coffee gorb nightcap",
		"leg1":		"gorbday gorb pvp",
		"leg2":		"gorbday pvp sleep",
		"loop_cs":	"leg1 ascend_cs leg2",
		"loop_smol":"leg1 ascend_smol leg2",
		"loop_yr":	"leg1 ascend_yr leg2",
	};

	// parser
	void run_task(string task) {
		if (abbreviations contains task)
			foreach _, subtask in split_string(abbreviations[task], " ")
				run_task(subtask);
		else if (available_choices contains task) {
			print("Running " + task + "!", "teal");
			call void task();
		}
		else
			abort(task + " is not a task.");
	}
	foreach _, task in split_string(to_lower_case(tasks), " ")
		run_task(task);
}

// support tasks

void get_nude() {
	foreach f in $familiars[left-hand man, disembodied hand, mad hatrack, fancypants scarecrow]
		if (have_familiar(f) && familiar_equipped_equipment(f) != $item[none])
			equip($item[none], f);
	outfit("nothing");
}

void change_clan(string clan) {
	if (find(create_matcher(to_lower_case(clan), to_lower_case(get_clan_name()))))
		return;
	chat_clan("/whitelist " + clan);
	waitq(2);
	if (!find(create_matcher(to_lower_case(clan), to_lower_case(get_clan_name())))) {
		cli_execute("chat");
		waitq(2);
		chat_clan("/whitelist " + clan);
		waitq(2);
		if (!find(create_matcher(to_lower_case(clan), to_lower_case(get_clan_name()))))
			abort("couldn't get home to " + clan);
	}
}

void resong(boolean[effect] gain) {
	void unsong(boolean[effect] except) {
		foreach e in $effects[Ode to Booze, Dirge of Dreadfulness, The Sonata of Sneakiness, Carlweather's Cantata of Confrontation, The Moxious Madrigal, Aloysius' Antiphon of Aptitude, The Magical Mojomuscular Melody, Cletus's Canticle of Celerity, Polka of Plenty, Power Ballad of the Arrowsmith, Brawnee's Anthem of Absorption, Fat Leon's Phat Loot Lyric, Psalm of Pointiness, Jackasses' Symphony of Destruction, Stevedave's Shanty of Superiority, Ur-Kel's Aria of Annoyance, Paul's Passionate Pop Song, Dirge of Dreadfulness (Remastered)]
			if (!(except contains e) && to_boolean(have_effect(e))) {
				cli_execute("shrug " + e);
				if (!to_boolean(have_effect(e)))
					return;
				abort("failed to remove active song "+e);
			}
	}
	int room = 3;
	foreach mod in $strings[four songs, additional song]
		if (boolean_modifier(mod))
			room += 1;
	if (room < count(gain))
		abort("neil cicirega you are not");
	foreach e in gain
		if (e.song && have_skill(to_skill(group_string(e.default, "cast 1 (.+)")[0][1])) && !to_boolean(have_effect(e))) {
			cli_execute(e.default);
			for _ from 1 to room
				if (!to_boolean(have_effect(e))) {
					unsong(gain);
					cli_execute(e.default);
				}
		}
}

boolean no_junkmail(kmessage m) {
	return ($strings[lady spookyraven's ghost, the loathing postal service, coolestrobot, fairygodmother, peace and love, torturebot, hermiebot, sellbot, botticelli, cat noir, onlyfax] contains to_lower_case(m.fromname));
}	


void fresh_hell(string c2t) {
	if (to_boolean(to_int(get_property("ascensionsToday"))))
		abort("one gash a night, buddy");
	if (my_inebriety() <= inebriety_limit())
		abort("overdrink first");
	if (to_boolean(my_adventures()))
		abort("turns remain");
	if (my_garden_type() != "thanksgarden")
		use($item[packet of thanksgarden seeds]);
	cli_execute("try; garden harvest");
		foreach it in $items[pizza of legend, calzone of legend, deep dish of legend, battery (car), battery (lantern), battery (AAA), battery (9-Volt), battery (D), battery (AA)]
		if (!to_boolean(available_amount(it)))
			create(it);
	foreach it in $items[baked veggie ricotta casserole, plain calzone, roasted vegetable focaccia, Boris's bread, roasted vegetable of Jarlsberg, Pete's rich ricotta]
		if (available_amount(it) < 3)
			create(3, it);
	foreach it in $items[ol' scratch's salad fork, frosty's frosty mug]
		retrieve_item(it);
	wait(5);
	set_property("c2t_ascend", c2t);
	cli_execute("c2t_ascend");
	if (!handling_choice())
		visit_url("choice.php");
	if (handling_choice())
		run_choice(1);
	cli_execute("backupcamera reverser enable");
	if (contains_text(visit_url("peevpee.php?action=smashstone&pwd&confirm=on", true), "Pledge allegiance to"))
		visit_url("peevpee.php?action=pledge&place=fight&pwd");
}

// key tasks

void stash() {
	change_clan("The Consortium of the Syndicate of the Kingdom");
	get_nude();
	foreach it in $items[Bag o' Tricks, Crown of Thrones, defective Game Grid token, Pantsgiving, Platinum Yendorian Express Card, Spooky Putty sheet, Talisman of Baio, defective Game Grid token, haiku katana, mafia pointer finger ring, bittycar meatcar, repaid diaper, incredibly dense meat gem]
		if (to_boolean(available_amount(it)) && to_lower_case(get_clan_name()) == "the consortium of the syndicate of the kingdom" && !to_boolean(stash_amount(it))) {
			retrieve_item(it);
			put_stash(1, it);
		}
	change_clan("Cool Guy Crew");
}

void pvp() {
	change_clan("Cool Guy Crew");
	get_nude();
	set_location($location[noob cave]);
	use_familiar($familiar[left-hand man]);
	maximize("-100 DA, item, shirt, hat, pants", false);
	maximize("-shirt, -hat, -pants, item, -equip champ", false);
	item it = equipped_item($slot[off-hand]);
	equip($item[none], $slot[off-hand]);
	equip(it, $slot[familiar]);
	maximize("-shirt, -hat, -pants, -familiar, item, -equip champ", false);
	if (to_boolean(pvp_attacks_left()))
		cli_execute("pvp fame optimal dresser");

	process_kmail("no_junkmail");
}

void coffee() {
	if (!can_interact() || to_boolean(get_property("_fireStartingKitUsed")))
		return;
	stash();
	mall_prices("allitems");
	if (!to_boolean(to_int(get_property("ascensionsToday"))))
		cli_execute("ptrack add start");
	set_property("_garbageItemChanged", "true");
	cli_execute("breakfast");
	if (11 < item_amount($item[raffle ticket]) + storage_amount($item[raffle ticket]) + closet_amount($item[raffle ticket]) + display_amount($item[raffle ticket]))
		cli_execute("raffle 11");
	foreach it in $items[hot wad, spooky wad, cold wad, sleaze wad, stench wad] {
		if (available_amount(it) < 3)
			cli_execute("try; make " + (3 - available_amount(it)) + " " + it);
		retrieve_item(3, it);
	}
	for _ from 1 to 3
		use_skill($skill[rainbow gravitation]);
	if (!to_boolean(get_property("_floundryItemCreated")))
		retrieve_item($item[carpe]);
	if (!to_boolean(get_property("_essentialTofuUsed"))) {
		buy(2 - available_amount($item[essential tofu]), $item[essential tofu], 4 * to_int(get_property("valueOfAdventure")));
		if (to_boolean(available_amount($item[essential tofu]))) {
			retrieve_item($item[essential tofu]);
			use($item[Essential Tofu]);
		}
	}
	if (familiar_equipped_equipment($familiar[crimbo shrub]) != $item[tiny stillsuit]) {
		retrieve_item($item[tiny stillsuit]);
		equip($item[tiny stillsuit], $familiar[crimbo shrub]);
	}
	visit_url("place.php?whichplace=campaway&action=campaway_sky");
	cli_execute("choice_by_label false");
	cli_execute("autoboxer");
	foreach trophy in $items[residual chitin paste]
		put_display(item_amount(trophy), trophy);
	if (to_int(get_property("_clanFortuneConsultUses")) < 3)
		for _ from to_int(get_property("_clanFortuneConsultUses")) to 2 {
			cli_execute("fortune coolestrobot salt batman thick");
			waitq(5);
		}
	cli_execute("backupcamera reverser enable");
	cli_execute("mallbuy confusing led clock");
	foreach it in $items[wardrobe-o-matic, csa fire-starting kit, confusing led clock] {
		retrieve_item(it);
		use(it);
	}
	visit_url("campground.php?action=rest");
	cli_execute("try; mayam resonance yamtility belt; mayam rings fur bottle cheese clock; mayam rings eye lightning yam explosion");
	if (to_boolean(available_amount($item[designer sweatpants]))) {
		int booze_casts = min(3, min(my_inebriety(), to_int(get_property("sweat")) / 25));
		use_skill(booze_casts, $skill[sweat out some booze]);
	}
	cli_execute("try; autumnaton upgrade");
	string[string] messages = {
		"Aliisza": "bagginses",
		"ShinyPlatypus": "are they turtley enough for the turtle club",
		"Zmonge": "I could live to be 100, and I will never type the name of this item correctly on the first go"
	};
	boolean[string, item] attachments = {
		"Aliisza": $items[designer handbag, fireclutch, surprisingly capacious handbag],
		"ShinyPlatypus": $items[box turtle, cardboard box turtle, chintzy turtle brooch, dueling turtle, furry green turtle, grinning turtle, ingot turtle, painted turtle, samurai turtle, samurai turtle helmet, sewer turtle, skeletortoise, sleeping wereturtle, soup turtle, syncopated turtle],
		"Zmonge": $items[Stuffed MagiMechTech MicroMechaMech]
	};
	foreach victim in messages {
		string kmail = "kmail ";
		boolean comma = false;
		foreach it in attachments[victim]
			if (it.tradeable && to_boolean(available_amount(it))) {
				retrieve_item(it, available_amount(it));
				if (comma)
					kmail += ", ";
				kmail += item_amount(it) + " " + it;
				comma = true;
			}
		if (comma)
			cli_execute(kmail + " to " + victim + " || " + messages[victim]);
	}
	pvp();
	cli_execute("3d_itemguard;");
}

void gorb() {
	change_clan("Cool Guy Crew");
	if (!to_boolean(get_property("_floundryItemCreated")))
		retrieve_item($item[carpe]);
	visit_url("place.php?whichplace=twitch");
	boolean beaten = true;
	boolean stuck = false;
	while (beaten) {
		string garbo = "garbo candydish";
		if (to_boolean(get_property("timeTowerAvailable")) && my_inebriety() < inebriety_limit())
			garbo += " nobarf";
		if (get_workshed() != $item[model train set])
			garbo += " workshed=mts";
		else
			garbo += " workshed=cmc";
		if (!to_boolean(to_int(get_property("ascensionsToday"))))
			garbo += " ascend";
		cli_execute("try; " + garbo);
		beaten = to_boolean(have_effect($effect[Beaten Up])) || starts_with(get_property("lastEncounter"), "Sssshh");
		if (to_boolean(get_property("garbo_interrupt"))) {
			if (stuck)
				abort("rerunning garbo didn't help");
			stuck = true;
			set_property("garbo_interrupt", "");
		}
		if (beaten)
			foreach s in $skills[Tongue of the Walrus, Cannelloni Cocoon]
				use_skill(s);
		stash();
		set_property("garboStashItems", "");
	}
	put_shop(210, 0, item_amount($item[bag of park garbage]) - 3, $item[bag of park garbage]);
	use($item[Gathered Meat-Clip], item_amount($item[Gathered Meat-Clip]));
	foreach it in $items[meat stack, dense meat stack, cheap sunglasses, expensive camera, fat stacks of cash, Knob Goblin visor, embezzler's oil]
		autosell(it, item_amount(it));
	if (to_boolean(get_property("_stenchAirportToday")) && available_amount($item[Funfunds&trade;]) >= 20) {
		retrieve_item($item[Funfunds&trade;], available_amount($item[Funfunds&trade;]));
		buy($coinmaster[The Dinsey Company Store], available_amount($item[Funfunds&trade;]) / 20, $item[One-day ticket to dinseylandfill]);
	}
	if (to_boolean(get_property("timeTowerAvailable")) && contains_text(get_property("_garboCompleted"), "nobarf"))
		cli_execute("chrono mode=rose turns=-0");
}

void forcenightcap() {
	if (my_inebriety() < inebriety_limit() || (my_inebriety() == inebriety_limit() && my_familiar() != $familiar[stooper]))
		cli_execute("drinksilent stillsuit distillate");
	use_familiar($familiar[stooper]);
	float voa = to_int(get_property("valueOfAdventure"));
	if (to_boolean(to_int(get_property("ascensionsToday"))))
		voa *= 0.75;
	resong($effects[ode to booze]);
	string consume = "consume all nomeat nightcap value " + get_property("valueOfAdventure") + " valuepvp " + to_int(voa);
	cli_execute(to_upper_case(consume));
}
void nightcap() {
	if (my_adventures() > 0)
		abort("still adventurous");
	forcenightcap();
}

void prism() {
	if (get_property("kingLiberated") != "true")
		abort("now's not the time for that, RED!");
	cli_execute("hagnk all; refresh all");
	equip_all_familiars();
	cli_execute("av-snapshot");
}

void ascend_cs() {
	if (my_path().id == 0)
		fresh_hell("2,1,1,25,2,5046,5040,2,0");
	if (my_path().id == 25) {
		cli_execute("lcswrapper");
		if (get_property("kingLiberated") != "true")
			abort("did not finish cs run");
	}
	string guildhall = visit_url("guild.php?place=challenge");
	if (!contains_text(guildhall, "paco")) {
		location chore = $location[The Outskirts of Cobb\'s Knob];
		if (my_primestat() == $stat[mysticality])
			chore = $location[The Haunted Pantry];
		if (my_primestat() == $stat[moxie])
			chore = $location[The Sleazy Back Alley];
		use_familiar($familiar[Frumious Bandersnatch]);
		resong($effects[Ode to Booze, Carlweather's Cantata of Confrontation, Musk of the Moose]);
		cli_execute("maximize 100 com, familiar weight");
		for _ from 1 to 8
			if (!($strings[Now's Your Pants! I Mean... Your Chance!, A Sandwich Appears!, Up In Their Grill] contains get_property("lastEncounter")))
				adv1(chore, 0, "runaway; abort;");
		guildhall = visit_url("guild.php?place=challenge");
		if (!contains_text(guildhall, "paco"))
			abort("did not open guild");
		retrieve_item($item[bitchin\' meatcar]);
		for _ from 1 to 3
			visit_url("guild.php?place=paco");
		if (handling_choice())
			run_choice(1);
	}
	retrieve_item($item[skeletal skiff]);
	prism();
}

void ascend_yr() {
	if (my_path().id == 0)
		fresh_hell("2,3,1,41,3,5046,5040,2,0");
	if (my_path().id == 41) {
		if (!to_boolean(item_amount($item[Thwaitgold listening bug statuette])))
			cli_execute("looprobot");
		if (!to_boolean(item_amount($item[Thwaitgold listening bug statuette])))
			abort("beep boop, didn't doop");
		string response = visit_url("place.php?whichplace=scrapheap&action=sh_upgrade");
		if (!handling_choice())
			abort("ERROR, ERROR");
		while (response.contains_text("Good old Statbot.") && !(response.contains_text("You don't have enough Energy to do that.")))
			response = run_choice(1);
		run_choice(4);
		visit_url("place.php?whichplace=nstower&action=ns_11_prism");
	}
	prism();
	resong($effects[Ode to Booze, Cletus's Canticle of Celerity]);
	use($item[astral six-pack]);
	drink(6, $item[astral pilsner]);
	foreach s in $skills[blood bubble, springy fusilli, silent hunter, inscrutable gaze, tongue of the walrus, cannelloni cocoon]
		use_skill(s);
	use_familiar($familiar[left-hand man]);
	maximize("muscle experience percent, moxie experience percent", false);
	set_auto_attack(0);
	set_property("battleAction", "custom combat script");
	write_ccs(to_buffer("\"if gotjump; skill feel pride; endif; use gas can, gas can; skill army of toddlers; abort;\""), "familyOkobolds");
	set_ccs("familyOkobolds");
	retrieve_item(100, $item[d4]);
	use(100, $item[d4]);
	cli_execute("3d_pandamonium 0");
}

void ascend_smol() {
	if (my_path().id == 0)
		fresh_hell("2,1,1,49,3,5046,5042,2,0");
	if (my_path().id == 49) {
		cli_execute("loopsmol");
		if (!to_boolean(item_amount($item[Thwaitgold fairyfly statue])))
			abort("one smol problem");
		if (my_inebriety() == 1 && inebriety_limit() == 1) {
			resong($effects[ode to booze]);
			drink($item[astral pilsner]);
		}
		visit_url("place.php?whichplace=nstower&action=ns_11_prism");
	}
	use_skill(3, $skill[sweat out some booze]);
	foreach it in $items[cuppa Sobrie tea, synthetic dog hair pill]
		use(it);
	prism();
	cli_execute("3d_pandamonium 0");
}

void sleep() {
	retrieve_item($item[Burning cape]);
	if (!(get_campground() contains $item[clockwork maid]) && mall_price($item[clockwork maid]) < to_int(get_property("valueOfAdventure")) * 8)
		use($item[clockwork maid]);
	if (to_boolean(available_amount($item[packet of thanksgarden seeds])))
		use($item[packet of thanksgarden seeds]);
	stash();
	get_nude();
	use_familiar($familiar[left-hand man]);
	if (!to_boolean(have_effect($effect[Offhand Remarkable])))
		cli_execute("genie effect Offhand Remarkable");
	maximize("1.1 adv, fites", false);
	cli_execute("ptrack add sleep");
}
