
import '../models/mineral.dart';

const List<Mineral> mineralesData = [

  // =========================
  // 🔷 MINERALES (25)
  // =========================

  // =========================
  // TOP MINERALES DEL PERÚ
  // =========================

  Mineral(
    nombre: 'Oro',
    nombreBusqueda: 'Gold',
    tipo: 'Mineral',
    formula: 'Au',
    dureza: '2.5 - 3',
    brillo: 'Metálico',
    color: 'Amarillo dorado',
    descripcion:
        'Metal nativo muy valioso y uno de los recursos minerales más importantes.',
    usos: 'Joyería, inversión, electrónica',
    dondeSeEncuentra:
        'Vetas hidrotermales, depósitos aluviales y zonas auríferas',
    imagenAsset: 'assets/minerals/oro.jpg',
  ),

  Mineral(
    nombre: 'Plata',
    nombreBusqueda: 'Silver',
    tipo: 'Mineral',
    formula: 'Ag',
    dureza: '2.5 - 3',
    brillo: 'Metálico',
    color: 'Blanco plateado',
    descripcion:
        'Metal nativo de gran importancia económica y ampliamente explotado.',
    usos: 'Joyería, monedas, electrónica',
    dondeSeEncuentra:
        'Vetas hidrotermales y depósitos polimetálicos',
    imagenAsset: 'assets/minerals/plata.jpg',
  ),

  Mineral(
    nombre: 'Cobre',
    nombreBusqueda: 'Native copper',
    tipo: 'Mineral',
    formula: 'Cu',
    dureza: '2.5 - 3',
    brillo: 'Metálico',
    color: 'Rojizo cobrizo',
    descripcion:
        'Metal nativo importante, aunque normalmente aparece asociado a otros minerales de cobre.',
    usos: 'Conductores eléctricos, industria, construcción',
    dondeSeEncuentra:
        'Zonas oxidadas de depósitos cupríferos y ambientes hidrotermales',
    imagenAsset: 'assets/minerals/cobre.jpg',
  ),

  Mineral(
    nombre: 'Calcopirita',
    nombreBusqueda: 'Chalcopyrite',
    tipo: 'Mineral',
    formula: 'CuFeS₂',
    dureza: '3.5 - 4',
    brillo: 'Metálico',
    color: 'Amarillo latón',
    descripcion:
        'Principal mena de cobre, muy importante en la minería peruana.',
    usos: 'Obtención de cobre',
    dondeSeEncuentra:
        'Pórfidos cupríferos, vetas hidrotermales y depósitos sulfurados',
    imagenAsset: 'assets/minerals/calcopirita.jpg',
  ),

  Mineral(
    nombre: 'Pirita',
    nombreBusqueda: 'Pyrite',
    tipo: 'Mineral',
    formula: 'FeS₂',
    dureza: '6 - 6.5',
    brillo: 'Metálico',
    color: 'Amarillo dorado',
    descripcion:
        'Mineral conocido como el oro de los tontos por su parecido con el oro.',
    usos: 'Fuente secundaria de azufre y estudios geológicos',
    dondeSeEncuentra:
        'Vetas hidrotermales, rocas metamórficas y sedimentarias',
    imagenAsset: 'assets/minerals/pirita.jpg',
  ),

  Mineral(
    nombre: 'Galena',
    nombreBusqueda: 'Galena',
    tipo: 'Mineral',
    formula: 'PbS',
    dureza: '2.5',
    brillo: 'Metálico',
    color: 'Gris plomo',
    descripcion:
        'Principal mena de plomo y con frecuencia asociada a plata.',
    usos: 'Obtención de plomo y plata asociada',
    dondeSeEncuentra:
        'Depósitos polimetálicos y vetas hidrotermales',
    imagenAsset: 'assets/minerals/galena.jpg',
  ),

  Mineral(
    nombre: 'Esfalerita',
    nombreBusqueda: 'Sphalerite',
    tipo: 'Mineral',
    formula: 'ZnS',
    dureza: '3.5 - 4',
    brillo: 'Resinoso',
    color: 'Marrón, amarillo o negro',
    descripcion:
        'Principal mena de zinc y muy común en depósitos polimetálicos.',
    usos: 'Obtención de zinc',
    dondeSeEncuentra:
        'Vetas hidrotermales y yacimientos zinc-plomo',
    imagenAsset: 'assets/minerals/esfalerita.jpg',
  ),

  Mineral(
    nombre: 'Hematita',
    nombreBusqueda: 'Hematite',
    tipo: 'Mineral',
    formula: 'Fe₂O₃',
    dureza: '5 - 6',
    brillo: 'Metálico a terroso',
    color: 'Rojo oscuro',
    descripcion:
        'Óxido de hierro muy importante como mena de hierro.',
    usos: 'Producción de hierro y pigmentos',
    dondeSeEncuentra:
        'Depósitos de hierro, ambientes sedimentarios y metamórficos',
    imagenAsset: 'assets/minerals/hematita.jpg',
  ),

  Mineral(
    nombre: 'Magnetita',
    nombreBusqueda: 'Magnetite',
    tipo: 'Mineral',
    formula: 'Fe₃O₄',
    dureza: '5.5 - 6.5',
    brillo: 'Metálico',
    color: 'Negro',
    descripcion:
        'Óxido de hierro con fuerte magnetismo y gran valor industrial.',
    usos: 'Producción de hierro',
    dondeSeEncuentra:
        'Rocas ígneas, metamórficas y depósitos ferríferos',
    imagenAsset: 'assets/minerals/magnetita.jpg',
  ),

  Mineral(
    nombre: 'Molibdenita',
    nombreBusqueda: 'Molybdenite',
    tipo: 'Mineral',
    formula: 'MoS₂',
    dureza: '1 - 1.5',
    brillo: 'Metálico',
    color: 'Gris azulado',
    descripcion:
        'Principal mena de molibdeno, asociada a grandes yacimientos cupríferos.',
    usos: 'Aleaciones metálicas e industria',
    dondeSeEncuentra:
        'Pórfidos de cobre y sistemas hidrotermales',
    imagenAsset: 'assets/minerals/molibdenita.jpg',
  ),

  Mineral(
    nombre: 'Casiterita',
    nombreBusqueda: 'Cassiterite',
    tipo: 'Mineral',
    formula: 'SnO₂',
    dureza: '6 - 7',
    brillo: 'Adamantino a submetálico',
    color: 'Marrón oscuro o negro',
    descripcion:
        'Principal mena de estaño.',
    usos: 'Obtención de estaño',
    dondeSeEncuentra:
        'Vetas hidrotermales y depósitos de estaño',
    imagenAsset: 'assets/minerals/casiterita.jpg',
  ),

  Mineral(
    nombre: 'Cuarzo',
    nombreBusqueda: 'Quartz',
    tipo: 'Mineral',
    formula: 'SiO₂',
    dureza: '7',
    brillo: 'Vítreo',
    color: 'Transparente o blanco',
    descripcion:
        'Uno de los minerales más abundantes de la corteza terrestre.',
    usos: 'Vidrio, electrónica, construcción',
    dondeSeEncuentra:
        'Vetas, granitos, pegmatitas y arenas',
    imagenAsset: 'assets/minerals/cuarzo.jpg',
  ),

  Mineral(
    nombre: 'Calcita',
    nombreBusqueda: 'Calcite',
    tipo: 'Mineral',
    formula: 'CaCO₃',
    dureza: '3',
    brillo: 'Vítreo',
    color: 'Blanco o transparente',
    descripcion:
        'Mineral muy común en calizas y mármoles.',
    usos: 'Cemento, cal, construcción',
    dondeSeEncuentra:
        'Calizas, cuevas y rocas carbonatadas',
    imagenAsset: 'assets/minerals/calcita.jpg',
  ),

  Mineral(
    nombre: 'Yeso',
    nombreBusqueda: 'Gypsum',
    tipo: 'Mineral',
    formula: 'CaSO₄·2H₂O',
    dureza: '2',
    brillo: 'Sedoso',
    color: 'Blanco',
    descripcion:
        'Mineral blando usado ampliamente en construcción.',
    usos: 'Yesería, cemento y moldes',
    dondeSeEncuentra:
        'Depósitos evaporíticos y zonas secas',
    imagenAsset: 'assets/minerals/yeso.jpg',
  ),

  Mineral(
    nombre: 'Fluorita',
    nombreBusqueda: 'Fluorite',
    tipo: 'Mineral',
    formula: 'CaF₂',
    dureza: '4',
    brillo: 'Vítreo',
    color: 'Verde, violeta o incoloro',
    descripcion:
        'Mineral muy conocido por su variedad de colores.',
    usos: 'Industria química y metalurgia',
    dondeSeEncuentra:
        'Vetas hidrotermales',
    imagenAsset: 'assets/minerals/fluorita.jpg',
  ),

  Mineral(
    nombre: 'Cuarzo',
    nombreBusqueda: 'Quartz',
    tipo: 'Mineral',
    formula: 'SiO₂',
    dureza: '7',
    brillo: 'Vítreo',
    color: 'Transparente o blanco',
    descripcion: 'Mineral muy abundante en la corteza terrestre.',
    usos: 'Vidrio, electrónica',
    dondeSeEncuentra: 'Vetas y rocas ígneas',
    imagenAsset: 'assets/minerals/cuarzo.jpg',
  ),

  Mineral(
    nombre: 'Pirita',
    nombreBusqueda: 'Pyrite',
    tipo: 'Mineral',
    formula: 'FeS₂',
    dureza: '6 - 6.5',
    brillo: 'Metálico',
    color: 'Dorado',
    descripcion: 'Conocido como el oro de los tontos.',
    usos: 'Azufre',
    dondeSeEncuentra: 'Vetas hidrotermales',
    imagenAsset: 'assets/minerals/pirita.jpg',
  ),

  Mineral(
    nombre: 'Calcita',
    nombreBusqueda: 'Calcite',
    tipo: 'Mineral',
    formula: 'CaCO₃',
    dureza: '3',
    brillo: 'Vítreo',
    color: 'Blanco',
    descripcion: 'Muy común en rocas sedimentarias.',
    usos: 'Cemento',
    dondeSeEncuentra: 'Calizas',
    imagenAsset: 'assets/minerals/calcita.jpg',
  ),

  Mineral(
    nombre: 'Yeso',
    nombreBusqueda: 'Gypsum',
    tipo: 'Mineral',
    formula: 'CaSO₄·2H₂O',
    dureza: '2',
    brillo: 'Sedoso',
    color: 'Blanco',
    descripcion: 'Mineral blando.',
    usos: 'Construcción',
    dondeSeEncuentra: 'Zonas secas',
    imagenAsset: 'assets/minerals/yeso.jpg',
  ),

  Mineral(
    nombre: 'Hematita',
    nombreBusqueda: 'Hematite',
    tipo: 'Mineral',
    formula: 'Fe₂O₃',
    dureza: '5 - 6',
    brillo: 'Metálico',
    color: 'Rojo oscuro',
    descripcion: 'Principal mena de hierro.',
    usos: 'Hierro',
    dondeSeEncuentra: 'Depósitos de hierro',
    imagenAsset: 'assets/minerals/hematita.jpg',
  ),

  Mineral(
    nombre: 'Magnetita',
    nombreBusqueda: 'Magnetite',
    tipo: 'Mineral',
    formula: 'Fe₃O₄',
    dureza: '6',
    brillo: 'Metálico',
    color: 'Negro',
    descripcion: 'Mineral magnético.',
    usos: 'Hierro',
    dondeSeEncuentra: 'Rocas ígneas',
    imagenAsset: 'assets/minerals/magnetita.jpg',
  ),

  Mineral(
    nombre: 'Galena',
    nombreBusqueda: 'Galena',
    tipo: 'Mineral',
    formula: 'PbS',
    dureza: '2.5',
    brillo: 'Metálico',
    color: 'Gris',
    descripcion: 'Principal mena de plomo.',
    usos: 'Plomo',
    dondeSeEncuentra: 'Vetas',
    imagenAsset: 'assets/minerals/galena.jpg',
  ),

  Mineral(
    nombre: 'Esfalerita',
    nombreBusqueda: 'Sphalerite',
    tipo: 'Mineral',
    formula: 'ZnS',
    dureza: '4',
    brillo: 'Resinoso',
    color: 'Marrón',
    descripcion: 'Mena de zinc.',
    usos: 'Zinc',
    dondeSeEncuentra: 'Depósitos',
    imagenAsset: 'assets/minerals/esfalerita.jpg',
  ),

  Mineral(
    nombre: 'Calcopirita',
    nombreBusqueda: 'Chalcopyrite',
    tipo: 'Mineral',
    formula: 'CuFeS₂',
    dureza: '4',
    brillo: 'Metálico',
    color: 'Dorado',
    descripcion: 'Mena de cobre.',
    usos: 'Cobre',
    dondeSeEncuentra: 'Vetas',
    imagenAsset: 'assets/minerals/calcopirita.jpg',
  ),

  Mineral(
    nombre: 'Malaquita',
    nombreBusqueda: 'Malachite',
    tipo: 'Mineral',
    formula: 'Cu₂CO₃(OH)₂',
    dureza: '4',
    brillo: 'Sedoso',
    color: 'Verde',
    descripcion: 'Carbonato de cobre.',
    usos: 'Decoración',
    dondeSeEncuentra: 'Oxidación de cobre',
    imagenAsset: 'assets/minerals/malaquita.jpg',
  ),

  // (los demás minerales resumidos pero funcionales)
  Mineral(nombre: 'Azurita', nombreBusqueda: 'Azurite', tipo: 'Mineral', formula: 'Cu₃(CO₃)₂(OH)₂', dureza: '4', brillo: 'Vítreo', color: 'Azul', descripcion: 'Mineral azul.', usos: 'Decoración', dondeSeEncuentra: 'Cobre'),
  Mineral(nombre: 'Fluorita', nombreBusqueda: 'Fluorite', tipo: 'Mineral', formula: 'CaF₂', dureza: '4', brillo: 'Vítreo', color: 'Varios', descripcion: 'Mineral colorido.', usos: 'Industria', dondeSeEncuentra: 'Vetas'),
  Mineral(nombre: 'Halita', nombreBusqueda: 'Halite', tipo: 'Mineral', formula: 'NaCl', dureza: '2.5', brillo: 'Vítreo', color: 'Blanco', descripcion: 'Sal.', usos: 'Alimentación', dondeSeEncuentra: 'Evaporitas'),
  Mineral(nombre: 'Olivino', nombreBusqueda: 'Olivine', tipo: 'Mineral', formula: 'MgFeSiO₄', dureza: '7', brillo: 'Vítreo', color: 'Verde', descripcion: 'Silicato.', usos: 'Industria', dondeSeEncuentra: 'Basalto'),
  Mineral(nombre: 'Talco', nombreBusqueda: 'Talc', tipo: 'Mineral', formula: 'Mg₃Si₄O₁₀(OH)₂', dureza: '1', brillo: 'Graso', color: 'Blanco', descripcion: 'Muy blando.', usos: 'Cosméticos', dondeSeEncuentra: 'Metamórficas'),

  // =========================
  // 🪨 ROCAS (25)
  // =========================

  Mineral(
    nombre: 'Granito',
    nombreBusqueda: 'Granite',
    tipo: 'Roca',
    formula: 'Cuarzo + feldespato',
    dureza: 'Alta',
    brillo: 'Granular',
    color: 'Gris',
    descripcion: 'Roca ígnea.',
    usos: 'Construcción',
    dondeSeEncuentra: 'Cordilleras',
    imagenAsset: 'assets/minerals/granito.jpg',
  ),

  Mineral(
    nombre: 'Basalto',
    nombreBusqueda: 'Basalt',
    tipo: 'Roca',
    formula: 'Fe Mg',
    dureza: 'Alta',
    brillo: 'Mate',
    color: 'Negro',
    descripcion: 'Roca volcánica.',
    usos: 'Carreteras',
    dondeSeEncuentra: 'Volcanes',
    imagenAsset: 'assets/minerals/basalto.jpg',
  ),

  Mineral(
    nombre: 'Caliza',
    nombreBusqueda: 'Limestone',
    tipo: 'Roca',
    formula: 'CaCO₃',
    dureza: 'Media',
    brillo: 'Mate',
    color: 'Blanco',
    descripcion: 'Sedimentaria.',
    usos: 'Cemento',
    dondeSeEncuentra: 'Marino',
    imagenAsset: 'assets/minerals/caliza.jpg',
  ),

  Mineral(
    nombre: 'Mármol',
    nombreBusqueda: 'Marble',
    tipo: 'Roca',
    formula: 'Calcita',
    dureza: 'Media',
    brillo: 'Pulido',
    color: 'Blanco',
    descripcion: 'Metamórfica.',
    usos: 'Decoración',
    dondeSeEncuentra: 'Montañas',
    imagenAsset: 'assets/minerals/marmol.jpg',
  ),

  Mineral(
    nombre: 'Pizarra',
    nombreBusqueda: 'Slate',
    tipo: 'Roca',
    formula: 'Arcilla',
    dureza: 'Media',
    brillo: 'Mate',
    color: 'Oscuro',
    descripcion: 'Metamórfica.',
    usos: 'Techos',
    dondeSeEncuentra: 'Zonas metamórficas',
    imagenAsset: 'assets/minerals/pizarra.jpg',
  ),

  Mineral(
    nombre: 'Esquisto',
    nombreBusqueda: 'Schist',
    tipo: 'Roca',
    formula: 'Micas',
    dureza: 'Media',
    brillo: 'Brillante',
    color: 'Gris',
    descripcion: 'Metamórfica.',
    usos: 'Geología',
    dondeSeEncuentra: 'Metamorfismo',
    imagenAsset: 'assets/minerals/esquisto.jpg',
  ),

  Mineral(
    nombre: 'Arenisca',
    nombreBusqueda: 'Sandstone',
    tipo: 'Roca',
    formula: 'Arena',
    dureza: 'Media',
    brillo: 'Mate',
    color: 'Amarillo',
    descripcion: 'Sedimentaria.',
    usos: 'Construcción',
    dondeSeEncuentra: 'Desiertos',
    imagenAsset: 'assets/minerals/arenisca.jpg',
  ),

  Mineral(
    nombre: 'Obsidiana',
    nombreBusqueda: 'Obsidian',
    tipo: 'Roca',
    formula: 'Vidrio volcánico',
    dureza: '5',
    brillo: 'Vítreo',
    color: 'Negro',
    descripcion: 'Roca volcánica.',
    usos: 'Decoración',
    dondeSeEncuentra: 'Volcanes',
    imagenAsset: 'assets/minerals/obsidiana.jpg',
  ),

  Mineral(
    nombre: 'Pumita',
    nombreBusqueda: 'Pumice',
    tipo: 'Roca',
    formula: 'Silicatos',
    dureza: 'Baja',
    brillo: 'Mate',
    color: 'Claro',
    descripcion: 'Roca porosa.',
    usos: 'Abrasivo',
    dondeSeEncuentra: 'Volcanes',
    imagenAsset: 'assets/minerals/pumita.jpg',
  ),

  Mineral(
    nombre: 'Gneis',
    nombreBusqueda: 'Gneiss',
    tipo: 'Roca',
    formula: 'Cuarzo',
    dureza: 'Alta',
    brillo: 'Bandeado',
    color: 'Rayado',
    descripcion: 'Metamórfica.',
    usos: 'Construcción',
    dondeSeEncuentra: 'Profundo',
    imagenAsset: 'assets/minerals/gneis.jpg',
  ),

];