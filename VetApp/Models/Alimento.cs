using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class Alimento
{
    public int CodAlimento { get; set; }

    public string Nombre { get; set; } = null!;

    public string Descripcion { get; set; } = null!;

    public string Proveedor { get; set; } = null!;

    public decimal PrecioUnitario { get; set; }

    public virtual ICollection<ConsumoHotel> ConsumoHotels { get; set; } = new List<ConsumoHotel>();
}
