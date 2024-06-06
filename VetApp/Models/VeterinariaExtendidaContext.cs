using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace VetApp.Models;

public partial class VeterinariaExtendidaContext : DbContext
{
    public VeterinariaExtendidaContext()
    {
    }

    public VeterinariaExtendidaContext(DbContextOptions<VeterinariaExtendidaContext> options)
        : base(options)
    {
    }

    public virtual DbSet<AplicaVacuna> AplicaVacunas { get; set; }

    public virtual DbSet<Cliente> Clientes { get; set; }

    public virtual DbSet<Consulta> Consultas { get; set; }

    public virtual DbSet<ConsumosVet> ConsumosVets { get; set; }

    public virtual DbSet<HistPeso> HistPesos { get; set; }

    public virtual DbSet<Mascota> Mascotas { get; set; }

    public virtual DbSet<Persona> Personas { get; set; }

    public virtual DbSet<PersonaCliente> PersonaClientes { get; set; }

    public virtual DbSet<Servicio> Servicios { get; set; }

    public virtual DbSet<Vacuna> Vacunas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("server=localhost; database=VeterinariaExtendida; integrated security=true; TrustServerCertificate=true; ");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AplicaVacuna>(entity =>
        {
            entity.HasKey(e => new { e.CodMascota, e.CodVacuna, e.FechaPrevista }).HasName("PK_AplicaVac");

            entity.ToTable("AplicaVacuna");

            entity.Property(e => e.CodMascota)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codMascota");
            entity.Property(e => e.CodVacuna)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codVacuna");
            entity.Property(e => e.FechaPrevista).HasColumnName("fechaPrevista");
            entity.Property(e => e.DosisAplicada).HasColumnName("dosisAplicada");
            entity.Property(e => e.FechaAplicacion)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("fechaAplicacion");

            entity.HasOne(d => d.CodMascotaNavigation).WithMany(p => p.AplicaVacunas)
                .HasForeignKey(d => d.CodMascota)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MasAV");

            entity.HasOne(d => d.CodVacunaNavigation).WithMany(p => p.AplicaVacunas)
                .HasForeignKey(d => d.CodVacuna)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VacAV");
        });

        modelBuilder.Entity<Cliente>(entity =>
        {
            entity.HasKey(e => e.CodCliente);

            entity.Property(e => e.CodCliente)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codCliente");
            entity.Property(e => e.Apellido)
                .HasMaxLength(80)
                .IsUnicode(false)
                .HasColumnName("apellido");
            entity.Property(e => e.Banco)
                .HasMaxLength(80)
                .IsUnicode(false)
                .HasColumnName("banco");
            entity.Property(e => e.Correo)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("correo");
            entity.Property(e => e.CuentaBanco)
                .HasMaxLength(40)
                .IsUnicode(false)
                .HasColumnName("cuentaBanco");
            entity.Property(e => e.Direccion)
                .HasMaxLength(60)
                .IsUnicode(false)
                .HasColumnName("direccion");
            entity.Property(e => e.Telefono)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("telefono");
        });

        modelBuilder.Entity<Consulta>(entity =>
        {
            entity.HasKey(e => new { e.CodMascota, e.FechaConsulta });

            entity.Property(e => e.CodMascota)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codMascota");
            entity.Property(e => e.FechaConsulta).HasColumnName("fechaConsulta");
            entity.Property(e => e.Diagnostico)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("diagnostico");
            entity.Property(e => e.Medicacion)
                .HasMaxLength(200)
                .IsUnicode(false)
                .HasColumnName("medicacion");
            entity.Property(e => e.Motivo)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("motivo");
            entity.Property(e => e.Tratamiento)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("tratamiento");

            entity.HasOne(d => d.CodMascotaNavigation).WithMany(p => p.Consulta)
                .HasForeignKey(d => d.CodMascota)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MascConsultas");
        });

        modelBuilder.Entity<ConsumosVet>(entity =>
        {
            entity.HasKey(e => new { e.CodMascota, e.CodVacuna, e.IdServicio, e.IdConsumoVet }).HasName("PK_CV");

            entity.ToTable("ConsumosVet");

            entity.Property(e => e.CodMascota)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codMascota");
            entity.Property(e => e.CodVacuna)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codVacuna");
            entity.Property(e => e.IdServicio)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("idServicio");
            entity.Property(e => e.IdConsumoVet)
                .ValueGeneratedOnAdd()
                .HasColumnName("idConsumoVet");
            entity.Property(e => e.CantVacunas).HasColumnName("cantVacunas");
            entity.Property(e => e.Nit)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("nit");
            entity.Property(e => e.Observaciones)
                .HasMaxLength(200)
                .IsUnicode(false)
                .HasColumnName("observaciones");

            entity.HasOne(d => d.CodMascotaNavigation).WithMany(p => p.ConsumosVets)
                .HasForeignKey(d => d.CodMascota)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MasCV");

            entity.HasOne(d => d.CodVacunaNavigation).WithMany(p => p.ConsumosVets)
                .HasForeignKey(d => d.CodVacuna)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VacCV");

            entity.HasOne(d => d.IdServicioNavigation).WithMany(p => p.ConsumosVets)
                .HasForeignKey(d => d.IdServicio)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SerCV");
        });

