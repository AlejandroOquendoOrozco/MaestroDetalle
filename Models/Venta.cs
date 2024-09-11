using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MaestroDetalle.Models
{
    public class Venta
    {
        public int IdeVenta { get; set; }

        public string NumeroDocumento { get; set; }

        public string RazonSocial { get; set; }

        public decimal Total { get; set; }


        public List<DetalleVenta>LstDetalleVenta{ get; set; }
    }
}