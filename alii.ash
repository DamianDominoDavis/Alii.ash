import <zlib.ash>

int voa = get_property("valueOfAdventure").to_int();

void main(string tasks) {
	// task keywords	
	boolean[string] available_choices;
	foreach key in $strings[
		ascend,
		coffee,
		cs,
		gorb,
		nightcap,
		pvp,
		sleep,
		stash
	] available_choices[key] = false;

	// abbreviations
	string[string] abbreviations = {
		"gorbday":	"gorb nightcap gorb pvp",
		"cloop":	"coffee gorbday ascend cs gorbday sleep"
	};

	// parse
	foreach i,key in tasks.to_lower_case().split_string(" ") {
		if (abbreviations contains key) {
			foreach i,task in abbreviations[key].split_string(" ") {
			print("Running " + task +"!", "teal");
				available_choices[task] = true;
				call void task();
			}
		}
		else if (available_choices contains key) {
			print("Running " + key +"!", "teal");
			available_choices[key] = true;
			call void key();
		}
	}
}

// support tasks

void change_clan(string clan) {
	if (clan.to_lower_case().create_matcher(get_clan_name().to_lower_case()).find())
		return;
	cli_execute("/whitelist " + clan);
	waitq(1);
	if (!clan.to_lower_case().create_matcher(get_clan_name().to_lower_case()).find())
		abort("couldn't get home to " + clan);
}

void gifts() {
	string[string] messages = {
		"Aliisza": "bagginses",
		"ShinyPlatypus": "are they turtley enough for the turtle club",
		"Zmonge": "I could live to be 100, and I will never type the name of this item correctly on the first go"
	};
	boolean[string,item] attachments = {
		"Aliisza": $items[designer handbag, fireclutch, surprisingly capacious handbag],
		"ShinyPlatypus": $items[box turtle, cardboard box turtle, chintzy turtle brooch, dueling turtle, furry green turtle, grinning turtle, ingot turtle, painted turtle, samurai turtle, samurai turtle helmet, sewer turtle, skeletortoise, sleeping wereturtle, soup turtle, syncopated turtle],
		"Zmonge": $items[Stuffed MagiMechTech MicroMechaMech]
	};
	foreach victim in messages {
		boolean[item] targets = attachments[victim];
		string kmail = "kmail ";
		boolean comma = false;
		foreach it in targets
			if (it.tradeable && it.available_amount() > 0) {
				it.retrieve_item(it.available_amount());
				kmail += (comma? ", " : "") + it.available_amount() + " " + it;
				comma = true;
			}
		if (comma)
			cli_execute(kmail + " to " + victim + " || " + messages[victim]);
	}
}

