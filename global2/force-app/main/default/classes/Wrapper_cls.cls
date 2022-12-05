public class Wrapper_cls {

	public String 	strNumeroCotizacion {get;set;}
	public String 	strProducto 		{get;set;}
	public Decimal 	decValorPrima 		{get;set;}	
	public String  	strUrlCotizador  	{get;set;}

	public boolean 	bolAnexoEnfermedadesGraves{get;set;}
	public boolean 	bolAnexoInvalidezTotalPermanente{get;set;}
	public boolean 	bolAnexosMuerteAccidental{get;set;}
	public Decimal 	decAnioMaduracion{get;set;}
	public String 	strProductoOp{get;set;}
	public Decimal 	decValorAsegurado{get;set;}	
	public String 	strOpcionCotizacion{get;set;}	
	

	public Date datFechaCotizacion {
		get
		{
			Integer y = this.datFechaCotizacion.year();
			Integer m = this.datFechaCotizacion.month();
			Integer d = this.datFechaCotizacion.day();
			return Date.newInstance( y,m,d );
		}
		set;
	}
		
	public Wrapper_cls ()
	{
		strNumeroCotizacion					=	'';
		strProducto							=	'';
		decValorPrima						=	0;
		bolAnexoEnfermedadesGraves			= 	false;
		bolAnexoInvalidezTotalPermanente	= 	false;
		bolAnexosMuerteAccidental			= 	false;
		decAnioMaduracion					=	0;
		strProductoOp						= 	'';
		decValorAsegurado					=	0;
		strOpcionCotizacion						= 	'';
	}
}