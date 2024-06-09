using System;
using System.Collections.Generic;

namespace VetApp.Models;

public partial class ConsumoHotel
{
    public int IdHospedaje { get; set; }

    public string IdServicio { get; set; } = null!;

    public string CodMascota { get; set; } = null!;

    public string? CodAlimento { get; set; }

    public string? CodMedicamento { get; set; }

    public string? IdComodidad { get; set; }

    public string Nit { get; set; } = null!;

    public string Observaciones { get; set; } = null!;
    public int NochesHosp { get; set; }
    public int CantidadAlim { get; set; }

    public int CantidadMedic { get; set; }

    public int CantidadCom { get; set; }

    public virtual Alimento? CodAlimentoNavigation { get; set; }

    public virtual Mascota CodMascotaNavigation { get; set; } = null!;

    public virtual Medicamento? CodMedicamentoNavigation { get; set; }

    public virtual Comodidade? IdComodidadNavigation { get; set; }

    public virtual Hospedaje IdHospedajeNavigation { get; set; } = null!;

    public virtual Servicio IdServicioNavigation { get; set; } = null!;
}
