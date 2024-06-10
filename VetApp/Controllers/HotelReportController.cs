using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
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

        public IActionResult GenerateHotelReport()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> GenerateHotelReport(DateOnly fechaInicio, DateOnly fechaFin)
        {
            var reportResults = new List<HotelConsumptionReportViewModel>();

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "GenerateHotelConsumptionReport";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@fechaInicio", fechaInicio.ToString("yyyy-MM-dd")));
                command.Parameters.Add(new SqlParameter("@fechaFin", fechaFin.ToString("yyyy-MM-dd")));

                var resultadoParam = new SqlParameter("@resultado", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                command.Parameters.Add(resultadoParam);

                await _context.Database.OpenConnectionAsync();

                using (var result = await command.ExecuteReaderAsync())
                {
                    while (await result.ReadAsync())
                    {
                        reportResults.Add(new HotelConsumptionReportViewModel
                        {
                            CodMascota = result.IsDBNull(0) ? string.Empty : result.GetString(0),
                            NombreMascota = result.IsDBNull(1) ? string.Empty : result.GetString(1),
                            Cliente = result.IsDBNull(2) ? string.Empty : result.GetString(2),
                            IdServicio = result.IsDBNull(3) ? string.Empty : result.GetString(3),
                            NombreServicio = result.IsDBNull(4) ? string.Empty : result.GetString(4),
                            Observaciones = result.IsDBNull(5) ? string.Empty : result.GetString(5),
                            NochesHosp = result.IsDBNull(6) ? 0 : result.GetInt32(6),
                            CantidadAlim = result.IsDBNull(7) ? 0 : result.GetInt32(7),
                            CantidadMedic = result.IsDBNull(8) ? 0 : result.GetInt32(8),
                            CantidadCom = result.IsDBNull(9) ? 0 : result.GetInt32(9),
                            CantidadBanos = result.IsDBNull(10) ? 0 : result.GetInt32(10),
                            Nit = result.IsDBNull(11) ? string.Empty : result.GetString(11),
                            Fecha = result.IsDBNull(12) ? DateOnly.MinValue : DateOnly.FromDateTime(result.GetDateTime(12)),
                            PrecioTotal = result.IsDBNull(13) ? 0 : result.GetDecimal(13),
                            PrecioTotalGeneral = result.IsDBNull(14) ? (decimal?)null : result.GetDecimal(14)
                        });
                    }
                }

                await _context.Database.CloseConnectionAsync();
                // Obtén el valor del parámetro de salida
                var resultado = (int)resultadoParam.Value;
                if (resultado != 1)
                {
                    ModelState.AddModelError("", "Error generating report.");
                    return View();
                }
            }

            return View("HotelReportResults", reportResults);
        }
    }
}
