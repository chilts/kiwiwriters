BEGIN;

-- ----------------------------------------------------------------------------

-- alter the challenge.event to have just times without time zone
-- for start
ALTER TABLE challenge.event ADD COLUMN tmp_startts TIMESTAMP WITHOUT TIME ZONE;
UPDATE challenge.event SET tmp_startts = startts;
ALTER TABLE challenge.event DROP COLUMN startts;
ALTER TABLE challenge.event ADD COLUMN startts TIMESTAMP WITHOUT TIME ZONE;
UPDATE challenge.event SET startts = tmp_startts;
ALTER TABLE challenge.event ALTER COLUMN startts SET NOT NULL;
ALTER TABLE challenge.event DROP COLUMN tmp_startts;

-- for end
ALTER TABLE challenge.event ADD COLUMN tmp_endts TIMESTAMP WITHOUT TIME ZONE;
UPDATE challenge.event SET tmp_endts = endts;
ALTER TABLE challenge.event DROP COLUMN endts;
ALTER TABLE challenge.event ADD COLUMN endts TIMESTAMP WITHOUT TIME ZONE;
UPDATE challenge.event SET endts = tmp_endts;
ALTER TABLE challenge.event ALTER COLUMN endts SET NOT NULL;
ALTER TABLE challenge.event DROP COLUMN tmp_endts;

