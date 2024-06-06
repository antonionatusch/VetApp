using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class Cliente
{
    public string CodCliente { get; set; } = null!;

    public string Apellido { get; set; } = null!;

    public string CuentaBanco { get; set; } = null!;

    public string Banco { get; set; } = null!;

    public string Direccion { get; set; } = null!;

    public string Telefono { get; set; } = null!;

    public string Correo { get; set; } = null!;

    public virtual ICollection<PersonaCliente> PersonaClientes { get; set; } = new List<PersonaCliente>();
}
