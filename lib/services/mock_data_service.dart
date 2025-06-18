import '../models/professor.dart';
import '../models/user.dart';
import '../models/review.dart';

/// Servicio que proporciona datos reales de profesores de Ingeniería de Sistemas - ULima
class MockDataService {
  // Lista de profesores de Ingeniería de Sistemas basada en CIS-Rol de Asesoría_2025-1
  static final List<Professor> _professors = [
    Professor(
      id: '1',
      name: 'Aguilar Lozano Caridad',
      department: 'Ingeniería de Sistemas',
      courses: ['Juego Negocios', 'Gest. Operaciones', 'Gest. Operac. Servicios'],
      averageRating: 4.5,
      totalReviews: 89,
      photoUrl: null,
      bio: 'Especialista en gestión de operaciones y simulación de negocios.',
    ),
    Professor(
      id: '2',
      name: 'Aguilar Paredes Richard Edgard',
      department: 'Ingeniería de Sistemas',
      courses: ['Sist. Organizacionales', 'Gest. Proyectos'],
      averageRating: 4.3,
      totalReviews: 76,
      photoUrl: null,
      bio: 'Experto en sistemas organizacionales y gestión de proyectos.',
    ),
    Professor(
      id: '3',
      name: 'Alfaro Marquína José Luis',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.7,
      totalReviews: 52,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '4',
      name: 'Alvarez Valdivia Edwin Manuel',
      department: 'Ingeniería de Sistemas',
      courses: ['Física I', 'Elec. y Electrónica', 'Inter.Cos./Inter.Thi', 'Mod.E Inte.Siste.', 'Ing. Conocimiento'],
      averageRating: 4.2,
      totalReviews: 134,
      photoUrl: null,
      bio: 'Docente con amplia experiencia en física, electrónica e ingeniería del conocimiento.',
    ),
    Professor(
      id: '5',
      name: 'Amable Ciudad Miriam Elizabeth',
      department: 'Ingeniería de Sistemas',
      courses: ['Simulación'],
      averageRating: 4.4,
      totalReviews: 67,
      photoUrl: null,
      bio: 'Especialista en simulación de sistemas.',
    ),
    Professor(
      id: '6',
      name: 'Arqandona Martinez Felipe Daniel',
      department: 'Ingeniería de Sistemas',
      courses: ['Física Para Sistemas'],
      averageRating: 4.1,
      totalReviews: 43,
      photoUrl: null,
      bio: 'Docente especializado en física aplicada a sistemas.',
    ),
    Professor(
      id: '7',
      name: 'Baca Fuentes Ivan Christian',
      department: 'Ingeniería de Sistemas',
      courses: ['Gest. Proyectos', 'Arq. de Software', 'Aud. Cont. Siste.'],
      averageRating: 4.6,
      totalReviews: 112,
      photoUrl: null,
      bio: 'Experto en arquitectura de software y auditoría de sistemas.',
    ),
    Professor(
      id: '8',
      name: 'Campos Medina Victor Hugo Santiago',
      department: 'Ingeniería de Sistemas',
      courses: ['Cálculo II'],
      averageRating: 4.0,
      totalReviews: 95,
      photoUrl: null,
      bio: 'Docente especializado en matemáticas aplicadas.',
    ),
    Professor(
      id: '9',
      name: 'Campos Villegas Martha Medalit',
      department: 'Ingeniería de Sistemas',
      courses: ['Estruc. Discretas', 'Simulación'],
      averageRating: 4.3,
      totalReviews: 78,
      photoUrl: null,
      bio: 'Especialista en estructuras discretas y simulación.',
    ),
    Professor(
      id: '10',
      name: 'Capcha Sánchez Fiorella',
      department: 'Ingeniería de Sistemas',
      courses: ['Inv. Operaciones I / Simulac. Procesos', 'Gest. Operaciones'],
      averageRating: 4.5,
      totalReviews: 83,
      photoUrl: null,
      bio: 'Experta en investigación de operaciones y gestión de procesos.',
    ),
    Professor(
      id: '11',
      name: 'Casma Salcedo Miguel Jacinto',
      department: 'Ingeniería de Sistemas',
      courses: ['Aud. Cont. Siste.'],
      averageRating: 4.2,
      totalReviews: 56,
      photoUrl: null,
      bio: 'Especialista en auditoría y control de sistemas.',
    ),
    Professor(
      id: '12',
      name: 'Castillo Mesías Luis Ernesto',
      department: 'Ingeniería de Sistemas',
      courses: ['Física Para Sistemas'],
      averageRating: 4.1,
      totalReviews: 49,
      photoUrl: null,
      bio: 'Docente especializado en física aplicada a sistemas.',
    ),
    Professor(
      id: '13',
      name: 'Chaparro Minaya Enrique Vladimir',
      department: 'Ingeniería de Sistemas',
      courses: ['Física Para Sistemas', 'I.A. Aplicada / Mod. E Inte.Siste.'],
      averageRating: 4.4,
      totalReviews: 91,
      photoUrl: null,
      bio: 'Especialista en física e inteligencia artificial aplicada.',
    ),
    Professor(
      id: '14',
      name: 'Checa Fernandez Rocío Del Pilar',
      department: 'Ingeniería de Sistemas',
      courses: ['Introd. Programación'],
      averageRating: 4.6,
      totalReviews: 102,
      photoUrl: null,
      bio: 'Docente especializada en introducción a la programación.',
    ),
    Professor(
      id: '15',
      name: 'Ciampa Torres José Moisés',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.3,
      totalReviews: 64,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '16',
      name: 'Curisinche Estrella César Eduardo',
      department: 'Ingeniería de Sistemas',
      courses: ['Des. Compet. Geren.'],
      averageRating: 4.2,
      totalReviews: 87,
      photoUrl: null,
      bio: 'Experto en desarrollo de competencias gerenciales.',
    ),
    Professor(
      id: '17',
      name: 'Cuzcano Chávez Ximena Marianne',
      department: 'Ingeniería de Sistemas',
      courses: ['Ciberseguridad / Cyb.', 'Prop. Investigación'],
      averageRating: 4.7,
      totalReviews: 73,
      photoUrl: null,
      bio: 'Especialista en ciberseguridad y metodología de investigación.',
    ),
    Professor(
      id: '18',
      name: 'Dávila Calle Guillermo Antonio',
      department: 'Ingeniería de Sistemas',
      courses: ['Des. Compet. Geren.', 'Mod. Siste. Logística / Compr. Gest Ab.'],
      averageRating: 4.1,
      totalReviews: 68,
      photoUrl: null,
      bio: 'Experto en competencias gerenciales y sistemas logísticos.',
    ),
    Professor(
      id: '19',
      name: 'Dedios La Madrid Edmundo Augusto',
      department: 'Ingeniería de Sistemas',
      courses: ['Plan Control Operac. / Compr. Gest Ab.', 'Gest. Operaciones'],
      averageRating: 4.3,
      totalReviews: 92,
      photoUrl: null,
      bio: 'Especialista en planificación y control de operaciones.',
    ),
    Professor(
      id: '20',
      name: 'Del Solar Vergara Eduardo Alejandro',
      department: 'Ingeniería de Sistemas',
      courses: ['Supply Chain Managem', 'Seguridad de Sistem.'],
      averageRating: 4.5,
      totalReviews: 115,
      photoUrl: null,
      bio: 'Experto en supply chain management y seguridad de sistemas.',
    ),
    Professor(
      id: '21',
      name: 'Diaz Parrá José Raúl',
      department: 'Ingeniería de Sistemas',
      courses: ['Arq. Empresarial', 'Plan. Estratégico'],
      averageRating: 4.4,
      totalReviews: 86,
      photoUrl: null,
      bio: 'Especialista en arquitectura empresarial y planificación estratégica.',
    ),
    Professor(
      id: '22',
      name: 'Diez Quiñones Panduro Percy',
      department: 'Ingeniería de Sistemas',
      courses: ['Red. Compu.'],
      averageRating: 4.2,
      totalReviews: 74,
      photoUrl: null,
      bio: 'Especialista en redes de computadoras.',
    ),
    Professor(
      id: '23',
      name: 'Dios Luna Jim Bryan',
      department: 'Ingeniería de Sistemas',
      courses: ['Sist. Operativos', 'Deep Learning'],
      averageRating: 4.8,
      totalReviews: 127,
      photoUrl: null,
      bio: 'Experto en sistemas operativos y deep learning.',
    ),
    Professor(
      id: '24',
      name: 'Escobedo Cardenas Edwin Jonathan',
      department: 'Ingeniería de Sistemas',
      courses: ['Estruc. Datos I'],
      averageRating: 4.3,
      totalReviews: 98,
      photoUrl: null,
      bio: 'Especialista en estructuras de datos.',
    ),
    Professor(
      id: '25',
      name: 'Fernández Del Pomar Marco Antonio',
      department: 'Ingeniería de Sistemas',
      courses: ['Transformac. Digital', 'Estrat. Intelig. Empre.', 'Gestión de Proyectos'],
      averageRating: 4.6,
      totalReviews: 143,
      photoUrl: null,
      bio: 'Experto en transformación digital y estrategias de inteligencia empresarial.',
    ),
    Professor(
      id: '26',
      name: 'Fernández Iparraguirre Jaddy Sylvana',
      department: 'Ingeniería de Sistemas',
      courses: ['Aud. Cont. Siste.'],
      averageRating: 4.1,
      totalReviews: 55,
      photoUrl: null,
      bio: 'Especialista en auditoría y control de sistemas.',
    ),
    Professor(
      id: '27',
      name: 'García Durante Sandro Juan',
      department: 'Ingeniería de Sistemas',
      courses: ['Ciberseguridad / Cyb.'],
      averageRating: 4.5,
      totalReviews: 81,
      photoUrl: null,
      bio: 'Especialista en ciberseguridad.',
    ),
    Professor(
      id: '28',
      name: 'García Vilcapoma Gladys Hortencia',
      department: 'Ingeniería de Sistemas',
      courses: ['Herram. Informáticas', 'I.A. Aplicada'],
      averageRating: 4.2,
      totalReviews: 79,
      photoUrl: null,
      bio: 'Especialista en herramientas informáticas e inteligencia artificial.',
    ),
    Professor(
      id: '29',
      name: 'Gómez Razza Víctor Humberto',
      department: 'Ingeniería de Sistemas',
      courses: ['Prog. Digital', 'I.A. Aplicada'],
      averageRating: 4.4,
      totalReviews: 107,
      photoUrl: null,
      bio: 'Experto en programación digital e inteligencia artificial.',
    ),
    Professor(
      id: '30',
      name: 'Gonzales Calderón Luis Manuel',
      department: 'Ingeniería de Sistemas',
      courses: ['Física Para Sistemas', 'Elec. y Electrónica', 'I.A. Aplicada', 'Estructura de Datos II'],
      averageRating: 4.3,
      totalReviews: 156,
      photoUrl: null,
      bio: 'Docente con amplia experiencia en física, electrónica e inteligencia artificial.',
    ),
    Professor(
      id: '31',
      name: 'Gutiérrez Cardenas Juan Manuel',
      department: 'Ingeniería de Sistemas',
      courses: ['Estructura de Datos II', 'Aprendiz. de Máquina'],
      averageRating: 4.6,
      totalReviews: 94,
      photoUrl: null,
      bio: 'Especialista en estructuras de datos y machine learning.',
    ),
    Professor(
      id: '32',
      name: 'Guzmán Jiménez Rosario Marybel',
      department: 'Ingeniería de Sistemas',
      courses: ['Mod. Base de Datos', 'Sem. Invest. I'],
      averageRating: 4.2,
      totalReviews: 71,
      photoUrl: null,
      bio: 'Especialista en modelado de bases de datos y metodología de investigación.',
    ),
    Professor(
      id: '33',
      name: 'Hau Ochoa Agatha Cristina',
      department: 'Ingeniería de Sistemas',
      courses: ['Ing. Proc. Negocio', 'Des. Compet. Geren.'],
      averageRating: 4.1,
      totalReviews: 63,
      photoUrl: null,
      bio: 'Experta en ingeniería de procesos de negocio y competencias gerenciales.',
    ),
    Professor(
      id: '34',
      name: 'Helfer Rodríguez Diego Norberto',
      department: 'Ingeniería de Sistemas',
      courses: ['Sist. ERP', 'I.A. Aplicada'],
      averageRating: 4.4,
      totalReviews: 88,
      photoUrl: null,
      bio: 'Especialista en sistemas ERP e inteligencia artificial.',
    ),
    Professor(
      id: '35',
      name: 'Herrera Santillan Luz Aydely',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.3,
      totalReviews: 57,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '36',
      name: 'Huaranga Junco Edgar Jesús',
      department: 'Ingeniería de Sistemas',
      courses: ['Aprendiz. de Máquina'],
      averageRating: 4.7,
      totalReviews: 82,
      photoUrl: null,
      bio: 'Especialista en machine learning.',
    ),
    Professor(
      id: '37',
      name: 'Irey Núñez Jorge Luis',
      department: 'Ingeniería de Sistemas',
      courses: ['Ing. de Software I', 'Ing. Soft. II', 'Prog. Web'],
      averageRating: 4.5,
      totalReviews: 132,
      photoUrl: null,
      bio: 'Experto en ingeniería de software y programación web.',
    ),
    Professor(
      id: '38',
      name: 'Jara Villavicencio Octavio V.',
      department: 'Ingeniería de Sistemas',
      courses: ['Sist. Distribuido', 'I.A. Aplicada'],
      averageRating: 4.4,
      totalReviews: 96,
      photoUrl: null,
      bio: 'Especialista en sistemas distribuidos e inteligencia artificial.',
    ),
    Professor(
      id: '39',
      name: 'Lewis Fuentes Winston',
      department: 'Ingeniería de Sistemas',
      courses: ['Arq. Tecno. Inform.', 'Gest. Proyectos'],
      averageRating: 4.2,
      totalReviews: 75,
      photoUrl: null,
      bio: 'Experto en arquitectura tecnológica y gestión de proyectos.',
    ),
    Professor(
      id: '40',
      name: 'Llanos Punyin Hector Germán',
      department: 'Ingeniería de Sistemas',
      courses: ['Plan. Estratégico'],
      averageRating: 4.1,
      totalReviews: 54,
      photoUrl: null,
      bio: 'Especialista en planificación estratégica.',
    ),
    Professor(
      id: '41',
      name: 'López Aleman Juan Francisco',
      department: 'Ingeniería de Sistemas',
      courses: ['Gest. Proyectos'],
      averageRating: 4.3,
      totalReviews: 67,
      photoUrl: null,
      bio: 'Especialista en gestión de proyectos.',
    ),
    Professor(
      id: '42',
      name: 'López Sandoval Heiner Ricardo',
      department: 'Ingeniería de Sistemas',
      courses: ['Redes Avanzadas', 'Física Para Sistemas', 'Investigación de Operaciones I'],
      averageRating: 4.4,
      totalReviews: 109,
      photoUrl: null,
      bio: 'Experto en redes avanzadas, física e investigación de operaciones.',
    ),
    Professor(
      id: '43',
      name: 'Machuca De Piña Juan Manuel',
      department: 'Ingeniería de Sistemas',
      courses: ['Prop. Investigación', 'Investigación de Operaciones II'],
      averageRating: 4.2,
      totalReviews: 73,
      photoUrl: null,
      bio: 'Especialista en metodología de investigación y operaciones.',
    ),
    Professor(
      id: '44',
      name: 'Mamani Paima Paulo Nazareno',
      department: 'Ingeniería de Sistemas',
      courses: ['Sem. Inves I', 'Sem. Inves II'],
      averageRating: 4.1,
      totalReviews: 65,
      photoUrl: null,
      bio: 'Especialista en seminarios de investigación.',
    ),
    Professor(
      id: '45',
      name: 'Marcelo Sánchez Víctor Hugo',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.3,
      totalReviews: 58,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '46',
      name: 'Matos Manguiñuri Jean Janssen',
      department: 'Ingeniería de Sistemas',
      courses: ['Gest. Proyectos', 'Des. Compet. Geren.'],
      averageRating: 4.2,
      totalReviews: 84,
      photoUrl: null,
      bio: 'Experto en gestión de proyectos y competencias gerenciales.',
    ),
    Professor(
      id: '47',
      name: 'Matuk Chúnez Andrea',
      department: 'Ingeniería de Sistemas',
      courses: ['Herramientas Informáticas'],
      averageRating: 4.4,
      totalReviews: 72,
      photoUrl: null,
      bio: 'Especialista en herramientas informáticas.',
    ),
    Professor(
      id: '48',
      name: 'Mayhua Quispe Ángela Gabriela',
      department: 'Ingeniería de Sistemas',
      courses: ['Prog. Web', 'Sem. Inves. II', 'Anál. y Dis. Algori.'],
      averageRating: 4.5,
      totalReviews: 103,
      photoUrl: null,
      bio: 'Experta en programación web y análisis de algoritmos.',
    ),
    Professor(
      id: '49',
      name: 'Medina Flores Jimmy Roberto',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.3,
      totalReviews: 61,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '50',
      name: 'Meza Rodríguez Aldo Richard',
      department: 'Ingeniería de Sistemas',
      courses: ['Fund. Opera. y Logist.'],
      averageRating: 4.1,
      totalReviews: 48,
      photoUrl: null,
      bio: 'Especialista en fundamentos de operaciones y logística.',
    ),
    Professor(
      id: '51',
      name: 'Miranda Pacheco Jorge Víctor',
      department: 'Ingeniería de Sistemas',
      courses: ['Sist. ERP', 'I.A. Aplicada'],
      averageRating: 4.4,
      totalReviews: 91,
      photoUrl: null,
      bio: 'Especialista en sistemas ERP e inteligencia artificial.',
    ),
    Professor(
      id: '52',
      name: 'More Sánchez Javier',
      department: 'Ingeniería de Sistemas',
      courses: ['Red. Compu.', 'Prop. Investigación', 'Sem. Inves. I'],
      averageRating: 4.2,
      totalReviews: 87,
      photoUrl: null,
      bio: 'Experto en redes de computadoras y metodología de investigación.',
    ),
    Professor(
      id: '53',
      name: 'Muñoz Casildo Nehil Indalicio',
      department: 'Ingeniería de Sistemas',
      courses: ['Estruc. Discretas / Ing. de Software I', 'Ing. Soft. II'],
      averageRating: 4.3,
      totalReviews: 116,
      photoUrl: null,
      bio: 'Especialista en estructuras discretas e ingeniería de software.',
    ),
    Professor(
      id: '54',
      name: 'Nakashima Chávez Giancarlo Juan',
      department: 'Ingeniería de Sistemas',
      courses: ['Prog. Orientada Obj.', 'Física I'],
      averageRating: 4.4,
      totalReviews: 95,
      photoUrl: null,
      bio: 'Especialista en programación orientada a objetos y física.',
    ),
    Professor(
      id: '55',
      name: 'Negrón Human René',
      department: 'Ingeniería de Sistemas',
      courses: ['Física Para Sistemas', 'Física II'],
      averageRating: 4.1,
      totalReviews: 78,
      photoUrl: null,
      bio: 'Docente especializado en física aplicada a sistemas.',
    ),
    Professor(
      id: '56',
      name: 'Nina Hanco Hernán',
      department: 'Ingeniería de Sistemas',
      courses: ['Sem. Inves. I', 'Prog. Orientada Obj.'],
      averageRating: 4.2,
      totalReviews: 69,
      photoUrl: null,
      bio: 'Especialista en investigación y programación orientada a objetos.',
    ),
    Professor(
      id: '57',
      name: 'Ocampo Zuñiga Antonio',
      department: 'Ingeniería de Sistemas',
      courses: ['Red. Compu.'],
      averageRating: 4.3,
      totalReviews: 52,
      photoUrl: null,
      bio: 'Especialista en redes de computadoras.',
    ),
    Professor(
      id: '58',
      name: 'Ortiz Pachas Christian Javier',
      department: 'Ingeniería de Sistemas',
      courses: ['Ges. Servi. Digitales'],
      averageRating: 4.5,
      totalReviews: 76,
      photoUrl: null,
      bio: 'Especialista en gestión de servicios digitales.',
    ),
    Professor(
      id: '59',
      name: 'Ortiz Valencia Alejandro Leopoldo',
      department: 'Ingeniería de Sistemas',
      courses: ['Des. Compet. Geren.'],
      averageRating: 4.1,
      totalReviews: 64,
      photoUrl: null,
      bio: 'Experto en desarrollo de competencias gerenciales.',
    ),
    Professor(
      id: '60',
      name: 'Palacios López Enrique Humberto',
      department: 'Ingeniería de Sistemas',
      courses: ['Gest. Proyectos'],
      averageRating: 4.2,
      totalReviews: 71,
      photoUrl: null,
      bio: 'Especialista en gestión de proyectos.',
    ),
    Professor(
      id: '61',
      name: 'Paredes Chávez Jorge Christian',
      department: 'Ingeniería de Sistemas',
      courses: ['Innovación Digital'],
      averageRating: 4.6,
      totalReviews: 83,
      photoUrl: null,
      bio: 'Especialista en innovación digital.',
    ),
    Professor(
      id: '62',
      name: 'Paredes Larroca Fabrico Humberto',
      department: 'Ingeniería de Sistemas',
      courses: ['Innov. en Ingeniería / Prod. de Manufactura', 'I.A. Aplicada / Automat. Indust.'],
      averageRating: 4.4,
      totalReviews: 98,
      photoUrl: null,
      bio: 'Experto en innovación en ingeniería y automatización industrial.',
    ),
    Professor(
      id: '63',
      name: 'Pasior Huaman Segundo Oswaldo',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.3,
      totalReviews: 55,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '64',
      name: 'Peñarrieta Huamán Herminio',
      department: 'Ingeniería de Sistemas',
      courses: ['Estructura de Datos I', 'Cálculo II / I.A. Aplicada / Estruc. Discretas'],
      averageRating: 4.2,
      totalReviews: 124,
      photoUrl: null,
      bio: 'Docente con experiencia en estructuras de datos, cálculo e inteligencia artificial.',
    ),
    Professor(
      id: '65',
      name: 'Pietrapiana Chiappe Fabio Fernando',
      department: 'Ingeniería de Sistemas',
      courses: ['Gest. Financiera', 'Des. Compet. Geren.'],
      averageRating: 4.1,
      totalReviews: 77,
      photoUrl: null,
      bio: 'Experto en gestión financiera y competencias gerenciales.',
    ),
    Professor(
      id: '66',
      name: 'Piscoya Chávez Sofia Margarita',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.4,
      totalReviews: 62,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '67',
      name: 'Puerta Arce Juan Alberto',
      department: 'Ingeniería de Sistemas',
      courses: ['Introd. Programación', 'Estruc. Discretas'],
      averageRating: 4.3,
      totalReviews: 89,
      photoUrl: null,
      bio: 'Especialista en introducción a la programación y estructuras discretas.',
    ),
    Professor(
      id: '68',
      name: 'Quintana Cruz Hernán Alejandro',
      department: 'Ingeniería de Sistemas',
      courses: ['Prog. Web', 'Proy. de Videojuegos'],
      averageRating: 4.7,
      totalReviews: 145,
      photoUrl: null,
      bio: 'Experto en programación web y desarrollo de videojuegos.',
    ),
    Professor(
      id: '69',
      name: 'Quinto Aniceta Javier Richard',
      department: 'Ingeniería de Sistemas',
      courses: ['Red. Compu.', 'Comp. Nube'],
      averageRating: 4.5,
      totalReviews: 93,
      photoUrl: null,
      bio: 'Especialista en redes de computadoras y computación en la nube.',
    ),
    Professor(
      id: '70',
      name: 'Quiroz Villalobos Lennin Paul',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.3,
      totalReviews: 59,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '71',
      name: 'Ramírez Argume Leo Carlos Israel',
      department: 'Ingeniería de Sistemas',
      courses: ['Red. Compu.', 'Ing. Proc. Negocio', 'Sem. Inves. I'],
      averageRating: 4.2,
      totalReviews: 101,
      photoUrl: null,
      bio: 'Experto en redes, ingeniería de procesos de negocio e investigación.',
    ),
    Professor(
      id: '72',
      name: 'Ramírez Cerna Lourdes',
      department: 'Ingeniería de Sistemas',
      courses: ['Prop. Investigación'],
      averageRating: 4.1,
      totalReviews: 47,
      photoUrl: null,
      bio: 'Especialista en metodología de investigación.',
    ),
    Professor(
      id: '73',
      name: 'Raygada Vargas Luis Armando',
      department: 'Ingeniería de Sistemas',
      courses: ['Sist. Intelig. Empre.'],
      averageRating: 4.4,
      totalReviews: 85,
      photoUrl: null,
      bio: 'Especialista en sistemas de inteligencia empresarial.',
    ),
    Professor(
      id: '74',
      name: 'Riccio Chávez Francisco Martín',
      department: 'Ingeniería de Sistemas',
      courses: ['Intelig. de Negocios', 'Gest. Base de Datos'],
      averageRating: 4.5,
      totalReviews: 118,
      photoUrl: null,
      bio: 'Especialista en inteligencia de negocios y gestión de bases de datos.',
    ),
    Professor(
      id: '75',
      name: 'Rodríguez Castillo Hugo Maximiliano',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.3,
      totalReviews: 66,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '76',
      name: 'Rojas Jaen Pablo Alberto',
      department: 'Ingeniería de Sistemas',
      courses: ['Prog. Orientada Obj.', 'Introd. Programación', 'I.A. Aplicada', 'Juego de Negocios'],
      averageRating: 4.4,
      totalReviews: 157,
      photoUrl: null,
      bio: 'Experto en programación orientada a objetos e inteligencia artificial.',
    ),
    Professor(
      id: '77',
      name: 'Román Acevedo Juan Carlos Eduardo',
      department: 'Ingeniería de Sistemas',
      courses: ['Prog. Orientada Obj.', 'Prog. Web'],
      averageRating: 4.2,
      totalReviews: 94,
      photoUrl: null,
      bio: 'Especialista en programación orientada a objetos y desarrollo web.',
    ),
    Professor(
      id: '78',
      name: 'Romero Romero Vilma Susana',
      department: 'Ingeniería de Sistemas',
      courses: ['Diseño Experimentos', 'Estadística Aplicada', 'Estadís. y Probabil.'],
      averageRating: 4.1,
      totalReviews: 87,
      photoUrl: null,
      bio: 'Especialista en diseño de experimentos y estadística aplicada.',
    ),
    Professor(
      id: '79',
      name: 'Romero Velazco George Edwin',
      department: 'Ingeniería de Sistemas',
      courses: ['Física Para Sistemas', 'Sistemas Operativos'],
      averageRating: 4.3,
      totalReviews: 105,
      photoUrl: null,
      bio: 'Especialista en física aplicada a sistemas y sistemas operativos.',
    ),
    Professor(
      id: '80',
      name: 'Roque Espinoza Javier Teodocio',
      department: 'Ingeniería de Sistemas',
      courses: ['Gest. Proyectos / Mod. Base de Datos'],
      averageRating: 4.2,
      totalReviews: 81,
      photoUrl: null,
      bio: 'Experto en gestión de proyectos y modelado de bases de datos.',
    ),
    Professor(
      id: '81',
      name: 'Rosales Rosales César',
      department: 'Ingeniería de Sistemas',
      courses: ['Mod. Base de Datos'],
      averageRating: 4.1,
      totalReviews: 63,
      photoUrl: null,
      bio: 'Especialista en modelado de bases de datos.',
    ),
    Professor(
      id: '82',
      name: 'Saavedra Sánchez Davila Lutzgardo',
      department: 'Ingeniería de Sistemas',
      courses: ['Fund. Programación', 'I.A. Aplicada'],
      averageRating: 4.3,
      totalReviews: 92,
      photoUrl: null,
      bio: 'Especialista en fundamentos de programación e inteligencia artificial.',
    ),
    Professor(
      id: '83',
      name: 'Salas Ochoa Jorge Luis Guillermo',
      department: 'Ingeniería de Sistemas',
      courses: ['Gest. Financiera', 'Gest. Minería', 'I.A. Aplicada', 'Progra. Ingeniería'],
      averageRating: 4.4,
      totalReviews: 134,
      photoUrl: null,
      bio: 'Experto en gestión financiera, minería de datos e inteligencia artificial.',
    ),
    Professor(
      id: '84',
      name: 'Sánchez Tenorio Juana Viviana',
      department: 'Ingeniería de Sistemas',
      courses: ['Machine Learning', 'Fund. Programación', 'Mod. E Inte.Siste.'],
      averageRating: 4.6,
      totalReviews: 108,
      photoUrl: null,
      bio: 'Especialista en machine learning y modelado de sistemas.',
    ),
    Professor(
      id: '85',
      name: 'Saravia Torres Pedro Humberto',
      department: 'Ingeniería de Sistemas',
      courses: ['Proy. Ingeniería I', 'Elec. y Electrónica'],
      averageRating: 4.2,
      totalReviews: 76,
      photoUrl: null,
      bio: 'Especialista en proyectos de ingeniería y electrónica.',
    ),
    Professor(
      id: '86',
      name: 'Sotelo Neyra Víctor Manuel',
      department: 'Ingeniería de Sistemas',
      courses: ['Física I', 'Física Para Sistemas'],
      averageRating: 4.1,
      totalReviews: 89,
      photoUrl: null,
      bio: 'Docente especializado en física aplicada a sistemas.',
    ),
    Professor(
      id: '87',
      name: 'Suni López Franci',
      department: 'Ingeniería de Sistemas',
      courses: ['Estructura de Datos II', 'Sem. Inves. I'],
      averageRating: 4.3,
      totalReviews: 71,
      photoUrl: null,
      bio: 'Especialista en estructuras de datos y metodología de investigación.',
    ),
    Professor(
      id: '88',
      name: 'Susano Urbina Gustavo Roberto',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.4,
      totalReviews: 58,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '89',
      name: 'Taco López John Oliver',
      department: 'Ingeniería de Sistemas',
      courses: ['I.A. Aplicada'],
      averageRating: 4.3,
      totalReviews: 54,
      photoUrl: null,
      bio: 'Especialista en inteligencia artificial aplicada.',
    ),
    Professor(
      id: '90',
      name: 'Tarazona Vargas Enver Gerald',
      department: 'Ingeniería de Sistemas',
      courses: ['Ana. Big Data', 'Estadística Aplicada'],
      averageRating: 4.7,
      totalReviews: 126,
      photoUrl: null,
      bio: 'Especialista en análisis de big data y estadística aplicada.',
    ),
    Professor(
      id: '91',
      name: 'Tello Yuen Roberto Leonardo',
      department: 'Ingeniería de Sistemas',
      courses: ['Introd. Programación', 'Prog. Orientada a Objetos'],
      averageRating: 4.2,
      totalReviews: 113,
      photoUrl: null,
      bio: 'Especialista en introducción a la programación y POO.',
    ),
    Professor(
      id: '92',
      name: 'Tincopa Flores Jean Pierre',
      department: 'Ingeniería de Sistemas',
      courses: ['Física Para Sistemas', 'Prop. Investigación', 'Red. Compu.'],
      averageRating: 4.3,
      totalReviews: 97,
      photoUrl: null,
      bio: 'Experto en física, investigación y redes de computadoras.',
    ),
    Professor(
      id: '93',
      name: 'Torres Paredes Carlos Martín',
      department: 'Ingeniería de Sistemas',
      courses: ['Estruc. Discretas', 'Física Para Sistemas'],
      averageRating: 4.1,
      totalReviews: 68,
      photoUrl: null,
      bio: 'Especialista en estructuras discretas y física aplicada.',
    ),
    Professor(
      id: '94',
      name: 'Ugarte Gómez José Luis',
      department: 'Ingeniería de Sistemas',
      courses: ['Inves. Operaciones I', 'Inves. Operaciones II', 'Simulac. de Procesos'],
      averageRating: 4.4,
      totalReviews: 142,
      photoUrl: null,
      bio: 'Experto en investigación de operaciones y simulación de procesos.',
    ),
    Professor(
      id: '95',
      name: 'Valdivia Caballero José Jesús',
      department: 'Ingeniería de Sistemas',
      courses: ['Introd. Programación', 'Mod. Base de Datos', 'Prog. Móvil'],
      averageRating: 4.5,
      totalReviews: 119,
      photoUrl: null,
      bio: 'Especialista en programación, bases de datos y desarrollo móvil.',
    ),
    Professor(
      id: '96',
      name: 'Vásquez Reyes Eduardo Ángel',
      department: 'Ingeniería de Sistemas',
      courses: ['Simulación'],
      averageRating: 4.2,
      totalReviews: 73,
      photoUrl: null,
      bio: 'Especialista en simulación de sistemas.',
    ),
    Professor(
      id: '97',
      name: 'Velasquez Colchado Dario Neiver',
      department: 'Ingeniería de Sistemas',
      courses: ['Sist. Intelig. Empre.'],
      averageRating: 4.3,
      totalReviews: 85,
      photoUrl: null,
      bio: 'Especialista en sistemas de inteligencia empresarial.',
    ),
    Professor(
      id: '98',
      name: 'Wong Urquiza Henry Joe',
      department: 'Ingeniería de Sistemas',
      courses: ['Ing. de Software I', 'DevOps'],
      averageRating: 4.6,
      totalReviews: 104,
      photoUrl: null,
      bio: 'Experto en ingeniería de software y DevOps.',
    ),
    Professor(
      id: '99',
      name: 'Zelada García Gianni Michael',
      department: 'Ingeniería de Sistemas',
      courses: ['Inves. Operaciones II', 'Simulación'],
      averageRating: 4.4,
      totalReviews: 91,
      photoUrl: null,
      bio: 'Especialista en investigación de operaciones y simulación.',
    ),
    Professor(
      id: '100',
      name: 'Zevallos Luna Victoria Guillermo',
      department: 'Ingeniería de Sistemas',
      courses: ['Gest. Opera.', 'Mod. Siste. Logistic.', 'Simulación'],
      averageRating: 4.3,
      totalReviews: 107,
      photoUrl: null,
      bio: 'Experto en gestión de operaciones, sistemas logísticos y simulación.',
    ),
  ];

