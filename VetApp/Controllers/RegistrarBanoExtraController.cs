using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using VetApp.Models;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;

namespace VetApp.Controllers
{
    public class RegistrarBanoExtraController : Controller
    {
        private readonly VeterinariaExtendidaContext _context;

        public RegistrarBanoExtraController(VeterinariaExtendidaContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> RegistrarBano()
        {
            var hospedajes = await _context.Hospedajes.ToListAsync();
            ViewBag.Hospedajes = new SelectList(hospedajes, "IdHospedaje", "IdHospedaje");
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> RegistrarBano(RegistrarBanoExtraViewModel model)
        {
            if (ModelState.IsValid)
            {
                await _context.Database.ExecuteSqlRawAsync(
                "EXEC RegistrarBanoExtra @IdHospedaje, @CantidadBanos",
                new SqlParameter("@IdHospedaje", model.IdHospedaje),
                new SqlParameter("@CantidadBanos", model.CantidadBanos)
                );

                ViewBag.Message = "Baño extra registrado con éxito.";
                return RedirectToAction("Index");
            }
            var hospedajes = await _context.Hospedajes.ToListAsync();
            ViewBag.Hospedajes = new SelectList(hospedajes, "IdHospedaje", "IdHospedaje");
            return View(model);
        }

        public async Task<IActionResult> Index()
        {
            var banos = await _context.ConsumoHotels
                .Where(ch => ch.IdServicio == "BE001" || ch.IdServicio == "BE002" || ch.IdServicio == "BE003")
                .Select(ch => new RegistrarBanoExtraViewModel
                {
                    IdHospedaje = ch.IdHospedaje,
                    CantidadBanos = ch.CantidadBanos
                })
                .ToListAsync();

            return View(banos);
        }
    }
}
