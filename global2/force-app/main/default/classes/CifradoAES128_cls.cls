/****************************************************************************************************
    Información general 
    -------------------
    Desarrollado por:   Avanxo Colombia
    Autor:              Luis Peñaranda.
    Proyecto:           Global Seguros (CRM)
    Descripción:        Clase para Cifrado y Desccifrado de textos usando el algoritmo AES128
    
    Generación de la Llave privada de encriptación
    Blob cryptoKey = Crypto.generateAesKey(128);
    
    Obtener la cadena que representa la clave de encriptación
    ----------------------------------------------------------
    String encodedKey = EncodingUtil.base64encode(cryptoKey);
    En la configuracion personlizada ParametrosEncripcionAES128__c se almacena la llave de encripcion, variable encodedKey
    
    Obtener la cadena que representa el vector de inicializacion
    ----------------------------------
    Blob initializationVector = Blob.valueOf('0000000000000000');
    String vector= EncodingUtil.base64encode(initializationVector );
    En la configuracion personlizada ParametrosEncripcionAES128__c se almacena la llave de encripcion, variable vector
    
    
    Información sobre cambios (Versiones)
    -------------------------------------
    Número  Fecha       Autor                       Descripción
    ------  ----------  --------------------------  -----------
    1.0     23-04-2014  Luis Peñaranda       		Creacion.
    ****************************************************************************************************/
public class CifradoAES128_cls {

    Blob encryptionKey ;
    Blob InitializationVector ;
        
    public CifradoAES128_cls() {
        try { 
        	// Obtener llave de cifrado
            ParametrosEncripcionAES128__c parEncrypKey	= ParametrosEncripcionAES128__c.getInstance('EncryptionKey');
            //encryptionKey = Encodingutil.base64Decode(parEncrypKey.valor__c);
            encryptionKey = Blob.ValueOf(parEncrypKey.valor__c);
            System.debug('<--' + encryptionKey);
            // Obtener Vector de inicilizacion
            ParametrosEncripcionAES128__c parEncrypVector	= ParametrosEncripcionAES128__c.getInstance('InitializationVector');
            //InitializationVector = Encodingutil.base64Decode(parEncrypVector.valor__c);
            InitializationVector = Blob.ValueOf(parEncrypVector.valor__c);
        } catch (Exception ex) {
             System.debug('Problema de Encripcion ['+ ex.getMessage() +'] ');
        }
    }
 
 	/* Cifrar texto*/
	/*public String Cifrar(String textoACifrar){
		          
        Blob encryptedValue = Crypto.encrypt('AES128', encryptionKey, InitializationVector, Blob.valueOf(textoACifrar));
		String textoEncriptado= EncodingUtil.base64encode(encryptedValue);
		System.debug('Texto Cifrado-->'+textoEncriptado);

        return textoEncriptado;
    }*/
    
 	/* DesCifrar texto*/
	/*public String DesCifrar(String textoADesCifrar){ 
        String textoDescifrado;
        Blob textoADesCifrarBlob;
        
        textoADesCifrarBlob = Encodingutil.base64Decode(textoADesCifrar);
        
        Blob decryptedValue = Crypto.decrypt('AES128', encryptionKey, InitializationVector,textoADesCifrarBlob);
        // Impresion del texto desencriptado
        textoDescifrado = decryptedValue.toString();
		System.debug('Text Descifrado-->'+textoDescifrado);
		return textoDescifrado;
		
    }*/
    
 	/* Cifrar texto*/
	public String CifrarUtf8(String textoACifrar){
		System.debug('Texto a Cifrar-->'+textoACifrar);
		String textoUtf8;
		textoUtf8=EncodingUtil.urlEncode(textoACifrar,'UTF-8');   
        Blob encryptedValue = Crypto.encrypt('AES128', encryptionKey, InitializationVector, Blob.ValueOf(textoUtf8));		        
		String textoEncriptado= EncodingUtil.base64encode(encryptedValue);
		System.debug('Texto Cifrado-->'+textoEncriptado);
        return textoEncriptado;
    }

    
 	/* DesCifrar texto*/
	public String DesCifrarUtf8(String textoADesCifrar){
        String textoDescifrado;
        Blob textoADesCifrarBlob;
        textoADesCifrarBlob = Encodingutil.base64Decode(textoADesCifrar);
		textoDescifrado = EncodingUtil.urlDecode(Crypto.decrypt('AES128', encryptionKey, InitializationVector, textoADesCifrarBlob).toString(), 'utf8');
		return textoDescifrado;
		
    }         
}