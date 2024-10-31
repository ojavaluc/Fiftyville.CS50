-- Verificar a cena do crime na Humphrey Street em 28 de julho de 2023.
SELECT * FROM crime_scene_reports WHERE day = 28 AND month = 7 AND year = 2023 AND street = 'Humphrey Street';
-- Resultado:
-- id 295, ano 2023, mes 7, dia 28, street Humphrey Street.
-- Descrição: O roubo do pato cs50 ocorreu às 10h15 na Humphrey Street Bakery.
-- As entrevistas foram realizadas hoje com três testemunhas que estavam presentes no momento - cada uma de suas transcrições menciona a Padaria.
-- id 297, ano 2023, mes 7, dia 28, street Humphrey Street.
-- Descrição: O lixo ocorreu às 16h36. Nenhuma testemunha conhecida.



-- Obter todas as pessoas
SELECT transcript FROM interviews WHERE day=28;
/*ele não pode deitar na rua, podemos trazê-lo para marm?
Por que, indded? murmurou Holmes. Sua majestade não havia falado antes que eu soubesse que estava me dirigindo a Wilhelm Gottsreich Sigismond von Ormstein, grão-duque de Cassel-Felstein e rei hereditário da Boêmia.*/
/*r em algum momento 10 minutos após o roubo viu o ladrão entrarem um carro no estacionamento da padaria e ir embora se você tiver imagens de segurança do estabelecimento da padaria convém procurar carros que saíram do estacionamento nesse período*/
/*Quando o ladrão estava saindo da padaria, eles ligaram para alguém que falou com eles por menos de um minuto. Na ligação, ouvi o ladrão dizer que eles estavam planejando pegar o primeiro vôo de Fiftyville amanhã. O ladrão então pediu à pessoa do outro lado da linha para comprar a passagem aérea*/


SELECT license_plate FROM bakery_security_logs WHERE day=28 AND activity='exit' AND hour=10 AND minute>15 AND minute<25;
/*| license_plate |
+---------------+
| 5P2BI95       |
| 94KL13X       |
| 6P58WS2       |
| 4328GD8       |
| G412CB7       |
| L93JTIZ       |
| 322W7JE       |
| 0NTHK55       |
+---------------+*/

SELECT name FROM people WHERE license_plate IN (
    SELECT license_plate FROM bakery_security_logs WHERE day=28 AND activity='exit' AND hour=10 AND minute>15 AND minute<25
);
/*|  name   |
+---------+
| Vanessa |
| Barry   |
| Iman    |
| Sofia   |
| Luca    |
| Diana   |
| Kelsey  |
| Bruce   |
+---------+*/

SELECT name FROM people WHERE id IN (
    SELECT person_id FROM bank_accounts WHERE account_number IN (
        SELECT account_number FROM atm_transactions WHERE transaction_type='withdraw' AND day=28 AND atm_location='Leggett Street'
    )
);
/*
| Kenny   |
| Iman    |
| Benista |
| Taylor  |
| Brooke  |
| Luca    |
| Diana   |
| Bruce   |
+---------+ */

SELECT name FROM people WHERE phone_number IN (
    SELECT caller FROM phone_calls WHERE day=28 AND duration<60
);


/*
+---------+
|  name   |
+---------+
| Kenny   |
| Sofia   |
| Benista |
| Taylor  |
| Diana   |
| Kelsey  |
| Bruce   |
| Carina  |
+---------+
*/

SELECT name FROM people WHERE phone_number IN (
    SELECT receiver FROM phone_calls WHERE day=28 AND duration<60
);


/*+------------+
|    name    |
+------------+
| James      |
| Larry      |
| Anna       |
| Jack       |
| Melissa    |
| Jacqueline |
| Philip     |
| Robin      |
| Doris      |
+------------+
*/


SELECT id FROM flights WHERE origin_airport_id= (SELECT id FROM airports WHERE city='Fiftyville') AND day=29
    ORDER BY hour, minute
        LIMIT 1;
--O ladrão escapou de cinquenta anos em flight_id = 36



SELECT name FROM people WHERE passport_number IN (
    SELECT passport_number FROM passengers WHERE flight_id=36
);


/*
+--------+
|  name  |
+--------+
| Kenny  |
| Sofia  |
| Taylor |
| Luca   |
| Kelsey |
| Edward |
| Bruce  |
| Doris  |
+--------+
*/


