/* This data is acquired from the Toronto Open Data site
 * https://www.toronto.ca/city-government/data-research-maps/open-data/open-data-catalogue/#8161bd0d-e8c2-f7ef-73b0-1d2ad084d2a7
 * The DBF (access) db was converted to CSV then stripped of the columns that are not needed
 * The ID refers to the provided "unique facility ID" from Parks & Recreation */
CREATE TABLE IF NOT EXISTS locations(id INTEGER PRIMARY KEY, name TEXT, longitude REAL,latitude REAL, address TEXT)
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (323,'Agincourt Recreation Centre',-79.27629313,43.78841444,'31 Glen Watford Dr');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (777,'Albert Campbell Collegiate Institute',-79.27340979,43.80902284,'1550 Sandhurst Crcl');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1680,'Albion Pool And Health Club',-79.58119369,43.73929345,'1485 Albion Rd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1688,'Alderwood Pool',-79.54735577,43.60190521,'2 Orianna Dr');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (124,'Antibes Community Centre',-79.44697983,43.78116358,'140 Antibes Dr');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (80,'Beaches Recreation Centre',-79.29881027,43.67393961,'6 Williamson Rd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (165,'Birchmount Community Centre',-79.26311121,43.69563261,'93 Birchmount Rd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (97,'Brown Community Centre',-79.40131552,43.6849215,'454 Avenue Rd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (35,'Centennial Recreation Centre - Etobicoke',-79.47698428,43.69007765,'2694 Eglinton Ave W');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (454,'Centennial Recreation Centre-Scarborough',-79.23511108,43.77554037,'1967 Ellesmere Rd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (131,'Cummer Park Community Centre',-79.37126221,43.80010377,'6000 Leslie St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1303,'DA Morrison Junior High School',-79.31169566,43.69540506,'271 Gledhill Ave');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (707,'Dennis R.Timbrell Resource Centre',-79.33169059,43.71794928,'29 St Dennis Dr');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (631,'Douglas Snow Aquatic Centre',-79.41289647,43.76781434,'5100 Yonge St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (109,'Earl Beatty Community Centre',-79.32156863,43.6862324,'455 Glebeholme Blvd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (814,'East York Community Centre',-79.34927367,43.69179258,'1081 1/2 Pape Ave');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (599,'Emery Collegiate Institute',-79.53955698,43.74872271,'3395 Weston Rd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (617,'Fairmount Park Community Centre',-79.31511551,43.67664643,'1757 Gerrard St E');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (118,'Frankland Community Centre',-79.34994067,43.67714593,'816 Logan Ave');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (741,'Gordon A Brown Middle School',-79.30535617,43.70787791,'2800 St Clair Ave E');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1687,'Gus Ryder Pool And Health Club',-79.52210813,43.60114448,'1 Faustina Dr');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (130,'Harrison Pool',-79.39086445,43.65105808,'15 Stephanie St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (137,'Hillcrest Community Centre',-79.41649871,43.67920594,'1339 Bathurst St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1511,'Humber Community Pool',-79.60683987,43.72916655,'205 Humber College Blvd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (154,'Jimmie Simpson Recreation Centre',-79.34533309,43.66045212,'870 Queen St E');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (173,'Joseph J. Piccininni Community Centre',-79.45139986,43.67533938,'1369 St Clair Ave W');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1344,'Lester B. Pearson Collegiate Institute',-79.22540187,43.80334254,'150 Tapscott Rd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (199,'Main Square Community Centre',-79.30018106,43.68735404,'245 Main St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (223,'Mary McCormick Recreation Centre',-79.43344683,43.64735264,'66 Sheridan Ave');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (431,'Matty Eckler Recreation Centre',-79.33940021,43.66806225,'953 Gerrard St E');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (14,'Nelson A. Boylen Collegiate Institute',-79.49547522,43.71713612,'155 Falstaff Ave');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1420,'Norseman Community School And Pool',-79.51633302,43.63431384,'105 Norseman St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (445,'Parkdale Community Recreation Centre',-79.43746726,43.64340418,'75 Lansdowne Ave');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1168,'Regent Park Aquatic Centre',-79.36096074,43.66076364,'640 Dundas St E');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (174,'Runnymede Collegiate Institute',-79.48981466,43.66354085,'569 Jane St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (497,'S.H. Armstrong Community Centre',-79.32284165,43.66595839,'56 Woodfield Rd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (591,'Scadding Court Community Centre',-79.40489713,43.65179429,'707 Dundas St W');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1395,'Sir Oliver Mowat Collegiate Institute',-79.14224148,43.77931055,'5400 Lawrence Ave E');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (517,'St. Lawrence Community Recreation Centre',-79.36498334,43.64980612,'230 The Esplanade');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (537,'Swansea Community Recreation Centre',-79.4771188,43.64411206,'15 Waller Ave');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (1404,'The Elms Community School',-79.55211708,43.72223589,'45 Golfdown Dr');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (550,'Trinity Community Recreation Centre',-79.41537391,43.64643528,'155 Crawford St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (166,'Vaughan Road Academy',-79.43670608,43.69103029,'529 Vaughan Rd');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (570,'Wallace-Emerson Community Centre',-79.43927386,43.66732359,'1260 Dufferin St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (178,'Weston Collegiate Institute',-79.50942503,43.7038249,'100 Pine St');
INSERT INTO locations(id,name,longitude,latitude,address) VALUES (652,'Wexford Collegiate Institute',-79.3067986,43.74616817,'1176 Pharmacy Ave');
