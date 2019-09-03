Config              = {}
Config.MarkerType   = 1
Config.DrawDistance = 100.0
Config.ZoneSize     = {x = 2.0, y = 2.0, z = 1.0}
Config.MarkerColor  = {r = 100, g = 204, b = 100}

Config.RequiredCopsCoke  = 2
Config.RequiredCopsMeth  = 1
Config.RequiredCopsWeed  = 0
Config.RequiredCopsOpium = 4

Config.TimeToFarm    = 10 * 300
Config.TimeToProcess = 15 * 300
Config.TimeToSell    = 5  * 300

Config.Locale = 'en'

Config.Zones = {
	CokeField =			{x = 1903.26,	y = 4919.69,	z = 47.80,	name = _U('coke_field'),		sprite = 501,	color = 40},
	CokeProcessing =	{x = 2455.59,	y = 1594.24,	z = 30.96,	name = _U('coke_processing'),	sprite = 467,	color = 40},
	CokeDealer =		{x = 52.69,	y = -2682.18,	z = 4.01,	name = _U('coke_dealer'),		sprite = 500,	color = 75},
	MethField =			{x = 1525.29,	y = 1710.02,	z = 109.00,	name = _U('meth_field'),		sprite = 499,	color = 26},
	MethProcessing =	{x = 240.33,	y = -2018.91,	z = 17.31,	name = _U('meth_processing'),	sprite = 467,	color = 26},
	MethDealer =		{x = -2286.6,	y = 355.32,	z = 173.6,	name = _U('meth_dealer'),		sprite = 500,	color = 75},
	WeedField =			{x = 2330.36,	y = 2571.94,	z = 45.68,	name = _U('weed_field'),		sprite = 496,	color = 52},
	WeedProcessing =	{x = -1165.05,		y = -1566.93,	z = 3.45,	name = _U('weed_processing'),	sprite = 467,	color = 52},
	WeedDealer =		{x = 901.26,		y = -1922.4,	z = 29.64,	name = _U('weed_dealer'),		sprite = 500,	color = 75},
	OpiumField =		{x = 661.43,	y = 1282.43,	z = 359.3,	name = _U('opium_field'),		sprite = 51,	color = 60},
	OpiumProcessing =	{x = -2082.95,	y = 2610.24,	z = 2.30,	name = _U('opium_processing'),	sprite = 467,	color = 60},
	OpiumDealer =		{x = -192.27,	y = 791.41,	z = 197.11,	name = _U('opium_dealer'),		sprite = 500,	color = 75}
}
