using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace VetApp.Models;

public partial class HistPeso
{
    [Display(Name ="Mascota")]
    public string CodMascota { get; set; } = null!;
    [Display(Name = "Fecha del pesaje")]

    public DateOnly FechaPesaje { get; set; }
    [Display(Name = "Peso a la fecha")]

    public decimal Peso { get; set; }
    [ValidateNever]
    [Display(Name ="Mascota")]
    public virtual Mascota CodMascotaNavigation { get; set; } = null!;
}
