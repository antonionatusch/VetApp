using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
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
        public async Task<IActionResult> Create([Bind("FechaInicio,FechaFin,CodMascota,Observaciones,Nit")] ConsumosVetCreateViewModel model)
        {
            if (ModelState.IsValid)
            {
                await _context.Database.ExecuteSqlInterpolatedAsync(
                    $"EXEC InsertarConsumoVet {model.FechaInicio}, {model.FechaFin}, {model.CodMascota}, {model.Observaciones}, {model.Nit}");
                return RedirectToAction(nameof(Index));
            }

            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "Nombre", model.CodMascota);
            return View(model);
        }

        // GET: ConsumosVet/Edit
        public async Task<IActionResult> Edit(string codMascota, string idServicio, int idConsumoVet)
        {
            if (codMascota == null || idServicio == null || idConsumoVet == 0)
            {
                return NotFound();
            }

            var consumosVet = await _context.ConsumosVets.FindAsync(codMascota, idServicio, idConsumoVet);
            if (consumosVet == null)
            {
                return NotFound();
            }
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "Nombre", consumosVet.CodMascota);
            ViewData["CodVacuna"] = new SelectList(_context.Vacunas, "CodVacuna", "Nombre", consumosVet.CodVacuna);
            ViewData["IdServicio"] = new SelectList(_context.Servicios, "IdServicio", "Nombre", consumosVet.IdServicio);
            return View(consumosVet);
        }

        // POST: ConsumosVet/Edit
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string codMascota, string idServicio, int idConsumoVet, [Bind("CodMascota,CodVacuna,IdServicio,Observaciones,CantVacunas,Nit")] ConsumosVet consumosVet)
        {
            if (codMascota != consumosVet.CodMascota || idServicio != consumosVet.IdServicio || idConsumoVet != consumosVet.IdConsumoVet)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(consumosVet);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ConsumosVetExists(consumosVet.CodMascota, consumosVet.IdServicio, consumosVet.IdConsumoVet))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "Nombre", consumosVet.CodMascota);
            ViewData["CodVacuna"] = new SelectList(_context.Vacunas, "CodVacuna", "Nombre", consumosVet.CodVacuna);
            ViewData["IdServicio"] = new SelectList(_context.Servicios, "IdServicio", "Nombre", consumosVet.IdServicio);
            return View(consumosVet);
        }

        // GET: ConsumosVet/Delete
        public async Task<IActionResult> Delete(string codMascota, string idServicio, int idConsumoVet)
        {
            if (codMascota == null || idServicio == null || idConsumoVet == 0)
            {
                return NotFound();
            }

            var consumosVet = await _context.ConsumosVets
                .Include(c => c.CodMascotaNavigation)
                .Include(c => c.CodVacunaNavigation)
                .Include(c => c.IdServicioNavigation)
                .FirstOrDefaultAsync(m => m.CodMascota == codMascota && m.IdServicio == idServicio && m.IdConsumoVet == idConsumoVet);

            if (consumosVet == null)
            {
                return NotFound();
            }

            return View(consumosVet);
        }

        // POST: ConsumosVet/Delete
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string codMascota, string idServicio, int idConsumoVet)
        {
            var consumosVet = await _context.ConsumosVets.FindAsync(codMascota, idServicio, idConsumoVet);
            if (consumosVet != null)
            {
                _context.ConsumosVets.Remove(consumosVet);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ConsumosVetExists(string codMascota, string idServicio, int idConsumoVet)
        {
            return _context.ConsumosVets.Any(e => e.CodMascota == codMascota && e.IdServicio == idServicio && e.IdConsumoVet == idConsumoVet);
        }
    }
}
