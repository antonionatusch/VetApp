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
    public class PersonaClientesController : Controller
    {
        private readonly VeterinariaExtendidaContext _context;

        public PersonaClientesController(VeterinariaExtendidaContext context)
        {
            _context = context;
        }

        // GET: PersonaClientes
        public async Task<IActionResult> Index()
        {
            var veterinariaExtendidaContext = _context.PersonaClientes.Include(p => p.CiNavigation).Include(p => p.CodClienteNavigation);
            return View(await veterinariaExtendidaContext.ToListAsync());
        }

        // GET: PersonaClientes/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var personaCliente = await _context.PersonaClientes
                .Include(p => p.CiNavigation)
                .Include(p => p.CodClienteNavigation)
                .FirstOrDefaultAsync(m => m.CodCliente == id);
            if (personaCliente == null)
            {
                return NotFound();
            }

            return View(personaCliente);
        }

        // GET: PersonaClientes/Create
        public IActionResult Create()
        {
            ViewData["Ci"] = new SelectList(_context.Personas, "Ci", "Ci");
            ViewData["CodCliente"] = new SelectList(_context.Clientes, "CodCliente", "CodCliente");
            return View();
        }

        // POST: PersonaClientes/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CodCliente,Ci,FechaAsociacion")] PersonaCliente personaCliente)
        {
            if (ModelState.IsValid)
            {
                _context.Add(personaCliente);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["Ci"] = new SelectList(_context.Personas, "Ci", "Ci", personaCliente.Ci);
            ViewData["CodCliente"] = new SelectList(_context.Clientes, "CodCliente", "CodCliente", personaCliente.CodCliente);
            return View(personaCliente);
        }

        // GET: PersonaClientes/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var personaCliente = await _context.PersonaClientes.FindAsync(id);
            if (personaCliente == null)
            {
                return NotFound();
            }
            ViewData["Ci"] = new SelectList(_context.Personas, "Ci", "Ci", personaCliente.Ci);
            ViewData["CodCliente"] = new SelectList(_context.Clientes, "CodCliente", "CodCliente", personaCliente.CodCliente);
            return View(personaCliente);
        }

        // POST: PersonaClientes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("CodCliente,Ci,FechaAsociacion")] PersonaCliente personaCliente)
        {
            if (id != personaCliente.CodCliente)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(personaCliente);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!PersonaClienteExists(personaCliente.CodCliente))
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
            ViewData["Ci"] = new SelectList(_context.Personas, "Ci", "Ci", personaCliente.Ci);
            ViewData["CodCliente"] = new SelectList(_context.Clientes, "CodCliente", "CodCliente", personaCliente.CodCliente);
            return View(personaCliente);
        }

        // GET: PersonaClientes/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var personaCliente = await _context.PersonaClientes
                .Include(p => p.CiNavigation)
                .Include(p => p.CodClienteNavigation)
                .FirstOrDefaultAsync(m => m.CodCliente == id);
            if (personaCliente == null)
            {
                return NotFound();
            }

            return View(personaCliente);
        }

        // POST: PersonaClientes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var personaCliente = await _context.PersonaClientes.FindAsync(id);
            if (personaCliente != null)
            {
                _context.PersonaClientes.Remove(personaCliente);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool PersonaClienteExists(string id)
        {
            return _context.PersonaClientes.Any(e => e.CodCliente == id);
        }
    }
}
