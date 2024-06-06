using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class ConsumosVet
{
    public string CodMascota { get; set; } = null!;

    public string CodVacuna { get; set; } = null!;

    public string IdServicio { get; set; } = null!;

    public int IdConsumoVet { get; set; }

    public string Observaciones { get; set; } = null!;

    public int CantVacunas { get; set; }

    public string Nit { get; set; } = null!;

    public virtual Mascota CodMascotaNavigation { get; set; } = null!;

    public virtual Vacuna CodVacunaNavigation { get; set; } = null!;

    public virtual Servicio IdServicioNavigation { get; set; } = null!;
}
