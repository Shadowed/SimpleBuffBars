-- by Medivhius
if( GetLocale() ~= "deDE" ) then
	return
end

local SimpleBB = select(2, ...)
SimpleBB.L = setmetatable({
	["None"] = "Nichts",

	-- GUI
	["General"] = "Allgemein",
	
	["Show temporary weapon enchants"] = "Zeige temporäre Waffenverzauberungen",
	["Shows your current temporary weapon enchants as a buff."] = "Zeigt deine temporäre Waffenverzauberungen als Buff",

	["Enable extra units"] = "Zusätzliche Leisten",
	["Allows you to configure and show buff bars for target, focus and pet units.\nDisabling this will reset the anchor configuration for those three units."] = "Ermöglicht das Einstellen und Anzeigen von Buffleisten für Ziel, Fokusziel und Pet.\nDas Deaktivieren dieser Option setzt die Anker für diese 3 zurück.",
	
	["Show examples"] = "Zeige Beispiele",
	["Shows an example buff/debuff for configuration."] = "Zeigt einen Beispielbuff/ -debuff zum Einstellen.",
	
	["Show tracking"] = "Zeige Suche",
	["Shows your current tracking as a buff, can change trackings through this as well."] = "Zeigt deine aktuelle Suche als einen Buff, die Suche kann auch mit einem Rechts-Klick auf die Buffleiste geändert werden.",
	
	["Global options"] = "Globale Einstellungen",
	["Lets you globally set options for all anchors instead of having to do it one by one.\n\nThe options already chosen in these do not reflect the current anchors settings.\n\nNOTE! Not all options are available, things like anchoring or hiding passive buffs are only available in the anchors own configuration."] = "Ermöglicht es Ankereinstellungen global zu ändern, anstatt dies für jeden einzelnen tun zu müssen.\n\nThe bereits gewählten Einstellungen spiegeln nicht die aktuellen Ankereinstellungen wieder.\n\nBeachte! Es stehen nicht alle Optionen zur Verfügung, z.B. wie verankern oder verstecken von passiven Buffs sind nur bei den jeweiligen Ankereinstellungen möglich.",
	
	["Lock frames"] = "Leisten verschließen",
	["Prevents the frames from being dragged with ALT + Drag."] = "Verhindert das Verschieben der Leisten mit ALT + Ziehen.",

	["Enable group"] = "Gruppe einschalten",
	["Enable showing this group, if it's disabled then no timers will appear inside."] = "Ermöglicht das Anzeigen dieser Gruppe, wenn sie abgeschaltet ist werden in ihr keine Timer angezeigt.",

	["Hide buffs you didn't cast"] = "Verstecke fremde Buffs",
	
	["Player buffs"] = "Spieler Buffs",
	["Player debuffs"] = "Spieler Debufs",
	["Temporary enchants"] = "Temporäre Verzauberungen",
	["petbuffs"] = "Tierbuffs",
	["petdebuffs"] = "Tierdebuffs",
	["targetbuffs"] = "Zielbuffs",
	["targetdebuffs"] = "Zieldebuffs",
	["focusbuffs"] = "Fokuszielbuffs",
	["focusdebuffs"] = "Fokuszieldebuffs",
	
	["Anchor configuration for %ss."] = "Ankereinstellungen für: %s.",

	["Grow display up"] = "Nach oben erweitern",
	["Instead of adding everything from top to bottom, timers will be shown from bottom to top."] = "Anstelle alles von oben nach unten anzuordnen, werden alle Leisten von unten nach oben angeordnet.",
	
	["Display scale"] = "Anzeigegröße",
	["How big the actual timers should be."] = "Wie groß die Leisten tatsächlich seien sollen.",
	
	["Max timers"] = "Maximale Anzahl der Leisten",
	["Maximum amount of timers that should be ran per an anchor at the same time, if too many are running at the same time then the new ones will simply be hidden until older ones are removed."] = "Maximale Anzahl der Leisten die pro Anker zur gleichen Zeit angezeigt werden,\nwenn zu viele angezeigt werden, werden neue verstecke bis alte entfernt werden.",
	
	["Icon position"] = "Iconposition",
	["Right"] = "Rechts",
	["Left"] = "Links",
	
	["Bars"] = "Leisten",
	["Height"] = "Höhe",
	["Width"] = "Breite",
	["Texture"] = "Textur",
	["Colors"] = "Farben",
	
	["Color by type"] = "Nach Typ einfärben",
	["Sets the bar color to the buff type, if it's a buff light blue, temporary weapon enchants purple, debuffs will be colored by magic type, or red if none."] = "Stellt die Leistenfarbe nach ihrem Typ ein, Buffs in hellblau, temporäre Waffenverzauberung in lila, Debuffs je nach Magietyp oder wenn es kein Buff ist rot.",
	
	["Color"] = "Farbe",
	["Bar color and background color, if color by type is enabled then this only applies to buffs and tracking."] = "Leisten- und Hintergrundfarbe. Wenn die Option "Nach Typ einfärben" aktiviert ist, dann gilt es nur für Buffs und Suche.",

	["Temporary enchant colors"] = "Farbe für temporäre Waffenverzauberungen",
	["Bar and background color for temporary weapon enchants, only used if color by type is enabled."] = "Leisten- und Hintergrundfarbe für temporäre Waffenverzauberungen, wird nur übernommen wenn die Option "Nach Typ einfärben" aktiviert ist.",
	
	["Fill timeless buffs"] = "Farbe für unbegrenzte Buffs",
	["Buffs without a duration will have the status bar shown as filled in, instead of empty."] = "Buffs mit einer unbegrenzten Dauer werden mit angezeigten Farbe gefüllt.",
	
	["Display alpha"] = "Anzeigehelligkeit",
	
	["Text"] = "Text",
	
	["Size"] = "Größe",
	["Font"] = "Font",
	
	["Row spacing"] = "Zeilenabstand",
	["How far apart each timer bar should be."] = "Wie weit die Leisten auseinander seien sollen.",

	["%s anchor configuration."] = "%s Ankereinstellungen.",
	["Hide"] = "Verstecken",
	
	["Anchor"] = "Anker",
	["Buffs"] = "Buffs",
	["Debuffs"] = "Debuffs",
	["Temporary enchants"] = "Temporäre Verzauberungen",
	
	["Spacing"] = "Abstand",
	["How far apart this anchor should be from the one it's anchored to, does not apply if anchor to is set to none."] = "Wie groß der Abstand zwischen diesem Anker und dem ist an welchen er angehängt ist, gilt nicht wenn keiner gesetzt ist.",
	
	["Buff sorting"] = "Buffreihenfolge",
	["Time left"] = "verbleibende Zeit",
	["Order gained"] = "Sortierreihenfolge",
	["Sorting information\nTime Left:\nTracking > Auras > Temporary weapon enchant > Buffs by time left\n\nOrder gained:\nTracking > Temporary weapon enchant > Auras > Buffs by order added."] = "Sortierinformation\nVerbleibende Zeit:\nSuche > Auren > temporäre Waffenverzauberungen > Buffs nach verbleibender Zeit\n\n.Sortierreihenfolge\nSuche > temporäre Waffenverzauberungen > Auren > der Reihenfolge nach hinzugefügte Buffs",

	["Hide passive buffs"] = "Passive Buffs verstecken",
	["Hide buffs without a duration, this is only buffs and not debuffs."] = "Buffs ohne Dauer verstecken, gilt nur für Buffs nicht für Debuffs.",

	["Move to"] = "Bewegen nach",
	["Allows you to move the temporary weapon enchants into another anchor."] = "Ermöglicht es die temporäre Waffenverzauberungen in einen anderen Anker zu verschieben.",

	["Anchor to"] = "Verankern an",
	["Lets you anchor %ss to another anchor where it'll be shown below it and positioned so that they never overlap."] = "Ermöglicht es Anker %ss an einen anderen Anker anzuhängen. Er wird unter ihm angezeigt und so positioniert das sie nicht überlappen.",
	
	["Display"] = "Anzeige",

	["Filters"] = "Filter",
	["Allows you to reduce the amount of buffs that are shown by using different filters to hide things that are not relevant to your current talents.\n\nThis will filter things that are not directly related to the filter type, the Physical filter will hide things like Flametongue Totem, or Divine Spirit, while the Caster filter will hide Windfury Totem or Battle Shout."] = Ermöglicht es die Anzahl der angezeigten Buffs an Hand verschiedener Filter zu reduzieren und so die nicht relevanten auszublenden\n\n.Es gibt den physischen und den Zauberfilter. Beim physischen Filter werden Buffs wie Totem der Flammenzuge oder Göttlicher Wille ausblendet, während beim Zauberfilter Buffs wie Totem des Windzorns oder Kriegsruf ausgeblendet werden.",

	["Auto filter"] = "Automatischer Filter",
	["Automatically enables the physical or caster filters based on talents and class."] = "Schalten anhand der Talente und Klase automatisch den physischen Filter oder den Zauberfilter ein.",

	["Time display"] = "Zeitanzeige",
	["HH:MM:SS"] = "HH:MM:SS",
	["Blizzard default"] = "Blizzard Standard",
	
	["Show stack first"] = "Zeige Stapel zuerst",
	["Show stack size"] = "Zeige Stapelhöhe",
	["Show spell rank"] = "Zeige Zauberrang",
}, {__index = SimpleBB.L})