-- create the challenge.timezone info
CREATE SEQUENCE challenge.timezone_id_seq;
CREATE TABLE challenge.timezone (
    id              INTEGER NOT NULL DEFAULT nextval('challenge.timezone_id_seq'::TEXT) PRIMARY KEY,
    name            TEXT NOT NULL,
    extra           TEXT NOT NULL DEFAULT '',

    UNIQUE(name),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER timezone_updated BEFORE UPDATE ON challenge.timezone
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- list copied from /usr/share/zoneinfo/zone.tab
INSERT INTO challenge.timezone(name) VALUES('Africa/Abidjan');
INSERT INTO challenge.timezone(name) VALUES('Africa/Accra');
INSERT INTO challenge.timezone(name) VALUES('Africa/Addis_Ababa');
INSERT INTO challenge.timezone(name) VALUES('Africa/Algiers');
INSERT INTO challenge.timezone(name) VALUES('Africa/Asmara');
INSERT INTO challenge.timezone(name) VALUES('Africa/Bamako');
INSERT INTO challenge.timezone(name) VALUES('Africa/Bangui');
INSERT INTO challenge.timezone(name) VALUES('Africa/Banjul');
INSERT INTO challenge.timezone(name) VALUES('Africa/Bissau');
INSERT INTO challenge.timezone(name) VALUES('Africa/Blantyre');
INSERT INTO challenge.timezone(name) VALUES('Africa/Brazzaville');
INSERT INTO challenge.timezone(name) VALUES('Africa/Bujumbura');
INSERT INTO challenge.timezone(name) VALUES('Africa/Cairo');
INSERT INTO challenge.timezone(name) VALUES('Africa/Casablanca');
INSERT INTO challenge.timezone(name, extra) VALUES('Africa/Ceuta', 'Ceuta & Melilla');
INSERT INTO challenge.timezone(name) VALUES('Africa/Conakry');
INSERT INTO challenge.timezone(name) VALUES('Africa/Dakar');
INSERT INTO challenge.timezone(name) VALUES('Africa/Dar_es_Salaam');
INSERT INTO challenge.timezone(name) VALUES('Africa/Djibouti');
INSERT INTO challenge.timezone(name) VALUES('Africa/Douala');
INSERT INTO challenge.timezone(name) VALUES('Africa/El_Aaiun');
INSERT INTO challenge.timezone(name) VALUES('Africa/Freetown');
INSERT INTO challenge.timezone(name) VALUES('Africa/Gaborone');
INSERT INTO challenge.timezone(name) VALUES('Africa/Harare');
INSERT INTO challenge.timezone(name) VALUES('Africa/Johannesburg');
INSERT INTO challenge.timezone(name) VALUES('Africa/Kampala');
INSERT INTO challenge.timezone(name) VALUES('Africa/Khartoum');
INSERT INTO challenge.timezone(name) VALUES('Africa/Kigali');
INSERT INTO challenge.timezone(name, extra) VALUES('Africa/Kinshasa', 'west Dem. Rep. of Congo');
INSERT INTO challenge.timezone(name) VALUES('Africa/Lagos');
INSERT INTO challenge.timezone(name) VALUES('Africa/Libreville');
INSERT INTO challenge.timezone(name) VALUES('Africa/Lome');
INSERT INTO challenge.timezone(name) VALUES('Africa/Luanda');
INSERT INTO challenge.timezone(name, extra) VALUES('Africa/Lubumbashi', 'east Dem. Rep. of Congo');
INSERT INTO challenge.timezone(name) VALUES('Africa/Lusaka');
INSERT INTO challenge.timezone(name) VALUES('Africa/Malabo');
INSERT INTO challenge.timezone(name) VALUES('Africa/Maputo');
INSERT INTO challenge.timezone(name) VALUES('Africa/Maseru');
INSERT INTO challenge.timezone(name) VALUES('Africa/Mbabane');
INSERT INTO challenge.timezone(name) VALUES('Africa/Mogadishu');
INSERT INTO challenge.timezone(name) VALUES('Africa/Monrovia');
INSERT INTO challenge.timezone(name) VALUES('Africa/Nairobi');
INSERT INTO challenge.timezone(name) VALUES('Africa/Ndjamena');
INSERT INTO challenge.timezone(name) VALUES('Africa/Niamey');
INSERT INTO challenge.timezone(name) VALUES('Africa/Nouakchott');
INSERT INTO challenge.timezone(name) VALUES('Africa/Ouagadougou');
INSERT INTO challenge.timezone(name) VALUES('Africa/Porto-Novo');
INSERT INTO challenge.timezone(name) VALUES('Africa/Sao_Tome');
INSERT INTO challenge.timezone(name) VALUES('Africa/Tripoli');
INSERT INTO challenge.timezone(name) VALUES('Africa/Tunis');
INSERT INTO challenge.timezone(name) VALUES('Africa/Windhoek');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Adak', 'Aleutian Islands');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Anchorage', 'Alaska Time');
INSERT INTO challenge.timezone(name) VALUES('America/Anguilla');
INSERT INTO challenge.timezone(name) VALUES('America/Antigua');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Araguaina', 'Tocantins');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/Buenos_Aires', 'Buenos Aires (BA, CF)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/Catamarca', 'Catamarca (CT), Chubut (CH)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/Cordoba', 'most locations (CB, CC, CN, ER, FM, LP, MN, NQ, RN, SA, SE, SF, SL)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/Jujuy', 'Jujuy (JY)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/La_Rioja', 'La Rioja (LR)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/Mendoza', 'Mendoza (MZ)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/Rio_Gallegos', 'Santa Cruz (SC)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/San_Juan', 'San Juan (SJ)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/Tucuman', 'Tucuman (TM)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Argentina/Ushuaia', 'Tierra del Fuego (TF)');
INSERT INTO challenge.timezone(name) VALUES('America/Aruba');
INSERT INTO challenge.timezone(name) VALUES('America/Asuncion');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Atikokan', 'Eastern Standard Time - Atikokan, Ontario and Southampton I, Nunavut');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Bahia', 'Bahia');
INSERT INTO challenge.timezone(name) VALUES('America/Barbados');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Belem', 'Amapa, E Para');
INSERT INTO challenge.timezone(name) VALUES('America/Belize');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Blanc-Sablon', 'Atlantic Standard Time - Quebec - Lower North Shore');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Boa_Vista', 'Roraima');
INSERT INTO challenge.timezone(name) VALUES('America/Bogota');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Boise', 'Mountain Time - south Idaho & east Oregon');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Cambridge_Bay', 'Central Time - west Nunavut');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Campo_Grande', 'Mato Grosso do Sul');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Cancun', 'Central Time - Quintana Roo');
INSERT INTO challenge.timezone(name) VALUES('America/Caracas');
INSERT INTO challenge.timezone(name) VALUES('America/Cayenne');
INSERT INTO challenge.timezone(name) VALUES('America/Cayman');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Chicago', 'Central Time');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Chihuahua', 'Mountain Time - Chihuahua');
INSERT INTO challenge.timezone(name) VALUES('America/Costa_Rica');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Cuiaba', 'Mato Grosso');
INSERT INTO challenge.timezone(name) VALUES('America/Curacao');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Danmarkshavn', 'east coast, north of Scoresbysund');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Dawson', 'Pacific Time - north Yukon');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Dawson_Creek', 'Mountain Standard Time - Dawson Creek & Fort Saint John, British Columbia');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Denver', 'Mountain Time');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Detroit', 'Eastern Time - Michigan - most locations');
INSERT INTO challenge.timezone(name) VALUES('America/Dominica');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Edmonton', 'Mountain Time - Alberta, east British Columbia & west Saskatchewan');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Eirunepe', 'W Amazonas');
INSERT INTO challenge.timezone(name) VALUES('America/El_Salvador');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Fortaleza', 'NE Brazil (MA, PI, CE, RN, PB)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Glace_Bay', 'Atlantic Time - Nova Scotia - places that did not observe DST 1966-1971');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Godthab', 'most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Goose_Bay', 'Atlantic Time - Labrador - most locations');
INSERT INTO challenge.timezone(name) VALUES('America/Grand_Turk');
INSERT INTO challenge.timezone(name) VALUES('America/Grenada');
INSERT INTO challenge.timezone(name) VALUES('America/Guadeloupe');
INSERT INTO challenge.timezone(name) VALUES('America/Guatemala');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Guayaquil', 'mainland');
INSERT INTO challenge.timezone(name) VALUES('America/Guyana');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Halifax', 'Atlantic Time - Nova Scotia (most places), PEI');
INSERT INTO challenge.timezone(name) VALUES('America/Havana');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Hermosillo', 'Mountain Standard Time - Sonora');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Indiana/Indianapolis', 'Eastern Time - Indiana - most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Indiana/Knox', 'Eastern Time - Indiana - Starke County');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Indiana/Marengo', 'Eastern Time - Indiana - Crawford County');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Indiana/Petersburg', 'Central Time - Indiana - Pike County');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Indiana/Vevay', 'Eastern Time - Indiana - Switzerland County');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Indiana/Vincennes', 'Central Time - Indiana - Daviess, Dubois, Knox, Martin, Perry & Pulaski Counties');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Inuvik', 'Mountain Time - west Northwest Territories');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Iqaluit', 'Eastern Time - east Nunavut');
INSERT INTO challenge.timezone(name) VALUES('America/Jamaica');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Juneau', 'Alaska Time - Alaska panhandle');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Kentucky/Louisville', 'Eastern Time - Kentucky - Louisville area');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Kentucky/Monticello', 'Eastern Time - Kentucky - Wayne County');
INSERT INTO challenge.timezone(name) VALUES('America/La_Paz');
INSERT INTO challenge.timezone(name) VALUES('America/Lima');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Los_Angeles', 'Pacific Time');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Maceio', 'Alagoas, Sergipe');
INSERT INTO challenge.timezone(name) VALUES('America/Managua');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Manaus', 'E Amazonas');
INSERT INTO challenge.timezone(name) VALUES('America/Martinique');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Mazatlan', 'Mountain Time - S Baja, Nayarit, Sinaloa');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Menominee', 'Central Time - Michigan - Dickinson, Gogebic, Iron & Menominee Counties');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Merida', 'Central Time - Campeche, Yucatan');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Mexico_City', 'Central Time - most locations');
INSERT INTO challenge.timezone(name) VALUES('America/Miquelon');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Moncton', 'Atlantic Time - New Brunswick');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Monterrey', 'Central Time - Coahuila, Durango, Nuevo Leon, Tamaulipas');
INSERT INTO challenge.timezone(name) VALUES('America/Montevideo');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Montreal', 'Eastern Time - Quebec - most locations');
INSERT INTO challenge.timezone(name) VALUES('America/Montserrat');
INSERT INTO challenge.timezone(name) VALUES('America/Nassau');
INSERT INTO challenge.timezone(name, extra) VALUES('America/New_York', 'Eastern Time');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Nipigon', 'Eastern Time - Ontario & Quebec - places that did not observe DST 1967-1973');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Nome', 'Alaska Time - west Alaska');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Noronha', 'Atlantic islands');
INSERT INTO challenge.timezone(name, extra) VALUES('America/North_Dakota/Center', 'Central Time - North Dakota - Oliver County');
INSERT INTO challenge.timezone(name, extra) VALUES('America/North_Dakota/New_Salem', 'Central Time - North Dakota - Morton County (except Mandan area)');
INSERT INTO challenge.timezone(name) VALUES('America/Panama');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Pangnirtung', 'Eastern Time - Pangnirtung, Nunavut');
INSERT INTO challenge.timezone(name) VALUES('America/Paramaribo');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Phoenix', 'Mountain Standard Time - Arizona');
INSERT INTO challenge.timezone(name) VALUES('America/Port-au-Prince');
INSERT INTO challenge.timezone(name) VALUES('America/Port_of_Spain');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Porto_Velho', 'W Para, Rondonia');
INSERT INTO challenge.timezone(name) VALUES('America/Puerto_Rico');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Rainy_River', 'Central Time - Rainy River & Fort Frances, Ontario');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Rankin_Inlet', 'Central Time - central Nunavut');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Recife', 'Pernambuco');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Regina', 'Central Standard Time - Saskatchewan - most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Rio_Branco', 'Acre');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Santiago', 'most locations');
INSERT INTO challenge.timezone(name) VALUES('America/Santo_Domingo');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Sao_Paulo', 'S & SE Brazil (GO, DF, MG, ES, RJ, SP, PR, SC, RS)');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Scoresbysund', 'Scoresbysund / Ittoqqortoormiit');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Shiprock', 'Mountain Time - Navajo');
INSERT INTO challenge.timezone(name, extra) VALUES('America/St_Johns', 'Newfoundland Time, including SE Labrador');
INSERT INTO challenge.timezone(name) VALUES('America/St_Kitts');
INSERT INTO challenge.timezone(name) VALUES('America/St_Lucia');
INSERT INTO challenge.timezone(name) VALUES('America/St_Thomas');
INSERT INTO challenge.timezone(name) VALUES('America/St_Vincent');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Swift_Current', 'Central Standard Time - Saskatchewan - midwest');
INSERT INTO challenge.timezone(name) VALUES('America/Tegucigalpa');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Thule', 'Thule / Pituffik');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Thunder_Bay', 'Eastern Time - Thunder Bay, Ontario');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Tijuana', 'Pacific Time');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Toronto', 'Eastern Time - Ontario - most locations');
INSERT INTO challenge.timezone(name) VALUES('America/Tortola');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Vancouver', 'Pacific Time - west British Columbia');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Whitehorse', 'Pacific Time - south Yukon');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Winnipeg', 'Central Time - Manitoba & west Ontario');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Yakutat', 'Alaska Time - Alaska panhandle neck');
INSERT INTO challenge.timezone(name, extra) VALUES('America/Yellowknife', 'Mountain Time - central Northwest Territories');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/Casey', 'Casey Station, Bailey Peninsula');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/Davis', 'Davis Station, Vestfold Hills');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/DumontDUrville', 'Dumont-d\'Urville Base, Terre Adelie');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/Mawson', 'Mawson Station, Holme Bay');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/McMurdo', 'McMurdo Station, Ross Island');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/Palmer', 'Palmer Station, Anvers Island');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/Rothera', 'Rothera Station, Adelaide Island');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/South_Pole', 'Amundsen-Scott Station, South Pole');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/Syowa', 'Syowa Station, E Ongul I');
INSERT INTO challenge.timezone(name, extra) VALUES('Antarctica/Vostok', 'Vostok Station, S Magnetic Pole');
INSERT INTO challenge.timezone(name, extra) VALUES('Arctic/Longyearbyen', 'Svalbard');
INSERT INTO challenge.timezone(name) VALUES('Asia/Aden');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Almaty', 'most locations');
INSERT INTO challenge.timezone(name) VALUES('Asia/Amman');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Anadyr', 'Moscow+10 - Bering Sea');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Aqtau', 'Atyrau (Atirau, Gur\'yev), Mangghystau (Mankistau)');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Aqtobe', 'Aqtobe (Aktobe)');
INSERT INTO challenge.timezone(name) VALUES('Asia/Ashgabat');
INSERT INTO challenge.timezone(name) VALUES('Asia/Baghdad');
INSERT INTO challenge.timezone(name) VALUES('Asia/Bahrain');
INSERT INTO challenge.timezone(name) VALUES('Asia/Baku');
INSERT INTO challenge.timezone(name) VALUES('Asia/Bangkok');
INSERT INTO challenge.timezone(name) VALUES('Asia/Beirut');
INSERT INTO challenge.timezone(name) VALUES('Asia/Bishkek');
INSERT INTO challenge.timezone(name) VALUES('Asia/Brunei');
INSERT INTO challenge.timezone(name) VALUES('Asia/Calcutta');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Choibalsan', 'Dornod, Sukhbaatar');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Chongqing', 'central China - Sichuan, Yunnan, Guangxi, Shaanxi, Guizhou, etc.');
INSERT INTO challenge.timezone(name) VALUES('Asia/Colombo');
INSERT INTO challenge.timezone(name) VALUES('Asia/Damascus');
INSERT INTO challenge.timezone(name) VALUES('Asia/Dhaka');
INSERT INTO challenge.timezone(name) VALUES('Asia/Dili');
INSERT INTO challenge.timezone(name) VALUES('Asia/Dubai');
INSERT INTO challenge.timezone(name) VALUES('Asia/Dushanbe');
INSERT INTO challenge.timezone(name) VALUES('Asia/Gaza');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Harbin', 'Heilongjiang (except Mohe), Jilin');
INSERT INTO challenge.timezone(name) VALUES('Asia/Hong_Kong');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Hovd', 'Bayan-Olgiy, Govi-Altai, Hovd, Uvs, Zavkhan');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Irkutsk', 'Moscow+05 - Lake Baikal');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Jakarta', 'Java & Sumatra');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Jayapura', 'Irian Jaya & the Moluccas');
INSERT INTO challenge.timezone(name) VALUES('Asia/Jerusalem');
INSERT INTO challenge.timezone(name) VALUES('Asia/Kabul');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Kamchatka', 'Moscow+09 - Kamchatka');
INSERT INTO challenge.timezone(name) VALUES('Asia/Karachi');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Kashgar', 'west Tibet & Xinjiang');
INSERT INTO challenge.timezone(name) VALUES('Asia/Katmandu');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Krasnoyarsk', 'Moscow+04 - Yenisei River');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Kuala_Lumpur', 'peninsular Malaysia');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Kuching', 'Sabah & Sarawak');
INSERT INTO challenge.timezone(name) VALUES('Asia/Kuwait');
INSERT INTO challenge.timezone(name) VALUES('Asia/Macau');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Magadan', 'Moscow+08 - Magadan');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Makassar', 'east & south Borneo, Celebes, Bali, Nusa Tengarra, west Timor');
INSERT INTO challenge.timezone(name) VALUES('Asia/Manila');
INSERT INTO challenge.timezone(name) VALUES('Asia/Muscat');
INSERT INTO challenge.timezone(name) VALUES('Asia/Nicosia');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Novosibirsk', 'Moscow+03 - Novosibirsk');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Omsk', 'Moscow+03 - west Siberia');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Oral', 'West Kazakhstan');
INSERT INTO challenge.timezone(name) VALUES('Asia/Phnom_Penh');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Pontianak', 'west & central Borneo');
INSERT INTO challenge.timezone(name) VALUES('Asia/Pyongyang');
INSERT INTO challenge.timezone(name) VALUES('Asia/Qatar');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Qyzylorda', 'Qyzylorda (Kyzylorda, Kzyl-Orda)');
INSERT INTO challenge.timezone(name) VALUES('Asia/Rangoon');
INSERT INTO challenge.timezone(name) VALUES('Asia/Riyadh');
INSERT INTO challenge.timezone(name) VALUES('Asia/Saigon');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Sakhalin', 'Moscow+07 - Sakhalin Island');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Samarkand', 'west Uzbekistan');
INSERT INTO challenge.timezone(name) VALUES('Asia/Seoul');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Shanghai', 'east China - Beijing, Guangdong, Shanghai, etc.');
INSERT INTO challenge.timezone(name) VALUES('Asia/Singapore');
INSERT INTO challenge.timezone(name) VALUES('Asia/Taipei');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Tashkent', 'east Uzbekistan');
INSERT INTO challenge.timezone(name) VALUES('Asia/Tbilisi');
INSERT INTO challenge.timezone(name) VALUES('Asia/Tehran');
INSERT INTO challenge.timezone(name) VALUES('Asia/Thimphu');
INSERT INTO challenge.timezone(name) VALUES('Asia/Tokyo');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Ulaanbaatar', 'most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Urumqi', 'most of Tibet & Xinjiang');
INSERT INTO challenge.timezone(name) VALUES('Asia/Vientiane');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Vladivostok', 'Moscow+07 - Amur River');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Yakutsk', 'Moscow+06 - Lena River');
INSERT INTO challenge.timezone(name, extra) VALUES('Asia/Yekaterinburg', 'Moscow+02 - Urals');
INSERT INTO challenge.timezone(name) VALUES('Asia/Yerevan');
INSERT INTO challenge.timezone(name, extra) VALUES('Atlantic/Azores', 'Azores');
INSERT INTO challenge.timezone(name) VALUES('Atlantic/Bermuda');
INSERT INTO challenge.timezone(name, extra) VALUES('Atlantic/Canary', 'Canary Islands');
INSERT INTO challenge.timezone(name) VALUES('Atlantic/Cape_Verde');
INSERT INTO challenge.timezone(name) VALUES('Atlantic/Faroe');
INSERT INTO challenge.timezone(name, extra) VALUES('Atlantic/Jan_Mayen', 'Jan Mayen');
INSERT INTO challenge.timezone(name, extra) VALUES('Atlantic/Madeira', 'Madeira Islands');
INSERT INTO challenge.timezone(name) VALUES('Atlantic/Reykjavik');
INSERT INTO challenge.timezone(name) VALUES('Atlantic/South_Georgia');
INSERT INTO challenge.timezone(name) VALUES('Atlantic/St_Helena');
INSERT INTO challenge.timezone(name) VALUES('Atlantic/Stanley');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Adelaide', 'South Australia');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Brisbane', 'Queensland - most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Broken_Hill', 'New South Wales - Yancowinna');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Currie', 'Tasmania - King Island');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Darwin', 'Northern Territory');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Eucla', 'Western Australia - Eucla area');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Hobart', 'Tasmania - most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Lindeman', 'Queensland - Holiday Islands');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Lord_Howe', 'Lord Howe Island');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Melbourne', 'Victoria');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Perth', 'Western Australia - most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('Australia/Sydney', 'New South Wales - most locations');
INSERT INTO challenge.timezone(name) VALUES('Europe/Amsterdam');
INSERT INTO challenge.timezone(name) VALUES('Europe/Andorra');
INSERT INTO challenge.timezone(name) VALUES('Europe/Athens');
INSERT INTO challenge.timezone(name) VALUES('Europe/Belgrade');
INSERT INTO challenge.timezone(name) VALUES('Europe/Berlin');
INSERT INTO challenge.timezone(name) VALUES('Europe/Bratislava');
INSERT INTO challenge.timezone(name) VALUES('Europe/Brussels');
INSERT INTO challenge.timezone(name) VALUES('Europe/Bucharest');
INSERT INTO challenge.timezone(name) VALUES('Europe/Budapest');
INSERT INTO challenge.timezone(name) VALUES('Europe/Chisinau');
INSERT INTO challenge.timezone(name) VALUES('Europe/Copenhagen');
INSERT INTO challenge.timezone(name) VALUES('Europe/Dublin');
INSERT INTO challenge.timezone(name) VALUES('Europe/Gibraltar');
INSERT INTO challenge.timezone(name) VALUES('Europe/Guernsey');
INSERT INTO challenge.timezone(name) VALUES('Europe/Helsinki');
INSERT INTO challenge.timezone(name) VALUES('Europe/Isle_of_Man');
INSERT INTO challenge.timezone(name) VALUES('Europe/Istanbul');
INSERT INTO challenge.timezone(name) VALUES('Europe/Jersey');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Kaliningrad', 'Moscow-01 - Kaliningrad');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Kiev', 'most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Lisbon', 'mainland');
INSERT INTO challenge.timezone(name) VALUES('Europe/Ljubljana');
INSERT INTO challenge.timezone(name) VALUES('Europe/London');
INSERT INTO challenge.timezone(name) VALUES('Europe/Luxembourg');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Madrid', 'mainland');
INSERT INTO challenge.timezone(name) VALUES('Europe/Malta');
INSERT INTO challenge.timezone(name) VALUES('Europe/Mariehamn');
INSERT INTO challenge.timezone(name) VALUES('Europe/Minsk');
INSERT INTO challenge.timezone(name) VALUES('Europe/Monaco');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Moscow', 'Moscow+00 - west Russia');
INSERT INTO challenge.timezone(name) VALUES('Europe/Oslo');
INSERT INTO challenge.timezone(name) VALUES('Europe/Paris');
INSERT INTO challenge.timezone(name) VALUES('Europe/Podgorica');
INSERT INTO challenge.timezone(name) VALUES('Europe/Prague');
INSERT INTO challenge.timezone(name) VALUES('Europe/Riga');
INSERT INTO challenge.timezone(name) VALUES('Europe/Rome');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Samara', 'Moscow+01 - Samara, Udmurtia');
INSERT INTO challenge.timezone(name) VALUES('Europe/San_Marino');
INSERT INTO challenge.timezone(name) VALUES('Europe/Sarajevo');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Simferopol', 'central Crimea');
INSERT INTO challenge.timezone(name) VALUES('Europe/Skopje');
INSERT INTO challenge.timezone(name) VALUES('Europe/Sofia');
INSERT INTO challenge.timezone(name) VALUES('Europe/Stockholm');
INSERT INTO challenge.timezone(name) VALUES('Europe/Tallinn');
INSERT INTO challenge.timezone(name) VALUES('Europe/Tirane');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Uzhgorod', 'Ruthenia');
INSERT INTO challenge.timezone(name) VALUES('Europe/Vaduz');
INSERT INTO challenge.timezone(name) VALUES('Europe/Vatican');
INSERT INTO challenge.timezone(name) VALUES('Europe/Vienna');
INSERT INTO challenge.timezone(name) VALUES('Europe/Vilnius');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Volgograd', 'Moscow+00 - Caspian Sea');
INSERT INTO challenge.timezone(name) VALUES('Europe/Warsaw');
INSERT INTO challenge.timezone(name) VALUES('Europe/Zagreb');
INSERT INTO challenge.timezone(name, extra) VALUES('Europe/Zaporozhye', 'Zaporozh\'ye, E Lugansk');
INSERT INTO challenge.timezone(name) VALUES('Europe/Zurich');
INSERT INTO challenge.timezone(name) VALUES('Indian/Antananarivo');
INSERT INTO challenge.timezone(name) VALUES('Indian/Chagos');
INSERT INTO challenge.timezone(name) VALUES('Indian/Christmas');
INSERT INTO challenge.timezone(name) VALUES('Indian/Cocos');
INSERT INTO challenge.timezone(name) VALUES('Indian/Comoro');
INSERT INTO challenge.timezone(name) VALUES('Indian/Kerguelen');
INSERT INTO challenge.timezone(name) VALUES('Indian/Mahe');
INSERT INTO challenge.timezone(name) VALUES('Indian/Maldives');
INSERT INTO challenge.timezone(name) VALUES('Indian/Mauritius');
INSERT INTO challenge.timezone(name) VALUES('Indian/Mayotte');
INSERT INTO challenge.timezone(name) VALUES('Indian/Reunion');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Apia');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Auckland', 'most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Chatham', 'Chatham Islands');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Easter', 'Easter Island & Sala y Gomez');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Efate');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Enderbury', 'Phoenix Islands');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Fakaofo');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Fiji');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Funafuti');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Galapagos', 'Galapagos Islands');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Gambier', 'Gambier Islands');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Guadalcanal');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Guam');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Honolulu', 'Hawaii');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Johnston', 'Johnston Atoll');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Kiritimati', 'Line Islands');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Kosrae', 'Kosrae');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Kwajalein', 'Kwajalein');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Majuro', 'most locations');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Marquesas', 'Marquesas Islands');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Midway', 'Midway Islands');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Nauru');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Niue');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Norfolk');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Noumea');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Pago_Pago');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Palau');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Pitcairn');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Ponape', 'Ponape (Pohnpei)');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Port_Moresby');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Rarotonga');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Saipan');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Tahiti', 'Society Islands');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Tarawa', 'Gilbert Islands');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Tongatapu');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Truk', 'Truk (Chuuk) and Yap');
INSERT INTO challenge.timezone(name, extra) VALUES('Pacific/Wake', 'Wake Island');
INSERT INTO challenge.timezone(name) VALUES('Pacific/Wallis');

-- ----------------------------------------------------------------------------

UPDATE property SET value = 15 WHERE key = 'Patch Level';

COMMIT;