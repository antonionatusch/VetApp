namespace VetApp.Models
{
    public class HotelConsumptionReportViewModel
    {
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
        public int CantidadBanos { get; set; }
        public string Nit { get; set; }
        public DateOnly Fecha { get; set; }
        public decimal PrecioTotal { get; set; }
        public decimal? PrecioTotalGeneral { get; set; }
    }
}
