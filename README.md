Exercice
=

Ce projet est à destination d'étudiants pour s'entrainer à réaliser des scripts de base de donnée.
Basé sur une modélisation de base réalisée par Segolène.

Importer des données
===
Importez le fichier structure.sql ainsi que le fichier data.sql

Vous pouvez aussi générer un nouveau jeu de données.
===
Requiert [composer](https://getcomposer.org/)

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

Exercice de procédure stockée
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


Cursors
==

Réaliser un boucle listant les musiciens du groupe 24



Triggers
==

Réaliser un trigger qui, lorsque la photo a été modifiée, stocke au sein d'une table `anciennes_photos` les anciennes images référencées.

Ceci peut être pratique pour automatiser un script qui parcourera cette table et supprimera les fichiers référencés.


Générer un script de backup
==
Réaliser un script bash permettant de réaliser un export automatique de votre base de données.
L'objectif étant de réaliser une tache planifiée pour réaliser une sauvegarde complète de votre base.
