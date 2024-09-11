using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using MaestroDetalle.Models;
using System.Xml.Linq;
using System.Data;
using System.Data.SqlClient;
namespace MaestroDetalle.Controllers;

public class HomeController : Controller
{
  
  private readonly string _cadenSql;

    public HomeController(IConfiguration configuration)
    {
        _cadenSql = configuration.GetConnectionString("CadenaSQL");
    }

    public IActionResult Index()
    {

        
        return View();
    }
    [HttpPost]
     public JsonResult GuardarVenta([FromBody] Venta bodyventa)
    {

        XElement ObjVenta = new XElement("Venta",
             new XElement("NumeroDocumento",bodyventa.NumeroDocumento),
             new XElement("RazonSocial",bodyventa.RazonSocial),
             new XElement("Total",bodyventa.Total)
        
        
        
        );
        XElement ObjDetalleventa =new XElement("DetalleVenta");
        foreach(DetalleVenta item in bodyventa.LstDetalleVenta){
            ObjDetalleventa.Add(new XElement("Item"),
                new XElement("Producto",item.Producto),
                new XElement("Precio",item.Precio),
                new XElement("Cantidad",item.Cantidad),
                new XElement("Total",item.Total)
            
            );
        }
        ObjVenta.Add(ObjDetalleventa);
        using(SqlConnection conexion =new SqlConnection(_cadenSql)){
            conexion.Open();
            SqlCommand cmd = new SqlCommand("SP_GUARDAR_VENTA", conexion);
            cmd.Parameters.Add("Venta_xml",SqlDbType.Xml).Value = ObjVenta.ToString();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.ExecuteNonQuery();
        }
        return Json(new{respuesta=true});
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
