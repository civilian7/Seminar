object ServerContainer1: TServerContainer1
  Height = 352
  Width = 438
  object DSServer1: TDSServer
    Left = 72
    Top = 19
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    Server = DSServer1
    Filters = <>
    Left = 72
    Top = 129
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    Left = 248
    Top = 27
  end
end
