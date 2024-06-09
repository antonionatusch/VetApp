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
    public class PesosController : Controller
    {
        private readonly VeterinariaExtendidaContext _context;

        public PesosController(VeterinariaExtendidaContext context)
        {
            _context = context;
        }

        // GET: Pesos
        public async Task<IActionResult> Index()
        {
            var veterinariaExtendidaContext = _context.HistPesos.Include(h => h.CodMascotaNavigation);
            return View(await veterinariaExtendidaContext.ToListAsync());
        }

        // GET: Pesos/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var histPeso = await _context.HistPesos
                .Include(h => h.CodMascotaNavigation)
                .FirstOrDefaultAsync(m => m.CodMascota == id);
            if (histPeso == null)
            {
                return NotFound();
            }

            return View(histPeso);
        }

        // GET: Pesos/Create
        public IActionResult Create()
        {
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "CodMascota");
            return View();
        }

        // POST: Pesos/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CodMascota,FechaPesaje,Peso")] HistPeso histPeso)
        {
            if (ModelState.IsValid)
            {
                _context.Add(histPeso);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "CodMascota", histPeso.CodMascota);
            return View(histPeso);
        }

        // GET: Pesos/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var histPeso = await _context.HistPesos.FindAsync(id);
            if (histPeso == null)
            {
                return NotFound();
            }
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "CodMascota", histPeso.CodMascota);
            return View(histPeso);
        }

        // POST: Pesos/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("CodMascota,FechaPesaje,Peso")] HistPeso histPeso)
        {
            if (id != histPeso.CodMascota)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(histPeso);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!HistPesoExists(histPeso.CodMascota))
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
            ViewData["CodMascota"] = new SelectList(_context.Mascotas, "CodMascota", "CodMascota", histPeso.CodMascota);
            return View(histPeso);
        }

        // GET: Pesos/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var histPeso = await _context.HistPesos
                .Include(h => h.CodMascotaNavigation)
                .FirstOrDefaultAsync(m => m.CodMascota == id);
            if (histPeso == null)
            {
                return NotFound();
            }

            return View(histPeso);
        }

        // POST: Pesos/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var histPeso = await _context.HistPesos.FindAsync(id);
            if (histPeso != null)
            {
                _context.HistPesos.Remove(histPeso);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool HistPesoExists(string id)
        {
            return _context.HistPesos.Any(e => e.CodMascota == id);
        }
    }
}
