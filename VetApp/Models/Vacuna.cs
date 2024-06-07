using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class Vacuna
{
    public string CodVacuna { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string Laboratorio { get; set; } = null!;

    public string PrevEnfermedad { get; set; } = null!;

    public decimal Dosis { get; set; }

    public decimal PrecioUnitario { get; set; }

    public virtual ICollection<AplicaVacuna> AplicaVacunas { get; set; } = new List<AplicaVacuna>();

    public virtual ICollection<ConsumosVet> ConsumosVets { get; set; } = new List<ConsumosVet>();
}
