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
    public class AplicaVacunasController : Controller
    {
        private readonly VeterinariaExtendidaContext _context;

        public AplicaVacunasController(VeterinariaExtendidaContext context)
        {
            _context = context;
        }

        // GET: AplicaVacunas
        public async Task<IActionResult> Index()
        {
            var veterinariaExtendidaContext = _context.AplicaVacunas.Include(a => a.CodMascotaNavigation).Include(a => a.CodVacunaNavigation);
            return View(await veterinariaExtendidaContext.ToListAsync());
        }

        // GET: AplicaVacunas/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var aplicaVacuna = await _context.AplicaVacunas
                .Include(a => a.CodMascotaNavigation)
                .Include(a => a.CodVacunaNavigation)
                .FirstOrDefaultAsync(m => m.CodMascota == id);
            if (aplicaVacuna == null)
            {
                return NotFound();
            }

            return View(aplicaVacuna);
        }

        // GET: AplicaVacunas/Create
        public IActionResult Create()
        {
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "CodMascota");
            ViewData["CodVacuna"] = new SelectList(_context.Vacunas, "CodVacuna", "CodVacuna");
            return View();
        }

        // POST: AplicaVacunas/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CodMascota,CodVacuna,FechaPrevista,FechaAplicacion,DosisAplicada")] AplicaVacuna aplicaVacuna)
        {
            if (ModelState.IsValid)
            {
                _context.Add(aplicaVacuna);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "CodMascota", aplicaVacuna.CodMascota);
            ViewData["CodVacuna"] = new SelectList(_context.Vacunas, "CodVacuna", "CodVacuna", aplicaVacuna.CodVacuna);
            return View(aplicaVacuna);
        }

        // GET: AplicaVacunas/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var aplicaVacuna = await _context.AplicaVacunas.FindAsync(id);
            if (aplicaVacuna == null)
            {
                return NotFound();
            }
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "CodMascota", aplicaVacuna.CodMascota);
            ViewData["CodVacuna"] = new SelectList(_context.Vacunas, "CodVacuna", "CodVacuna", aplicaVacuna.CodVacuna);
            return View(aplicaVacuna);
        }

        // POST: AplicaVacunas/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("CodMascota,CodVacuna,FechaPrevista,FechaAplicacion,DosisAplicada")] AplicaVacuna aplicaVacuna)
        {
            if (id != aplicaVacuna.CodMascota)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(aplicaVacuna);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!AplicaVacunaExists(aplicaVacuna.CodMascota))
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
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "CodMascota", aplicaVacuna.CodMascota);
            ViewData["CodVacuna"] = new SelectList(_context.Vacunas, "CodVacuna", "CodVacuna", aplicaVacuna.CodVacuna);
            return View(aplicaVacuna);
        }

        // GET: AplicaVacunas/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var aplicaVacuna = await _context.AplicaVacunas
                .Include(a => a.CodMascotaNavigation)
                .Include(a => a.CodVacunaNavigation)
                .FirstOrDefaultAsync(m => m.CodMascota == id);
            if (aplicaVacuna == null)
            {
                return NotFound();
            }

            return View(aplicaVacuna);
        }

        // POST: AplicaVacunas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var aplicaVacuna = await _context.AplicaVacunas.FindAsync(id);
            if (aplicaVacuna != null)
            {
                _context.AplicaVacunas.Remove(aplicaVacuna);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool AplicaVacunaExists(string id)
        {
            return _context.AplicaVacunas.Any(e => e.CodMascota == id);
        }
    }
}
