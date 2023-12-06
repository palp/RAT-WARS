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
	"blackstatic1": {
		"icon": RAT_WEAPON_PATH + "black_static.png",
		"displayname": "BLACK STATIC",
		"details": "Bolts of harsh noise smites random nearby enemies",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"blackstatic2": {
		"icon": RAT_WEAPON_PATH + "black_static.png",
		"displayname": "BLACK STATIC",
		"details": "Time between attacks is decreased",
		"level": "Level: 2",
		"prerequisite": ["blackstatic1"],
		"type": "weapon"
	},
	"blackstatic3": {
		"icon": RAT_WEAPON_PATH + "black_static.png",
		"displayname": "BLACK STATIC",
		"details": "More bolts are produced.",
		"level": "Level: 3",
		"prerequisite": ["blackstatic2"],
		"type": "weapon"
	},
	"blackstatic4": {
		"icon": RAT_WEAPON_PATH + "black_static.png",
		"displayname": "BLACK STATIC",
		"details": "Number of bolts are increased and time between attacks is decreased",
		"level": "Level: 4",
		"prerequisite": ["blackstatic3"],
		"type": "weapon"
	},
	"deathmagic1": {
		"icon": RAT_WEAPON_PATH + "death_magic.png",
		"displayname": "DEATH MAGIC",
		"details": "Harnessing death magic, a shattered projectile is thrown in a spiral, becoming more lethal over time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"deathmagic2": {
		"icon": RAT_WEAPON_PATH + "death_magic.png",
		"displayname": "DEATH MAGIC",
		"details": "DEATH MAGIC can pass through more enemies, gains increased attack speed, and can charge for longer",
		"level": "Level: 2",
		"prerequisite": ["deathmagic1"],
		"type": "weapon"
	},
	"deathmagic3": {
		"icon": RAT_WEAPON_PATH + "death_magic.png",
		"displayname": "DEATH MAGIC",
		"details": "DEATH MAGIC can pass through more enemies, gains increased attack speed, and can charge for longer",
		"level": "Level: 3",
		"prerequisite": ["deathmagic2"],
		"type": "weapon"
	},
	"deathmagic": {
		"icon": RAT_WEAPON_PATH + "death_magic.png",
		"displayname": "DEATH MAGIC",
		"details": "An additional DEATH MAGIC is created",
		"level": "Level: 4",
		"prerequisite": ["deathmagic3"],
		"type": "weapon"
	},
	"dieslow1": {
		"icon": RAT_WEAPON_PATH + "die_slow.png",
		"displayname": "DIE SLOW",
		"details": "A burning pool of gas is tossed from a can at a random enemy",
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
		"details": "A deadly razor sharp vinyl that bounces back",
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
		"icon": RAT_ICON_PATH + "glitter_pill.png",
		"displayname": "GLITTER PILLS",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": RAT_ICON_PATH + "glitter_pill.png",
		"displayname": "GLITTER PILLS",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": RAT_ICON_PATH + "glitter_pill.png",
		"displayname": "GLITTER PILLS",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": RAT_ICON_PATH + "glitter_pill.png",
		"displayname": "GLITTER PILLS",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": RAT_ICON_PATH + "excess.png",
		"displayname": "EXCESS",
		"details": "Your weapons now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": RAT_ICON_PATH + "excess.png",
		"displayname": "EXCESS",
		"details": "Your weapons now spawn 1 more additional attack",
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

