<?php
    /* 
        Script that generates a dumb sql file for segolène's mydb database.
        requirements:
         - composer require fzaninotto/faker

     */

    include('vendor/autoload.php');

    function commit() {
        return "COMMIT;\n";
    }
    function generateMusiciens($faker, $nb) {
        $file = '';
        for ($i = 0; $i < $nb; $i++) {
            $query = "INSERT INTO musiciens VALUES(NULL, '%s', '%s', '%s');";
            $file .= sprintf($query, addslashes($faker->lastName), addslashes($faker->firstName), $faker->sentence) ;
        }
        return $file.commit();
    }
    function generateInstruments($faker, $nb) {
        $file = '';
        for ($i = 0; $i < $nb; $i++) {
            $query = "INSERT INTO instruments (nom) VALUES('instrument_$faker->word');";
            $file .= $query;
        }
        return $file.commit();
    }
    function generateCategories($faker, $nb) {
        $file = '';
        for ($i = 0; $i < $nb; $i++) {
            $query = "INSERT INTO categorie (nom) VALUES('categ_$faker->word');";
            $file .= $query;
        }
        return $file.commit();
    }
    function generatePays($faker, $nb) {
        $file = '';
        for ($i = 0; $i < $nb; $i++) {
            $query = "INSERT INTO pays (nom) VALUES('pays_$faker->word');";
            $file .= $query;
        }
        return $file.commit();
    }
    function generateGroupes($faker, $nb, $nb_pays, $nb_categ) {
        $file = '';
        for ($i = 0; $i < $nb; $i++) {
            $query = "INSERT INTO groupes (nom, email, tarif, description, pays_id_pays, categorie_id_categorie) VALUES('groupe_%s', '$faker->email', $faker->randomNumber, '$faker->text', %d, %d  );";
            $file .= sprintf($query, addslashes($faker->name), rand(1, $nb_pays), rand(1, $nb_categ));
        }
        return $file.commit();
    }

    function generateGroupeInstruments($nb_group, $nb_instruments) {
        $file = '';
        for ($i = 0; $i < $nb_group; $i++) {
            $query = "INSERT INTO groupes_instruments VALUES(%d, %d);";
            // TODO : Do it better, but I'm lazy. This is risky as duplicates may occur
            for($j=0; $j<rand(0,2); $j++ ) $file .= sprintf($query, $i+1, rand(1, $nb_instruments));
        }
        return $file.commit();
    }

    function generateGroupeMusiciens($nb_group, $nb_musicien) {
        $file = '';
        for ($i = 0; $i < $nb_musicien; $i++) {
            $query = "INSERT INTO groupes_musiciens VALUES(%d, %d );";
            // TODO : Do it better, but I'm lazy. This is risky as duplicates may occur
            for($j=0; $j<rand(1, 3); $j++ ) $file .= sprintf($query, rand(1, $nb_group), $i+1);
        }
        return $file.commit();
        
    }
    function generateMusiciensInstruments($nb_instruments, $nb_musicien) {
        $file = '';
        for ($i = 0; $i < $nb_musicien; $i++) {
            $query = "INSERT INTO musiciens_instruments VALUES(%d, %d);";
            // TODO : Do it better, but I'm lazy. This is risky as duplicates may occur
            for($j=0; $j<rand(1, 3); $j++ ) $file .= sprintf($query, $i+1, rand(1, $nb_instruments));
        }
        return $file.commit();
    }
    function generatePhotos($faker, $nb_groupes) {
        $file = '';
        for ($i = 0; $i < $nb_groupes; $i++) {
            // actually the faker uses lorempixel which is really slow lately.
            // we should rather use  'https://picsum.photos/600/400'
            $query = "INSERT INTO photos VALUES(null,'%s' , %d );";
            $file .= sprintf($query, $faker->imageUrl, rand(1, $nb_groupes));
        }
        return $file.commit();
    }

    // generate the file
    
    $nb_instruments = 1000;
    $nb_categories = 10;
    $nb_pays = 1000;
    $nb_groupes = 5000;
    $nb_musiciens = 10000;
    
    $faker = Faker\Factory::create();

    $file = "SET AUTOCOMMIT=0;\n";
    $file .= generateInstruments($faker, $nb_instruments);
    $file .= generateCategories($faker, $nb_categories);
    $file .= generateMusiciens($faker, $nb_musiciens);
    $file .= generatePays($faker, $nb_pays);
    $file .= generateGroupes($faker, $nb_groupes, $nb_pays, $nb_categories);
    $file .= generatePhotos($faker, $nb_groupes);
    $file .= generateGroupeMusiciens($nb_groupes, $nb_musiciens);
    $file .= generateGroupeInstruments($nb_groupes, $nb_instruments);
    $file .= generateMusiciensInstruments($nb_instruments, $nb_musiciens);
    $fp = fopen('data.sql', 'w');
    fwrite($fp, $file);
    fclose($fp);
?>
