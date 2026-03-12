# TD — Études et Analyses d'attaques virales célèbres

**UE SEC102 — CNAM**

---

## 1. Historique et raisons des attaques

### Le Ver de Morris (1988)

Le 2 novembre 1988, Robert Tappan Morris, étudiant de 23 ans à l'université de Cornell, lance depuis un ordinateur du MIT ce qui deviendra la **première infection informatique à grande échelle de l'histoire**. Son objectif déclaré était expérimental : mesurer la taille d'Internet, alors composé d'environ 60 000 machines. Il ne s'agissait pas d'une attaque malveillante planifiée, mais d'un projet de recherche qui a **dégénéré en catastrophe** à cause d'une erreur de conception : le ver se réinfectait les machines dans un cas sur sept, saturant leurs ressources jusqu'à les rendre inutilisables. Environ **6 000 machines** furent infectées (~10 % de l'Internet de l'époque), causant entre 100 000 $ et 10 millions de $ de dommages.

### WannaCry (2017)

Le 12 mai 2017, WannaCry frappe le monde entier en infectant **plus de 200 000 ordinateurs dans 150 pays**. Contrairement au ver de Morris, cette attaque est délibérément malveillante, avec pour objectif la **génération de revenus** par extorsion (rançon en Bitcoin). Elle est attribuée au **Groupe Lazarus**, une organisation APT liée à l'État nord-coréen, qui cherchait à la fois un gain financier et une déstabilisation géopolitique. L'attaque n'aurait pas été possible sans la fuite des outils offensifs de la NSA par le groupe _Shadow Brokers_ en avril 2017, qui a rendu publique l'exploitation **EternalBlue**.

---

## 2. Classification des types d'attaque

