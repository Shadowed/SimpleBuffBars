-- by Medivhius
if( GetLocale() ~= "deDE" ) then
	return
end

local SimpleBB = select(2, ...)
SimpleBB.L = setmetatable({
	["None"] = "Nichts",

	-- GUI
	["General"] = "Allgemein",
	
	["Show temporary weapon enchants"] = "Zeige tempor�re Waffenverzauberungen",
	["Shows your current temporary weapon enchants as a buff."] = "Zeigt deine tempor�re Waffenverzauberungen als Buff",

	["Enable extra units"] = "Zus�tzliche Leisten",
	["Allows you to configure and show buff bars for target, focus and pet units.\nDisabling this will reset the anchor configuration for those three units."] = "Erm�glicht das Einstellen und Anzeigen von Buffleisten f�r Ziel, Fokusziel und Pet.\nDas Deaktivieren dieser Option setzt die Anker f�r diese 3 zur�ck.",
	
	["Show examples"] = "Zeige Beispiele",
	["Shows an example buff/debuff for configuration."] = "Zeigt einen Beispielbuff/ -debuff zum Einstellen.",
	
	["Show tracking"] = "Zeige Suche",
	["Shows your current tracking as a buff, can change trackings through this as well."] = "Zeigt deine aktuelle Suche als einen Buff, die Suche kann auch mit einem Rechts-Klick auf die Buffleiste ge�ndert werden.",
	
	["Global options"] = "Globale Einstellungen",
	["Lets you globally set options for all anchors instead of having to do it one by one.\n\nThe options already chosen in these do not reflect the current anchors settings.\n\nNOTE! Not all options are available, things like anchoring or hiding passive buffs are only available in the anchors own configuration."] = "Erm�glicht es Ankereinstellungen global zu �ndern, anstatt dies f�r jeden einzelnen tun zu m�ssen.\n\nThe bereits gew�hlten Einstellungen spiegeln nicht die aktuellen Ankereinstellungen wieder.\n\nBeachte! Es stehen nicht alle Optionen zur Verf�gung, z.B. wie verankern oder verstecken von passiven Buffs sind nur bei den jeweiligen Ankereinstellungen m�glich.",
	
	["Lock frames"] = "Leisten verschlie�en",
	["Prevents the frames from being dragged with ALT + Drag."] = "Verhindert das Verschieben der Leisten mit ALT + Ziehen.",

	["Enable group"] = "Gruppe einschalten",
	["Enable showing this group, if it's disabled then no timers will appear inside."] = "Erm�glicht das Anzeigen dieser Gruppe, wenn sie abgeschaltet ist werden in ihr keine Timer angezeigt.",

	["Hide buffs you didn't cast"] = "Verstecke fremde Buffs",
	
	["Player buffs"] = "Spieler Buffs",
	["Player debuffs"] = "Spieler Debufs",
	["Temporary enchants"] = "Tempor�re Verzauberungen",
	["petbuffs"] = "Tierbuffs",
	["petdebuffs"] = "Tierdebuffs",
	["targetbuffs"] = "Zielbuffs",
	["targetdebuffs"] = "Zieldebuffs",
	["focusbuffs"] = "Fokuszielbuffs",
	["focusdebuffs"] = "Fokuszieldebuffs",
	
	["Anchor configuration for %ss."] = "Ankereinstellungen f�r: %s.",

	["Grow display up"] = "Nach oben erweitern",
	["Instead of adding everything from top to bottom, timers will be shown from bottom to top."] = "Anstelle alles von oben nach unten anzuordnen, werden alle Leisten von unten nach oben angeordnet.",
	
	["Display scale"] = "Anzeigegr��e",
	["How big the actual timers should be."] = "Wie gro� die Leisten tats�chlich seien sollen.",
	
	["Max timers"] = "Maximale Anzahl der Leisten",
	["Maximum amount of timers that should be ran per an anchor at the same time, if too many are running at the same time then the new ones will simply be hidden until older ones are removed."] = "Maximale Anzahl der Leisten die pro Anker zur gleichen Zeit angezeigt werden,\nwenn zu viele angezeigt werden, werden neue verstecke bis alte entfernt werden.",
	
	["Icon position"] = "Iconposition",
	["Right"] = "Rechts",
	["Left"] = "Links",
	
	["Bars"] = "Leisten",
	["Height"] = "H�he",
	["Width"] = "Breite",
	["Texture"] = "Textur",
	["Colors"] = "Farben",
	
	["Color by type"] = "Nach Typ einf�rben",
	["Sets the bar color to the buff type, if it's a buff light blue, temporary weapon enchants purple, debuffs will be colored by magic type, or red if none."] = "Stellt die Leistenfarbe nach ihrem Typ ein, Buffs in hellblau, tempor�re Waffenverzauberung in lila, Debuffs je nach Magietyp oder wenn es kein Buff ist rot.",
	
	["Color"] = "Farbe",
	["Bar color and background color, if color by type is enabled then this only applies to buffs and tracking."] = "Leisten- und Hintergrundfarbe. Wenn die Option "Nach Typ einf�rben" aktiviert ist, dann gilt es nur f�r Buffs und Suche.",

	["Temporary enchant colors"] = "Farbe f�r tempor�re Waffenverzauberungen",
	["Bar and background color for temporary weapon enchants, only used if color by type is enabled."] = "Leisten- und Hintergrundfarbe f�r tempor�re Waffenverzauberungen, wird nur �bernommen wenn die Option "Nach Typ einf�rben" aktiviert ist.",
	
	["Fill timeless buffs"] = "Farbe f�r unbegrenzte Buffs",
	["Buffs without a duration will have the status bar shown as filled in, instead of empty."] = "Buffs mit einer unbegrenzten Dauer werden mit angezeigten Farbe gef�llt.",
	
	["Display alpha"] = "Anzeigehelligkeit",
	
	["Text"] = "Text",
	
	["Size"] = "Gr��e",
	["Font"] = "Font",
	
	["Row spacing"] = "Zeilenabstand",
	["How far apart each timer bar should be."] = "Wie weit die Leisten auseinander seien sollen.",

	["%s anchor configuration."] = "%s Ankereinstellungen.",
	["Hide"] = "Verstecken",
	
	["Anchor"] = "Anker",
	["Buffs"] = "Buffs",
	["Debuffs"] = "Debuffs",
	["Temporary enchants"] = "Tempor�re Verzauberungen",
	
	["Spacing"] = "Abstand",
	["How far apart this anchor should be from the one it's anchored to, does not apply if anchor to is set to none."] = "Wie gro� der Abstand zwischen diesem Anker und dem ist an welchen er angeh�ngt ist, gilt nicht wenn keiner gesetzt ist.",
	
	["Buff sorting"] = "Buffreihenfolge",
	["Time left"] = "verbleibende Zeit",
	["Order gained"] = "Sortierreihenfolge",
	["Sorting information\nTime Left:\nTracking > Auras > Temporary weapon enchant > Buffs by time left\n\nOrder gained:\nTracking > Temporary weapon enchant > Auras > Buffs by order added."] = "Sortierinformation\nVerbleibende Zeit:\nSuche > Auren > tempor�re Waffenverzauberungen > Buffs nach verbleibender Zeit\n\n.Sortierreihenfolge\nSuche > tempor�re Waffenverzauberungen > Auren > der Reihenfolge nach hinzugef�gte Buffs",

	["Hide passive buffs"] = "Passive Buffs verstecken",
	["Hide buffs without a duration, this is only buffs and not debuffs."] = "Buffs ohne Dauer verstecken, gilt nur f�r Buffs nicht f�r Debuffs.",

	["Move to"] = "Bewegen nach",
	["Allows you to move the temporary weapon enchants into another anchor."] = "Erm�glicht es die tempor�re Waffenverzauberungen in einen anderen Anker zu verschieben.",

	["Anchor to"] = "Verankern an",
	["Lets you anchor %ss to another anchor where it'll be shown below it and positioned so that they never overlap."] = "Erm�glicht es Anker %ss an einen anderen Anker anzuh�ngen. Er wird unter ihm angezeigt und so positioniert das sie nicht �berlappen.",
	
	["Display"] = "Anzeige",

	["Filters"] = "Filter",
	["Allows you to reduce the amount of buffs that are shown by using different filters to hide things that are not relevant to your current talents.\n\nThis will filter things that are not directly related to the filter type, the Physical filter will hide things like Flametongue Totem, or Divine Spirit, while the Caster filter will hide Windfury Totem or Battle Shout."] = Erm�glicht es die Anzahl der angezeigten Buffs an Hand verschiedener Filter zu reduzieren und so die nicht relevanten auszublenden\n\n.Es gibt den physischen und den Zauberfilter. Beim physischen Filter werden Buffs wie Totem der Flammenzuge oder G�ttlicher Wille ausblendet, w�hrend beim Zauberfilter Buffs wie Totem des Windzorns oder Kriegsruf ausgeblendet werden.",

	["Auto filter"] = "Automatischer Filter",
	["Automatically enables the physical or caster filters based on talents and class."] = "Schalten anhand der Talente und Klase automatisch den physischen Filter oder den Zauberfilter ein.",

	["Time display"] = "Zeitanzeige",
	["HH:MM:SS"] = "HH:MM:SS",
	["Blizzard default"] = "Blizzard Standard",
	
	["Show stack first"] = "Zeige Stapel zuerst",
	["Show stack size"] = "Zeige Stapelh�he",
	["Show spell rank"] = "Zeige Zauberrang",
}, {__index = SimpleBB.L})