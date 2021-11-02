Flash'Iteasy est un CMS (Content Management System) dont la vocation etait de permettre à des agences web professionnelles de faire travailler grpahistes, UX/UI-istes et développeurs au sein d'un seul et même environnement (fie-admin). 

Une video de démonstration est visible à cette adresse : http://www.aguabuena.fr/fie/TutoFIE_fluxRSS.mov

Le projet est architecturé de la manière suivante :

- fie-api : moteur de rendu graphique précompilé. Le conteneur général de tout contenu Flash'Iteasy, basé sur de l'injection de dépendance et de l'inversion de contrôle. Un conteneur graphique général vient charger des éléments divers (blocs image, blocs texte, animations, filtres, interactions utilisateur ou autres, formulaires, sources de données, etc.). Chaque objet éditable est doté d'une liste de ParameterSets dont le typage permet de générer les éditeurs correspondants. Par exemple, un bloc texte standard est doté de valeur d'origine x et y, de tailles horizontale et verticale (typage int, éditeur NumericStepper), d'un contenu (typage text, éditeur TextInput), d'un alignement (typage Enum, éditeur ComboBox) etc. Chaque type d'objet éditable générera donc dynamiquement son éditeur dans l'interface d'administration.
- fie-admin : module d'administration des contenus en mode graphique. Principalement destiné aux graphistes et intégrateurs, on y gére les pages, leur contenu et toutes les animations et interactions nécessaires. On y connecte les sources de données (xml, bases de données, flux rss, fichiers locaux ou distants, etc.) et on les branche facilement sur les objets existant. appli
- fie-app : moteur de création d'appli iOS
- fie-services : microservices backend pour la génération de fontes, de documents pdf, la prise en charge du référencement, l'export des pages en version html/javascript, etc. On y trouve également les connexions aux bases de données, aux objets json et API REST
- example-lib : example de librairie externe chargée au runtime(sample-lib, clock-lib, clouds-lib, etc.). C'est le type de modules fourni aux développeurs pour charger leurs propres contenus au runtime et rendre éditable les paramètres souhaités en fonction de leur typage (int, number, string, list, xmllist, éléments de formulaires, etc.). les objets cgargés apparaissent naturellement sdans l'interface d'édition.

On y trouve aussi un certain nombre de projets annexes, destinés à l'application des modèles Flash'Iteasy à d'autres systèmes existant, comme par exemple Prestashop ou WordPress.


