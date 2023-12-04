extends Node


const ICON_PATH = "res://Textures/Items/Upgrades/"
const RAT_ICON_PATH = "res://assets/player/upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"
const RAT_WEAPON_PATH = "res://assets/player/attacks/"
const UPGRADES = {
	"plug1": {
		"icon": RAT_WEAPON_PATH + "buttplug.png",
		"displayname": "NC-17",
		"details": "A powerful, pulsating ring of b-plugs orbits the player.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"plug2": {
		"icon": RAT_WEAPON_PATH + "buttplug.png",
		"displayname": "NC-17",
		"details": "An additional b-plug is created, knockback, damage and max radius are increased.",
		"level": "Level: 2",
		"prerequisite": ["plug1"],
		"type": "weapon"
	},
	"plug3": {
		"icon": RAT_WEAPON_PATH + "buttplug.png",
		"displayname": "NC-17",
		"details": "An additional b-plug is created, knockback, damage and max radius are increased.",
		"level": "Level: 3",
		"prerequisite": ["plug2"],
		"type": "weapon"
	},
	"plug4": {
		"icon": RAT_WEAPON_PATH + "buttplug.png",
		"displayname": "NC-17",
		"details": "An additional b-plug is created, knockback, damage and max radius are increased..",
		"level": "Level: 4",
		"prerequisite": ["plug3"],
		"type": "weapon"
	},
	"stonefist1": {

		"icon": RAT_WEAPON_PATH + "stonefist.png",
		"displayname": "STONEFIST",
		"details": "A crushing fist of stone is thrown at a random enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"stonefist2": {

		"icon": RAT_WEAPON_PATH + "stonefist.png",
		"displayname": "STONEFIST",
		"details": "An additional STONEFIST is thrown",

		"level": "Level: 2",
		"prerequisite": ["stonefist1"],
		"type": "weapon"
	},
	"stonefist3": {
		"icon": RAT_WEAPON_PATH + "stonefist.png",
		"displayname": "STONEFIST",
		"details": "STONEFISTS now blast through another enemy and do + 3 damage",
		"level": "Level: 3",
		"prerequisite": ["stonefist2"],
		"type": "weapon"
	},
	"stonefist4": {
		"icon": RAT_WEAPON_PATH + "stonefist.png",
		"displayname": "STONEFIST",
		"details": "An additional 2 STONEFISTS are thrown",
		"level": "Level: 4",
		"prerequisite": ["stonefist3"],
		"type": "weapon"
	},
	"javelin1": {
		"icon": WEAPON_PATH + "javelin_3_new_attack.png",
		"displayname": "Javelin",
		"details": "A magical javelin will follow you attacking enemies in a straight line",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"javelin2": {
		"icon": WEAPON_PATH + "javelin_3_new_attack.png",
		"displayname": "Javelin",
		"details": "The javelin will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prerequisite": ["javelin1"],
		"type": "weapon"
	},
	"javelin3": {
		"icon": WEAPON_PATH + "javelin_3_new_attack.png",
		"displayname": "Javelin",
		"details": "The javelin will attack another additional enemy per attack",
		"level": "Level: 3",
		"prerequisite": ["javelin2"],
		"type": "weapon"
	},
	"javelin4": {
		"icon": WEAPON_PATH + "javelin_3_new_attack.png",
		"displayname": "Javelin",
		"details": "The javelin now does + 5 damage per attack and causes 20% additional knockback",
		"level": "Level: 4",
		"prerequisite": ["javelin3"],
		"type": "weapon"
	},
	"tornado1": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "A tornado is created and random heads somewhere in the players direction",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"tornado2": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "An additional Tornado is created",
		"level": "Level: 2",
		"prerequisite": ["tornado1"],
		"type": "weapon"
	},
	"tornado3": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "The Tornado cooldown is reduced by 0.5 seconds",
		"level": "Level: 3",
		"prerequisite": ["tornado2"],
		"type": "weapon"
	},
	"tornado4": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "An additional tornado is created and the knockback is increased by 25%",
		"level": "Level: 4",
		"prerequisite": ["tornado3"],
		"type": "weapon"
	},
	"dieslow1": {
		"icon": RAT_WEAPON_PATH + "die_slow.png",
		"displayname": "DIE SLOW",
		"details": "A burning pool of gas tossed from a can.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"dieslow2": {
		"icon": RAT_WEAPON_PATH + "die_slow.png",
		"displayname": "DIE SLOW",
		"details": "An additional burning pool of gas is created.",
		"level": "Level: 2",
		"prerequisite": ["dieslow1"],
		"type": "weapon"
	},
	"dieslow3": {
		"icon": RAT_WEAPON_PATH + "die_slow.png",
		"displayname": "DIE SLOW",
		"details": "An additional burning pool of gas is created.",
		"level": "Level: 3",
		"prerequisite": ["dieslow2"],
		"type": "weapon"
	},
	"dieslow4": {
		"icon": RAT_WEAPON_PATH + "die_slow.png",
		"displayname": "DIE SLOW",
		"details": "Two additional burning pools of gas are created.",
		"level": "Level: 4",
		"prerequisite": ["dieslow3"],
		"type": "weapon"
	},
	"vinyl1": {
		"icon": RAT_WEAPON_PATH + "vinyl.png",
		"displayname": "RAT WARS LP",
		"details": "A deadly razor sharp vinyl that bounces.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"vinyl2": {
		"icon": RAT_WEAPON_PATH + "vinyl.png",
		"displayname": "RAT WARS LP",
		"details": "An additional LIMITED EDITION RED Vinyl is created",
		"level": "Level: 2",
		"prerequisite": ["vinyl1"],
		"type": "weapon"
	},
	"vinyl3": {
		"icon": RAT_WEAPON_PATH + "vinyl.png",
		"displayname": "RAT WARS LP",
		"details": "The LIMITED EDITION RED LP cooldown is reduced by 0.5 seconds",
		"level": "Level: 3",
		"prerequisite": ["vinyl2"],
		"type": "weapon"
	},
	"vinyl4": {
		"icon": RAT_WEAPON_PATH + "vinyl.png",
		"displayname": "RAT WARS LP",
		"details": "An additional LIMITED EDITION RED LP is created and the knockback is increased by 25%",
		"level": "Level: 4",
		"prerequisite": ["vinyl3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": RAT_ICON_PATH + "feel_nothing.png",
		"displayname": "FEEL NOTHING",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": RAT_ICON_PATH + "feel_nothing.png",
		"displayname": "FEEL NOTHING",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": RAT_ICON_PATH + "feel_nothing.png",
		"displayname": "FEEL NOTHING",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": RAT_ICON_PATH + "feel_nothing.png",
		"displayname": "FEEL NOTHING",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": RAT_ICON_PATH + "darkenough.png",
		"displayname": "DARK ENOUGH",
		"details": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": RAT_ICON_PATH + "darkenough.png",
		"displayname": "DARK ENOUGH",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": RAT_ICON_PATH + "darkenough.png",
		"displayname": "DARK ENOUGH",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": RAT_ICON_PATH + "darkenough.png",
		"displayname": "DARK ENOUGH",
		"details": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": RAT_ICON_PATH + "rat_wars_cassette.png",
		"displayname": "RAT WARS CASSETTE",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": RAT_ICON_PATH + "rat_wars_cassette.png",
		"displayname": "RAT WARS CASSETTE",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": RAT_ICON_PATH + "rat_wars_cassette.png",
		"displayname": "RAT WARS CASSETTE",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": RAT_ICON_PATH + "rat_wars_cassette.png",
		"displayname": "RAT WARS CASSETTE",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}