  // Comentarios y reseñas de profesores de Ingeniería de Sistemas
  static final Map<String, List<Review>> _reviews = {
    '68': [ // Quintana Cruz Hernán Alejandro - Prog. Web, Proy. de Videojuegos
      Review(
        id: 'r1',
        userId: 'u1',
        userName: 'Juan Pérez',
        rating: 5,
        comment: 'Excelente profesor de programación web. Sus clases son muy dinámicas y siempre está al día con las últimas tecnologías. Los proyectos de videojuegos son increíbles.',
        date: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Review(
        id: 'r2',
        userId: 'u2',
        userName: 'María González',
        rating: 5,
        comment: 'El mejor profesor para aprender desarrollo web. Sus explicaciones son claras y los proyectos muy divertidos.',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        id: 'r3',
        userId: 'u3',
        userName: 'Carlos Ruiz',
        rating: 4,
        comment: 'Muy buen profesor, aunque a veces los proyectos son exigentes. Vale la pena el esfuerzo por todo lo que se aprende.',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ],
    '23': [ // Dios Luna Jim Bryan - Sist. Operativos, Deep Learning
      Review(
        id: 'r4',
        userId: 'u1',
        userName: 'Ana Torres',
        rating: 5,
        comment: 'Increíble profesor de Deep Learning. Logra hacer entendibles conceptos muy complejos. Sus clases de sistemas operativos también son excelentes.',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Review(
        id: 'r5',
        userId: 'u2',
        userName: 'Luis Mendoza',
        rating: 5,
        comment: 'El mejor profesor de IA que he tenido. Sus explicaciones son súper claras y los proyectos muy actuales.',
        date: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ],
    '84': [ // Sánchez Tenorio Juana Viviana - Machine Learning
      Review(
        id: 'r6',
        userId: 'u4',
        userName: 'Sandra Morales',
        rating: 5,
        comment: 'Excelente profesora de Machine Learning. Sus clases son muy bien estructuradas y siempre con ejemplos prácticos.',
        date: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ],
    '98': [ // Wong Urquiza Henry Joe - Ing. de Software I, DevOps
      Review(
        id: 'r7',
        userId: 'u1',
        userName: 'Diego Fernández',
        rating: 5,
        comment: 'Excelente profesor de DevOps. Sus clases son muy actualizadas y relevantes para la industria.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Review(
        id: 'r8',
        userId: 'u3',
        userName: 'Elena Vásquez',
        rating: 4,
        comment: 'Muy buen profesor de ingeniería de software. Sus metodologías son muy efectivas.',
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ],
    '90': [ // Tarazona Vargas Enver Gerald - Ana. Big Data, Estadística Aplicada
      Review(
        id: 'r9',
        userId: 'u2',
        userName: 'Roberto Chang',
        rating: 5,
        comment: 'Sus clases de Big Data son fascinantes. Combina teoría con práctica de manera perfecta.',
        date: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      Review(
        id: 'r10',
        userId: 'u5',
        userName: 'Carla Jiménez',
        rating: 4,
        comment: 'Muy buen profesor de estadística, aunque los temas son complejos. Vale la pena el esfuerzo.',
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ],
    '25': [ // Fernández Del Pomar Marco Antonio - Transformac. Digital
      Review(
        id: 'r11',
        userId: 'u1',
        userName: 'Fernando Ruiz',
        rating: 5,
        comment: 'Excelente profesor de transformación digital. Sus clases son muy inspiradoras y actuales.',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        id: 'r12',
        userId: 'u3',
        userName: 'Patricia Luna',
        rating: 4,
        comment: 'Muy buen profesor, aunque a veces es muy exigente con los proyectos.',
        date: DateTime.now().subtract(const Duration(days: 9)),
      ),
    ],
  };

  // Usuarios ficticios
  static final List<User> _users = [
    User(
      id: 'u1',
      name: 'Juan Pérez',
      email: 'juan.perez@ulima.edu.pe',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: 'u2',
      name: 'María González',
      email: 'maria.gonzalez@ulima.edu.pe',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    User(
      id: 'u3',
      name: 'Carlos Ruiz',
      email: 'carlos.ruiz@ulima.edu.pe',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    User(
      id: 'u4',
      name: 'Sandra Morales',
      email: 'sandra.morales@ulima.edu.pe',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    User(
      id: 'u5',
      name: 'Diego Fernández',
      email: 'diego.fernandez@ulima.edu.pe',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  /// Obtiene todos los usuarios
  static List<User> getAllUsers() {
    return List.from(_users);
  }

  /// Obtiene todos los profesores
  static List<Professor> getAllProfessors() {
    return List.from(_professors);
  }

  /// Obtiene profesores por departamento
  static List<Professor> getProfessorsByDepartment(String department) {
    if (department == 'All') return getAllProfessors();
    return _professors.where((prof) => prof.department == department).toList();
  }

  /// Obtiene profesores favoritos (los mejor calificados)
  static List<Professor> getFavoriteProfessors({int limit = 5}) {
    final sorted = List<Professor>.from(_professors);
    sorted.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return sorted.take(limit).toList();
  }

  /// Obtiene top profesores (por número de reseñas)
  static List<Professor> getTopProfessors({int limit = 5}) {
    final sorted = List<Professor>.from(_professors);
    sorted.sort((a, b) => b.totalReviews.compareTo(a.totalReviews));
    return sorted.take(limit).toList();
  }

  /// Busca profesores por nombre o departamento
  static List<Professor> searchProfessors(String query) {
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    return _professors.where((prof) {
      return prof.name.toLowerCase().contains(lowerQuery) ||
             prof.department.toLowerCase().contains(lowerQuery) ||
             prof.courses.any((course) => course.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Obtiene un profesor por ID
  static Professor? getProfessorById(String id) {
    try {
      return _professors.firstWhere((prof) => prof.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene reseñas de un profesor en formato Map
  static List<Map<String, dynamic>> getReviewsForProfessor(String professorId) {
    final reviews = _reviews[professorId] ?? [];
    return reviews.map((review) => {
      'id': review.id,
      'userId': review.userId,
      'userName': review.userName,
      'rating': review.rating,
      'comment': review.comment,
      'date': review.date,
    }).toList();
  }

  /// Obtiene la distribución de ratings para un profesor
  static Map<int, int> getRatingDistribution(String professorId) {
    final reviews = _reviews[professorId] ?? [];
    final distribution = <int, int>{
      1: 0, 2: 0, 3: 0, 4: 0, 5: 0,
    };
    
    for (final review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    }
    
    // Para Quintana Cruz Hernán Alejandro (id: '68'), generar distribución realista basada en 145 reviews
    if (professorId == '68') {
      distribution[5] = 95;  // 95 reseñas de 5 estrellas
      distribution[4] = 35;  // 35 reseñas de 4 estrellas  
      distribution[3] = 10;  // 10 reseñas de 3 estrellas
      distribution[2] = 3;   // 3 reseñas de 2 estrellas
      distribution[1] = 2;   // 2 reseñas de 1 estrella
    }
    
    // Para Dios Luna Jim Bryan (id: '23'), generar distribución realista basada en 127 reviews
    if (professorId == '23') {
      distribution[5] = 85;  // 85 reseñas de 5 estrellas
      distribution[4] = 30;  // 30 reseñas de 4 estrellas  
      distribution[3] = 8;   // 8 reseñas de 3 estrellas
      distribution[2] = 3;   // 3 reseñas de 2 estrellas
      distribution[1] = 1;   // 1 reseña de 1 estrella
    }
    
    return distribution;
  }

  /// Verifica si un profesor está en favoritos
  static bool isFavoriteProfessor(String professorId) {
    // Simulamos que algunos de los mejores profesores están en favoritos
    final favoriteIds = ['68', '23', '84', '98', '90']; // Quintana, Dios Luna, Sánchez Tenorio, Wong, Tarazona
    return favoriteIds.contains(professorId);
  }

  /// Obtiene todos los departamentos únicos
  static List<String> getAllDepartments() {
    final departments = _professors.map((prof) => prof.department).toSet().toList();
    departments.sort();
    return ['All', ...departments];
  }

  /// Obtiene usuario actual (simulado)
  static User getCurrentUser() {
    return _users.first;
  }

  /// Agrega una nueva reseña a un profesor
  static void addReviewToProfessor({
    required String professorId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) {
    final newReview = Review(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
      date: DateTime.now(),
    );

    if (_reviews[professorId] == null) {
      _reviews[professorId] = [];
    }
    _reviews[professorId]!.insert(0, newReview); // Agregar al inicio

    // Actualizar el rating promedio del profesor
    final professorIndex = _professors.indexWhere((p) => p.id == professorId);
    if (professorIndex != -1) {
      final professor = _professors[professorIndex];
      final allReviews = _reviews[professorId]!;
      final totalRating = allReviews.fold(0, (sum, review) => sum + review.rating);
      final newAverage = totalRating / allReviews.length;
      
      _professors[professorIndex] = Professor(
        id: professor.id,
        name: professor.name,
        department: professor.department,
        courses: professor.courses,
        averageRating: newAverage,
        totalReviews: allReviews.length,
        photoUrl: professor.photoUrl,
        bio: professor.bio,
      );
    }
  }
}
