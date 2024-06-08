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


               

                await _context.SaveChangesAsync();

                return RedirectToAction(nameof(Index));
            }

            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "Nombre", CodMascota);
            return View();
        }
    }
}
