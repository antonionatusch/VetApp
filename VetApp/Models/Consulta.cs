using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class Consulta
{
    public string CodMascota { get; set; } = null!;

    public DateOnly FechaConsulta { get; set; }

    public string Motivo { get; set; } = null!;

    public string Diagnostico { get; set; } = null!;

    public string Tratamiento { get; set; } = null!;

    public string Medicacion { get; set; } = null!;

    public virtual Mascota CodMascotaNavigation { get; set; } = null!;
}
