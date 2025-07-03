object ServerContainer3: TServerContainer3
  OnDestroy = DataModuleDestroy
  Height = 271
  Width = 415
  object DSServer1: TDSServer
    Left = 64
    Top = 19
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    PoolSize = 0
    Server = DSServer1
    Filters = <>
    Left = 64
    Top = 177
  end
  object DSHTTPService1: TDSHTTPService
    HttpPort = 8080
    Server = DSServer1
    Filters = <>
    Left = 248
    Top = 167
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    OnCreateInstance = DSServerClass1CreateInstance
    Server = DSServer1
    Left = 200
    Top = 35
  end
end
