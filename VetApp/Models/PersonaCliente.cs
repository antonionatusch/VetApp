using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class PersonaCliente
{
    public string CodCliente { get; set; } = null!;

    public string Ci { get; set; } = null!;

    public DateOnly FechaAsociacion { get; set; }

    public virtual Persona CiNavigation { get; set; } = null!;

    public virtual Cliente CodClienteNavigation { get; set; } = null!;
}
