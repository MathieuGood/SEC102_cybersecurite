# TD Etudes et analyses d'attaques virales célèbres 1

UE SEC102 CNAM
Auditeur : Mathieu Bon
Année universitaire 2025-2026 Semestre 2

## Historique et raisons de l'attaque

### Ver de Morris

Il est considéré comme le premier ver informatique à se propager sur ARPANET (précurseur d'internet). Il a été créé en 1988 par Robert Tappan Morris, un étudiant américain . Ce ver n'avait pas de but malveillant en tant que tel, il a été conçu pour mesurer la taille d'ARPANET. Cependant, en raison d'une erreur de conception, le ver s'est propagé de manière incontrôlée, causant des perturbations majeures sur les postes infectés allant jusqu'à la paralysie. On estime qu'il a infecté environ 6 000 machines, soit environ 10% d'ARPANET à l'époque.

### WannaCry

WannaCry est un ransomware qui a été découvert en mai 2017. Son origine est attribuée à un groupe de hackers appelé "Lazarus Group", qui serait lié à la Corée du Nord. Cette attaque a été rendue possible grâce à une faille 0-day dans Windows initialement découverte par la NSA et rendue publique par le groupe de hackers "Shadow Brokers". Contrairement au Ver de Morris, WannaCry avait un objectif malveillant clair : chiffrer les données des victimes et demander une rançon en échange de la clé de déchiffrement. Son ampleur a été considérable, affectant des centaines de milliers d'ordinateurs dans plus de 150 pays. Le système de santé britannique (NHS) a été particulièrement touché, avec des hôpitaux incapables d'accéder à leurs données et de fournir des soins adéquats.

## Type d'attaque

Le ver de Morris et WannaCry sont tous les deux des types d'attaques virales, mais ils diffèrent dans leur nature et leur objectif. Le ver de Morris est un ver informatique classique, conçu pour se propager automatiquement à travers les réseaux sans intervention humaine. En revanche, WannaCry est un ransomware qui combine des éléments de ver informatique (pour la propagation) avec une composante de rançon (pour extorquer de l'argent aux victimes).

### Ver de Morris

Avant de se propager, le ver de Morris vérifiait s'il était déjà présent sur la machine cible pour éviter une double installation. Mais une règle de propagation mal conçue a conduit à une réinfection dans environ 1 cas sur 7, ce qui a amplifié les dégâts. Les ressources de la machine multiplement infectée étaient saturées, entraînant une paralysie complète.

### WannaCry

WannaCry avait la particularité de rendre inutilisables les données de la victime en les chiffrant. Il reste alors peu d'espoir de déchiffrer les données sans disposer de la clé au regard de la technologie de chiffrement utilisée. Le seul recours était de payer la rançon.

## Failles système utilisées

### Ver de Morris

Le ver de Morris exploitait plusieurs failles dans les systèmes Unix de l'époque, notamment :

- Un dépassement de tampon dans le service fingerd, ouvrant la porte à l'exécution de code arbitraire à distance.
- Une vulnérabilité dans sendmail en mode debug, autorisant l'injection de commandes malveillantes.
- La faible sécurisation de rsh et rexec, dont le mécanisme d'authentification rudimentaire facilitait l'exécution distante de commandes non autorisées.

### WannaCry

WannaCry utilisait une faille dans le protocole SMB de Windows. Ce protocole utilisé pour le partage de fichiers et d'imprimantes sur les réseaux, présentait une vulnérabilité critique autorisant l'exécution de code à distance. Au moment où WannaCry a été lancé, Microsoft avait déjà publié un correctif pour cette faille, mais de nombreux systèmes n'avaient pas été mis à jour, laissant la porte ouverte à l'attaque.

## Mesures de prévention

En me mettant à la place d'un administrateur système, voici les mesures de prévention que je mettrais en place pour éviter des attaques similaires à celles du Ver de Morris et de WannaCry :

- Mise en place d'une politique de mots de passes forts (longueur minimale, complexité, expiration périodique).
- Mise à jour régulière des systèmes d'exploitation et des logiciels pour appliquer les correctifs de sécurité dès qu'ils sont disponibles.
- Installation d'antivirus sur les postes clients et serveurs
- Mise en place d'un plan de sauvegarde 3-2-1 (3 copies, 2 supports différents, 1 hors site)

## Stratégie d'éradication du virus et de la menace

Dans les deux cas, la première étape impérative est de déconnecter les machines infectées de tout réseau pour éviter la propagation du ver.

### Ver de Morris

Pour éradiquer le Ver de Morris, je pense qu'il est nécessaire de démarrer les machines en mode sans échec pour qu'un minimum de services soient actifs. Ensuite on peut bloquer les ports utilisés par le ver (notamment ceux liés à rsh, rexec, sendmail et fingerd) et supprimer les fichiers malveillants associés. . L'administrateur système doit ensuite évaluer la nécessité de ces services pour décider lesquels désactiver. Le fichier des machines de confiance autorisées à se connecter via rsh à l'ordinateur doit être au minimum contrôlé et au mieux vidé pour mettre en place une autre méthode d'authenfication plus forte L'étape finale est de réinitialiser les mots de passe des comptes compromis et de renforcer la politique de sécurité pour éviter une réinfection.

### WannaCry

La réparation de WannaCry est plus complexe, car il s'agit d'un ransomware qui chiffre les données de l'ordinateur. Le déchiffrement des données est souvent impossible sans payer la rançon avec ce mode d'attaque. Sans sauvegarde externe, il n'y a malheureusement pas de solution pour récupérer les données. Le ransomware peut cependant être supprimé par un antivirus à jour. Pour éviter toute nouvelle infection, l'application du patch de sécurité fourni par Microsoft suffit à sécuriser son poste de travail. Comme dans toute infection, la réinitialisation des mots de passe et la mise à jour de tous les logiciels pour éviter qu'une infection similaire ne se reproduise sont des étapes cruciales. Comme pour le Ver de Morris, on peut désactiver tous les services inutiles, particulièrement ceux qui sont obsolètes. Par exemple, SMB en version 1 étant à la fois obsolète et très certainement non utilisé, il peut être désactivé sans risque. La question devient plus délicate si des services critiques pour l'entreprise sont concernés, par exemple si ce protocole est nécessaire pour faire fonctionner une application métier ou un matériel ancien.
