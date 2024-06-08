using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using VetApp.Models;

namespace VetApp.Controllers
{
    public class ConsumosVetController : Controller
    {
        private readonly VeterinariaExtendidaContext _context;

        public ConsumosVetController(VeterinariaExtendidaContext context)
        {
            _context = context;
        }

        // GET: ConsumosVet
        public async Task<IActionResult> Index()
        {
            var consumosVets = await _context.ConsumosVets
                .Include(c => c.CodMascotaNavigation)
                .Include(c => c.CodVacunaNavigation)
                .Include(c => c.IdServicioNavigation)
                .ToListAsync();
            return View(consumosVets);
        }

        // GET: ConsumosVet/Create
        public IActionResult Create()
        {
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "Nombre");
            return View();
        }

        // POST: ConsumosVet/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(DateOnly FechaInicio, DateOnly FechaFin, string CodMascota, string Observaciones, string Nit)
        {
            if (ModelState.IsValid)
            {
                await _context.Database.ExecuteSqlInterpolatedAsync(
                    $"EXEC InsertarConsumoVet {FechaInicio}, {FechaFin}, {CodMascota}, {Observaciones}, {Nit}");

                // Verificar e insertar consultas generales
                var consultas = await _context.Consultas
                    .Where(c => c.CodMascota == CodMascota && c.FechaConsulta >= FechaInicio && c.FechaConsulta <= FechaFin)
                    .ToListAsync();

                foreach (var consulta in consultas)
                {
                    await _context.ConsumosVets.AddAsync(new ConsumosVet
                    {
                        CodMascota = consulta.CodMascota,
                        CodVacuna = null,
                        IdServicio = "CG000", // ID del servicio de consultas generales
                        Observaciones = Observaciones,
                        CantVacunas = 0,
                        Nit = Nit,
                        IdConsumoVet = 0 // Este campo será autoincremental
                    });
                }

                await _context.SaveChangesAsync();

                return RedirectToAction(nameof(Index));
            }

            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "Nombre", CodMascota);
            return View();
        }
    }
}
