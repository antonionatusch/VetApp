﻿using System;
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
        public async Task<IActionResult> Details(string codCliente, string ci, DateOnly fechaAsociacion)
        {
            if (codCliente == null || ci == null || fechaAsociacion == null)
            {
                return NotFound();
            }

            var personaCliente = await _context.PersonaClientes
                .Include(p => p.CiNavigation)
                .Include(p => p.CodClienteNavigation)
                .FirstOrDefaultAsync(m => m.CodCliente == codCliente && m.Ci == ci && m.FechaAsociacion == fechaAsociacion);
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
        public async Task<IActionResult> Edit(string codCliente, string ci, DateOnly fechaAsociacion)
        {
            if (codCliente == null || ci == null || fechaAsociacion == null)
            {
                return NotFound();
            }

            var personaCliente = await _context.PersonaClientes.FindAsync(codCliente, ci, fechaAsociacion);
            if (personaCliente == null)
            {
                return NotFound();
            }
            ViewBag.CodCliente = codCliente;
            ViewBag.Ci = ci;
            ViewBag.FechaAsociacion = fechaAsociacion;
            ViewData["Ci"] = new SelectList(_context.Personas, "Ci", "Ci", personaCliente.Ci);
            ViewData["CodCliente"] = new SelectList(_context.Clientes, "CodCliente", "CodCliente", personaCliente.CodCliente);
            return View(personaCliente);
        }

        // POST: PersonaClientes/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string codCliente, string ci, DateOnly fechaAsociacion, [Bind("CodCliente,Ci,FechaAsociacion")] PersonaCliente personaCliente)
        {
            if (codCliente != personaCliente.CodCliente || ci != personaCliente.Ci || fechaAsociacion != personaCliente.FechaAsociacion)
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
                    if (!PersonaClienteExists(personaCliente.CodCliente, personaCliente.Ci, personaCliente.FechaAsociacion))
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
        public async Task<IActionResult> Delete(string codCliente, string ci, DateOnly fechaAsociacion)
        {
            if (codCliente == null || ci == null || fechaAsociacion == null)
            {
                return NotFound();
            }

            var personaCliente = await _context.PersonaClientes
                .Include(p => p.CiNavigation)
                .Include(p => p.CodClienteNavigation)
                .FirstOrDefaultAsync(m => m.CodCliente == codCliente && m.Ci == ci && m.FechaAsociacion == fechaAsociacion);
            if (personaCliente == null)
            {
                return NotFound();
            }

            ViewBag.CodCliente = codCliente;
            ViewBag.Ci = ci;
            ViewBag.FechaAsociacion = fechaAsociacion;

            return View(personaCliente);
        }

        // POST: PersonaClientes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string codCliente, string ci, DateOnly fechaAsociacion)
        {
            var personaCliente = await _context.PersonaClientes.FindAsync(codCliente, ci, fechaAsociacion);
            if (personaCliente != null)
            {
                _context.PersonaClientes.Remove(personaCliente);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool PersonaClienteExists(string codCliente, string ci, DateOnly fechaAsociacion)
        {
            return _context.PersonaClientes.Any(e => e.CodCliente == codCliente && e.Ci == ci && e.FechaAsociacion == fechaAsociacion);
        }
    }
}