| Critère              | Ver de Morris                    | WannaCry                      |
| -------------------- | -------------------------------- | ----------------------------- |
| **Type principal**   | Ver informatique (_worm_)        | _Cryptoworm_ + Ransomware     |
| **Propagation**      | Auto-réplication sur réseau      | Auto-réplication via SMBv1    |
| **Objectif**         | Expérimental (mesure d'Internet) | Financier / géopolitique      |
| **Effet secondaire** | DoS non intentionnel             | Chiffrement des fichiers      |
| **Acteur**           | Étudiant isolé                   | APT étatique (Groupe Lazarus) |

- **Ver de Morris** : classé comme **ver réseau** avec **effet DoS involontaire**. Il exploite des vulnérabilités logicielles pour se propager de machine en machine sans intervention humaine.
- **WannaCry** : classé comme **ransomware à propagation vermiforme** (_cryptoworm_). Il combine l'auto-réplication d'un ver avec le chiffrement des données propre aux ransomwares, exigeant une rançon de 300 $ en Bitcoin.

---

## 3. Failles système exploitées

### Ver de Morris — trois vecteurs

1. **Buffer overflow dans `fingerd`** : dépassement de tampon dans le démon `finger` (Unix BSD), permettant l'exécution de code arbitraire à distance.
2. **Mode DEBUG de `sendmail`** : faille dans le serveur de mail permettant d'envoyer des fichiers via un shell et d'exécuter des commandes sur la machine cible.
3. **Attaque par dictionnaire sur les mots de passe** : utilisation d'une liste de 900 mots courants et des noms de comptes pour deviner les credentials, puis exploitation des commandes `rsh` et `rexec` pour se propager latéralement.

### WannaCry — une faille centrale

- **EternalBlue (MS17-010)** : vulnérabilité critique dans le protocole **SMBv1** (Server Message Block) de Windows. Initialement découverte par la NSA à des fins d'espionnage, volée par les _Shadow Brokers_ et rendue publique le 8 avril 2017. Microsoft avait pourtant publié un correctif le **14 mars 2017**, soit deux mois avant l'attaque. Les systèmes non mis à jour — dont beaucoup tournaient encore sous Windows XP — restaient vulnérables. Le correctif n'était d'ailleurs pas initialement disponible pour XP, forçant Microsoft à le publier en urgence.

---

## 4. Prévention en tant qu'administrateur réseau

### Mesures qui auraient prévenu le Ver de Morris

- **Politique stricte de mots de passe** : interdire les mots de passe triviaux, imposer des mots de passe complexes, audits réguliers.
- **Désactivation des services inutiles** : `fingerd` et le mode DEBUG de `sendmail` n'avaient aucune raison d'être exposés sur Internet.
- **Segmentation réseau** : limiter la confiance implicite entre machines (`rsh`/`rexec` présupposent une confiance totale entre hôtes, ce qui est inacceptable).
- **Principe du moindre privilège** : chaque service ne doit fonctionner qu'avec les droits strictement nécessaires.

### Mesures qui auraient prévenu WannaCry

- **Gestion des correctifs (patch management)** : déploiement systématique et rapide des mises à jour de sécurité via un outil centralisé (WSUS, SCCM). Le patch MS17-010 était disponible deux mois avant l'attaque.
- **Désactivation de SMBv1** : ce protocole obsolète n'a plus aucune utilité dans un réseau moderne et représente une surface d'attaque majeure.
- **Segmentation et filtrage réseau** : bloquer le port 445 (SMB) en entrée/sortie au niveau du pare-feu périmétrique et entre les VLANs internes pour limiter la propagation latérale.
- **Plan de sauvegarde (3-2-1)** : maintenir des sauvegardes régulières, hors ligne ou sur un système isolé (3 copies, 2 supports différents, 1 hors site), pour garantir la restauration en cas de chiffrement.
- **Plan de mise à fin de vie des systèmes obsolètes** : planifier et budgéter le remplacement ou l'isolation stricte des postes sous Windows XP non supportés.
- **Monitoring et EDR** : déployer des solutions de détection comportementale capables d'identifier des chiffrements massifs de fichiers ou des scans SMB anormaux.

---

## 5. Éradication du virus sur un poste infecté

### Ver de Morris

1. **Isolation immédiate** du poste du réseau (déconnexion physique ou désactivation de l'interface réseau) pour stopper la propagation.
2. **Redémarrage en mode mono-utilisateur** ou depuis un support externe pour éviter que le ver continue de s'exécuter.
3. **Identification et suppression des processus malveillants** (les multiples copies du ver consommant les ressources CPU/RAM).
4. **Suppression des fichiers du ver** depuis un système sain.
5. **Application des correctifs** sur `sendmail`, `fingerd` et révision des fichiers `.rhosts` / de confiance `rsh`.
6. **Réinitialisation de tous les mots de passe** potentiellement compromis.
7. **Vérification de l'intégrité** des binaires système (possibilité de backdoors).

### WannaCry

1. **Isolation immédiate** du poste infecté (coupure réseau) pour empêcher la propagation via SMB aux autres machines du réseau.
2. **Ne pas payer la rançon** : aucune garantie de récupération des données, et cela finance les attaquants.
3. **Application du kill switch** : s'assurer que le domaine de kill switch est accessible depuis le réseau (Marcus Hutchins avait stoppé l'attaque mondiale en enregistrant ce domaine pour ~11 $).
4. **Application du patch MS17-010** sur toutes les machines avant reconnexion au réseau.
5. **Désactivation de SMBv1** sur l'ensemble du parc.
6. **Restauration des données** depuis les sauvegardes saines (il n'existe pas de déchiffreur fiable pour WannaCry).
7. **Réinstallation complète** si aucune sauvegarde n'est disponible et si l'intégrité du système est compromise.
8. **Audit post-incident** : analyser les logs, identifier le patient zéro, vérifier l'absence de persistance ou de mouvement latéral résiduel.

---

## Conclusion

Ces deux attaques, séparées de 29 ans, illustrent l'évolution radicale des menaces : d'une expérience académique incontrôlée à une opération militarisée à visée financière et géopolitique. Elles partagent néanmoins la même leçon fondamentale : **un système non patché et mal segmenté est une cible**. La gestion rigoureuse des correctifs, la segmentation réseau, la politique du moindre privilège et un plan de sauvegarde solide restent les piliers indépassables de toute administration réseau sérieuse. Ces principes, que l'on retrouve aujourd'hui dans le modèle **Zero Trust** et dans les obligations réglementaires comme **NIS2**, auraient, s'ils avaient été appliqués, considérablement limité l'impact des deux attaques.
