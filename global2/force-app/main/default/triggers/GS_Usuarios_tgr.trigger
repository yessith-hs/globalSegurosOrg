trigger GS_Usuarios_tgr on User (before update) {
    System.debug('Prueba');
    For(User Usuario : Trigger.new){
        System.Debug('New: ' + Usuario.UserPermissionsMarketingUser + ' Old: ' + Trigger.OldMap.get(Usuario.Id).UserPermissionsMarketingUser);
        If( Trigger.OldMap.get(Usuario.Id).UserPermissionsMarketingUser == True && Usuario.UserPermissionsMarketingUser <> Trigger.OldMap.get(Usuario.Id).UserPermissionsMarketingUser){
            Usuario.UserPermissionsMarketingUser = Trigger.OldMap.get(Usuario.Id).UserPermissionsMarketingUser;
        }
    }
}