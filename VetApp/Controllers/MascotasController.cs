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
    public class MascotasController : Controller
    {
        private readonly VeterinariaExtendidaContext _context;

        public MascotasController(VeterinariaExtendidaContext context)
        {
            _context = context;
        }

        // GET: Mascotas
        public async Task<IActionResult> Index()
        {
            var veterinariaExtendidaContext = _context.Mascotas.Include(m => m.CodClienteNavigation);
            return View(await veterinariaExtendidaContext.ToListAsync());
        }

        // GET: Mascotas/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var mascota = await _context.Mascotas
                .Include(m => m.CodClienteNavigation)
                .FirstOrDefaultAsync(m => m.CodMascota == id);
            if (mascota == null)
            {
                return NotFound();
            }

            return View(mascota);
        }

        // GET: Mascotas/Create
        public IActionResult Create()
        {
            ViewData["CodCliente"] = new SelectList(_context.Clientes, "CodCliente", "CodCliente");
            return View();
        }

        // POST: Mascotas/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CodMascota,CodCliente,Nombre,Especie,Raza,Color,FechaNac")] Mascota mascota)
        {
            if (ModelState.IsValid)
            {
                _context.Add(mascota);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["CodCliente"] = new SelectList(_context.Clientes, "CodCliente", "CodCliente", mascota.CodCliente);
            return View(mascota);
        }

        // GET: Mascotas/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var mascota = await _context.Mascotas.FindAsync(id);
            if (mascota == null)
            {
                return NotFound();
            }
            ViewData["CodCliente"] = new SelectList(_context.Clientes, "CodCliente", "CodCliente", mascota.CodCliente);
            return View(mascota);
        }

        // POST: Mascotas/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("CodMascota,CodCliente,Nombre,Especie,Raza,Color,FechaNac")] Mascota mascota)
        {
            if (id != mascota.CodMascota)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(mascota);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!MascotaExists(mascota.CodMascota))
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
            ViewData["CodCliente"] = new SelectList(_context.Clientes, "CodCliente", "CodCliente", mascota.CodCliente);
            return View(mascota);
        }

        // GET: Mascotas/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var mascota = await _context.Mascotas
                .Include(m => m.CodClienteNavigation)
                .FirstOrDefaultAsync(m => m.CodMascota == id);
            if (mascota == null)
            {
                return NotFound();
            }

            return View(mascota);
        }

        // POST: Mascotas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var mascota = await _context.Mascotas.FindAsync(id);
            if (mascota != null)
            {
                _context.Mascotas.Remove(mascota);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool MascotaExists(string id)
        {
            return _context.Mascotas.Any(e => e.CodMascota == id);
        }
    }
}
