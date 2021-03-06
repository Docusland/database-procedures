Exercise
=

This project is only meant to be used for practicing on databases. Generated a dump data.sql file for Segolène's mydb database.

Requires [composer](https://getcomposer.org/)

Installation
==

```
composer install
```

Run
==

```bash
php generateSQL.php
```

Exemple de procédure stockée
==

Prenons 4 id de groupes donnés, (75, 156, 42, 750) calculer le tarif total pour ces groupes
```sql
SET @tarif = 0;                   -- On initialise @tarif à 0
CALL calculer_cout (75, @tarif);  -- Réservation du groupe 75
CALL calculer_cout (156, @tarif);  -- Réservation du groupe 156
CALL calculer_cout (42, @tarif);  -- Réservation du groupe 42
CALL calculer_cout (750, @tarif);  -- Réservation du groupe 750
SELECT @tarif AS total;
-- SELECT sum(tarif) FROM groupes WHERE groupes.id_groupe IN (42, 75, 156, 750)
-- 138673281
```

```sql
DELIMITER |

CREATE PROCEDURE calculer_cout (IN p_group_id INT, INOUT p_cout DECIMAL(20,2))
 BEGIN
    SELECT p_cout + groupes.tarif INTO p_cout
    FROM groupes
    WHERE groupes.id_groupe = p_group_id;
END |

DELIMITER ;
```

ou encore


```sql
SET @tarif = 0;   
SET @groups := JSON_ARRAY(75, 156, 42, 750);
CALL group_cost(@groups, @tarif);
SELECT @tarif AS total;


DROP PROCEDURE IF EXISTS group_cost;
DELIMITER |
CREATE PROCEDURE group_cost(
        in_array JSON,
        INOUT p_cout DECIMAL(20,2)
    )
    COMMENT 'Iterate an array and for each item sum the group cost'
BEGIN
    DECLARE i INT UNSIGNED DEFAULT 0;
    DECLARE v_count INT UNSIGNED DEFAULT JSON_LENGTH(in_array);
    DECLARE v_current_item JSON DEFAULT NULL;
    DECLARE v_sum DECIMAL(20,2) DEFAULT p_cout;
    -- loop from 0 to the last item
    WHILE i < v_count DO
        -- get the current item and build an SQL statement
        -- to pass it to a callback procedure
        SET v_current_item = JSON_EXTRACT(in_array, CONCAT('$[', i, ']'));
        SELECT v_sum + groupes.tarif INTO v_sum
        FROM groupes
        WHERE groupes.id_groupe = v_current_item;

        SET i := i + 1;
    END WHILE;
    SELECT v_sum INTO p_cout;
END |
DELIMITER ;
```

Cursors
==

Réaliser un boucle listant les musiciens du groupe 24

Corrections
===
-----

```sql
DROP PROCEDURE loop_on_musicians;
DELIMITER |
CREATE PROCEDURE loop_on_musicians(IN g_id VARCHAR(100))
BEGIN
    DECLARE v_nom, v_prenom VARCHAR(100);
    
    -- On déclare fin comme un BOOLEAN, avec FALSE pour défaut
    DECLARE fin BOOLEAN DEFAULT FALSE;                     
    
    DECLARE curs_musiciens CURSOR
        FOR SELECT musiciens.nom, musiciens.prenom from musiciens, groupes_musiciens
          where groupes_musiciens.groupes_id_groupe = g_id
          and musiciens.id_musicien = groupes_musiciens.musiciens_id_musicien;

    -- On utilise TRUE au lieu de 1
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE; 

    OPEN curs_musiciens;                                    

    loop_curseur: LOOP                                                
        FETCH curs_musiciens INTO v_nom, v_prenom;

        IF fin THEN     -- Plus besoin de "= 1"
            LEAVE loop_curseur;
        END IF;
                   
        SELECT CONCAT(v_prenom, ' ', v_nom) AS 'Musician';
    END LOOP;

    CLOSE curs_musiciens; 
END|
DELIMITER ;

CALL loop_on_musicians(24);
```

Triggers
==

Réaliser un trigger qui, lorsque la photo a été modifiée, stocke au sein d'une table `anciennes_photos` les anciennes images référencées.

Ceci peut être pratique pour automatiser un script qui parcourera cette table et supprimera les fichiers référencés.

```sql
CREATE TABLE anciennes_photos (id INT PRIMARY KEY NOT NULL AUTO_INCREMENT , path VARCHAR(255));

DELIMITER //

CREATE TRIGGER  update_photo
    BEFORE UPDATE
    ON photos FOR EACH ROW

BEGIN  
    IF OLD.photo != NEW.photo 
    THEN
        INSERT INTO anciennes_photos (path) VALUES (OLD.photo);
    END IF 

END //
DELIMITER ;
```


Optimisations de base de données 
==
* [MysqlTuner](https://github.com/major/MySQLTuner-perl)
* Indexer les champs pertinents. Ainsi, cette tâche est complexe, minucieuse et dépendante de l'application sur laquelle vous travaillez. Il faut lire tous les SELECT afin de voir quels indexes sont pertinents. 
* Retirer les indexes inutiles
* SELECT SQL_NO_CACHE * FROM table;
* Eviter le Select *
* ANALYZE, EXPLAIN et VACUUM sont à appliquer et utiliser
* Mettre un LIMIT 1 si vous n'attendez qu'un seul enregistrement
* Activer le cache (SHOW VARIABLES LIKE 'query_cache_size'; SET GLOBAL query_cache_size = 15728640 ; ). Attention ceci est temporaire et les paramètres sont à appliquer dans le fichier my.cnf une fois validés.
* Détecter les requêtes coûteuses via long_query_time et log-slow-queries dans le fichier my.cnf

Outils et sources
==
* [Mysqldump backup and restore](https://webcheatsheet.com/sql/mysql_backup_restore.php)
* [Mysqldump options](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)


Exemple de fichier d'export
==
L'objectif est de réaliser un script permettant d'automatiser les backups de la basede données. 
Ce script peut ensuite être mis au sein de taches planifiées.

Script BAT réalisé par Dorian.

```bash
@echo off

echo ---------------------------------------------------------------
echo ---------------------------------------------------------------
echo  Generation du fichier batch pour la sauvegarde est en cours...
echo ---------------------------------------------------------------
echo ---------------------------------------------------------------

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"

set "datestamp=%YYYY%%MM%%DD%"
set "file=%1_backupfile_%datestamp%.sql"
echo %file%

mysqldump --routines -u root --databases %1 > D:/Cours/DATABASE_ADMINISTRATION/backup_db/%file%

echo ---------------------------------------------------------------
echo ---------------------------------------------------------------
echo ------------------------------FIN------------------------------
echo ---------------------------------------------------------------
echo ---------------------------------------------------------------
```

Le script d'import associé

```bash
@echo off

echo ---------------------------------------------------------------
echo ---------------------------------------------------------------
echo  IMPORT BASE DE DONNEE MYDB
echo ---------------------------------------------------------------
echo ---------------------------------------------------------------

set dir= "D:/Cours/DATABASE_ADMINISTRATION/backup_db/"

mysql -u root < %dir%%1.sql


echo ---------------------------------------------------------------
echo ---------------------------------------------------------------
echo ------------------------------FIN------------------------------
echo ---------------------------------------------------------------
echo ---------------------------------------------------------------

pause
```