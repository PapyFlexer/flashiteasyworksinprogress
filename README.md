Flash'Iteasy est un CMS (Content Management System) dont la vocation etait de permettre à des agences web professionnelles de faire travailler grpahistes, UX/UIistes et développeurs au sein d'un même environnement.
Le projet est architecturé de la manière suivante :

- fie-api : moteur de rendu graphique précompilé. Le conteneur général de tout contenu Flash'Iteasy, basé sur de l'injection de dépendance et de l'inversion de contrôle
- fie-admin : module d'administration des contenus en mode graphique. Principalement destiné aux graphistes et intégrateurs
- fie-app : moteur de création d'appli iOS
- fie-services : microservices backend pour génération de fontes, de documents pdf, etc.
- example-lib : example de libray externe chargée au runtime(clock-lib, clouds-lib, etc.). C'est le type de modules fourni aux développeurs pour porter leur propre contenu au runtime et rendre éditable les paramètres ouhaités en fonction de leur typage (int, number, string, list, xmllist, et éléments de formulaires)

On y trouve aussi un certain nombre de projets annexes, destinés à l'application des modèles Flash'Iteasy à d'autres systèmes existant, comme par exemple Prestashop ou WordPress.


