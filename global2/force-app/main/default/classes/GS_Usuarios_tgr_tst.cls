@isTest
private class GS_Usuarios_tgr_tst {
    @isTest 
    static void TestUsuariosTgr() {
        User Usuario = new User();
        
        Usuario.LastName = 'Perez';
        Usuario.Alias = 'PPerez';
        Usuario.Email = 'pperez@global.com';
        Usuario.Username = 'pperez@global.com';
        Usuario.CommunityNickname = 'PPerez';
        Usuario.CodigoUsuario__c = '123456';
        Usuario.FechaVinculacion__c = System.today();
        Usuario.UserPermissionsMarketingUser = True;
        Usuario.TimeZoneSidKey = 'America/Bogota';
        Usuario.LocaleSidKey = 'es_CO';
        Usuario.EmailEncodingKey = 'ISO-8859-1';
        Usuario.ProfileId = '00eG0000001GPOUIA4';
        Usuario.LanguageLocaleKey = 'es';
        
        Insert Usuario;
        System.debug('Usuario: ' + Usuario);
        
        Usuario.UserPermissionsMarketingUser = False;
        Update Usuario;
        System.debug('Usuario1: ' + Usuario);
    }
}