/**
* @author Luis R. Peñaranda
* @author <a href="mailto:lpenaranda@avanxo.com">
* @author <a target="_blank" href="http://www.avanxo.com">www.avanxo.com</a>
* @version 1.0, Nov-2014.
**/
/* 
<!--
  <apex:column >
<apex:facet name="header">IMG</apex:facet>						
<img id="theImage" src="/servlet/servlet.FileDownload?file=015110000009Hp7" width="15" height="15"/> 												
</apex:column>
-->
	*/
public class FichaCustomer_ctr
{
	/* == INICIO: VARIABLES Y GET SET == */
	public string strConsultora{get;set;}
	public list<SelectOption> lstAlcance{get;set;}
	public list<SelectOption> lstTipo{get;set;}
	public list<SelectOption> lstPais{get;set;}//WRM
	public Boolean  esCorporativo{get;set;}//LRPA
	public String  usuarioPais{get;set;}//LRPA
	public string strTipo{get;set;}
	public string strPais{get;set;}//WRM
	public string strAlcance{get;set;}
	public string strCodigo{get;set;}
	public string strNombreConsultora{get;set;}
	public string strCodigoConsultora{get;set;}
	public string strIdConsultora{get;set;}
	public string strCodigoDirectora{get;set;}
	public string strNombreDirectora{get;set;}
	public string strIdDirectora{get;set;}
	public string strIndicadorRetencion{get;set;}
	public string strBloqueoVarios{get;set;}
	public boolean blnEsContactoValido{get;set;}
	public boolean blnMostrarAdvertencia{get;set;}
	public string strCodDirEntrante;
	public string strCodDirBuscada;
	public boolean blnResult{get;set;}
	public string lblPais {get;set;}//WRM
	public string idCasoDetail {get;set;}
	public String mostrarPop {get;set;}
	public String parametro {get;set;}
	public boolean senalViewCase {get;set;}
	public map<string,string> mapParams;
	/*Case*/
	public list<case> lstCase;
	
	public list<case> getlstCase()
	{
		list<case> lTempCase = new list<case>();
		for(case a : (List<case>)setCon.getRecords())
			lTempCase.add(a);
		return lTempCase;
	}
	public boolean blnIsFirst 
	{
		get
		{
			return !setCon.getHasPrevious();
		}
	}
	public boolean blnIsLast
	{
		get 
		{
			return !setCon.getHasNext();
		}
	}
	public string strTotalHits
	{
		get
		{
			return string.ValueOf(setCon.getResultSize());
		}
	}
	

	/* Fin Outbound */
	public Boolean prueba {get;set;} 



	public FichaCustomer_ctr(ApexPages.StandardController controller)
	{
		blnResult=false;
		blnMostrarAdvertencia=false;
		blnEsContactoValido=false;
		//idCasoDetail='50011000003y8OgAAI';
		system.debug('OTRA VEZ EL CONSTRUCTOR-->'+idCasoDetail);
		senalViewCase=false;
	}

	public PageReference Cancel()
	{
		PageReference pr=null; 
		string strRetUrl='/';
		if(mapParams.containsKey('retURL'))
		{
			strRetUrl=mapParams.get('retURL');
			pr = new PageReference(strRetUrl);
			pr.setRedirect(true);
		}
		return pr;
	}
	public void fnLabel(){}
	/*Set Con*/
	public ApexPages.StandardSetController setCon
	{
		get
		{
			if(setCon == null)
			{
				setCon = new ApexPages.StandardSetController( Database.getQueryLocator( consultaCase() ) );
				setCon.setPageSize(3);
			}
			return setCon;
		}
		set;
	}

	public Pagereference  setCaseDetail()
	{
			idCasoDetail=parametro;
			senalViewCase=true;
			return null;
	}
	
	private string consultaCase()
	{
		String valEmpresa='Global Seguros';
		string strQuery='';
		strQuery+='select Id,Subject, CaseNUmber,FechaHoraRecibido__c,Status,Poliza__r.Name,imagenSemaforo__c from Case where Poliza__r.EmpresaProducto__c= ';

		strQuery+='\''+valEmpresa+'\' '; 
		strQuery+='Order by CaseNUmber DESC';
		system.debug('\n===>strQuery='+strQuery);
		return strQuery;    
	}

	public Pagereference Consultar()
	{
		Pagereference pr=null;
		setCon=null;
		blnEsContactoValido=false;
		//consultaContactoDigitado();
		return pr;
	}
	/* Case */
	public Integer getResults()
	{
		return setCon.getResultSize();
	}
	public void NextPage()
	{
		if(setCon.getHasNext())
			setCon.next();
	}

	public void PreviousPage()
	{
		if(setCon.getHasPrevious())
			setCon.previous();
	}
 
	public void FirstPage()
	{
		setCon.first();
	}

	public void LastPage()
	{
		setCon.last();
	}


	public PageReference Save()
	{ 
		String strURL = '/500/e?';
     	PageReference pageRef =  new PageReference(strURL);     	
     	pageRef.setRedirect(true);     	
     	return pageRef;

	}

}