        modelBuilder.Entity<HistPeso>(entity =>
        {
            entity.HasKey(e => new { e.CodMascota, e.FechaPesaje }).HasName("PK_HistPeso");

            entity.Property(e => e.CodMascota)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codMascota");
            entity.Property(e => e.FechaPesaje).HasColumnName("fechaPesaje");
            entity.Property(e => e.Peso)
                .HasColumnType("decimal(5, 2)")
                .HasColumnName("peso");

            entity.HasOne(d => d.CodMascotaNavigation).WithMany(p => p.HistPesos)
                .HasForeignKey(d => d.CodMascota)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MasHistPesos");
        });

        modelBuilder.Entity<Mascota>(entity =>
        {
            entity.HasKey(e => e.CodMascota);

            entity.Property(e => e.CodMascota)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codMascota");
            entity.Property(e => e.CodCliente)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codCliente");
            entity.Property(e => e.Color)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("color");
            entity.Property(e => e.Especie)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("especie");
            entity.Property(e => e.FechaNac).HasColumnName("fechaNac");
            entity.Property(e => e.Nombre)
                .HasMaxLength(80)
                .IsUnicode(false)
                .HasColumnName("nombre");
            entity.Property(e => e.Raza)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasColumnName("raza");

            entity.HasOne(d => d.CodClienteNavigation).WithMany(p => p.Mascota)
                .HasForeignKey(d => d.CodCliente)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CliMascotas");
        });

        modelBuilder.Entity<Persona>(entity =>
        {
            entity.HasKey(e => e.Ci);

            entity.Property(e => e.Ci)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("ci");
            entity.Property(e => e.Correo)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("correo");
            entity.Property(e => e.Direccion)
                .HasMaxLength(60)
                .IsUnicode(false)
                .HasColumnName("direccion");
            entity.Property(e => e.Nombre)
                .HasMaxLength(80)
                .IsUnicode(false)
                .HasColumnName("nombre");
            entity.Property(e => e.Telefono)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("telefono");
        });

        modelBuilder.Entity<PersonaCliente>(entity =>
        {
            entity.HasKey(e => new { e.CodCliente, e.Ci, e.FechaAsociacion }).HasName("PK_PC");

            entity.ToTable("PersonaCliente");

            entity.Property(e => e.CodCliente)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codCliente");
            entity.Property(e => e.Ci)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("ci");
            entity.Property(e => e.FechaAsociacion).HasColumnName("fechaAsociacion");

            entity.HasOne(d => d.CiNavigation).WithMany(p => p.PersonaClientes)
                .HasForeignKey(d => d.Ci)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PersonasPC");

            entity.HasOne(d => d.CodClienteNavigation).WithMany(p => p.PersonaClientes)
                .HasForeignKey(d => d.CodCliente)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClientesPC");
        });

        modelBuilder.Entity<Servicio>(entity =>
        {
            entity.HasKey(e => e.IdServicio).HasName("PK_Ser");

            entity.Property(e => e.IdServicio)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("idServicio");
            entity.Property(e => e.Descripcion)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("descripcion");
            entity.Property(e => e.Nombre)
                .HasMaxLength(80)
                .IsUnicode(false)
                .HasColumnName("nombre");
            entity.Property(e => e.Precio)
                .HasColumnType("money")
                .HasColumnName("precio");
            entity.Property(e => e.TipoServicio)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("tipoServicio");
            entity.Property(e => e.UnidadMedida)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("unidadMedida");
        });

        modelBuilder.Entity<Vacuna>(entity =>
        {
            entity.HasKey(e => e.CodVacuna).HasName("PK_Vac");

            entity.Property(e => e.CodVacuna)
                .HasMaxLength(20)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("codVacuna");
            entity.Property(e => e.Dosis)
                .HasColumnType("decimal(5, 2)")
                .HasColumnName("dosis");
            entity.Property(e => e.Laboratorio)
                .HasMaxLength(80)
                .IsUnicode(false)
                .HasColumnName("laboratorio");
            entity.Property(e => e.Nombre)
                .HasMaxLength(80)
                .IsUnicode(false)
                .HasColumnName("nombre");
            entity.Property(e => e.PrecioUnitario)
                .HasColumnType("money")
                .HasColumnName("precioUnitario");
            entity.Property(e => e.PrevEnfermedad)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("prevEnfermedad");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