boolean no_junkmail(kmessage m) {
	return ($strings[lady spookyraven's ghost,the loathing postal service,coolestrobot,fairygodmother,peace and love,hermiebot,sellbot,botticelli,cat noir] contains m.fromname.to_lower_case());
}

void secondbreakfast() {
	change_clan("Cool Guy Crew");
	if ($item[raffle ticket].available_amount() < 1) {
		cli_execute("breakfast");
		cli_execute("try; raffle 1");
		cli_execute("try; make 5 hot wad, 5 spooky wad, 5 cold wad, 5 sleaze wad, 5 stench wad, 5 twinkly wad");
		cli_execute("acquire 5 hot wad, 5 spooky wad, 5 cold wad, 5 sleaze wad, 5 stench wad, 5 twinkly wad");
		for i from 1 to 3 $skill[rainbow gravitation].use_skill();
		cli_execute("try; acquire carpe");
		if (!get_property("_essentialTofuUsed").to_boolean()) {
			cli_execute(`buy essential tofu @{(get_property("valueOfAdventure").to_int() * 4)}`);
			if (item_amount($item[essential tofu]) > 0)
				use(1, $item[Essential Tofu]);
		}
		cli_execute("familiar left; unequip familiar; unequip off-hand; umbrella bucket");
		cli_execute("familiar shrub; equip familiar tiny stillsuit");
		cli_execute("familiar left");
		visit_url("place.php?whichplace=campaway&action=campaway_sky");
		gifts();
/**/	cli_execute("choice_by_label false");
/**/	cli_execute("try; autoboxer");
		process_kmail("no_junkmail");
		if (get_property("_clanFortuneConsultUses").to_int() < 3)
			for x from get_property("_clanFortuneConsultUses").to_int() to 2 {
				cli_execute("fortune coolestrobot salt batman thick");
				waitq(5);
			}
	}
}

// key tasks

void stash() {
	change_clan("The Consortium of the Syndicate of the Kingdom");
	foreach f in $familiars[left-hand man, disembodied hand]
		cli_execute("try; familiar "+f+"; unequip familiar");
	outfit("birthday suit");
	foreach it in $items[Bag o Tricks, Crown of Thrones, defective Game Grid token, Pantsgiving, Platinum Yendorian Express Card, Spooky Putty sheet, Talisman of Baio, defective Game Grid token, haiku katana, mafia pointer finger ring]
		if (it.available_amount() > 0 && get_clan_name() == 'The Consortium of the Syndicate of the Kingdom' && it.stash_amount() < 1)
			cli_execute("try; stash put 1 " + it );
	change_clan("Cool Guy Crew");
}

void pvp() {
	change_clan("Cool Guy Crew");
	cli_execute("familiar left");
	cli_execute("unequip familiar");
	cli_execute("outfit nothing");
	$location[noob cave].set_location();
	for i from 1 to 2 cli_execute("maximize 9.887 cold res, booze drop, -14 com;");
	cli_execute("pvp_mab");
}

void coffee() {
	stash();
//	cli_execute("git update; svn update");
//	mall_prices("allitems");
	cli_execute("breakfast");
	secondbreakfast();
	pvp();
}

void gorb() {
	change_clan("Cool Guy Crew");
 	cli_execute("ptrack add gorbStart");
	cli_execute("try; acquire carpe");
	boolean beaten = true;
	boolean stuck = false;
	while(beaten) {
		if (my_inebriety() > inebriety_limit() || get_property("ascensionsToday").to_int() > 0)
			cli_execute("try; garbo");
		else
			cli_execute("try; garbo ascend workshed=cmc");
		beaten = ($effect[Beaten Up].have_effect() > 0);
		if (get_property("garbo_interrupt") == "true") {
			if (stuck)
				abort("rerunning garbo didn't help");
			stuck = true;
			set_property("garbo_interrupt", "");
		}
		if (beaten)
			foreach s in $skills[Tongue of the Walrus,Cannelloni Cocoon]
				s.use_skill();
	}
	cli_execute("shop put -3 park garb @ 210;");
	cli_execute("use * gathered meat;");
	foreach it in $items[meat stack, dense meat stack, cheap sunglasses, expensive camera, fat stacks of cash, knob visor, embezzler oil]
		cli_execute(`autosell * {it}`);
	if (get_property("_stenchAirportToday").to_boolean())
		buy($coinmaster[The Dinsey Company Store], available_amount($item[Funfunds&trade;]) / 20, $item[One-day ticket to dinseylandfill]);
	stash();
	cli_execute("ptrack add gorbDone");
}

void nightcap() {
	if (my_adventures() > 0)
		abort("Rethink overdrinking...");
	cli_execute("familiar stooper;");
	cli_execute("shrug ur-kel;");
	cli_execute("shrug polka of plenty;");
	cli_execute("cast 2 ode to booze;");
	cli_execute("drink stillsuit distillate;");
	cli_execute(`consume all nomeat nightcap value {voa} valuepvp {voa};`.to_upper_case());
}

void gorbday() {
	gorb();
	nightcap();
	gorb();
	pvp();
}

void ascend() {
	if (my_inebriety() <= inebriety_limit())
		abort("Overdrink first!!");
	if (my_adventures() > 0)
		abort("Turns remain!!");
	wait(5);
	cli_execute("c2t_ascend"); //c2t call to ascend. Change settings via the relay page.
	visit_url("choice.php"); //think I still need to click thru the choice adv
	run_choice(1);
	visit_url("peevpee.php?action=smashstone&pwd&confirm=on", true);
}

void cs() {
	cli_execute("ptrack add csStart");
	cli_execute("c2t_hccs");
	cli_execute("prism");
	cli_execute("acquire deep dish of legend, calzone of legend, pizza of legend");
	cli_execute("ptrack add csEnd");
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
}
