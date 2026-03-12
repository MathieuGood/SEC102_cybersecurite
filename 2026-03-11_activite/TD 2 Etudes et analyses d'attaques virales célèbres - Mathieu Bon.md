# TD Etudes et analyses d'attaques virales célèbres 2

UE SEC102 CNAM
Auditeur : Mathieu Bon
Année universitaire 2025-2026 Semestre 2

## Historique et raisons de l'attaque

### NotPetya

NotPetya est un malware destructeur découvert en juin 2017. Il est attribué au groupe Sandworm, lié aux services de renseignement militaire russes (GRU). L'attaque a débuté via le logiciel de comptabilité ukrainien MEDoc, dont le mécanisme de mise à jour a été compromis, constituant une attaque par chaîne d'approvisionnement. Bien que NotPetya se présentait comme un ransomware similaire à Petya, son véritable objectif était destructeur en rendant les systèmes définitivement irrécupérables. L'Ukraine était la cible principale dans le contexte du conflit russo-ukrainien, mais les dégâts collatéraux ont été massifs à l'échelle mondiale, affectant des entreprises comme Maersk, Merck, FedEx ou Saint-Gobain, causant environ 10 milliards de dollars de pertes.

### DarkHotel

DarkHotel est une campagne d'espionnage ciblée découverte en 2014 par Kaspersky. Ses auteurs ciblaient des dirigeants d'entreprises et personnalités de haut rang séjournant dans des hôtels de luxe en Asie. L'objectif n'était pas financier mais stratégique : voler des informations sensibles à caractère industriel ou politique. La discrétion et la précision du ciblage distinguent DarkHotel des attaques de masse : les victimes étaient identifiées à l'avance et l'attaque déclenchée uniquement à leur arrivée à l'hôtel.

## Type d'attaque

NotPetya et DarkHotel représentent deux catégories d'attaques très différentes. NotPetya est un wiper déguisé en ransomware, combinant des techniques de ver pour la propagation latérale avec une charge destructrice irréversible. DarkHotel est une attaque APT sophistiquée, combinant ingénierie sociale, exploitation de vulnérabilités zero-day et installation de backdoors persistants.

### NotPetya

NotPetya se propage latéralement sur le réseau local après l'infection initiale via la mise à jour empoisonnée de MEDoc. Contrairement à un ransomware classique, il ne propose aucune clé de déchiffrement réelle : l'identifiant de victime affiché est généré aléatoirement, rendant toute récupération impossible. Sa composante de destruction du MBR (Master Boot Record) empêche définitivement le redémarrage des machines infectées.

### DarkHotel

DarkHotel repose sur deux vecteurs complémentaires. D'abord, le réseau Wi-Fi interne de l'hôtel est utilisé pour pousser de fausses mises à jour logicielles (Adobe Flash, Windows) vers les appareils des victimes ciblées. Ensuite, des campagnes de spear-phishing envoient des documents piégés aux cibles identifiées. Une fois installé, le malware dépose un keylogger et une backdoor permettant une surveillance durable et discrète.

## Failles système utilisées

### NotPetya

NotPetya exploitait plusieurs vecteurs cumulés :

- **EternalBlue (CVE-2017-0144)** : la même faille SMB exploitée par WannaCry, permettant l'exécution de code à distance sur les systèmes non patchés.
- **Mimikatz** : outil d'extraction des identifiants Windows depuis la mémoire (processus LSASS), permettant une propagation latérale via des comptes légitimes et donc indétectable par les défenses classiques.
- **PsExec et WMIC** : outils d'administration Windows légitimes détournés pour exécuter du code à distance sur d'autres machines du réseau.
- **Chaîne d'approvisionnement (MEDoc)** : compromission du serveur de mise à jour du logiciel de comptabilité MEDoc, permettant la distribution du malware à l'ensemble de ses utilisateurs via un canal de confiance.

### DarkHotel

DarkHotel exploitait plusieurs failles :

- **Zero-days Adobe Flash et Internet Explorer** : des vulnérabilités non corrigées au moment de l'attaque, permettant l'exécution de code arbitraire à la simple visite d'une page web ou à l'ouverture d'un document.
- **Interception réseau Wi-Fi hôtelier** : les réseaux Wi-Fi des hôtels, peu sécurisés ou directement contrôlés par les attaquants via un accès à l'infrastructure réseau de l'établissement, servaient à injecter de fausses mises à jour logicielles.
- **Spear-phishing ciblé** : envoi de documents Office ou PDF malveillants exploitant des vulnérabilités spécifiques aux versions logicielles utilisées par les cibles.

## Mesures de prévention

En me mettant à la place d'un administrateur système d'un réseau d'entreprise, voici les mesures de prévention que je mettrais en place pour éviter des attaques similaires à NotPetya et DarkHotel :

- Mise à jour rigoureuse et systématique de tous les systèmes via un processus de gestion des correctifs (patch management) formalisé, avec des délais d'application définis selon la criticité des vulnérabilités.
- Segmentation réseau (VLANs) pour limiter la propagation latérale en cas d'infection : un poste compromis ne doit pas pouvoir atteindre l'ensemble du réseau.
- Application du principe de moindre privilège : restriction des droits administrateurs locaux et contrôle strict des comptes à privilèges élevés.
- Surveillance des outils d'administration légitimes (PsExec, WMIC, PowerShell) pour détecter tout usage anormal, via un SIEM ou un EDR.
- Vérification de l'intégrité des mises à jour logicielles via signatures numériques, et politique de validation des logiciels tiers avant déploiement.
- Formation des collaborateurs, en particulier les cadres dirigeants, au phishing et au spear-phishing.
- Interdiction ou contrôle strict de l'utilisation des réseaux Wi-Fi publics ou hôteliers depuis des équipements professionnels, avec obligation d'utiliser un VPN d'entreprise.
- Plan de sauvegarde 3-2-1 avec tests de restauration réguliers, indispensable face à des attaques de type wiper où les données ne sont pas récupérables autrement.

## Stratégie d'éradication du virus et de la menace

Dans les deux cas, la première mesure impérative est d'isoler les machines suspectes du réseau pour stopper toute propagation.

### NotPetya

L'éradication de NotPetya est particulièrement difficile car le MBR peut être écrasé, rendant les machines non démarrables. Pour les postes encore fonctionnels, une déconnexion immédiate du réseau est impérative, suivie d'une analyse forensique pour identifier l'étendue de la compromission. Les données chiffrées sont irrécupérables sans sauvegarde externe préalable. La remédiation passe par un réimage complet des postes infectés à partir d'images saines. Après nettoyage, il est essentiel d'appliquer le correctif MS17-010, de changer l'intégralité des mots de passe du domaine Active Directory et d'auditer les comptes pour détecter d'éventuelles portes dérobées. La réintégration au réseau doit se faire progressivement, sous surveillance renforcée.

### DarkHotel

La nature furtive de DarkHotel complique sa détection. Si une infection est suspectée — notamment après un séjour hôtelier ou la réception d'un email ciblé — une analyse forensique complète du poste est nécessaire pour identifier keyloggers et backdoors. Les connexions réseau sortantes inhabituelles doivent être inspectées. Un EDR (Endpoint Detection and Response) est bien plus adapté qu'un antivirus classique pour détecter ce type de menace comportementale. Une fois la backdoor identifiée et supprimée, tous les identifiants et informations sensibles potentiellement exfiltrés doivent être considérés comme compromis et renouvelés. Les postes concernés doivent être réimagés. La politique de connexion Wi-Fi doit être immédiatement revue pour imposer l'usage systématique du VPN en déplacement.
