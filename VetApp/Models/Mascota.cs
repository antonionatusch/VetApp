using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class Mascota
{
    public string CodMascota { get; set; } = null!;

    public string CodCliente { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string Especie { get; set; } = null!;

    public string Raza { get; set; } = null!;

    public string Color { get; set; } = null!;

    public DateOnly? FechaNac { get; set; }

    public virtual ICollection<AplicaVacuna> AplicaVacunas { get; set; } = new List<AplicaVacuna>();

    public virtual Cliente CodClienteNavigation { get; set; } = null!;

    public virtual ICollection<Consulta> Consulta { get; set; } = new List<Consulta>();

    public virtual ICollection<ConsumosVet> ConsumosVets { get; set; } = new List<ConsumosVet>();
}
