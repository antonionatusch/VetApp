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

    public virtual DbSet<Cliente> Clientes { get; set; }

    public virtual DbSet<Persona> Personas { get; set; }

    public virtual DbSet<PersonaCliente> PersonaClientes { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("server=localhost; database=VeterinariaExtendida; integrated security=true; TrustServerCertificate=true; ");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
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

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
