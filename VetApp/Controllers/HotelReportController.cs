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
        public async Task<IActionResult> GenerateHotelReport(HotelConsumptionReportViewModel model)
        {
            if (model.FechaSalida < model.FechaIngreso)
            {
                ModelState.AddModelError("FechaSalida", "La fecha de salida no puede ser menor que la fecha de ingreso.");
            }

            if (ModelState.IsValid)
            {
                var reportResults = new List<HotelConsumptionReportViewModel>();

                using (var command = _context.Database.GetDbConnection().CreateCommand())
                {
                    command.CommandText = "GenerateHotelConsumptionReport";
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@fechaInicio", model.FechaIngreso.ToString("yyyy-MM-dd")));
                    command.Parameters.Add(new SqlParameter("@fechaFin", model.FechaSalida.ToString("yyyy-MM-dd")));
                    command.Parameters.Add(new SqlParameter("@idHospedaje", model.IdHospedaje));

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
                        .FirstOrDefaultAsync(h => h.IdHospedaje == model.IdHospedaje && h.FechaIngreso >= DateOnly.FromDateTime(model.FechaIngreso.ToDateTime(TimeOnly.MinValue)) && h.FechaSalida <= DateOnly.FromDateTime(model.FechaSalida.ToDateTime(TimeOnly.MinValue)));

                    if (hospedaje != null)
                    {
                        reportResults.Add(new HotelConsumptionReportViewModel
                        {
                            IdHospedaje = model.IdHospedaje,
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

            var hospedajes = await _context.Hospedajes
                .Select(h => new { h.IdHospedaje, h.CodMascota })
                .ToListAsync();

            ViewBag.Hospedajes = new SelectList(hospedajes, "IdHospedaje", "IdHospedaje");

            return View(model);
        }
    }
}
