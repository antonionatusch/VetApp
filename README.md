<br />
<div align ="center">
  <a href="https://virtual.upsa.edu.bo/">
    <img src ="https://virtual.upsa.edu.bo/pluginfile.php/1/theme_lambda/logo/1708129513/logo%20UPSA-universidad-03.png">
  </a>
</div>

# VetApp y sus objetivos
Repositorio que contiene la aplicación y los queries necesario para el final de Bases de Datos Sem I/2024



Objetivos:
* Realizar la implementación física de la base de datos junto a las inserciones de datos y sus procedimientos almacenados
* Construir la app web de tipo CRUD que permita interactuar con la base de datos

## gitignore
El gitignore **bajo _ninguna_ circunstancia** debe modificarse sin previa autorización de los administradores del repo,
puesto que este archivo previene problemas de compilación, permite una mayor flexibilidad de colaboración,
entre otros.

## Ramas 
Podrá solicitar una nueva rama para contribuir al desarrollo del repositorio siempre
y cuando todos los demás colaboradores estén de acuerdo.

A la rama dev solo irán aquellos aportes **100% funcionales** y que **no** interfieran con el desarrollo
individual de las ramas de los colaboradores, pero que están pendientes de expansión o reducción, junto
con los directorios de trabajo de los colaboradores.

A la rama master irán todas aquellos aportes **100% funcionales** definitivos, que no necesitarán de 
modificación posterior, junto con los directorios de trabajo de colaboradores

La rama de cada desarrollador es dibujo libre, sin embargo, **no se aceptarán _pull requests_ que modifiquen
archivos importantes como el _.gitignore_ o el _README.md_** (es decir, el presente documento).


## Lenguaje
Al estar manejando bases de datos, y luego una app web de tipo ASP.NET, los lenguajes principales son **SQL, HTML, CSS y C#.**

## Contacto
Cualquier duda, sugerencia, o recomendación deberá hacerse contactando de manera presencial o por correo
a los co-dueños:

Mauricio Flores - a2022112750@estudiantes.upsa.edu.bo

Antonio Natusch - a2022111958@estudiantes.upsa.edu.bo

## Recursos
Libro: <a href="https://drive.google.com/file/d/1rQgM_uVnlWDIrkBZJvzxO_-pqN7o_155/view"> Fundamentals of Database Systems - Elmasri </a> <br></br>
Libro: <a href="https://drive.google.com/file/d/1kTc6JP_yx1SLsGa14ltO_3ZhLSn0R-W3/view"> Database Design, Applation Development, and Administration - Mannino </a>

## Descripción del problema

<div>
Problema: Veterinaria

Un veterinario tiene como pacientes animales, como cliente familias, un cliente es un conjunto de personas que suele corresponderse con una familia.

Cada cliente tiene un código, primer apellido es la cabeza de la familia, un # de cuenta bancaria, una dirección, un teléfono y los nombres y la identificación de las personas correspondientes. No existe el límite de personas asociadas a un cliente, además, una persona puede estar dado de alta en varios clientes (Ejemplo: Un hombre que vive con su esposa tiene un gato y como tal pertenece a un cliente, pero también está dado de alta en el cliente asociado con el perro de sus padres). Los clientes pueden tener varias mascotas, cada mascota tiene un código, un alias, una especie, una raza, color de pelo, fecha de nacimiento, peso del paciente (se debe llevar el historial de peso durante las 10 últimas visitas y el peso actual). Así mismo se guarda un historial médico con cada enfermedad que tuvo y la fecha en la que se enfermó. Adicionalmente cada mascota tiene un calendario de vacunación, en la que se llena el registro de cada vacuna, y la enfermedad contra la que se está vacunado.

Ampliación: Servicio de hotel de mascotas

La veterinaria está desarrollando un nuevo negocio de “hotel de mascotas”, para lo cual necesitan ampliar su sistema teniendo en cuenta el funcionamiento deseado de este nuevo servicio:

1.       Se puede hospedar a cualquier mascota sea o no paciente de la veterinaria, pero debe registrarse la información para todos.

2.      Para el huésped, debe registrarse si tiene necesidades especiales en cuanto a medicación, alimentación o algún cuidado particular.

3.      La alimentación en general se cobra como parte del servicio de hospedaje, excepto cuando requiere alimentación especial, que se factura de manera adicional, lo mismo que medicinas y otros insumos que sean necesarios para su cuidado particular.

 

Se requiere:

·        El servicio incluye también la higiene básica de un baño al ser recibido, y en estancias prolongadas un baño semanal adicional, cualquier servicio más allá de eso se considera extra en la cuenta.

·        Construir la funcionalidad necesaria para el registro de los huéspedes y todas sus necesidades. Y construir la funcionalidad necesaria para el check out del huésped y la emisión de la nota de cobranza.

·        Elaborar un reporte de los huéspedes atendidos en un periodo entre dos fechas, incluyendo los huéspedes que están siendo atendidos.

·        Todas las interfaces ABMC/CRUD que sean necesarias
</div>


## Demostración del reporte del consumo hotelero y baños
https://prnt.sc/LhwZBpad5oJl

## Demostración del reporte médico
https://prnt.sc/m7QlwTF9IHUp
