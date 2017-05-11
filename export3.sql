--
-- Файл сгенерирован с помощью SQLiteStudio v3.0.7 в Mon Dec 12 00:33:44 2016
--
-- Использованная кодировка текста: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Таблица: Patient
DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient ( ID INTEGER NOT NULL PRIMARY KEY, EMSID varchar(255) NOT NULL, Age NUMERIC (10, 1) NOT NULL CHECK(Age > 0 AND Age < 120), YOB integer(10) NOT NULL CHECK (YOB > 1900 AND YOB < 2100), Sex char(1) CHECK(Sex = 'M' OR Sex='F'))
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (1, '2914/14', 50, 1964, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (2, '4049\14', 29, 1985, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (3, '4058\14', 25, 1989, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (4, '4106\14', 17, 1997, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (5, '4213\14', 56, 1958, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (6, '4036\14', 61, 1953, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (7, '4202\14', 0.1, 2014, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (8, '4527/13', 66, 1947, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (9, '5166/13', 58, 1955, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (10, '4475/13', 15, 1998, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (11, '6749/14', 69, 1945, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (12, '291/15', 0.1, 2015, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (13, '405/15', 42, 1972, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (14, '435/15', 28, 1987, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (15, '382/15', 62, 1953, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (16, '389/15', 25, 1990, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (17, '383/15', 48, 1967, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (18, '460/15', 60, 1955, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (19, '356/15', 54, 1961, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (20, '492/15', 5, 2010, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (21, '275/15', 65, 1950, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (22, '515/15', 67, 1948, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (23, '493/15', 62, 1953, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (24, '381/15', 68, 1947, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (25, '507/15', 23, 1992, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (26, '387/15', 15, 2000, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (27, '499/15', 63, 1952, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (28, '426/15', 53, 1962, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (29, '6665/14', 34, 1980, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (30, '520/15', 61, 1954, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (31, '518/15', 39, 1976, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (32, '379/15', 64, 1951, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (33, '502/15', 12, 2003, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (34, '554/15', 71, 1944, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (35, '495/15', 55, 1960, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (36, '588/15', 31, 1984, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (37, '550/15', 28, 1987, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (38, '484/15', 65, 1950, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (39, '449/15', 35, 1980, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (40, '541/15', 39, 1976, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (41, '423/15', 44, 1971, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (42, '572/15', 72, 1943, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (43, '540/15', 5, 2010, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (44, '601/15', 20, 1995, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (45, '576/15', 53, 1962, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (46, '560/15', 48, 1967, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (47, '612/15', 48, 1967, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (48, '546/15', 20, 1995, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (49, '630/15', 59, 1956, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (50, '646/15', 68, 1947, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (51, '549/15', 68, 1947, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (52, '556/15', 60, 1955, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (53, '558/15', 52, 1963, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (54, '564/15', 8, 2007, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (55, '615/15', 8, 2007, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (56, '602/15', 48, 1967, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (57, '557/15', 48, 1967, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (58, '650/15', 62, 1953, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (59, '580/15', 63, 1952, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (60, '543/15', 10, 2005, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (61, '620/15', 39, 1976, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (62, '511/15', 70, 1945, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (63, '675/15', 36, 1979, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (64, '645/15', 33, 1982, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (65, '637/15', 2, 2013, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (66, '641/15', 64, 1951, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (67, '506/15', 55, 1960, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (68, '608/15', 23, 1992, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (69, '529/15', 33, 1982, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (70, '664/15', 13, 2002, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (71, '459/15', 61, 1954, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (72, '548/15', 44, 1971, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (73, '555/15', 30, 1985, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (74, '579/15', 38, 1977, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (75, '595/15', 33, 1982, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (76, '597/15', 55, 1960, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (77, '609/15', 50, 1965, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (78, '623/15', 34, 1981, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (79, '624/15', 58, 1957, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (80, '631/15', 48, 1967, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (82, '654/15', 60, 1955, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (83, '655/15', 53, 1962, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (84, '656/15', 72, 1943, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (85, '663/15', 26, 1989, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (86, '665/15', 10, 2005, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (87, '666/15', 45, 1970, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (88, '671/15', 59, 1956, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (89, '688/15', 13, 2002, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (90, '690/15', 62, 1953, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (91, '692/15', 50, 1965, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (92, '695/15', 8, 2007, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (93, '698/15', 46, 1969, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (94, '704/15', 9, 2006, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (95, '706/15', 6, 2009, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (96, '707/15', 35, 1980, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (97, '710/15', 33, 1982, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (98, '715/15', 2.5, 2012, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (99, '719/15', 36, 1979, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (101, '720/15', 59, 1956, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (102, '726/15', 62, 1953, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (103, '727/15', 45, 1970, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (104, '728/15', 58, 1957, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (105, '731/15', 49, 1966, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (106, '734/15', 0.1, 2015, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (107, '736/15', 73, 1942, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (108, '738/15', 66, 1949, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (109, '747/15', 26, 1989, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (110, '751/15', 54, 1961, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (111, '755/15', 55, 1960, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (112, '762/15', 65, 1950, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (113, '764/15', 16, 1999, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (114, '770/15', 4, 2011, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (115, '775/15', 26, 1989, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (116, '783/15', 60, 1955, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (117, '787/15', 41, 1974, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (118, '788/15', 45, 1970, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (119, '795/15', 64, 1951, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (120, '797/15', 34, 1981, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (121, '801/15', 29, 1986, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (122, '806/15', 61, 1954, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (123, '809/15', 60, 1955, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (124, '818/15', 48, 1967, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (125, '819/15', 53, 1962, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (126, '823/15', 55, 1960, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (127, '825/15', 21, 1994, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (128, '829/15', 59, 1956, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (129, '830/15', 60, 1955, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (130, '831/15', 70, 1945, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (131, '835/15', 47, 1968, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (132, '843/15', 75, 1940, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (133, '846/15', 34, 1981, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (134, '857/15', 43, 1972, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (135, '858/15', 48, 1967, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (136, '859/15', 29, 1986, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (137, '860/15', 1.25, 2014, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (138, '861/15', 22, 1993, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (139, '862/15', 39, 1976, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (140, '864/15', 57, 1958, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (141, '868/15', 16, 1999, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (142, '874/15', 30, 1985, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (143, '877/15', 58, 1957, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (144, '879/15', 45, 1970, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (145, '883/15', 25, 1990, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (146, '884/15', 43, 1972, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (147, '885/15', 39, 1976, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (148, '886/15', 53, 1962, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (149, '893/15', 38, 1977, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (150, '894/15', 68, 1947, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (151, '912/15', 13, 2002, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (152, '918/15', 42, 1973, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (153, '922/15', 53, 1962, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (154, '923/15', 5, 2010, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (155, '926/15', 67, 1948, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (156, '937/15', 28, 1987, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (157, '946/15', 20, 1995, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (158, '950/15', 20, 1995, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (159, '964/15', 29, 1986, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (160, '988/15', 63, 1952, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (161, '991/15', 27, 1988, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (162, '993/15', 67, 1948, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (163, '1010/15', 60, 1955, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (164, '1028/15', 58, 1957, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (165, '1040/15', 66, 1949, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (166, '1041/15', 30, 1985, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (167, '1043/15', 64, 1951, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (168, '1049/15', 38, 1977, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (169, '1050/15', 75, 1940, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (170, '1058/15', 54, 1961, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (171, '1059/15', 5, 2010, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (172, '1065/15', 70, 1945, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (173, '1069/15', 55, 1960, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (174, '1070/15', 63, 1952, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (175, '1075/15', 58, 1957, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (176, '1078/15', 57, 1958, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (177, '1083/15', 49, 1966, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (178, '1084/15', 48, 1967, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (179, '1087/15', 66, 1949, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (180, '1089/15', 63, 1952, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (181, '1091/15', 60, 1955, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (182, '1103/15', 49, 1966, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (183, '1112/15', 9, 2006, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (184, '1121/15', 67, 1948, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (185, '1124/15', 53, 1962, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (186, '1127/15', 56, 1959, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (187, '1128/15', 30, 1985, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (188, '1136/15', 52, 1963, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (189, '1137/15', 67, 1948, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (190, '1146/15', 53, 1962, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (191, '1150/15', 12, 2003, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (192, '1170/15', 12, 2003, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (193, '1171/15', 33, 1982, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (194, '1172/15', 62, 1953, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (195, '1174/15', 23, 1992, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (196, '1175/15', 56, 1959, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (197, '1178/15', 23, 1992, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (198, '1182/15', 56, 1959, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (199, '1183/15', 33, 1982, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (200, '1184/15', 12, 2003, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (201, '1186/15', 61, 1954, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (202, '1187/15', 51, 1964, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (203, '1189/15', 30, 1985, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (204, '1191/15', 62, 1953, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (205, '1193/15', 45, 1970, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (206, '1194/15', 27, 1988, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (207, '1197/15', 21, 1994, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (208, '1198/15', 60, 1955, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (209, '1203/15', 12, 2003, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (210, '1205/15', 35, 1980, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (211, '1214/15', 51, 1964, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (212, '1216/15', 55, 1960, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (213, '1217/15', 66, 1949, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (214, '1219/15', 50, 1965, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (215, '1227/15', 30, 1985, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (216, '1232/15', 63, 1952, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (217, '1237/15', 68, 1947, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (218, '1249/15', 55, 1960, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (219, '1257/15', 48, 1967, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (220, '1262/15', 73, 1942, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (221, '1268/15', 43, 1972, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (222, '1285/15', 64, 1951, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (223, '1294/15', 53, 1962, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (224, '1301/15', 12, 2003, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (225, '1306/15', 27, 1988, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (226, '1307/15', 5, 2010, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (227, '1308/15', 68, 1947, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (228, '1322/15', 15, 2000, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (229, '1323/15', 26, 1989, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (230, '1333/15', 71, 1944, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (231, '1343/15', 37, 1978, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (232, '1346/15', 51, 1964, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (233, '1347/15', 4, 2011, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (234, '1353/15', 42, 1973, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (235, '1360/15', 58, 1957, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (236, '1389/15', 58, 1957, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (237, '1409/15', 21, 1994, 'M');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (238, '1411/15', 32, 1983, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (239, '1414/15', 52, 1963, 'F');
INSERT INTO Patient (ID, EMSID, Age, YOB, Sex) VALUES (240, '1429/15', 27, 1988, 'M');

-- Таблица: Diagnosis
DROP TABLE IF EXISTS Diagnosis;
CREATE TABLE Diagnosis ( ID INTEGER NOT NULL PRIMARY KEY, Name varchar(255) NOT NULL UNIQUE, Description varchar(4000), Ref varchar(1000))
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (1, 'Adenoma', 'Аденома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (2, 'Astrocytoma', 'Астроцитома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (3, 'Ganglioglioma', 'Ганглиоглиома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (4, 'Germinoma', 'Герминома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (5, 'Glioblastoma', 'Глиобластома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (6, 'Carcinoma', 'Карцинома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (7, 'Melanoma', 'Меланома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (8, 'Meningioma', 'Менингиома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (9, 'Neurinoma', 'Невринома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (10, 'Neurofibroma', 'Нейрофиброма', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (11, 'Oligoastrocytoma', 'Олигоастроцитома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (12, 'Subependimoma', 'Субэпендимома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (13, 'Chordoma', 'Хордома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (14, 'Ependimoma', 'Эпендимома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (15, 'Neuroepithelial tumor', 'Дизэмбриобластическая нейроэпителиальная опухоль ', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (16, 'Primitive neuroectodermal tumor', 'Примитивная нейроэктодермальная опухоль', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (17, 'Cholesteatoma', 'Холестеатома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (18, 'Medulloblastoma', 'Медуллобластома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (19, 'Adenocarcinoma', 'Аденокарцинома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (20, 'Xantoastrocytoma', 'Ксантоастроцитома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (22, 'Glioneural tumor', 'глио-нейрональная опухоль 4 желудочка', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (23, 'Chorioidpapilloma', 'Хориодипапиллома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (25, 'Craniofaringioma', 'Краниофарингиома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (26, 'Necrosis', 'Некроз', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (28, 'Hemangioblastoma', 'Гемангиобластома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (29, 'Giant-cell tumor of bone', 'Гигантоклеточная опухоль', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (30, 'Gliosarkoma', 'Глиосаркома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (31, 'Primary lymphoma of B-cell', 'Лимфома первичная В-клеточная ', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (33, 'Metastasis NSCLC', 'Метастаз немелкоклеточного рака легкого', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (34, 'Metastasis clear cell', 'Метастаз светлоклеточного рака', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (35, 'Brain', 'Мозг', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (36, 'Metastatic prostate cancer moles', 'метастаз рака мол железы', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (37, 'Oligodendroglioma', 'Олигодендроглиома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (39, 'Schwannoma', 'Шваннома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (40, 'n/d', 'без диагноза/нет в списке', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (41, 'Ameloblastoma', 'амелобластома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (42, 'Pinealoma', 'пинеоцитома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (43, 'papillary tumor', 'папиллярная опухоль', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (44, 'clear-cell carcinoma', 'рак почки', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (45, 'gangioastrocytoma', 'гангиоастроцитома', NULL);
INSERT INTO Diagnosis (ID, Name, Description, Ref) VALUES (46, 'glia hyperplasia', 'гиперплазия глиальной ткани', NULL);

-- Таблица: Diagnosis_Comment
DROP TABLE IF EXISTS Diagnosis_Comment;
CREATE TABLE Diagnosis_Comment ( DiagnosisID integer(10) NOT NULL, CommentID integer(10) NOT NULL, PRIMARY KEY (DiagnosisID, CommentID), FOREIGN KEY(CommentID) REFERENCES Comment(ID), FOREIGN KEY(DiagnosisID) REFERENCES Diagnosis(ID))

-- Таблица: Tissue
DROP TABLE IF EXISTS Tissue;
CREATE TABLE Tissue ( ID integer(10) NOT NULL, PatientID integer(10) NOT NULL, Location varchar(4000) NOT NULL, Diagnosis integer(10) NOT NULL, Grade integer(10), "Date" date NOT NULL, Coords varchar(255), PRIMARY KEY (ID, PatientID), FOREIGN KEY(Diagnosis) REFERENCES Diagnosis(ID), FOREIGN KEY(PatientID) REFERENCES Patient(ID))

-- Таблица: Device
DROP TABLE IF EXISTS Device;
CREATE TABLE Device ( ID INTEGER NOT NULL PRIMARY KEY, Name varchar(255) NOT NULL UNIQUE, Location varchar(4000) NOT NULL, Description varchar(4000) NOT NULL)
INSERT INTO Device (ID, Name, Location, Description) VALUES (1, 'LTQ1', 'IBP', 'Thermo Finnigan LTQ FT. оборудованного сверхпроводящим магнитом 7Т');

-- Таблица: Sample
DROP TABLE IF EXISTS Sample;
CREATE TABLE Sample ( TumorID integer(10) NOT NULL, TumorPatientID integer(10) NOT NULL, ID integer(10) NOT NULL, Label varchar(255) NOT NULL, Coords varchar(255), Histology varchar(4000), PRIMARY KEY (TumorID, TumorPatientID, ID), FOREIGN KEY(TumorID, TumorPatientID) REFERENCES Tissue(ID, PatientID))

-- Таблица: Spectrum
DROP TABLE IF EXISTS Spectrum;
CREATE TABLE Spectrum ( SampleTumorID integer(10) NOT NULL, SampleTumorPatientID integer(10) NOT NULL, SampleID integer(10) NOT NULL, ID integer(10) NOT NULL, Solvent integer(10) NOT NULL, Device integer(10) NOT NULL, RTrange integer(10), MZrange integer(10), "Date" date NOT NULL, FileName varchar(255) NOT NULL UNIQUE, PRIMARY KEY (SampleTumorID, SampleTumorPatientID, SampleID, ID), FOREIGN KEY(Solvent) REFERENCES Solvent(ID), FOREIGN KEY(Device) REFERENCES Device(ID), FOREIGN KEY(SampleTumorID, SampleTumorPatientID, SampleID) REFERENCES Sample(TumorID, TumorPatientID, ID))

-- Таблица: Solvent
DROP TABLE IF EXISTS Solvent;
CREATE TABLE Solvent ( ID INTEGER NOT NULL PRIMARY KEY, Name varchar(255) NOT NULL UNIQUE, Composition varchar(4000) NOT NULL UNIQUE)
INSERT INTO Solvent (ID, Name, Composition) VALUES (1, 'Met', 'Methanol(HPLC grade)');
INSERT INTO Solvent (ID, Name, Composition) VALUES (2, 'MetCl', 'Methanol+chloroform');

-- Таблица: Sample_Comment
DROP TABLE IF EXISTS Sample_Comment;
CREATE TABLE Sample_Comment ( SampleTumorID integer(10) NOT NULL, SampleTumorPatientID integer(10) NOT NULL, SampleID integer(10) NOT NULL, CommentID integer(10) NOT NULL, PRIMARY KEY (SampleTumorID, SampleTumorPatientID, SampleID, CommentID), FOREIGN KEY(CommentID) REFERENCES Comment(ID), FOREIGN KEY(SampleTumorID, SampleTumorPatientID, SampleID) REFERENCES Sample(TumorID, TumorPatientID, ID))

-- Таблица: TissueType
DROP TABLE IF EXISTS TissueType;
CREATE TABLE TissueType ( ID INTEGER NOT NULL PRIMARY KEY, Name varchar(255) NOT NULL UNIQUE, Description varchar(4096))
INSERT INTO TissueType (ID, Name, Description) VALUES (1, 'Brain', 'unmodified brain tissue');
INSERT INTO TissueType (ID, Name, Description) VALUES (2, 'Tumor', 'tumor');
INSERT INTO TissueType (ID, Name, Description) VALUES (3, 'Necrosis', 'necrotic masses');

-- Таблица: Tissue_TissueType
DROP TABLE IF EXISTS Tissue_TissueType;
CREATE TABLE Tissue_TissueType ( TissueID integer(10) NOT NULL, TissuePatientID integer(10) NOT NULL, TissueTypeID integer(10) NOT NULL, PRIMARY KEY (TissueID, TissuePatientID, TissueTypeID), FOREIGN KEY(TissueTypeID) REFERENCES TissueType(ID), FOREIGN KEY(TissueID, TissuePatientID) REFERENCES Tissue(ID, PatientID))

-- Таблица: Tissue_Comment
DROP TABLE IF EXISTS Tissue_Comment;
CREATE TABLE Tissue_Comment ( TissueID integer(10) NOT NULL, TissuePatientID integer(10) NOT NULL, CommentID integer(10) NOT NULL, PRIMARY KEY (TissueID, TissuePatientID, CommentID), FOREIGN KEY(CommentID) REFERENCES Comment(ID), FOREIGN KEY(TissueID, TissuePatientID) REFERENCES Tissue(ID, PatientID))

-- Таблица: Spectrum_Comment
DROP TABLE IF EXISTS Spectrum_Comment;
CREATE TABLE Spectrum_Comment ( SpectrumSampleTumorID integer(10) NOT NULL, SpectrumSampleTumorPatientID integer(10) NOT NULL, SpectrumSampleID integer(10) NOT NULL, SpectrumID integer(10) NOT NULL, CommentID integer(10) NOT NULL, PRIMARY KEY (SpectrumSampleTumorID, SpectrumSampleTumorPatientID, SpectrumSampleID, SpectrumID, CommentID), FOREIGN KEY(CommentID) REFERENCES Comment(ID), FOREIGN KEY(SpectrumSampleTumorID, SpectrumSampleTumorPatientID, SpectrumSampleID, SpectrumID) REFERENCES Spectrum(SampleTumorID, SampleTumorPatientID, SampleID, ID))

-- Таблица: Comment
DROP TABLE IF EXISTS Comment;
CREATE TABLE Comment ( ID INTEGER NOT NULL PRIMARY KEY, "Date" timestamp NOT NULL, Comment varchar(4096) NOT NULL)

-- Индекс: Patient_EMSID
DROP INDEX IF EXISTS Patient_EMSID;
CREATE UNIQUE INDEX Patient_EMSID ON Patient (EMSID)

-- Индекс: Spectrum_Date
DROP INDEX IF EXISTS Spectrum_Date;
CREATE INDEX Spectrum_Date ON Spectrum ("Date")

-- Индекс: Patient_YOB
DROP INDEX IF EXISTS Patient_YOB;
CREATE INDEX Patient_YOB ON Patient (YOB)

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
