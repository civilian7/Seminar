object DM: TDM
  OnCreate = DataModuleCreate
  Height = 321
  Width = 640
  object SQLConnection1: TSQLConnection
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXDataSnap'
      'HostName=localhost'
      'Port=211'
      'CommunicationProtocol=tcp/ip'
      'DatasnapContext=datasnap/'
      
        'DriverAssemblyLoader=Borland.Data.TDBXClientDriverLoader,Borland' +
        '.Data.DbxClientDriver,Version=24.0.0.0,Culture=neutral,PublicKey' +
        'Token=91d62ebb5b0d1b1b')
    Connected = True
    Left = 56
    Top = 32
  end
  object dpUser: TDSProviderConnection
    ServerClassName = 'TServerMethods1'
    Connected = True
    SQLConnection = SQLConnection1
    Left = 56
    Top = 104
  end
  object cdsUser: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'UserList'
    RemoteServer = dpUser
    Left = 56
    Top = 168
    object cdsUserSEQ: TAutoIncField
      AutoGenerateValue = arAutoInc
      FieldName = 'SEQ'
      KeyFields = 'SEQ'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object cdsUserUSR_ID: TWideStringField
      FieldName = 'USR_ID'
      Required = True
      Size = 12
    end
    object cdsUserUSR_PW: TWideStringField
      FieldName = 'USR_PW'
      Required = True
      Size = 64
    end
    object cdsUserUSR_NM: TWideStringField
      FieldName = 'USR_NM'
      Required = True
    end
    object cdsUserUSR_LVL: TIntegerField
      FieldName = 'USR_LVL'
    end
    object cdsUserLGN_CNT: TIntegerField
      FieldName = 'LGN_CNT'
    end
    object cdsUserLGN_FAIL_CNT: TIntegerField
      FieldName = 'LGN_FAIL_CNT'
    end
    object cdsUserLST_LOGIN_DT: TDateTimeField
      FieldName = 'LST_LOGIN_DT'
    end
    object cdsUserLST_LOGIN_IP: TWideStringField
      FieldName = 'LST_LOGIN_IP'
      Size = 15
    end
    object cdsUserLST_LOGOUT_DT: TDateTimeField
      FieldName = 'LST_LOGOUT_DT'
    end
    object cdsUserUSE_YN: TWideStringField
      FieldName = 'USE_YN'
      Size = 1
    end
    object cdsUserCRT_ID: TWideStringField
      FieldName = 'CRT_ID'
    end
    object cdsUserCRT_DT: TSQLTimeStampField
      FieldName = 'CRT_DT'
    end
    object cdsUserCRT_IP: TWideStringField
      FieldName = 'CRT_IP'
      Size = 15
    end
    object cdsUserMOD_ID: TWideStringField
      FieldName = 'MOD_ID'
    end
    object cdsUserMOD_DT: TSQLTimeStampField
      FieldName = 'MOD_DT'
    end
    object cdsUserMOD_IP: TWideStringField
      FieldName = 'MOD_IP'
      Size = 15
    end
  end
end
