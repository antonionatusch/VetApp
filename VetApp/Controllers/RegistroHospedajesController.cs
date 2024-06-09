using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using VetApp.Models;
using VetApp.ViewModels;
using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace VetApp.Controllers
{
    public class RegistroHospedajesController : Controller
    {
        private readonly VeterinariaExtendidaContext _context;

        public RegistroHospedajesController(VeterinariaExtendidaContext context)
        {
            _context = context;
        }

        // GET: RegistroHospedajes
        public async Task<IActionResult> Index()
        {
            var hospedajes = await _context.Hospedajes
                .Include(h => h.CodMascotaNavigation)
                .Select(h => new RegistrarHospedajeViewModel
                {
                    CodMascota = h.CodMascota,
                    FechaIngreso = h.FechaIngreso,
                    FechaSalida = h.FechaSalida,
                    TamanoMascota = h.CodMascotaNavigation.Especie,
                    UsaNecesidadesEspeciales = _context.ConsumoHotels
                        .Any(ch => ch.IdHospedaje == h.IdHospedaje && ch.CodMascota == h.CodMascota && ch.IdServicio == "NE000")
                })
                .ToListAsync();

            return View(hospedajes);
        }

        // GET: RegistroHospedajes/Create
        public IActionResult Create()
        {
            var model = new RegistrarHospedajeViewModel
            {
                Mascotas = new SelectList(_context.Mascotas, "CodMascota", "Nombre")
            };
            return View(model);
        }

        // POST: RegistroHospedajes/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(RegistrarHospedajeViewModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    await _context.RegistrarHospedaje(model);
                    return RedirectToAction(nameof(Index));
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError(string.Empty, $"Error: {ex.Message}");
                }
            }

            model.Mascotas = new SelectList(_context.Mascotas, "CodMascota", "Nombre", model.CodMascota);
            return View(model);
        }
    }
}
