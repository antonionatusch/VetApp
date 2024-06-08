using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace VetApp.Models
{
    public partial class AplicaVacuna
    {
        public string CodMascota { get; set; } = null!;

        public string CodVacuna { get; set; } = null!;

        [DataType(DataType.Date)]
        [Display(Name = "Fecha Prevista")]
        [Required(ErrorMessage = "La Fecha Prevista es obligatoria.")]
        [CustomValidation(typeof(AplicaVacuna), "ValidateFechaPrevista")]
        public DateOnly FechaPrevista { get; set; }

        [DataType(DataType.Date)]
        [Display(Name = "Fecha Aplicación")]
        public DateOnly? FechaAplicacion { get; set; }

        public int DosisAplicada { get; set; }

        [ValidateNever]
        public virtual Mascota CodMascotaNavigation { get; set; } = null!;

        [ValidateNever]
        public virtual Vacuna CodVacunaNavigation { get; set; } = null!;

        public static ValidationResult? ValidateFechaPrevista(DateOnly fechaPrevista, ValidationContext context)
        {
            if (fechaPrevista < DateOnly.FromDateTime(DateTime.Now))
            {
                return new ValidationResult("La Fecha Prevista no puede ser anterior a la fecha de hoy.");
            }
            return ValidationResult.Success;
        }
    }
}
