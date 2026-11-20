// lib/features/plagas/domain/plaga.dart

class Plaga {
  final String nombre;
  final String descripcionFisica;
  final String causa;
  final String rutaImagen;

  const Plaga({
    required this.nombre,
    required this.descripcionFisica,
    required this.causa,
    required this.rutaImagen,
  });
}

const List<Plaga> listaPlagas = [
  Plaga(
    nombre: 'Mosca blanca',
    descripcionFisica:
        'Miden entre 1 y 2 mm, su cuerpo es blanco/amarillo pálido y tiene 2 alas cubiertas de un polvo blanco. Se asemeja a una polilla.',
    causa:
        'Temperaturas altas, periodos secos y exceso de fertilización nitrogenada.',
    rutaImagen: 'assets/images/plagas/Mosca_blanca.jpg',
  ),
  Plaga(
    nombre: 'Minador de hoja',
    descripcionFisica:
        'Miden aproximadamente 2 mm, es de color negro con manchas amarillas y se asemeja a una mosquita.',
    causa:
        'Suelen aparecer en época de calor y cuando la planta es joven ya que pueden perforar fácilmente para sus crías.',
    rutaImagen: 'assets/images/plagas/Minador_de_hoja.jpg',
  ),
  Plaga(
    nombre: 'Gusano del fruto',
    descripcionFisica:
        'Miden aproximadamente 2 a 4 mm, su color puede variar entre verde claro, oscuro, rosa, amarillento o incluso casi negro.',
    causa:
        'Aparecen en los inicios de lluvias o porque el cultivo se encuentra en maduración y les atrae el aroma del fruto.',
    rutaImagen: 'assets/images/plagas/Gusano_del_fruto.jpg',
  ),
  Plaga(
    nombre: 'Pulgón verde',
    descripcionFisica:
        'Miden aproximadamente 1 a 2.5 mm, es pequeño y ovalado, su color puede ser verde o verde amarillento y no es brilloso.',
    causa:
        'Cuando la planta tiene estrés hídrico por falta de riego y exceso de nitrógeno. Además busca brotes tiernos.',
    rutaImagen: 'assets/images/plagas/Pulgon_verde.jpg',
  ),
  Plaga(
    nombre: 'Trips',
    descripcionFisica:
        'Miden aproximadamente 0.8 a 1 mm, es muy pequeño y alargado, su color puede ser amarillo pálido, café o negro.',
    causa: 'Cuando hay baja humedad, busca plantas débiles.',
    rutaImagen: 'assets/images/plagas/Trips.jpg',
  ),
  Plaga(
    nombre: 'Doradilla o diabrótica',
    descripcionFisica:
        'Miden aproximadamente 5 a 6 mm, es como un escarabajo pequeño de color amarillo o verde con manchas.',
    causa:
        'En condiciones favorables de temperatura y humedad donde sus crías puedan vivir y en suelo con alta materia orgánica.',
    rutaImagen: 'assets/images/plagas/Doradilla_o_diabrotica.jpg',
  ),
  Plaga(
    nombre: 'Chicharrita verde',
    descripcionFisica:
        'Miden aproximadamente 3 a 4 mm, es delgado y alargado en forma de cuña de color verde claro.',
    causa:
        'Se presenta en periodos secos y de sequía, además si la planta presenta déficit hídrico.',
    rutaImagen: 'assets/images/plagas/Chicharrita_verde.jpg',
  ),
  Plaga(
    nombre: 'Gorgojo del frijol',
    descripcionFisica:
        'Miden aproximadamente 3 a 5 mm, es robusto asemejando un escarabajo de color café o café grisáceo.',
    causa: 'Cuando se realiza una cosecha tardía o en cierto rango de humedad.',
    rutaImagen: 'assets/images/plagas/Gorgojo_del_frijol.jpg',
  ),
  Plaga(
    nombre: 'Pulguilla saltona',
    descripcionFisica:
        'Miden aproximadamente 1 a 3 mm, es ovalado y brillante de color café o negro.',
    causa: 'Aparecen en climas calurosos y soleados así como en suelos secos.',
    rutaImagen: 'assets/images/plagas/Pulguilla_saltona.jpg',
  ),
  Plaga(
    nombre: 'Gusano falso medidor',
    descripcionFisica:
        'Miden aproximadamente 30 a 35 mm, es una oruga lisa de color verde pálido.',
    causa:
        'Aparece cuando hay aumento de humedad o lluvias y busca follajes tiernos.',
    rutaImagen: 'assets/images/plagas/Gusano_falso_medidor.jpg',
  ),
  Plaga(
    nombre: 'Gallina ciega',
    descripcionFisica:
        'Miden aproximadamente 30 a 50 mm, tiene un cuerpo robusto en forma de C y es de color café o naranja amarillento.',
    causa:
        'Aparecen en temporadas de lluvias o cuando se usa estiércol o composta fresca sin madurar bien.',
    rutaImagen: 'assets/images/plagas/Gallina_ciega.jpg',
  ),
  Plaga(
    nombre: 'Hormiga arriera o de monte',
    descripcionFisica:
        'Miden aproximadamente 6 a 14 mm, tiene un cuerpo robusto, es de color café rojizo oscuro y tiene espinas diminutas en el tórax.',
    causa:
        'Cuando hay cercanía al monte alto, clima seco o presencia de brotes.',
    rutaImagen: 'assets/images/plagas/Hormiga_arriera_o_de_monte.jpg',
  ),
  Plaga(
    nombre: 'Chinche hedionda o verde',
    descripcionFisica:
        'Miden aproximadamente 1 a 1.5 cm, son de color verde brillante o café pálido, y desprenden un olor desagradable al sentirse amenazadas.',
    causa:
        'Presencia en climas tropicales y suele aparecer en cualquier cultivo.',
    rutaImagen: 'assets/images/plagas/Chinche_hedionda_o_verde.jpg',
  ),
  Plaga(
    nombre: 'Saltamontes o chapulines',
    descripcionFisica:
        'Miden aproximadamente 3 a 5 cm, tienen un cuerpo alargado y son de color verde con patas traseras muy desarrolladas.',
    causa: 'Se encuentran en climas húmedos y en brotes tiernos.',
    rutaImagen: 'assets/images/plagas/Saltamontes_o_chapulines.jpg',
  ),
  Plaga(
    nombre: 'Gusano trozador',
    descripcionFisica:
        'Miden aproximadamente 3 a 6 cm, tienen un cuerpo grueso de color grisáceo.',
    causa:
        'Buscan exceso de humedad y espacios de cosechas anteriores donde no se haya limpiado bien.',
    rutaImagen: 'assets/images/plagas/Gusano_trozador.jpg',
  ),
  Plaga(
    nombre: 'Babosas',
    descripcionFisica:
        'Miden aproximadamente 2 a 15 cm, tienen un cuerpo largo y blando de color beige.',
    causa:
        'Aparecen cuando hay exceso de humedad y cuando existen ambientes oscuros.',
    rutaImagen: 'assets/images/plagas/Babosas.jpg',
  ),
  Plaga(
    nombre: 'Caracoles',
    descripcionFisica:
        'Miden aproximadamente 2 a 10 cm, tienen un cuerpo largo y blando de color beige o café y tienen caparazón.',
    causa:
        'Cuando hay exceso de humedad y alimento disponible. Suelen aparecer en riegos nocturnos.',
    rutaImagen: 'assets/images/plagas/Caracoles.jpg',
  ),
  Plaga(
    nombre: 'Grillo topo o perro de agua',
    descripcionFisica:
        'Miden aproximadamente 2 a 7 cm, sus garras se asemejan a las de un topo, tiene pelaje fino y corto de color café.',
    causa: 'Buscan humedad, tierra blanda y materia orgánica.',
    rutaImagen: 'assets/images/plagas/Grillo_topo_o_perro_de_agua.jpg',
  ),
];
