﻿using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class Hospedaje
{
    public int IdHospedaje { get; set; }

    public string CodMascota { get; set; } = null!;

    public DateOnly FechaIngreso { get; set; }

    public DateOnly FechaSalida { get; set; }

    public string Observaciones { get; set; } = null!;

    public virtual ICollection<ConsumoHotel> ConsumoHotels { get; set; } = new List<ConsumoHotel>();
    [ValidateNever]
    public virtual Mascota CodMascotaNavigation { get; set; } = null!;
}
