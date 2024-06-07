using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class Persona
{
    public string Ci { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string Telefono { get; set; } = null!;

    public string Correo { get; set; } = null!;

    public string Direccion { get; set; } = null!;

    public virtual ICollection<PersonaCliente> PersonaClientes { get; set; } = new List<PersonaCliente>();
}
