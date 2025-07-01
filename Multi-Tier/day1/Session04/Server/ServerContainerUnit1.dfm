object ServerContainer1: TServerContainer1
  Height = 271
  Width = 415
  object DSServer1: TDSServer
    AutoStart = False
    Left = 96
    Top = 11
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    Server = DSServer1
    Filters = <>
    Left = 96
    Top = 73
  end
  object UserService: TDSServerClass
    OnGetClass = UserServiceGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 200
    Top = 11
  end
end
