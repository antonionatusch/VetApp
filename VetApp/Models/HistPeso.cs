using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class HistPeso
{
    public string CodMascota { get; set; } = null!;

    public DateOnly FechaPesaje { get; set; }

    public decimal Peso { get; set; }

    public virtual Mascota CodMascotaNavigation { get; set; } = null!;
}
