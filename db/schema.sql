-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Gép: pelda_host:3306
-- Létrehozás ideje: 2021. Ápr 28. 04:12
-- Kiszolgáló verziója: 8.0.24
-- PHP verzió: 7.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `test_db`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `dishes`
--

CREATE TABLE `dishes` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` varchar(10000) NOT NULL,
  `price` int NOT NULL,
  `isActive` tinyint(1) NOT NULL,
  `dishTypeId` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- A tábla adatainak kiíratása `dishes`
--

INSERT INTO `dishes` (`id`, `name`, `slug`, `description`, `price`, `isActive`, `dishTypeId`) VALUES
(1, 'Borsóleves', 'borsoleves', 'Zsenge mirelit borsóból és mélyhűtött zöldségekből készült rendkívül ízletes tavaszi leves.', 700, 1, 1),
(2, 'Húsleves', 'husleves', 'Csirkehúsból, gyökérzöldségekből és leveskockából készült ízletes leves.', 690, 1, 1),
(3, 'Sütőtök krémleves', 'sutotok-kremleves', 'Halloweeni hangulat az év (szinte) minden napján - szigorúan étkezési célú sütőtökből készült, ízletes őszi leves!', 890, 0, 1),
(4, 'Tojásleves', 'tojasleves', 'Őrölt köménnyel, paprikás rántással készült leves változatos méretű tyúktojásokból, csurgatva.', 590, 1, 1),
(5, 'Meggyleves', 'meggyleves', 'Tejszínes, zamatos hideg gyümölcsleves, laktózt igen, magokat elvétve, kukacokat remélhetőleg nem tartalmaz.', 690, 1, 1),
(6, 'Frankfurti leves', 'frankfurti-leves', 'Virsli, tejfölös habarás és kelkáposzta. Mennyei ízvilág!', 880, 1, 1),
(7, 'Sertéspörkölt', 'sertesporkolt', 'Sertéspörkölt magyarosan. Nem is kell ehhez semmi mást hozzáfűzni!', 1850, 1, 2),
(8, 'Párizsias csirkemell rizzsel', 'parizsias-csirkemell-rizzsel', 'Finom rántott csirkemell párizsias bundában. Megfelelően ropogós. Párolt rizs körettel tálaljuk.', 1950, 1, 2),
(9, 'Rakott kelkáposzta', 'rakott-kelkaposzta', 'Sajt, tejföl, kelkáposzta, darált hús egymásra helyezve tetszőleges sorrendben, majd kisütve.', 1750, 1, 2),
(10, 'Svéd húsgolyó', 'sved-husgolyo', 'Zamatos sűrített paradicsomból, friss káposztából készült paradicsomos káposzta  húsgombóccal. ', 1550, 1, 2),
(11, 'Rántott szelet burgonyapürével és kukoricasalátával', 'rantott-szelet-burgonyapurevel-es-kukoricasalataval', 'Igazi ünnepi főétel, rendkívül finom!!! ', 2560, 1, 2),
(12, 'Sült csirkemell parajos penne tésztával', 'sult-csirkemell-parajos-penne-tesztaval', 'Egyértelműen Popeye kedvence!', 2250, 1, 2),
(13, 'Sütőtökös sajtos makaróni (kis adag)', 'sutotokos-sajtos-makaroni-kis-adag', 'Igazi őszi desszert.', 550, 0, 3),
(14, 'Almásrétes', 'almasretes', 'Almából és rétesből.', 750, 1, 3),
(15, 'Palacsinta', 'palacsinta', 'Három darab palacsinta, kakaóból, lekvárból és palacsintából.', 750, 1, 3),
(16, 'Gundel palacsinta', 'gundel-palacsinta', 'Csokis öntet, dió és palacsinta. Tűzforró ízélmény!', 980, 1, 3),
(17, 'Almás pite', 'almas-pite', 'Almából és pitéből.', 750, 1, 3),
(18, 'Túrógombóc', 'turogomboc', 'Túróból, búzadarából, tojásból és fagyasztott málnából, tejföllel és porcukorral megszórva.', 790, 1, 3),
(19, 'Bambi', 'bambi', 'Narancsolajból készült retro üdítőital a pincéből.', 310, 1, 4),
(20, 'Nagymarosi ásványvíz', 'nagymarosi-asvanyviz', 'Ásványvíz számtalan buborékkal.', 270, 1, 4),
(21, 'Sárga kóla', 'sarga-kola', 'Sárga színű szénsavas üdítőital.', 290, 1, 4),
(22, 'Zöld kóla', 'zold-kola', 'Zöld színű szénsavas üdítőital.', 290, 1, 4),
(23, 'Meggylé', 'meggyle', 'Meggyből készült szénsavmentes üdítőital.', 280, 1, 4),
(24, 'Sütőtöklé', 'sutotokle', 'Sütőtökből készült narancssárga színvilágú szénsavmentes üdítőital.', 350, 0, 4),
(34, 'Szilvás gombóc', 'szilvas-gomboc', 'Szilvás gombóc mag nélküli besztercei szilvával töltve.', 780, 0, 3);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `dishTypes`
--

CREATE TABLE `dishTypes` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` varchar(10000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- A tábla adatainak kiíratása `dishTypes`
--

INSERT INTO `dishTypes` (`id`, `name`, `slug`, `description`) VALUES
(1, 'Levesek', 'levesek', ''),
(2, 'Főételek', 'foetelek',''),
(3, 'Desszertek', 'desszertek',''),
(4, 'Italok', 'italok','');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `createdAt` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `dishes`
--
ALTER TABLE `dishes`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `dishTypes`
--
ALTER TABLE `dishTypes`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);


INSERT INTO `users` (`id`, `email`, `password`, `createdAt`) VALUES
(1, 'teszt@kodbazis.hu', '$2y$10$yxi.oyIMlNXsLV5a5NKRGulvsv0sE3W18NNsfe.28XsW0y9rfXqZm', 1619583304);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `dishes`
--
ALTER TABLE `dishes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT a táblához `dishTypes`
--
ALTER TABLE `dishTypes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