SELECT p.name FROM people p
INNER JOIN passengers ps ON p.passport_number = ps.passport_number AND ps.flight_id = 36
INNER JOIN phone_calls pc ON p.phone_number = pc.caller AND pc.day = 28 AND pc.duration < 60
INNER JOIN bakery_security_logs bsl ON p.license_plate = bsl.license_plate AND bsl.day = 28 AND bsl.activity = 'exit' AND bsl.hour = 10 AND bsl.minute > 15 AND bsl.minute < 25
INNER JOIN bank_accounts ba ON p.id = ba.person_id
INNER JOIN atm_transactions atm ON ba.account_number = atm.account_number AND atm.transaction_type = 'withdraw' AND atm.day = 28 AND atm.atm_location = 'Leggett Street';

/*- A única pessoa comum em todas essas listas é Bruce.
- Confirmamos que Bruce é o criminoso.
*/

SELECT name FROM people WHERE phone_number IN (
    SELECT receiver FROM phone_calls WHERE day=28 AND duration<60 AND caller = (
        SELECT phone_number FROM people WHERE name='Bruce'
    )
);

/*
+-------+
| name  |
+-------+
| Robin |
+-------+
Thus, Robin is the accomplice
*/




SELECT *
FROM flights JOIN airports ON destination_airport_id = airports.id
WHERE destination_airport_id = 36;



SELECT *
FROM flights JOIN airports ON flights.origin_airport_id = airports.id
WHERE year = 2023 AND month = 7 AND day = 29 AND origin_airport_id = 8;



-- Verifique o banco de dados de pessoas de Fiftyville para combinar os números das placas acima com as pessoas
SELECT *
FROM people
WHERE (license_plate = "5P2BI95");

SELECT *
FROM people
WHERE license_plate = "94KL13X";

SELECT *
FROM people
WHERE license_plate = "6P58WS2";

SELECT *
FROM people
WHERE license_plate = "4328GD8";

SELECT *
FROM people
WHERE license_plate = "G412CB7";

SELECT *
FROM people
WHERE license_plate = "L93JTIZ";

SELECT *
FROM people
WHERE license_plate = "322W7JE";

SELECT *
FROM people
WHERE license_plate = "0NTHK55";



--Check phone logs for calls that took place at the time and date of theft that were <= 60 secs

SELECT *
FROM phone_calls
WHERE year = 2023 AND day = 28 AND month = 7 AND duration <= 60;

--resultado
/*id | caller | receiver | year | month | day | duration
221 | (130) 555-0289 | (996) 555-8899 | 2023 | 7 | 28 | 51 Sofia
224 | (499) 555-9472 | (892) 555-8872 | 2023 | 7 | 28 | 36 Kelsey
233 | (367) 555-5533 | (375) 555-8161 | 2023 | 7 | 28 | 45 Bruce
234 | (609) 555-5876 | (389) 555-5198 | 2023 | 7 | 28 | 60
251 | (499) 555-9472 | (717) 555-1342 | 2023 | 7 | 28 | 50
254 | (286) 555-6063 | (676) 555-6554 | 2023 | 7 | 28 | 43
255 | (770) 555-1861 | (725) 555-3243 | 2023 | 7 | 28 | 49 Diana
261 | (031) 555-6622 | (910) 555-3251 | 2023 | 7 | 28 | 38
279 | (826) 555-1652 | (066) 555-9701 | 2023 | 7 | 28 | 55
281 | (338) 555-6650 | (704) 555-2131 | 2023 | 7 | 28 | 54
*/

--AGORA TEMOS 4 SUSPEITOS:Sofia, Kelsey, Bruce,Diana.



/*AGORA vamos descobrir para quem os 4 suspeitos estavam ligando no momento do roubo*/
SELECT *
FROM people
WHERE phone_number = "(996) 555-8899";
/*id | name | phone_number | passport_number | license_plate
567218 | Jack | (996) 555-8899 | 9029462229 | 52R0Y8U    */


SELECT *
FROM people
WHERE phone_number = "(375) 555-8161";
/*id | name | phone_number | passport_number | license_plate
864400 | Robin | (375) 555-8161 | NULL | 4V16VO0    */

SELECT *
FROM people
WHERE phone_number = "(725) 555-3243";
/*id | name | phone_number | passport_number | license_plate
847116 | Philip |  (725) 555-3243 | 3391710505 | GW362R6*/

SELECT *
FROM people
WHERE phone_number = "(892) 555-8872";
/*id | name | phone_number | passport_number | license_plate
251693 | Larry |  (892) 555-8872 | 2312901747 | O268ZZ0*/



SELECT *
FROM flights JOIN airports ON destination_airport_id = airports.id
WHERE destination_airport_id = 4;
