using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using VetApp.Models;

namespace VetApp.Controllers
{
    public class HotelReportController : Controller
    {
        private readonly VeterinariaExtendidaContext _context;

        public HotelReportController(VeterinariaExtendidaContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> GenerateHotelReportAsync()
        {
            var hospedajes = await _context.Hospedajes
              .Select(h => new { h.IdHospedaje, h.CodMascota })
              .ToListAsync();

            ViewBag.Hospedajes = new SelectList(hospedajes, "IdHospedaje", "IdHospedaje");

            return View();
        }

        [HttpPost]
        public async Task<IActionResult> GenerateHotelReport(DateOnly fechaInicio, DateOnly fechaFin, int idHospedaje)
        {
            var reportResults = new List<HotelConsumptionReportViewModel>();

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "GenerateHotelConsumptionReport";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@fechaInicio", fechaInicio.ToString("yyyy-MM-dd")));
                command.Parameters.Add(new SqlParameter("@fechaFin", fechaFin.ToString("yyyy-MM-dd")));
                command.Parameters.Add(new SqlParameter("@idHospedaje", idHospedaje));

                var resultadoParam = new SqlParameter("@resultado", SqlDbType.Money)
                {
                    Direction = ParameterDirection.Output
                };
                command.Parameters.Add(resultadoParam);

                await _context.Database.OpenConnectionAsync();

                // Ejecutar el stored procedure
                await command.ExecuteNonQueryAsync();

                // Leer el resultado del parámetro de salida
                var resultado = (decimal)resultadoParam.Value;

                // Obtener detalles del hospedaje
                var hospedaje = await _context.Hospedajes
                    .FirstOrDefaultAsync(h => h.IdHospedaje == idHospedaje && h.FechaIngreso >= DateOnly.FromDateTime(fechaInicio.ToDateTime(TimeOnly.MinValue)) && h.FechaSalida <= DateOnly.FromDateTime(fechaFin.ToDateTime(TimeOnly.MinValue)));

                if (hospedaje != null)
                {
                    reportResults.Add(new HotelConsumptionReportViewModel
                    {
                        IdHospedaje = idHospedaje,
                        CodMascota = hospedaje.CodMascota,
                        FechaIngreso = hospedaje.FechaIngreso,
                        FechaSalida = hospedaje.FechaSalida,
                        PrecioTotalGeneral = resultado
                    });
                }

                await _context.Database.CloseConnectionAsync();
            }

            return View("HotelReportResults", reportResults);
        }
    }
}
