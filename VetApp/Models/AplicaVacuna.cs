﻿using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class AplicaVacuna
{
    public string CodMascota { get; set; } = null!;

    public string CodVacuna { get; set; } = null!;

    public DateOnly FechaPrevista { get; set; }

    public DateOnly? FechaAplicacion { get; set; }

    public int DosisAplicada { get; set; }
    [ValidateNever]
    public virtual Mascota CodMascotaNavigation { get; set; } = null!;
    [ValidateNever]
    public virtual Vacuna CodVacunaNavigation { get; set; } = null!;
}
