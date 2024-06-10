using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace VetApp.Models
{
    public class HotelConsumptionReportViewModel : IValidatableObject
    {
        public int IdHospedaje { get; set; }
        public string CodMascota { get; set; }
        public string NombreMascota { get; set; }
        public string Cliente { get; set; }
        public string IdServicio { get; set; }
        public string NombreServicio { get; set; }
        public string Observaciones { get; set; }
        public int NochesHosp { get; set; }
        public int CantidadAlim { get; set; }
        public int CantidadMedic { get; set; }
        public int CantidadCom { get; set; }
        public string Nit { get; set; }
        public DateOnly Fecha { get; set; }
        public decimal PrecioTotal { get; set; }
        public decimal? PrecioTotalGeneral { get; set; }

        [Required(ErrorMessage = "La fecha de ingreso es obligatoria")]
        [Display(Name = "Fecha Ingreso")]
        [DataType(DataType.Date)]
        public DateOnly FechaIngreso { get; set; }

        [Required(ErrorMessage = "La fecha de salida es obligatoria")]
        [Display(Name = "Fecha Salida")]
        [DataType(DataType.Date)]
        public DateOnly FechaSalida { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            if (FechaSalida < FechaIngreso)
            {
                yield return new ValidationResult(
                    "La fecha de salida no puede ser menor que la fecha de ingreso.",
                    new[] { nameof(FechaSalida) }
                );
            }
        }
    }
}
