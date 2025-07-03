object CMServerContainer: TCMServerContainer
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 318
  Width = 438
  object CMServer: TDSServer
    Left = 40
    Top = 11
  end
  object CMServerTransport: TDSTCPServerTransport
    PoolSize = 0
    Server = CMServer
    Filters = <>
    AuthenticationManager = CMAuthManager
    Left = 40
    Top = 105
  end
  object CMServerClass: TDSServerClass
    OnGetClass = CMServerClassGetClass
    Server = CMServer
    Left = 136
    Top = 11
  end
  object CMAuthManager: TDSAuthenticationManager
    OnUserAuthorize = CMAuthManagerUserAuthorize
    Roles = <>
    Left = 160
    Top = 192
  end
  object CMHTTPService: TDSHTTPService
    HttpPort = 8089
    Server = CMServer
    DSPort = 0
    Filters = <>
    SessionTimeout = 0
    Left = 40
    Top = 191
  end
end
